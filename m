Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487184527D1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241632AbhKPCq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:46:58 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:43857 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238468AbhKPCpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 21:45:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uwnk90a_1637030514;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Uwnk90a_1637030514)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Nov 2021 10:42:02 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-erofs@lists.ozlabs.org, Yue Hu <huyue2@yulong.com>,
        Gao Xiang <xiang@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 4.19.y 1/2] erofs: remove the occupied parameter from z_erofs_pagevec_enqueue()
Date:   Tue, 16 Nov 2021 10:41:52 +0800
Message-Id: <20211116024153.245131-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <1636983460149191@kroah.com>
References: <1636983460149191@kroah.com>
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
[ Gao Xiang: handle 4.19 codebase conflicts manually. ]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
Gao Xiang: Same to 5.4.y and 5.10.y, apply this trivial cleanup as well.

 drivers/staging/erofs/unzip_pagevec.h | 5 +----
 drivers/staging/erofs/unzip_vle.c     | 4 +---
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/erofs/unzip_pagevec.h b/drivers/staging/erofs/unzip_pagevec.h
index 23856ba2742d..64724dd1e04e 100644
--- a/drivers/staging/erofs/unzip_pagevec.h
+++ b/drivers/staging/erofs/unzip_pagevec.h
@@ -117,10 +117,8 @@ static inline void z_erofs_pagevec_ctor_init(struct z_erofs_pagevec_ctor *ctor,
 static inline bool
 z_erofs_pagevec_ctor_enqueue(struct z_erofs_pagevec_ctor *ctor,
 			     struct page *page,
-			     enum z_erofs_page_type type,
-			     bool *occupied)
+			     enum z_erofs_page_type type)
 {
-	*occupied = false;
 	if (unlikely(ctor->next == NULL && type))
 		if (ctor->index + 1 == ctor->nr)
 			return false;
@@ -135,7 +133,6 @@ z_erofs_pagevec_ctor_enqueue(struct z_erofs_pagevec_ctor *ctor,
 	/* should remind that collector->next never equal to 1, 2 */
 	if (type == (uintptr_t)ctor->next) {
 		ctor->next = page;
-		*occupied = true;
 	}
 
 	ctor->pages[ctor->index++] =
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 0f1558c6747e..48c21a4d5dc8 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -234,7 +234,6 @@ static int z_erofs_vle_work_add_page(
 	enum z_erofs_page_type type)
 {
 	int ret;
-	bool occupied;
 
 	/* give priority for the compressed data storage */
 	if (builder->role >= Z_EROFS_VLE_WORK_PRIMARY &&
@@ -242,8 +241,7 @@ static int z_erofs_vle_work_add_page(
 		try_to_reuse_as_compressed_page(builder, page))
 		return 0;
 
-	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector,
-		page, type, &occupied);
+	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector, page, type);
 	builder->work->vcnt += (unsigned)ret;
 
 	return ret ? 0 : -EAGAIN;
-- 
2.24.4

