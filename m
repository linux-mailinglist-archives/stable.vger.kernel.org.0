Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594E097BEC
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 16:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbfHUODF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 10:03:05 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50194 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726484AbfHUODF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 10:03:05 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 37A035C532598535888E;
        Wed, 21 Aug 2019 22:02:46 +0800 (CST)
Received: from architecture4.huawei.com (10.140.130.215) by smtp.huawei.com
 (10.3.19.208) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 21 Aug
 2019 22:02:30 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Chao Yu <chao@kernel.org>, <devel@driverdev.osuosl.org>,
        Miao Xie <miaoxie@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, <weidu.du@huawei.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
        Gao Xiang <gaoxiang25@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 5/6] staging: erofs: detect potential multiref due to corrupted images
Date:   Wed, 21 Aug 2019 22:01:52 +0800
Message-ID: <20190821140152.229648-1-gaoxiang25@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821021942.GA14087@kroah.com>
References: <20190821021942.GA14087@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.140.130.215]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As reported by erofs-utils fuzzer, currently, multiref
(ondisk deduplication) hasn't been supported for now,
we should forbid it properly.

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---

changelog from v1:
 - change err = -EFSCORRUPTED as well as Chao suggested;
   [ the difference between adding err or not to [PATCH 5/6] is just whether
     we error out the whole compressed cluster or partial of them (since some
     pages could be decompressed successfully), it's an undefined behavior
     for these corrupted compressed images... ]

Hi Chao,
 Could you kindly review it again? Thanks!

Hi Greg,
 This is [PATCH 5/6] of the original patchset, and I fix as what Chao suggested...
 But I'm not sure whether it should be merged right now, it is up to you. :)

Thanks,
Gao Xiang


 drivers/staging/erofs/zdata.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
index 4d6faaab04f5..60d7c20db87d 100644
--- a/drivers/staging/erofs/zdata.c
+++ b/drivers/staging/erofs/zdata.c
@@ -798,6 +798,7 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 	for (i = 0; i < nr_pages; ++i)
 		pages[i] = NULL;
 
+	err = 0;
 	z_erofs_pagevec_ctor_init(&ctor, Z_EROFS_NR_INLINE_PAGEVECS,
 				  cl->pagevec, 0);
 
@@ -819,8 +820,17 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 			pagenr = z_erofs_onlinepage_index(page);
 
 		DBG_BUGON(pagenr >= nr_pages);
-		DBG_BUGON(pages[pagenr]);
 
+		/*
+		 * currently EROFS doesn't support multiref(dedup),
+		 * so here erroring out one multiref page.
+		 */
+		if (unlikely(pages[pagenr])) {
+			DBG_BUGON(1);
+			SetPageError(pages[pagenr]);
+			z_erofs_onlinepage_endio(pages[pagenr]);
+			err = -EFSCORRUPTED;
+		}
 		pages[pagenr] = page;
 	}
 	z_erofs_pagevec_ctor_exit(&ctor, true);
@@ -828,7 +838,6 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 	overlapped = false;
 	compressed_pages = pcl->compressed_pages;
 
-	err = 0;
 	for (i = 0; i < clusterpages; ++i) {
 		unsigned int pagenr;
 
@@ -852,7 +861,12 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
 			pagenr = z_erofs_onlinepage_index(page);
 
 			DBG_BUGON(pagenr >= nr_pages);
-			DBG_BUGON(pages[pagenr]);
+			if (unlikely(pages[pagenr])) {
+				DBG_BUGON(1);
+				SetPageError(pages[pagenr]);
+				z_erofs_onlinepage_endio(pages[pagenr]);
+				err = -EFSCORRUPTED;
+			}
 			pages[pagenr] = page;
 
 			overlapped = true;
-- 
2.17.1

