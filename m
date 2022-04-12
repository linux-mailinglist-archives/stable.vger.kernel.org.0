Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E994FD1E3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbiDLHJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352438AbiDLHFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F76B4757D;
        Mon, 11 Apr 2022 23:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B83A760A21;
        Tue, 12 Apr 2022 06:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C451CC385A1;
        Tue, 12 Apr 2022 06:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746088;
        bh=c20VdvzvhFiupQWkJezZWMas+iElTSBytPEo9wRQr4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NP2kBN0XjeJvaOZUI+zyVOTpBUwZdd8ZVodbmMQuduIoV02aNbW+Qdx5D2xrUrDj4
         WQwaYEKgrQX1QNBk61KYFA5BIN3AslbYnmiUpZYCuYIyH4djIb50XN1HotJfNKcdTu
         ZVbpZmPZbmsrLasrf6Byvu81Y6RAPLj08ERRRUDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/277] NFS: Avoid writeback threads getting stuck in mempool_alloc()
Date:   Tue, 12 Apr 2022 08:29:02 +0200
Message-Id: <20220412062946.057895796@linuxfoundation.org>
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

[ Upstream commit 0bae835b63c53f86cdc524f5962e39409585b22c ]

In a low memory situation, allow the NFS writeback code to fail without
getting stuck in infinite loops in mempool_alloc().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pagelist.c | 10 +++++-----
 fs/nfs/write.c    | 10 ++++++++--
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index b1130dc200d2..f2fe23e6c51f 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -90,10 +90,10 @@ void nfs_set_pgio_error(struct nfs_pgio_header *hdr, int error, loff_t pos)
 	}
 }
 
-static inline struct nfs_page *
-nfs_page_alloc(void)
+static inline struct nfs_page *nfs_page_alloc(void)
 {
-	struct nfs_page	*p = kmem_cache_zalloc(nfs_page_cachep, GFP_KERNEL);
+	struct nfs_page *p =
+		kmem_cache_zalloc(nfs_page_cachep, nfs_io_gfp_mask());
 	if (p)
 		INIT_LIST_HEAD(&p->wb_list);
 	return p;
@@ -901,7 +901,7 @@ int nfs_generic_pgio(struct nfs_pageio_descriptor *desc,
 	struct nfs_commit_info cinfo;
 	struct nfs_page_array *pg_array = &hdr->page_array;
 	unsigned int pagecount, pageused;
-	gfp_t gfp_flags = GFP_KERNEL;
+	gfp_t gfp_flags = nfs_io_gfp_mask();
 
 	pagecount = nfs_page_array_len(mirror->pg_base, mirror->pg_count);
 	pg_array->npages = pagecount;
@@ -988,7 +988,7 @@ nfs_pageio_alloc_mirrors(struct nfs_pageio_descriptor *desc,
 	desc->pg_mirrors_dynamic = NULL;
 	if (mirror_count == 1)
 		return desc->pg_mirrors_static;
-	ret = kmalloc_array(mirror_count, sizeof(*ret), GFP_KERNEL);
+	ret = kmalloc_array(mirror_count, sizeof(*ret), nfs_io_gfp_mask());
 	if (ret != NULL) {
 		for (i = 0; i < mirror_count; i++)
 			nfs_pageio_mirror_init(&ret[i], desc->pg_bsize);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index a296e504e4aa..d21b25511499 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -94,9 +94,15 @@ EXPORT_SYMBOL_GPL(nfs_commit_free);
 
 static struct nfs_pgio_header *nfs_writehdr_alloc(void)
 {
-	struct nfs_pgio_header *p = mempool_alloc(nfs_wdata_mempool, GFP_KERNEL);
+	struct nfs_pgio_header *p;
 
-	memset(p, 0, sizeof(*p));
+	p = kmem_cache_zalloc(nfs_wdata_cachep, nfs_io_gfp_mask());
+	if (!p) {
+		p = mempool_alloc(nfs_wdata_mempool, GFP_NOWAIT);
+		if (!p)
+			return NULL;
+		memset(p, 0, sizeof(*p));
+	}
 	p->rw_mode = FMODE_WRITE;
 	return p;
 }
-- 
2.35.1



