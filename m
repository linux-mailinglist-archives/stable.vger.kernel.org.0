Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902A42E3DE4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437912AbgL1OV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502247AbgL1OVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9377E207B2;
        Mon, 28 Dec 2020 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165250;
        bh=pTNAT20uZOQhm5q/w3LXW0+Z6AtvCK8AFwsi8VJmBdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iglcnpYz5A0+rMp51P0STqsuB6Le3hnQhGmxFwascmMu+lg9G8G3DpME+RKipUg24
         cOUXLhiHxlEWw7Y+5qFqvLKAx6GLJH5iqbH1eTDEZZ7AVr5/s+vqrkuHKpCyRqTEf0
         B8WLRI2N8hLMDGEjLAx5swZmGCRuayUyRhaguGek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 465/717] dpaa2-eth: fix the size of the mapped SGT buffer
Date:   Mon, 28 Dec 2020 13:47:43 +0100
Message-Id: <20201228125043.250012273@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 54a57d1c449275ee727154ac106ec1accae012e3 ]

This patch fixes an error condition triggered when the code path which
transmits a S/G frame descriptor when the skb's headroom is not enough
for DPAA2's needs.

We are greated with a splat like the one below when a SGT structure is
recycled and that is because even though a dma_unmap is performed on the
Tx confirmation path, the unmap is not done with the proper size.

[  714.464927] WARNING: CPU: 13 PID: 0 at drivers/iommu/io-pgtable-arm.c:281 __arm_lpae_map+0x2d4/0x30c
(...)
[  714.465343] Call trace:
[  714.465348]  __arm_lpae_map+0x2d4/0x30c
[  714.465353]  __arm_lpae_map+0x114/0x30c
[  714.465357]  __arm_lpae_map+0x114/0x30c
[  714.465362]  __arm_lpae_map+0x114/0x30c
[  714.465366]  arm_lpae_map+0xf4/0x180
[  714.465373]  arm_smmu_map+0x4c/0xc0
[  714.465379]  __iommu_map+0x100/0x2bc
[  714.465385]  iommu_map_atomic+0x20/0x30
[  714.465391]  __iommu_dma_map+0xb0/0x110
[  714.465397]  iommu_dma_map_page+0xb8/0x120
[  714.465404]  dma_map_page_attrs+0x1a8/0x210
[  714.465413]  __dpaa2_eth_tx+0x384/0xbd0 [fsl_dpaa2_eth]
[  714.465421]  dpaa2_eth_tx+0x84/0x134 [fsl_dpaa2_eth]
[  714.465427]  dev_hard_start_xmit+0x10c/0x2b0
[  714.465433]  sch_direct_xmit+0x1a0/0x550
(...)

The dpaa2-eth driver uses an area of software annotations to transmit
necessary information from the Tx path to the Tx confirmation one. This
SWA structure has a different layout for each kind of frame that we are
dealing with: linear, S/G or XDP.

The commit referenced was incorrectly setting up the 'sgt_size' field
for the S/G type of SWA even though we are dealing with a linear skb
here.

Fixes: d70446ee1f40 ("dpaa2-eth: send a scatter-gather FD instead of realloc-ing")
Reported-by: Daniel Thompson <daniel.thompson@linaro.org>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20201211171607.108034-1-ciorneiioana@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cf9400a9886d7..d880ab2a7d962 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -878,7 +878,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 	swa = (struct dpaa2_eth_swa *)sgt_buf;
 	swa->type = DPAA2_ETH_SWA_SINGLE;
 	swa->single.skb = skb;
-	swa->sg.sgt_size = sgt_buf_size;
+	swa->single.sgt_size = sgt_buf_size;
 
 	/* Separately map the SGT buffer */
 	sgt_addr = dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTIONAL);
-- 
2.27.0



