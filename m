Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F2B4522EC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344607AbhKPBQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:56 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:33435 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377578AbhKPBL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 20:11:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UwmntOt_1637024900;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UwmntOt_1637024900)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Nov 2021 09:08:29 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-erofs@lists.ozlabs.org, Yue Hu <huyue2@yulong.com>,
        Gao Xiang <xiang@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 5.10.y 1/2] erofs: remove the occupied parameter from z_erofs_pagevec_enqueue()
Date:   Tue, 16 Nov 2021 09:08:18 +0800
Message-Id: <20211116010819.122905-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <16369834628252@kroah.com>
References: <16369834628252@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

commit 7dea3de7d384f4c8156e8bd93112ba6db1eb276c upstream.

No any behavior to variable occupied in z_erofs_attach_page() which
is only caller to z_erofs_pagevec_enqueue().

Link: https://lore.kernel.org/r/20210419102623.2015-1-zbestahu@gmail.com
Signed-off-by: Yue Hu <huyue2@yulong.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
Gao Xiang: Apply this trivial cleanup (no behavior change) for easier
           backporting.

 fs/erofs/zdata.c | 4 +---
 fs/erofs/zpvec.h | 5 +----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 86fd3bf62af6..ca27d3e47857 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -282,7 +282,6 @@ static int z_erofs_attach_page(struct z_erofs_collector *clt,
 			       enum z_erofs_page_type type)
 {
 	int ret;
-	bool occupied;
 
 	/* give priority for inplaceio */
 	if (clt->mode >= COLLECT_PRIMARY &&
@@ -290,8 +289,7 @@ static int z_erofs_attach_page(struct z_erofs_collector *clt,
 	    z_erofs_try_inplace_io(clt, page))
 		return 0;
 
-	ret = z_erofs_pagevec_enqueue(&clt->vector,
-				      page, type, &occupied);
+	ret = z_erofs_pagevec_enqueue(&clt->vector, page, type);
 	clt->cl->vcnt += (unsigned int)ret;
 
 	return ret ? 0 : -EAGAIN;
diff --git a/fs/erofs/zpvec.h b/fs/erofs/zpvec.h
index 1d67cbd38704..95a620739e6a 100644
--- a/fs/erofs/zpvec.h
+++ b/fs/erofs/zpvec.h
@@ -107,10 +107,8 @@ static inline void z_erofs_pagevec_ctor_init(struct z_erofs_pagevec_ctor *ctor,
 
 static inline bool z_erofs_pagevec_enqueue(struct z_erofs_pagevec_ctor *ctor,
 					   struct page *page,
-					   enum z_erofs_page_type type,
-					   bool *occupied)
+					   enum z_erofs_page_type type)
 {
-	*occupied = false;
 	if (!ctor->next && type)
 		if (ctor->index + 1 == ctor->nr)
 			return false;
@@ -125,7 +123,6 @@ static inline bool z_erofs_pagevec_enqueue(struct z_erofs_pagevec_ctor *ctor,
 	/* should remind that collector->next never equal to 1, 2 */
 	if (type == (uintptr_t)ctor->next) {
 		ctor->next = page;
-		*occupied = true;
 	}
 	ctor->pages[ctor->index++] = tagptr_fold(erofs_vtptr_t, page, type);
 	return true;
-- 
2.24.4

