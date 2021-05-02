Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA4D370C53
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhEBOFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232599AbhEBOFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD307613D7;
        Sun,  2 May 2021 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964282;
        bh=Uc8tXsIHRsuaiYVvz1xm0zrbot1Lgb5vstXRryIUeU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSPcpV6ef5l8SwjasEtT2Cuk2Dll8eMDbhuQu4i/FQuBCtKzkcetAziotpA10GIiR
         ITtPBAgeRko6GEtikmu+wvGFxRxEo2pVhL8a4XqNRrPPuXkHs0LyPH3JgEtDNxo2t8
         s/bTxk9UDaTiCv+AV1bDLHB+mAfdIbzD3tjB8qN7DmDSn7lnjJ7VSs4t0fsaf9zo2Q
         03dZdqB1m/Pm5JGQzi9BvVKl/eC8I+ZKlommCA0z6JGkZ/fGUQ37IMTbcwOJvCx/99
         uyEL214wSYjxOuUzg1KCU1L16HTjHKLccHE3HZiwSVaIfwr7keF7oe/Dr5cy+X8fnC
         okOL0IjzO0aEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Tang <tanghui20@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/34] crypto: qat - fix unmap invalid dma address
Date:   Sun,  2 May 2021 10:04:06 -0400
Message-Id: <20210502140434.2719553-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 792b32fad548281e1b7fe14df9063a96c54b32a2 ]

'dma_mapping_error' return a negative value if 'dma_addr' is equal to
'DMA_MAPPING_ERROR' not zero, so fix initialization of 'dma_addr'.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 0d67cf5ede51..6b8ad3d67481 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -715,7 +715,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	struct qat_alg_buf_list *bufl;
 	struct qat_alg_buf_list *buflout = NULL;
 	dma_addr_t blp;
-	dma_addr_t bloutp = 0;
+	dma_addr_t bloutp;
 	struct scatterlist *sg;
 	size_t sz_out, sz = struct_size(bufl, bufers, n + 1);
 
@@ -727,6 +727,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	if (unlikely(!bufl))
 		return -ENOMEM;
 
+	for_each_sg(sgl, sg, n, i)
+		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
+
 	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, blp)))
 		goto err_in;
@@ -760,10 +763,14 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 				       dev_to_node(&GET_DEV(inst->accel_dev)));
 		if (unlikely(!buflout))
 			goto err_in;
+
+		bufers = buflout->bufers;
+		for_each_sg(sglout, sg, n, i)
+			bufers[i].addr = DMA_MAPPING_ERROR;
+
 		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, bloutp)))
 			goto err_out;
-		bufers = buflout->bufers;
 		for_each_sg(sglout, sg, n, i) {
 			int y = sg_nctr;
 
-- 
2.30.2

