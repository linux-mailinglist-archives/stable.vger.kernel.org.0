Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F63B45C107
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346240AbhKXNOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348003AbhKXNMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:12:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 183CE6140B;
        Wed, 24 Nov 2021 12:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757753;
        bh=Uf/Wcztr9Wvb/Kimt4by+bdPmpJPrLRDszZo1cXBh24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+3bbNYq2oXtV1HvY9Y3r9ydaK00nTp1lfNiCkeFZr73ygTI2FQ8bU2IabwB2z7w2
         mjYTiQXZLebU6nWSKNgv5Z71pcz0r4T9tx22c2GPvXy4zpR0bmfdqo1Mf8NTXm7N3v
         NYyRQ6fSHeNgw/SX/oN2576Yv4vTKgNCceCp9qBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 4.19 258/323] erofs: fix unsafe pagevec reuse of hooked pclusters
Date:   Wed, 24 Nov 2021 12:57:28 +0100
Message-Id: <20211124115727.597633999@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 86432a6dca9bed79111990851df5756d3eb5f57c upstream.

There are pclusters in runtime marked with Z_EROFS_PCLUSTER_TAIL
before actual I/O submission. Thus, the decompression chain can be
extended if the following pcluster chain hooks such tail pcluster.

As the related comment mentioned, if some page is made of a hooked
pcluster and another followed pcluster, it can be reused for in-place
I/O (since I/O should be submitted anyway):
 _______________________________________________________________
|  tail (partial) page |          head (partial) page           |
|_____PRIMARY_HOOKED___|____________PRIMARY_FOLLOWED____________|

However, it's by no means safe to reuse as pagevec since if such
PRIMARY_HOOKED pclusters finally move into bypass chain without I/O
submission. It's somewhat hard to reproduce with LZ4 and I just found
it (general protection fault) by ro_fsstressing a LZMA image for long
time.

I'm going to actively clean up related code together with multi-page
folio adaption in the next few months. Let's address it directly for
easier backporting for now.

Call trace for reference:
  z_erofs_decompress_pcluster+0x10a/0x8a0 [erofs]
  z_erofs_decompress_queue.isra.36+0x3c/0x60 [erofs]
  z_erofs_runqueue+0x5f3/0x840 [erofs]
  z_erofs_readahead+0x1e8/0x320 [erofs]
  read_pages+0x91/0x270
  page_cache_ra_unbounded+0x18b/0x240
  filemap_get_pages+0x10a/0x5f0
  filemap_read+0xa9/0x330
  new_sync_read+0x11b/0x1a0
  vfs_read+0xf1/0x190

Link: https://lore.kernel.org/r/20211103182006.4040-1-xiang@kernel.org
Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/erofs/unzip_pagevec.h |   13 ++++++++++---
 drivers/staging/erofs/unzip_vle.c     |   17 +++++++++--------
 2 files changed, 19 insertions(+), 11 deletions(-)

--- a/drivers/staging/erofs/unzip_pagevec.h
+++ b/drivers/staging/erofs/unzip_pagevec.h
@@ -117,11 +117,18 @@ static inline void z_erofs_pagevec_ctor_
 static inline bool
 z_erofs_pagevec_ctor_enqueue(struct z_erofs_pagevec_ctor *ctor,
 			     struct page *page,
-			     enum z_erofs_page_type type)
+			     enum z_erofs_page_type type,
+			     bool pvec_safereuse)
 {
-	if (unlikely(ctor->next == NULL && type))
-		if (ctor->index + 1 == ctor->nr)
+	if (!ctor->next) {
+		/* some pages cannot be reused as pvec safely without I/O */
+		if (type == Z_EROFS_PAGE_TYPE_EXCLUSIVE && !pvec_safereuse)
+			type = Z_EROFS_VLE_PAGE_TYPE_TAIL_SHARED;
+
+		if (type != Z_EROFS_PAGE_TYPE_EXCLUSIVE &&
+		    ctor->index + 1 == ctor->nr)
 			return false;
+	}
 
 	if (unlikely(ctor->index >= ctor->nr))
 		z_erofs_pagevec_ctor_pagedown(ctor, false);
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -228,10 +228,10 @@ static inline bool try_to_reuse_as_compr
 }
 
 /* callers must be with work->lock held */
-static int z_erofs_vle_work_add_page(
-	struct z_erofs_vle_work_builder *builder,
-	struct page *page,
-	enum z_erofs_page_type type)
+static int z_erofs_vle_work_add_page(struct z_erofs_vle_work_builder *builder,
+				     struct page *page,
+				     enum z_erofs_page_type type,
+				     bool pvec_safereuse)
 {
 	int ret;
 
@@ -241,9 +241,9 @@ static int z_erofs_vle_work_add_page(
 		try_to_reuse_as_compressed_page(builder, page))
 		return 0;
 
-	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector, page, type);
+	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector, page, type,
+					   pvec_safereuse);
 	builder->work->vcnt += (unsigned)ret;
-
 	return ret ? 0 : -EAGAIN;
 }
 
@@ -688,14 +688,15 @@ hitted:
 		tight &= builder_is_followed(builder);
 
 retry:
-	err = z_erofs_vle_work_add_page(builder, page, page_type);
+	err = z_erofs_vle_work_add_page(builder, page, page_type,
+					builder_is_followed(builder));
 	/* should allocate an additional staging page for pagevec */
 	if (err == -EAGAIN) {
 		struct page *const newpage =
 			__stagingpage_alloc(page_pool, GFP_NOFS);
 
 		err = z_erofs_vle_work_add_page(builder,
-			newpage, Z_EROFS_PAGE_TYPE_EXCLUSIVE);
+			newpage, Z_EROFS_PAGE_TYPE_EXCLUSIVE, true);
 		if (likely(!err))
 			goto retry;
 	}


