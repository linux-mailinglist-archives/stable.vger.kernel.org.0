Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4033857868C
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 17:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiGRPme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 11:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiGRPmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 11:42:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5B6BCAB
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 08:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A62ECE17ED
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 15:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD66C341CA;
        Mon, 18 Jul 2022 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658158949;
        bh=vIqBtFGlyadhXQC9a8hPc0Opd5+klgnDPtAvxZL5oyQ=;
        h=Subject:To:Cc:From:Date:From;
        b=1F6zhbGIGVkhM/1JQsO40qGzfA3/t9qa8tEfjhN2uspkSnuLT52T7RI/AgZlqjWIU
         MlHiUp3qxJs1RFXLe2IK6aI28YYboPLDVQxf202Kz5mj10r9yrQDrfMBgxkzxAWksA
         HpXnhXS9h30JdG4E4bB36hMH3HowQBvLsHZPLm88=
Subject: FAILED: patch "[PATCH] netfs: do not unlock and put the folio twice" failed to apply to 5.10-stable tree
To:     xiubli@redhat.com, bagasdotme@gmail.com, dhowells@redhat.com,
        idryomov@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jul 2022 17:42:18 +0200
Message-ID: <1658158938391@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fac47b43c760ea90e64b895dba60df0327be7775 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Mon, 11 Jul 2022 12:11:21 +0800
Subject: [PATCH] netfs: do not unlock and put the folio twice

check_write_begin() will unlock and put the folio when return
non-zero.  So we should avoid unlocking and putting it twice in
netfs layer.

Change the way ->check_write_begin() works in the following two ways:

 (1) Pass it a pointer to the folio pointer, allowing it to unlock and put
     the folio prior to doing the stuff it wants to do, provided it clears
     the folio pointer.

 (2) Change the return values such that 0 with folio pointer set means
     continue, 0 with folio pointer cleared means re-get and all error
     codes indicating an error (no special treatment for -EAGAIN).

[ bagasdotme: use Sphinx code text syntax for *foliop pointer ]

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/56423
Link: https://lore.kernel.org/r/cf169f43-8ee7-8697-25da-0204d1b4343e@redhat.com
Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

diff --git a/Documentation/filesystems/netfs_library.rst b/Documentation/filesystems/netfs_library.rst
index 4d19b19bcc08..73a4176144b3 100644
--- a/Documentation/filesystems/netfs_library.rst
+++ b/Documentation/filesystems/netfs_library.rst
@@ -301,7 +301,7 @@ through which it can issue requests and negotiate::
 		void (*issue_read)(struct netfs_io_subrequest *subreq);
 		bool (*is_still_valid)(struct netfs_io_request *rreq);
 		int (*check_write_begin)(struct file *file, loff_t pos, unsigned len,
-					 struct folio *folio, void **_fsdata);
+					 struct folio **foliop, void **_fsdata);
 		void (*done)(struct netfs_io_request *rreq);
 	};
 
@@ -381,8 +381,10 @@ The operations are as follows:
    allocated/grabbed the folio to be modified to allow the filesystem to flush
    conflicting state before allowing it to be modified.
 
-   It should return 0 if everything is now fine, -EAGAIN if the folio should be
-   regrabbed and any other error code to abort the operation.
+   It may unlock and discard the folio it was given and set the caller's folio
+   pointer to NULL.  It should return 0 if everything is now fine (``*foliop``
+   left set) or the op should be retried (``*foliop`` cleared) and any other
+   error code to abort the operation.
 
  * ``done``
 
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 42118a4f3383..d1cfb235c4b9 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -375,7 +375,7 @@ static int afs_begin_cache_operation(struct netfs_io_request *rreq)
 }
 
 static int afs_check_write_begin(struct file *file, loff_t pos, unsigned len,
-				 struct folio *folio, void **_fsdata)
+				 struct folio **foliop, void **_fsdata)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6dee88815491..d6e5916138e4 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -63,7 +63,7 @@
 	 (CONGESTION_ON_THRESH(congestion_kb) >> 2))
 
 static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
-					struct folio *folio, void **_fsdata);
+					struct folio **foliop, void **_fsdata);
 
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
@@ -1288,18 +1288,19 @@ ceph_find_incompatible(struct page *page)
 }
 
 static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
-					struct folio *folio, void **_fsdata)
+					struct folio **foliop, void **_fsdata)
 {
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_snap_context *snapc;
 
-	snapc = ceph_find_incompatible(folio_page(folio, 0));
+	snapc = ceph_find_incompatible(folio_page(*foliop, 0));
 	if (snapc) {
 		int r;
 
-		folio_unlock(folio);
-		folio_put(folio);
+		folio_unlock(*foliop);
+		folio_put(*foliop);
+		*foliop = NULL;
 		if (IS_ERR(snapc))
 			return PTR_ERR(snapc);
 
diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 42f892c5712e..0ce535852151 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -319,8 +319,9 @@ static bool netfs_skip_folio_read(struct folio *folio, loff_t pos, size_t len,
  * conflicting writes once the folio is grabbed and locked.  It is passed a
  * pointer to the fsdata cookie that gets returned to the VM to be passed to
  * write_end.  It is permitted to sleep.  It should return 0 if the request
- * should go ahead; unlock the folio and return -EAGAIN to cause the folio to
- * be regot; or return an error.
+ * should go ahead or it may return an error.  It may also unlock and put the
+ * folio, provided it sets ``*foliop`` to NULL, in which case a return of 0
+ * will cause the folio to be re-got and the process to be retried.
  *
  * The calling netfs must initialise a netfs context contiguous to the vfs
  * inode before calling this.
@@ -348,13 +349,13 @@ int netfs_write_begin(struct netfs_inode *ctx,
 
 	if (ctx->ops->check_write_begin) {
 		/* Allow the netfs (eg. ceph) to flush conflicts. */
-		ret = ctx->ops->check_write_begin(file, pos, len, folio, _fsdata);
+		ret = ctx->ops->check_write_begin(file, pos, len, &folio, _fsdata);
 		if (ret < 0) {
 			trace_netfs_failure(NULL, NULL, ret, netfs_fail_check_write_begin);
-			if (ret == -EAGAIN)
-				goto retry;
 			goto error;
 		}
+		if (!folio)
+			goto retry;
 	}
 
 	if (folio_test_uptodate(folio))
@@ -416,8 +417,10 @@ int netfs_write_begin(struct netfs_inode *ctx,
 error_put:
 	netfs_put_request(rreq, false, netfs_rreq_trace_put_failed);
 error:
-	folio_unlock(folio);
-	folio_put(folio);
+	if (folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	}
 	_leave(" = %d", ret);
 	return ret;
 }
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 1773e5df8e65..1b18dfa52e48 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -214,7 +214,7 @@ struct netfs_request_ops {
 	void (*issue_read)(struct netfs_io_subrequest *subreq);
 	bool (*is_still_valid)(struct netfs_io_request *rreq);
 	int (*check_write_begin)(struct file *file, loff_t pos, unsigned len,
-				 struct folio *folio, void **_fsdata);
+				 struct folio **foliop, void **_fsdata);
 	void (*done)(struct netfs_io_request *rreq);
 };
 

