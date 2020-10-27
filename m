Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A8D29C33B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902194AbgJ0ObZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760045AbgJ0ObX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:31:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F6F20754;
        Tue, 27 Oct 2020 14:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809080;
        bh=ZaVjIWVv8PtuZehReE4iWCq4c9wvjvXt8JCOgG+Mj0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vcc3soSDeqgdTRqLBabCukaYkpih4lDJ+MWJQyZBH7swHFYQtJjsx4KB68kKkuHV+
         HZHXoUHsfH8+Ly/5gTKtiqgXUpWGskeFdxYuQeUldBZa4Xofu6/RE+8TyPjMUQkG+f
         om5Qc/IaBfVh2s2NleaWzFm64o9cX2NvASK2pWzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/408] crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()
Date:   Tue, 27 Oct 2020 14:50:06 +0100
Message-Id: <20201027135458.213660017@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 7e3ad085b5bdd..ef4339e84d034 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -442,7 +442,7 @@ static void mtk_desc_dma_free(struct mtk_cryp *cryp)
 static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 {
 	struct mtk_ring **ring = cryp->ring;
-	int i, err = ENOMEM;
+	int i;
 
 	for (i = 0; i < MTK_RING_MAX; i++) {
 		ring[i] = kzalloc(sizeof(**ring), GFP_KERNEL);
@@ -476,7 +476,7 @@ static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 				  ring[i]->cmd_base, ring[i]->cmd_dma);
 		kfree(ring[i]);
 	}
-	return err;
+	return -ENOMEM;
 }
 
 static int mtk_crypto_probe(struct platform_device *pdev)
-- 
2.25.1



