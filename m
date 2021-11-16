Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673E74522ED
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378758AbhKPBQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:57 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:42529 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377585AbhKPBLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 20:11:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UwmntOt_1637024900;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UwmntOt_1637024900)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Nov 2021 09:08:31 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-erofs@lists.ozlabs.org,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>
Subject: [PATCH 5.10.y 2/2] erofs: fix unsafe pagevec reuse of hooked pclusters
Date:   Tue, 16 Nov 2021 09:08:19 +0800
Message-Id: <20211116010819.122905-2-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211116010819.122905-1-hsiangkao@linux.alibaba.com>
References: <16369834628252@kroah.com>
 <20211116010819.122905-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/erofs/zdata.c | 13 +++++++------
 fs/erofs/zpvec.h | 13 ++++++++++---
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index ca27d3e47857..8cb2cf612e49 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -278,8 +278,8 @@ static inline bool z_erofs_try_inplace_io(struct z_erofs_collector *clt,
 
 /* callers must be with collection lock held */
 static int z_erofs_attach_page(struct z_erofs_collector *clt,
-			       struct page *page,
-			       enum z_erofs_page_type type)
+			       struct page *page, enum z_erofs_page_type type,
+			       bool pvec_safereuse)
 {
 	int ret;
 
@@ -289,9 +289,9 @@ static int z_erofs_attach_page(struct z_erofs_collector *clt,
 	    z_erofs_try_inplace_io(clt, page))
 		return 0;
 
-	ret = z_erofs_pagevec_enqueue(&clt->vector, page, type);
+	ret = z_erofs_pagevec_enqueue(&clt->vector, page, type,
+				      pvec_safereuse);
 	clt->cl->vcnt += (unsigned int)ret;
-
 	return ret ? 0 : -EAGAIN;
 }
 
@@ -645,7 +645,8 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 		tight &= (clt->mode >= COLLECT_PRIMARY_FOLLOWED);
 
 retry:
-	err = z_erofs_attach_page(clt, page, page_type);
+	err = z_erofs_attach_page(clt, page, page_type,
+				  clt->mode >= COLLECT_PRIMARY_FOLLOWED);
 	/* should allocate an additional staging page for pagevec */
 	if (err == -EAGAIN) {
 		struct page *const newpage =
@@ -653,7 +654,7 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 
 		newpage->mapping = Z_EROFS_MAPPING_STAGING;
 		err = z_erofs_attach_page(clt, newpage,
-					  Z_EROFS_PAGE_TYPE_EXCLUSIVE);
+					  Z_EROFS_PAGE_TYPE_EXCLUSIVE, true);
 		if (!err)
 			goto retry;
 	}
diff --git a/fs/erofs/zpvec.h b/fs/erofs/zpvec.h
index 95a620739e6a..52898176ef31 100644
--- a/fs/erofs/zpvec.h
+++ b/fs/erofs/zpvec.h
@@ -107,11 +107,18 @@ static inline void z_erofs_pagevec_ctor_init(struct z_erofs_pagevec_ctor *ctor,
 
 static inline bool z_erofs_pagevec_enqueue(struct z_erofs_pagevec_ctor *ctor,
 					   struct page *page,
-					   enum z_erofs_page_type type)
+					   enum z_erofs_page_type type,
+					   bool pvec_safereuse)
 {
-	if (!ctor->next && type)
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
 
 	if (ctor->index >= ctor->nr)
 		z_erofs_pagevec_ctor_pagedown(ctor, false);
-- 
2.24.4

