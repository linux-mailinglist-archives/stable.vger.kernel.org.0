Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E575B4575A9
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbhKSRlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235599AbhKSRl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD5F61A8C;
        Fri, 19 Nov 2021 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343505;
        bh=2hqvsmA7e0UYI5UY6c+gm7IquZiL2/EMw4WIu34v7iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nHir9zW/0IlB1s3Ur4Wnn4IQ8GQVT9HGFyZarr+5pKt5dN+oEm0UNyhSKzMwg4dE
         xih0+BGmN85CStmTeAyJw1I6mmdlBxkOUbz0L6ZNCEP+xyhHHLytl02nA6ONwuX5ed
         MUrdsxxizNHxTV5vY82LWDINW64MZPe0RiPaqyXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 5.10 18/21] erofs: fix unsafe pagevec reuse of hooked pclusters
Date:   Fri, 19 Nov 2021 18:37:53 +0100
Message-Id: <20211119171444.470625833@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
References: <20211119171443.892729043@linuxfoundation.org>
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
 fs/erofs/zdata.c |   13 +++++++------
 fs/erofs/zpvec.h |   13 ++++++++++---
 2 files changed, 17 insertions(+), 9 deletions(-)

--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -278,8 +278,8 @@ static inline bool z_erofs_try_inplace_i
 
 /* callers must be with collection lock held */
 static int z_erofs_attach_page(struct z_erofs_collector *clt,
-			       struct page *page,
-			       enum z_erofs_page_type type)
+			       struct page *page, enum z_erofs_page_type type,
+			       bool pvec_safereuse)
 {
 	int ret;
 
@@ -289,9 +289,9 @@ static int z_erofs_attach_page(struct z_
 	    z_erofs_try_inplace_io(clt, page))
 		return 0;
 
-	ret = z_erofs_pagevec_enqueue(&clt->vector, page, type);
+	ret = z_erofs_pagevec_enqueue(&clt->vector, page, type,
+				      pvec_safereuse);
 	clt->cl->vcnt += (unsigned int)ret;
-
 	return ret ? 0 : -EAGAIN;
 }
 
@@ -645,7 +645,8 @@ hitted:
 		tight &= (clt->mode >= COLLECT_PRIMARY_FOLLOWED);
 
 retry:
-	err = z_erofs_attach_page(clt, page, page_type);
+	err = z_erofs_attach_page(clt, page, page_type,
+				  clt->mode >= COLLECT_PRIMARY_FOLLOWED);
 	/* should allocate an additional staging page for pagevec */
 	if (err == -EAGAIN) {
 		struct page *const newpage =
@@ -653,7 +654,7 @@ retry:
 
 		newpage->mapping = Z_EROFS_MAPPING_STAGING;
 		err = z_erofs_attach_page(clt, newpage,
-					  Z_EROFS_PAGE_TYPE_EXCLUSIVE);
+					  Z_EROFS_PAGE_TYPE_EXCLUSIVE, true);
 		if (!err)
 			goto retry;
 	}
--- a/fs/erofs/zpvec.h
+++ b/fs/erofs/zpvec.h
@@ -107,11 +107,18 @@ static inline void z_erofs_pagevec_ctor_
 
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


