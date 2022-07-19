Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB41C579E4A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242408AbiGSNBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242703AbiGSM72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F6149B7B;
        Tue, 19 Jul 2022 05:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8954AB81B21;
        Tue, 19 Jul 2022 12:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AF7C385A2;
        Tue, 19 Jul 2022 12:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233475;
        bh=34nY3cGcXUqpygCFQdRtZUmjMo5CnWbwj99e4WJuw6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbXYtX3WmU+c9EYKDTJCcUp8Je44avSZ6/dMkWj4/AB7vj91Fx5Q2DCiOMa6J5fP0
         mDWrU6jUKSfGiUXaktKUC2NUr0MfM1qyt4wKSrXW45EvP0cZYZWPl8Ir79S1+seJ1K
         9vtKEdGvlWsUTVh0QHHUHlHEGFO4BY5+FEW78CmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 135/231] netfs: do not unlock and put the folio twice
Date:   Tue, 19 Jul 2022 13:53:40 +0200
Message-Id: <20220719114725.789597627@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit fac47b43c760ea90e64b895dba60df0327be7775 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/netfs_library.rst |  8 +++++---
 fs/afs/file.c                               |  2 +-
 fs/ceph/addr.c                              | 11 ++++++-----
 fs/netfs/buffered_read.c                    | 17 ++++++++++-------
 include/linux/netfs.h                       |  2 +-
 5 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/Documentation/filesystems/netfs_library.rst b/Documentation/filesystems/netfs_library.rst
index 0483abcafcb0..0542358724f1 100644
--- a/Documentation/filesystems/netfs_library.rst
+++ b/Documentation/filesystems/netfs_library.rst
@@ -300,7 +300,7 @@ through which it can issue requests and negotiate::
 		void (*issue_read)(struct netfs_io_subrequest *subreq);
 		bool (*is_still_valid)(struct netfs_io_request *rreq);
 		int (*check_write_begin)(struct file *file, loff_t pos, unsigned len,
-					 struct folio *folio, void **_fsdata);
+					 struct folio **foliop, void **_fsdata);
 		void (*done)(struct netfs_io_request *rreq);
 		void (*cleanup)(struct address_space *mapping, void *netfs_priv);
 	};
@@ -376,8 +376,10 @@ The operations are as follows:
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
index fab8324833ba..a8a5a91dc375 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -376,7 +376,7 @@ static int afs_begin_cache_operation(struct netfs_io_request *rreq)
 }
 
 static int afs_check_write_begin(struct file *file, loff_t pos, unsigned len,
-				 struct folio *folio, void **_fsdata)
+				 struct folio **foliop, void **_fsdata)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 11dbb1133a21..ae567fb7f65a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -63,7 +63,7 @@
 	 (CONGESTION_ON_THRESH(congestion_kb) >> 2))
 
 static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
-					struct folio *folio, void **_fsdata);
+					struct folio **foliop, void **_fsdata);
 
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
@@ -1285,18 +1285,19 @@ ceph_find_incompatible(struct page *page)
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
index e8e3359a4c54..8d03826c2b15 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -320,8 +320,9 @@ static bool netfs_skip_folio_read(struct folio *folio, loff_t pos, size_t len,
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
@@ -352,13 +353,13 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
 
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
@@ -420,8 +421,10 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
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
index a9c6f73877ec..95dadf0cd4b8 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -211,7 +211,7 @@ struct netfs_request_ops {
 	void (*issue_read)(struct netfs_io_subrequest *subreq);
 	bool (*is_still_valid)(struct netfs_io_request *rreq);
 	int (*check_write_begin)(struct file *file, loff_t pos, unsigned len,
-				 struct folio *folio, void **_fsdata);
+				 struct folio **foliop, void **_fsdata);
 	void (*done)(struct netfs_io_request *rreq);
 	void (*cleanup)(struct address_space *mapping, void *netfs_priv);
 };
-- 
2.35.1



