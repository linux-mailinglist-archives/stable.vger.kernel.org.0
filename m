Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EA037817D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhEJK1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:27:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231441AbhEJK0S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:26:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A08561466;
        Mon, 10 May 2021 10:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642314;
        bh=Uc8tXsIHRsuaiYVvz1xm0zrbot1Lgb5vstXRryIUeU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i49udXneTayoW1Y6T49uSPj7AX6719cCGW+Z6vMWILvoJw3ptQZGuDCD+2W6w5Lp4
         eSj0atWpyWMktC9eI069/vQwniHbppEQJlR0k5dqn/i4/GkwkuVFSOwniuT/ZhE2dx
         JFznqO7XzsfN1OUCeojxMZy3mNIUOR2g0aJspRUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Tang <tanghui20@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/184] crypto: qat - fix unmap invalid dma address
Date:   Mon, 10 May 2021 12:18:57 +0200
Message-Id: <20210510101951.620504527@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



