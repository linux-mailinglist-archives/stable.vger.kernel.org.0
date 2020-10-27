Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE0C29C1CF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818910AbgJ0RZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752034AbgJ0Oxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:53:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D5D9222C8;
        Tue, 27 Oct 2020 14:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810419;
        bh=OpLbOhOpLkgVcWBbkxBCA/veGdYFoU8WNyf0u5A4wjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qG74gNjZbDB3n7jbIkjtepzA231BcEhXAudVGCLEfjcZoQI25ZtCEd9am03v9oW4T
         lcSa2dIAcBM1r0JPE3bviX4FJDLaWcU4UDL6RJyLpEBmbo4fSL8qkJgJFahSclvT1j
         u4RYNyOUsG2YrpfBcpXQzbLEdO/hTAdvMgoguncY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Xiaoliang Pang <dawning.pang@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 132/633] cypto: mediatek - fix leaks in mtk_desc_ring_alloc
Date:   Tue, 27 Oct 2020 14:47:55 +0100
Message-Id: <20201027135528.879619638@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoliang Pang <dawning.pang@gmail.com>

[ Upstream commit 228d284aac61283cde508a925d666f854b57af63 ]

In the init loop, if an error occurs in function 'dma_alloc_coherent',
then goto the err_cleanup section, after run i--,
in the array ring, the struct mtk_ring with index i will not be released,
causing memory leaks

Fixes: 785e5c616c849 ("crypto: mediatek - Add crypto driver support for some MediaTek chips")
Cc: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Xiaoliang Pang <dawning.pang@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mediatek/mtk-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index ef4339e84d034..efce3a83b35a8 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -469,13 +469,13 @@ static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
 	return 0;
 
 err_cleanup:
-	for (; i--; ) {
+	do {
 		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
 				  ring[i]->res_base, ring[i]->res_dma);
 		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
 				  ring[i]->cmd_base, ring[i]->cmd_dma);
 		kfree(ring[i]);
-	}
+	} while (i--);
 	return -ENOMEM;
 }
 
-- 
2.25.1



