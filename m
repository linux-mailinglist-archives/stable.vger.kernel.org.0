Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63C24FD202
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347377AbiDLHJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352071AbiDLHEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:04:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537CE457B2;
        Mon, 11 Apr 2022 23:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D7A260A21;
        Tue, 12 Apr 2022 06:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969ABC385A1;
        Tue, 12 Apr 2022 06:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746058;
        bh=WDud53N3J5fauLU1Y/1OS8o+0T5+mV0aB97fdLwlVME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/pEazK1hj9dPxy78Fsng7o08+K31tv62V5lVswyVaruNbyjbazjQhn3ojxdvIP9L
         sDJaJfM0r1PtD8l6z7C4g/Ff7cG9t3UqWzZm02C8zSwCQsFYRLjTKCodxJYWCIaFAP
         k2adpSRwAt95cnXBYmXCJdDZmkrXrmpqFz+v3zUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/277] NFS: nfsiod should not block forever in mempool_alloc()
Date:   Tue, 12 Apr 2022 08:29:01 +0200
Message-Id: <20220412062946.028817523@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit 515dcdcd48736576c6f5c197814da6f81c60a21e ]

The concern is that since nfsiod is sometimes required to kick off a
commit, it can get locked up waiting forever in mempool_alloc() instead
of failing gracefully and leaving the commit until later.

Try to allocate from the slab first, with GFP_KERNEL | __GFP_NORETRY,
then fall back to a non-blocking attempt to allocate from the memory
pool.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h      |  7 +++++++
 fs/nfs/pnfs_nfs.c      |  8 ++++++--
 fs/nfs/write.c         | 24 +++++++++---------------
 include/linux/nfs_fs.h |  2 +-
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 66fc936834f2..7239118d98a3 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -580,6 +580,13 @@ nfs_write_match_verf(const struct nfs_writeverf *verf,
 		!nfs_write_verifier_cmp(&req->wb_verf, &verf->verifier);
 }
 
+static inline gfp_t nfs_io_gfp_mask(void)
+{
+	if (current->flags & PF_WQ_WORKER)
+		return GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
+	return GFP_KERNEL;
+}
+
 /* unlink.c */
 extern struct rpc_task *
 nfs_async_rename(struct inode *old_dir, struct inode *new_dir,
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 316f68f96e57..657c242a18ff 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -419,7 +419,7 @@ static struct nfs_commit_data *
 pnfs_bucket_fetch_commitdata(struct pnfs_commit_bucket *bucket,
 			     struct nfs_commit_info *cinfo)
 {
-	struct nfs_commit_data *data = nfs_commitdata_alloc(false);
+	struct nfs_commit_data *data = nfs_commitdata_alloc();
 
 	if (!data)
 		return NULL;
@@ -515,7 +515,11 @@ pnfs_generic_commit_pagelist(struct inode *inode, struct list_head *mds_pages,
 	unsigned int nreq = 0;
 
 	if (!list_empty(mds_pages)) {
-		data = nfs_commitdata_alloc(true);
+		data = nfs_commitdata_alloc();
+		if (!data) {
+			nfs_retry_commit(mds_pages, NULL, cinfo, -1);
+			return -ENOMEM;
+		}
 		data->ds_commit_index = -1;
 		list_splice_init(mds_pages, &data->pages);
 		list_add_tail(&data->list, &list);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 0691b0b02147..a296e504e4aa 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -70,27 +70,17 @@ static mempool_t *nfs_wdata_mempool;
 static struct kmem_cache *nfs_cdata_cachep;
 static mempool_t *nfs_commit_mempool;
 
-struct nfs_commit_data *nfs_commitdata_alloc(bool never_fail)
+struct nfs_commit_data *nfs_commitdata_alloc(void)
 {
 	struct nfs_commit_data *p;
 
-	if (never_fail)
-		p = mempool_alloc(nfs_commit_mempool, GFP_NOIO);
-	else {
-		/* It is OK to do some reclaim, not no safe to wait
-		 * for anything to be returned to the pool.
-		 * mempool_alloc() cannot handle that particular combination,
-		 * so we need two separate attempts.
-		 */
+	p = kmem_cache_zalloc(nfs_cdata_cachep, nfs_io_gfp_mask());
+	if (!p) {
 		p = mempool_alloc(nfs_commit_mempool, GFP_NOWAIT);
-		if (!p)
-			p = kmem_cache_alloc(nfs_cdata_cachep, GFP_NOIO |
-					     __GFP_NOWARN | __GFP_NORETRY);
 		if (!p)
 			return NULL;
+		memset(p, 0, sizeof(*p));
 	}
-
-	memset(p, 0, sizeof(*p));
 	INIT_LIST_HEAD(&p->pages);
 	return p;
 }
@@ -1809,7 +1799,11 @@ nfs_commit_list(struct inode *inode, struct list_head *head, int how,
 	if (list_empty(head))
 		return 0;
 
-	data = nfs_commitdata_alloc(true);
+	data = nfs_commitdata_alloc();
+	if (!data) {
+		nfs_retry_commit(head, NULL, cinfo, -1);
+		return -ENOMEM;
+	}
 
 	/* Set up the argument struct */
 	nfs_init_commit(data, head, NULL, cinfo);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 41102e03512f..5ffcde9ac413 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -567,7 +567,7 @@ extern int nfs_wb_all(struct inode *inode);
 extern int nfs_wb_page(struct inode *inode, struct page *page);
 extern int nfs_wb_page_cancel(struct inode *inode, struct page* page);
 extern int  nfs_commit_inode(struct inode *, int);
-extern struct nfs_commit_data *nfs_commitdata_alloc(bool never_fail);
+extern struct nfs_commit_data *nfs_commitdata_alloc(void);
 extern void nfs_commit_free(struct nfs_commit_data *data);
 bool nfs_commit_end(struct nfs_mds_commit_info *cinfo);
 
-- 
2.35.1



