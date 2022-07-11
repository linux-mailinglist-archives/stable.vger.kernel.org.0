Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28F656D3BC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 06:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiGKEXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 00:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGKEXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 00:23:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDD596260
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 21:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657513424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3P7dCne5l6opjJU2k3qWtqi1rMQbIE4VPCehg9nJnr0=;
        b=Uv4aAWd86j5HyQborPIxDYcSCROuUbwHX+WKncU60tVJmjYusgQ3j+9imTKXIyRSB/xHSK
        7jOQ7D5lxzxOxFmLrG97Oc/Kpi+jUe3GArHYZZopOZfa4a8LWFu9xj2G2zoGwdTUfAi0ln
        TQb+cLxh1aoIEMf8sMkdAOKInYXjn8w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-1EuZQ595Pz-dpg66gg4NMw-1; Mon, 11 Jul 2022 00:23:41 -0400
X-MC-Unique: 1EuZQ595Pz-dpg66gg4NMw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0685802D2C;
        Mon, 11 Jul 2022 04:23:40 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71DF3492CA2;
        Mon, 11 Jul 2022 04:23:35 +0000 (UTC)
From:   xiubli@redhat.com
To:     dhowells@redhat.com, idryomov@gmail.com, jlayton@kernel.org
Cc:     marc.dionne@auristor.com, willy@infradead.org,
        keescook@chromium.org, kirill.shutemov@linux.intel.com,
        william.kucharski@oracle.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-cachefs@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v5] netfs: do not unlock and put the folio twice
Date:   Mon, 11 Jul 2022 12:23:28 +0800
Message-Id: <20220711042328.417942-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

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

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/56423
Link: https://lore.kernel.org/r/20220707045112.10177-2-xiubli@redhat.com/
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 Documentation/filesystems/netfs_library.rst |  8 +++++---
 fs/afs/file.c                               |  2 +-
 fs/ceph/addr.c                              | 11 ++++++-----
 fs/netfs/buffered_read.c                    | 17 ++++++++++-------
 include/linux/netfs.h                       |  2 +-
 5 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/Documentation/filesystems/netfs_library.rst b/Documentation/filesystems/netfs_library.rst
index 4d19b19bcc08..8d4cf5d5822d 100644
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
+   pointer to NULL.  It should return 0 if everything is now fine (*foliop
+   left set) or the op should be retried (*foliop cleared) and any other error
+   code to abort the operation.
 
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
index 8095fc47230e..3369c54d8002 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -63,7 +63,7 @@
 	 (CONGESTION_ON_THRESH(congestion_kb) >> 2))
 
 static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
-					struct folio *folio, void **_fsdata);
+					struct folio **foliop, void **_fsdata);
 
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
@@ -1280,18 +1280,19 @@ ceph_find_incompatible(struct page *page)
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
index 42f892c5712e..8fa0725cd649 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -319,8 +319,9 @@ static bool netfs_skip_folio_read(struct folio *folio, loff_t pos, size_t len,
  * conflicting writes once the folio is grabbed and locked.  It is passed a
  * pointer to the fsdata cookie that gets returned to the VM to be passed to
  * write_end.  It is permitted to sleep.  It should return 0 if the request
- * should go ahead; unlock the folio and return -EAGAIN to cause the folio to
- * be regot; or return an error.
+ * should go ahead or it may return an error.  It may also unlock and put the
+ * folio, provided it sets *foliop to NULL, in which case a return of 0 will
+ * cause the folio to be re-got and the process to be retried.
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
 
-- 
2.36.0.rc1

