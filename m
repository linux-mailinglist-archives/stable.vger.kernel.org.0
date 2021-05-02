Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637B6370BF8
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbhEBOE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhEBOEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66638613BB;
        Sun,  2 May 2021 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964209;
        bh=QOGzl6mLhu4tzKnRuYyI8XSEEL2iq1TDAs165Wu+3Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUx2piyLVOEqcYCjRvwbIYE4DUYNaguSdoSiYiBYlecEFMZEWMVs2ZiEL4bSsmVMh
         /kupKX7/1H+5fzBF5HUrvtWGjZ2ze9ZBmUAfdldYc031gKGzvb7g+YXJephMYrIyXI
         4iJi0Me78CE0HyAc7aEL034e3buwi0DVSIzH48gohNKUtf/+pq3qx/fu6d1d0RjJpr
         vQv59MMRKLssuuHb8f+ikTJxsmfbIyMxzpH32587XMphSgYWnqjhp4nBHg/xx07x1Z
         ckpdz0Xmbz+dfVIQcwu5bPOnFyod+P7/ClAoCNKeHhl22dP+tl4sRAZ84rN3hIrsm5
         OT6pWyMp9PBbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Tang <tanghui20@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 09/79] crypto: qat - fix unmap invalid dma address
Date:   Sun,  2 May 2021 10:02:06 -0400
Message-Id: <20210502140316.2718705-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140316.2718705-1-sashal@kernel.org>
References: <20210502140316.2718705-1-sashal@kernel.org>
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
index ff78c73c47e3..ea1c6899290d 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -719,7 +719,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	struct qat_alg_buf_list *bufl;
 	struct qat_alg_buf_list *buflout = NULL;
 	dma_addr_t blp;
-	dma_addr_t bloutp = 0;
+	dma_addr_t bloutp;
 	struct scatterlist *sg;
 	size_t sz_out, sz = struct_size(bufl, bufers, n + 1);
 
@@ -731,6 +731,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	if (unlikely(!bufl))
 		return -ENOMEM;
 
+	for_each_sg(sgl, sg, n, i)
+		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
+
 	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, blp)))
 		goto err_in;
@@ -764,10 +767,14 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
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

