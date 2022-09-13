Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007895B710D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiIMOfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiIMOfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C4C65642;
        Tue, 13 Sep 2022 07:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3D4F614B2;
        Tue, 13 Sep 2022 14:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8CEC433D6;
        Tue, 13 Sep 2022 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078750;
        bh=PGP2n75K5nrEDJFeUjxdIcEcRfPzOjwmBHBl8Ki3YUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvBaN4ci/3cuTaaqBLYH71PXefpA1OE4fGQROf7NpqczcC2rg9vcQAEVMHFfYhF5d
         xXQIvZjrJSSpzw37ZlkZ21FAks/hmFaKmo0Vp0QKuq42jbywTJdQhcPiyS0stCjDtX
         g6OzTwhfQr/2lMblxiVtIno7vhT6FI8sQGrxzJeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/121] NFS: Further optimisations for ls -l
Date:   Tue, 13 Sep 2022 16:03:54 +0200
Message-Id: <20220913140359.215519443@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ff81dfb5d721fff87bd516c558847f6effb70031 ]

If a user is doing 'ls -l', we have a heuristic in GETATTR that tells
the readdir code to try to use READDIRPLUS in order to refresh the inode
attributes. In certain cirumstances, we also try to invalidate the
remaining directory entries in order to ensure this refresh.

If there are multiple readers of the directory, we probably should avoid
invalidating the page cache, since the heuristic breaks down in that
situation anyway.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Tested-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c           | 16 +++++++++++-----
 include/linux/nfs_fs.h |  5 ++---
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 78219396788b4..32c3d0c454b19 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -78,6 +78,7 @@ static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct inode *dir
 		ctx->attr_gencount = nfsi->attr_gencount;
 		ctx->dir_cookie = 0;
 		ctx->dup_cookie = 0;
+		ctx->page_index = 0;
 		spin_lock(&dir->i_lock);
 		if (list_empty(&nfsi->open_files) &&
 		    (nfsi->cache_validity & NFS_INO_DATA_INVAL_DEFER))
@@ -85,6 +86,7 @@ static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct inode *dir
 					      NFS_INO_INVALID_DATA |
 						      NFS_INO_REVAL_FORCED);
 		list_add(&ctx->list, &nfsi->open_files);
+		clear_bit(NFS_INO_FORCE_READDIR, &nfsi->flags);
 		spin_unlock(&dir->i_lock);
 		return ctx;
 	}
@@ -626,8 +628,7 @@ void nfs_force_use_readdirplus(struct inode *dir)
 	if (nfs_server_capable(dir, NFS_CAP_READDIRPLUS) &&
 	    !list_empty(&nfsi->open_files)) {
 		set_bit(NFS_INO_ADVISE_RDPLUS, &nfsi->flags);
-		invalidate_mapping_pages(dir->i_mapping,
-			nfsi->page_index + 1, -1);
+		set_bit(NFS_INO_FORCE_READDIR, &nfsi->flags);
 	}
 }
 
@@ -938,10 +939,8 @@ static int find_and_lock_cache_page(struct nfs_readdir_descriptor *desc)
 			       sizeof(nfsi->cookieverf));
 	}
 	res = nfs_readdir_search_array(desc);
-	if (res == 0) {
-		nfsi->page_index = desc->page_index;
+	if (res == 0)
 		return 0;
-	}
 	nfs_readdir_page_unlock_and_put_cached(desc);
 	return res;
 }
@@ -1081,6 +1080,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_open_dir_context *dir_ctx = file->private_data;
 	struct nfs_readdir_descriptor *desc;
+	pgoff_t page_index;
 	int res;
 
 	dfprintk(FILE, "NFS: readdir(%pD2) starting at cookie %llu\n",
@@ -1111,10 +1111,15 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	desc->dir_cookie = dir_ctx->dir_cookie;
 	desc->dup_cookie = dir_ctx->dup_cookie;
 	desc->duped = dir_ctx->duped;
+	page_index = dir_ctx->page_index;
 	desc->attr_gencount = dir_ctx->attr_gencount;
 	memcpy(desc->verf, dir_ctx->verf, sizeof(desc->verf));
 	spin_unlock(&file->f_lock);
 
+	if (test_and_clear_bit(NFS_INO_FORCE_READDIR, &nfsi->flags) &&
+	    list_is_singular(&nfsi->open_files))
+		invalidate_mapping_pages(inode->i_mapping, page_index + 1, -1);
+
 	do {
 		res = readdir_search_pagecache(desc);
 
@@ -1151,6 +1156,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	dir_ctx->dup_cookie = desc->dup_cookie;
 	dir_ctx->duped = desc->duped;
 	dir_ctx->attr_gencount = desc->attr_gencount;
+	dir_ctx->page_index = desc->page_index;
 	memcpy(dir_ctx->verf, desc->verf, sizeof(dir_ctx->verf));
 	spin_unlock(&file->f_lock);
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 66b6cc24ab8c9..be8625d8a10a7 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -103,6 +103,7 @@ struct nfs_open_dir_context {
 	__be32	verf[NFS_DIR_VERIFIER_SIZE];
 	__u64 dir_cookie;
 	__u64 dup_cookie;
+	pgoff_t page_index;
 	signed char duped;
 };
 
@@ -181,9 +182,6 @@ struct nfs_inode {
 	struct rw_semaphore	rmdir_sem;
 	struct mutex		commit_mutex;
 
-	/* track last access to cached pages */
-	unsigned long		page_index;
-
 #if IS_ENABLED(CONFIG_NFS_V4)
 	struct nfs4_cached_acl	*nfs4_acl;
         /* NFSv4 state */
@@ -272,6 +270,7 @@ struct nfs4_copy_state {
 #define NFS_INO_INVALIDATING	(3)		/* inode is being invalidated */
 #define NFS_INO_FSCACHE		(5)		/* inode can be cached by FS-Cache */
 #define NFS_INO_FSCACHE_LOCK	(6)		/* FS-Cache cookie management lock */
+#define NFS_INO_FORCE_READDIR	(7)		/* force readdirplus */
 #define NFS_INO_LAYOUTCOMMIT	(9)		/* layoutcommit required */
 #define NFS_INO_LAYOUTCOMMITTING (10)		/* layoutcommit inflight */
 #define NFS_INO_LAYOUTSTATS	(11)		/* layoutstats inflight */
-- 
2.35.1



