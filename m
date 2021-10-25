Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4035D43A08A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhJYTbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235355AbhJYT3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:29:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 424F060FE8;
        Mon, 25 Oct 2021 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190011;
        bh=dZL0HkKLfPiYFXAEZO8A5y1YUcudAsryqSfPfFfRvXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkHU4OCz24JbJnihZ4pheGo1JGwUPK9+bGXxhQWLS49l2d/QJ2bs+C00Je/lYylTk
         rWQ5WCfrzHq+MAwGh32O8X+Wkd2aHZzY6IzsD0M6BUHWFPxS61ERlATLUpTCna09R0
         dTOrVgY/BZtjknNsjhY+RoyVNe7H2me2PPcus9ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Donnelly <pdonnell@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.4 26/58] ceph: fix handling of "meta" errors
Date:   Mon, 25 Oct 2021 21:14:43 +0200
Message-Id: <20211025190941.839507576@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 1bd85aa65d0e7b5e4d09240f492f37c569fdd431 upstream.

Currently, we check the wb_err too early for directories, before all of
the unsafe child requests have been waited on. In order to fix that we
need to check the mapping->wb_err later nearer to the end of ceph_fsync.

We also have an overly-complex method for tracking errors after
blocklisting. The errors recorded in cleanup_session_requests go to a
completely separate field in the inode, but we end up reporting them the
same way we would for any other error (in fsync).

There's no real benefit to tracking these errors in two different
places, since the only reporting mechanism for them is in fsync, and
we'd need to advance them both every time.

Given that, we can just remove i_meta_err, and convert the places that
used it to instead just use mapping->wb_err instead. That also fixes
the original problem by ensuring that we do a check_and_advance of the
wb_err at the end of the fsync op.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/52864
Reported-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c       |   12 +++---------
 fs/ceph/file.c       |    1 -
 fs/ceph/inode.c      |    2 --
 fs/ceph/mds_client.c |   17 +++++------------
 fs/ceph/super.h      |    3 ---
 5 files changed, 8 insertions(+), 27 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2249,7 +2249,6 @@ static int unsafe_request_wait(struct in
 
 int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct ceph_file_info *fi = file->private_data;
 	struct inode *inode = file->f_mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 flush_tid;
@@ -2280,14 +2279,9 @@ int ceph_fsync(struct file *file, loff_t
 	if (err < 0)
 		ret = err;
 
-	if (errseq_check(&ci->i_meta_err, READ_ONCE(fi->meta_err))) {
-		spin_lock(&file->f_lock);
-		err = errseq_check_and_advance(&ci->i_meta_err,
-					       &fi->meta_err);
-		spin_unlock(&file->f_lock);
-		if (err < 0)
-			ret = err;
-	}
+	err = file_check_and_advance_wb_err(file);
+	if (err < 0)
+		ret = err;
 out:
 	dout("fsync %p%s result=%d\n", inode, datasync ? " datasync" : "", ret);
 	return ret;
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -234,7 +234,6 @@ static int ceph_init_file_info(struct in
 	fi->fmode = fmode;
 	spin_lock_init(&fi->rw_contexts_lock);
 	INIT_LIST_HEAD(&fi->rw_contexts);
-	fi->meta_err = errseq_sample(&ci->i_meta_err);
 	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
 
 	return 0;
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -515,8 +515,6 @@ struct inode *ceph_alloc_inode(struct su
 
 	ceph_fscache_inode_init(ci);
 
-	ci->i_meta_err = 0;
-
 	return &ci->vfs_inode;
 }
 
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1272,7 +1272,6 @@ static void cleanup_session_requests(str
 {
 	struct ceph_mds_request *req;
 	struct rb_node *p;
-	struct ceph_inode_info *ci;
 
 	dout("cleanup_session_requests mds%d\n", session->s_mds);
 	mutex_lock(&mdsc->mutex);
@@ -1281,16 +1280,10 @@ static void cleanup_session_requests(str
 				       struct ceph_mds_request, r_unsafe_item);
 		pr_warn_ratelimited(" dropping unsafe request %llu\n",
 				    req->r_tid);
-		if (req->r_target_inode) {
-			/* dropping unsafe change of inode's attributes */
-			ci = ceph_inode(req->r_target_inode);
-			errseq_set(&ci->i_meta_err, -EIO);
-		}
-		if (req->r_unsafe_dir) {
-			/* dropping unsafe directory operation */
-			ci = ceph_inode(req->r_unsafe_dir);
-			errseq_set(&ci->i_meta_err, -EIO);
-		}
+		if (req->r_target_inode)
+			mapping_set_error(req->r_target_inode->i_mapping, -EIO);
+		if (req->r_unsafe_dir)
+			mapping_set_error(req->r_unsafe_dir->i_mapping, -EIO);
 		__unregister_request(mdsc, req);
 	}
 	/* zero r_attempts, so kick_requests() will re-send requests */
@@ -1436,7 +1429,7 @@ static int remove_session_caps_cb(struct
 		spin_unlock(&mdsc->cap_dirty_lock);
 
 		if (dirty_dropped) {
-			errseq_set(&ci->i_meta_err, -EIO);
+			mapping_set_error(inode->i_mapping, -EIO);
 
 			if (ci->i_wrbuffer_ref_head == 0 &&
 			    ci->i_wr_ref == 0 &&
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -402,8 +402,6 @@ struct ceph_inode_info {
 	struct fscache_cookie *fscache;
 	u32 i_fscache_gen;
 #endif
-	errseq_t i_meta_err;
-
 	struct inode vfs_inode; /* at end */
 };
 
@@ -712,7 +710,6 @@ struct ceph_file_info {
 	spinlock_t rw_contexts_lock;
 	struct list_head rw_contexts;
 
-	errseq_t meta_err;
 	u32 filp_gen;
 	atomic_t num_locks;
 };


