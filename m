Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C846A206387
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390694AbgFWU0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390692AbgFWU0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:26:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F19320E65;
        Tue, 23 Jun 2020 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944004;
        bh=wcg4lAdI+Kttyls8CHHSvvI9I6B33hXNzeASTBTkiME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKJOkyl4qvHrWND24Ktxgp8gI6rk/wXxWVWttIPetMGBCn7GLZg03120tVzJPf23J
         5Ga6MWrhlFIBPCP4WeAP01CL9H3ioNicECvjMg6LdTZBE3T0sQ+JPbcre4cgQVLjQf
         PTDrGrQumqALadXXafMzWxq0BX4dbj6KB41AXQx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/314] virtiofs: schedule blocking async replies in separate worker
Date:   Tue, 23 Jun 2020 21:54:49 +0200
Message-Id: <20200623195343.341828154@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

[ Upstream commit bb737bbe48bea9854455cb61ea1dc06e92ce586c ]

In virtiofs (unlike in regular fuse) processing of async replies is
serialized.  This can result in a deadlock in rare corner cases when
there's a circular dependency between the completion of two or more async
replies.

Such a deadlock can be reproduced with xfstests:generic/503 if TEST_DIR ==
SCRATCH_MNT (which is a misconfiguration):

 - Process A is waiting for page lock in worker thread context and blocked
   (virtio_fs_requests_done_work()).
 - Process B is holding page lock and waiting for pending writes to
   finish (fuse_wait_on_page_writeback()).
 - Write requests are waiting in virtqueue and can't complete because
   worker thread is blocked on page lock (process A).

Fix this by creating a unique work_struct for each async reply that can
block (O_DIRECT read).

Fixes: a62a8ef9d97d ("virtio-fs: add virtiofs filesystem")
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c      |   1 +
 fs/fuse/fuse_i.h    |   1 +
 fs/fuse/virtio_fs.c | 106 +++++++++++++++++++++++++++++---------------
 3 files changed, 73 insertions(+), 35 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 3dd37a998ea93..713d55a61890e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -712,6 +712,7 @@ static ssize_t fuse_async_req_send(struct fuse_conn *fc,
 	spin_unlock(&io->lock);
 
 	ia->ap.args.end = fuse_aio_complete_req;
+	ia->ap.args.may_block = io->should_dirty;
 	err = fuse_simple_background(fc, &ia->ap.args, GFP_KERNEL);
 	if (err)
 		fuse_aio_complete_req(fc, &ia->ap.args, err);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index ca344bf714045..d7cde216fc871 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -249,6 +249,7 @@ struct fuse_args {
 	bool out_argvar:1;
 	bool page_zeroing:1;
 	bool page_replace:1;
+	bool may_block:1;
 	struct fuse_in_arg in_args[3];
 	struct fuse_arg out_args[2];
 	void (*end)(struct fuse_conn *fc, struct fuse_args *args, int error);
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index a5c86048b96ed..7505f81027623 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -55,6 +55,12 @@ struct virtio_fs_forget {
 	struct list_head list;
 };
 
+struct virtio_fs_req_work {
+	struct fuse_req *req;
+	struct virtio_fs_vq *fsvq;
+	struct work_struct done_work;
+};
+
 static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 				 struct fuse_req *req, bool in_flight);
 
@@ -443,19 +449,67 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 }
 
 /* Work function for request completion */
+static void virtio_fs_request_complete(struct fuse_req *req,
+				       struct virtio_fs_vq *fsvq)
+{
+	struct fuse_pqueue *fpq = &fsvq->fud->pq;
+	struct fuse_conn *fc = fsvq->fud->fc;
+	struct fuse_args *args;
+	struct fuse_args_pages *ap;
+	unsigned int len, i, thislen;
+	struct page *page;
+
+	/*
+	 * TODO verify that server properly follows FUSE protocol
+	 * (oh.uniq, oh.len)
+	 */
+	args = req->args;
+	copy_args_from_argbuf(args, req);
+
+	if (args->out_pages && args->page_zeroing) {
+		len = args->out_args[args->out_numargs - 1].size;
+		ap = container_of(args, typeof(*ap), args);
+		for (i = 0; i < ap->num_pages; i++) {
+			thislen = ap->descs[i].length;
+			if (len < thislen) {
+				WARN_ON(ap->descs[i].offset);
+				page = ap->pages[i];
+				zero_user_segment(page, len, thislen);
+				len = 0;
+			} else {
+				len -= thislen;
+			}
+		}
+	}
+
+	spin_lock(&fpq->lock);
+	clear_bit(FR_SENT, &req->flags);
+	spin_unlock(&fpq->lock);
+
+	fuse_request_end(fc, req);
+	spin_lock(&fsvq->lock);
+	dec_in_flight_req(fsvq);
+	spin_unlock(&fsvq->lock);
+}
+
+static void virtio_fs_complete_req_work(struct work_struct *work)
+{
+	struct virtio_fs_req_work *w =
+		container_of(work, typeof(*w), done_work);
+
+	virtio_fs_request_complete(w->req, w->fsvq);
+	kfree(w);
+}
+
 static void virtio_fs_requests_done_work(struct work_struct *work)
 {
 	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
 						 done_work);
 	struct fuse_pqueue *fpq = &fsvq->fud->pq;
-	struct fuse_conn *fc = fsvq->fud->fc;
 	struct virtqueue *vq = fsvq->vq;
 	struct fuse_req *req;
-	struct fuse_args_pages *ap;
 	struct fuse_req *next;
-	struct fuse_args *args;
-	unsigned int len, i, thislen;
-	struct page *page;
+	unsigned int len;
 	LIST_HEAD(reqs);
 
 	/* Collect completed requests off the virtqueue */
@@ -473,38 +527,20 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
 
 	/* End requests */
 	list_for_each_entry_safe(req, next, &reqs, list) {
-		/*
-		 * TODO verify that server properly follows FUSE protocol
-		 * (oh.uniq, oh.len)
-		 */
-		args = req->args;
-		copy_args_from_argbuf(args, req);
-
-		if (args->out_pages && args->page_zeroing) {
-			len = args->out_args[args->out_numargs - 1].size;
-			ap = container_of(args, typeof(*ap), args);
-			for (i = 0; i < ap->num_pages; i++) {
-				thislen = ap->descs[i].length;
-				if (len < thislen) {
-					WARN_ON(ap->descs[i].offset);
-					page = ap->pages[i];
-					zero_user_segment(page, len, thislen);
-					len = 0;
-				} else {
-					len -= thislen;
-				}
-			}
-		}
-
-		spin_lock(&fpq->lock);
-		clear_bit(FR_SENT, &req->flags);
 		list_del_init(&req->list);
-		spin_unlock(&fpq->lock);
 
-		fuse_request_end(fc, req);
-		spin_lock(&fsvq->lock);
-		dec_in_flight_req(fsvq);
-		spin_unlock(&fsvq->lock);
+		/* blocking async request completes in a worker context */
+		if (req->args->may_block) {
+			struct virtio_fs_req_work *w;
+
+			w = kzalloc(sizeof(*w), GFP_NOFS | __GFP_NOFAIL);
+			INIT_WORK(&w->done_work, virtio_fs_complete_req_work);
+			w->fsvq = fsvq;
+			w->req = req;
+			schedule_work(&w->done_work);
+		} else {
+			virtio_fs_request_complete(req, fsvq);
+		}
 	}
 }
 
-- 
2.25.1



