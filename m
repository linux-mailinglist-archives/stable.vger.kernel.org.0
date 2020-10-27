Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A0A29AF4F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755281AbgJ0OJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755273AbgJ0OJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:09:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0624621D7B;
        Tue, 27 Oct 2020 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807747;
        bh=FVSIgkXFta9/+GIfQ8k3JSZOxrkORigGtUZUW0LUPN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wy6ldxz7ngwQKBTcBAcHtSlsDyjjolM60LtVZacDhGRu5rOmUKJ2eEmQPixtveAHn
         CWj5t52U6VUg1Bny1T2Q9JUI+IEGT5Pz4gcdsIzz6jo0Gq8+GQb5h6Bya3hOTh6P8X
         YNFwfk3X9gHuqS4J05RQVab5fDtCYCLTQ/JBkqIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 026/191] crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()
Date:   Tue, 27 Oct 2020 14:48:01 +0100
Message-Id: <20201027134910.983442193@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 8cbde6c6a6d2b1599ff90f932304aab7e32fce89 ]

In case of memory allocation failure, a negative error code should
be returned.

Fixes: 785e5c616c849 ("crypto: mediatek - Add crypto driver support for some MediaTek chips")
Cc: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mediatek/mtk-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index b182e941b0cd8..c58e708d30395 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -445,7 +445,7 @@ static void mtk_desc_dma_free(struct mtk_cryp *cryp)
 static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 {
 	struct mtk_ring **ring = cryp->ring;
-	int i, err = ENOMEM;
+	int i;
 
 	for (i = 0; i < MTK_RING_MAX; i++) {
 		ring[i] = kzalloc(sizeof(**ring), GFP_KERNEL);
@@ -479,7 +479,7 @@ static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 				  ring[i]->cmd_base, ring[i]->cmd_dma);
 		kfree(ring[i]);
 	}
-	return err;
+	return -ENOMEM;
 }
 
 static int mtk_crypto_probe(struct platform_device *pdev)
-- 
2.25.1



