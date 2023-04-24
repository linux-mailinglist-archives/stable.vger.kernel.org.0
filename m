Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF2A6ECEE9
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjDXNgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbjDXNf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40308A63
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBCD2623BC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF626C433EF;
        Mon, 24 Apr 2023 13:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343341;
        bh=6Pl+e3U2TNSCXdvrEJYvpWbm/KdHYSPKB9hipob65zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWfBykFK4yaiXsIGGxhOkUW5V7AEIXjSmK0eXgW5JUw/ZOhrMwhUnY+F+LVTLtPaY
         8aIJyVBKrmqCx81+oS19J5J9fqFahY/TwCx35iu8rA/oGKZcEPv6gtL/AKVfywT0K2
         VWi7a2XFQ6UyNxyVlAmKH0bYhwcZCVVOBaQxKPj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Connor Kuehl <ckuehl@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 5.10 50/68] virtiofs: split requests that exceed virtqueue size
Date:   Mon, 24 Apr 2023 15:18:21 +0200
Message-Id: <20230424131129.589375128@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor Kuehl <ckuehl@redhat.com>

commit a7f0d7aab0b4f3f0780b1f77356e2fe7202ac0cb upstream.

If an incoming FUSE request can't fit on the virtqueue, the request is
placed onto a workqueue so a worker can try to resubmit it later where
there will (hopefully) be space for it next time.

This is fine for requests that aren't larger than a virtqueue's maximum
capacity.  However, if a request's size exceeds the maximum capacity of the
virtqueue (even if the virtqueue is empty), it will be doomed to a life of
being placed on the workqueue, removed, discovered it won't fit, and placed
on the workqueue yet again.

Furthermore, from section 2.6.5.3.1 (Driver Requirements: Indirect
Descriptors) of the virtio spec:

  "A driver MUST NOT create a descriptor chain longer than the Queue
  Size of the device."

To fix this, limit the number of pages FUSE will use for an overall
request.  This way, each request can realistically fit on the virtqueue
when it is decomposed into a scattergather list and avoid violating section
2.6.5.3.1 of the virtio spec.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/fuse_i.h    |    3 +++
 fs/fuse/inode.c     |    3 ++-
 fs/fuse/virtio_fs.c |   19 +++++++++++++++++--
 3 files changed, 22 insertions(+), 3 deletions(-)

--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -556,6 +556,9 @@ struct fuse_conn {
 	/** Maxmum number of pages that can be used in a single request */
 	unsigned int max_pages;
 
+	/** Constrain ->max_pages to this value during feature negotiation */
+	unsigned int max_pages_limit;
+
 	/** Input queue */
 	struct fuse_iqueue iq;
 
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -710,6 +710,7 @@ void fuse_conn_init(struct fuse_conn *fc
 	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
 	fc->user_ns = get_user_ns(user_ns);
 	fc->max_pages = FUSE_DEFAULT_MAX_PAGES_PER_REQ;
+	fc->max_pages_limit = FUSE_MAX_MAX_PAGES;
 
 	INIT_LIST_HEAD(&fc->mounts);
 	list_add(&fm->fc_entry, &fc->mounts);
@@ -1056,7 +1057,7 @@ static void process_init_reply(struct fu
 				fc->abort_err = 1;
 			if (arg->flags & FUSE_MAX_PAGES) {
 				fc->max_pages =
-					min_t(unsigned int, FUSE_MAX_MAX_PAGES,
+					min_t(unsigned int, fc->max_pages_limit,
 					max_t(unsigned int, arg->max_pages, 1));
 			}
 			if (IS_ENABLED(CONFIG_FUSE_DAX) &&
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -18,6 +18,12 @@
 #include <linux/uio.h>
 #include "fuse_i.h"
 
+/* Used to help calculate the FUSE connection's max_pages limit for a request's
+ * size. Parts of the struct fuse_req are sliced into scattergather lists in
+ * addition to the pages used, so this can help account for that overhead.
+ */
+#define FUSE_HEADER_OVERHEAD    4
+
 /* List of virtio-fs device instances and a lock for the list. Also provides
  * mutual exclusion in device removal and mounting path
  */
@@ -1426,9 +1432,10 @@ static int virtio_fs_get_tree(struct fs_
 {
 	struct virtio_fs *fs;
 	struct super_block *sb;
-	struct fuse_conn *fc;
+	struct fuse_conn *fc = NULL;
 	struct fuse_mount *fm;
-	int err;
+	unsigned int virtqueue_size;
+	int err = -EIO;
 
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
@@ -1440,6 +1447,10 @@ static int virtio_fs_get_tree(struct fs_
 		return -EINVAL;
 	}
 
+	virtqueue_size = virtqueue_get_vring_size(fs->vqs[VQ_REQUEST].vq);
+	if (WARN_ON(virtqueue_size <= FUSE_HEADER_OVERHEAD))
+		goto out_err;
+
 	err = -ENOMEM;
 	fc = kzalloc(sizeof(struct fuse_conn), GFP_KERNEL);
 	if (!fc)
@@ -1454,6 +1465,10 @@ static int virtio_fs_get_tree(struct fs_
 	fc->delete_stale = true;
 	fc->auto_submounts = true;
 
+	/* Tell FUSE to split requests that exceed the virtqueue's size */
+	fc->max_pages_limit = min_t(unsigned int, fc->max_pages_limit,
+				    virtqueue_size - FUSE_HEADER_OVERHEAD);
+
 	fsc->s_fs_info = fm;
 	sb = sget_fc(fsc, virtio_fs_test_super, virtio_fs_set_super);
 	fuse_mount_put(fm);


