Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63844BDED9
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347137AbiBUJDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348269AbiBUJCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:02:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353FE2BB1E;
        Mon, 21 Feb 2022 00:57:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA17261207;
        Mon, 21 Feb 2022 08:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0031C340E9;
        Mon, 21 Feb 2022 08:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433853;
        bh=yTiJO3VHqrsiJhsQfZjxSVQ8oAzI9Z62PZS/bkmbkrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmN8Wo2UW/lAiieclSnHDEquV03wDSenOseg0xsWUGLILe9EAEIS/+vMnbEmTO7Vo
         RY/RdaSTyrsfGOw3hwYxiEHyELUdaUKcdhT4a/v0k/5gXondqu9uMFGNHTf7y+Z/pK
         Taz9G3npQZmNtg6y/6NjR18ZBkto9EYglq0/8HEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc St-Amand <mstamand@ciena.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/58] net: macb: Align the dma and coherent dma masks
Date:   Mon, 21 Feb 2022 09:49:51 +0100
Message-Id: <20220221084913.745489306@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc St-Amand <mstamand@ciena.com>

[ Upstream commit 37f7860602b5b2d99fc7465f6407f403f5941988 ]

Single page and coherent memory blocks can use different DMA masks
when the macb accesses physical memory directly. The kernel is clever
enough to allocate pages that fit into the requested address width.

When using the ARM SMMU, the DMA mask must be the same for single
pages and big coherent memory blocks. Otherwise the translation
tables turn into one big mess.

  [   74.959909] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
  [   74.959989] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1
  [   75.173939] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
  [   75.173955] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1

Since using the same DMA mask does not hurt direct 1:1 physical
memory mappings, this commit always aligns DMA and coherent masks.

Signed-off-by: Marc St-Amand <mstamand@ciena.com>
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d110aa616a957..f162ac7d74e59 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4073,7 +4073,7 @@ static int macb_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(44));
+		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
 		bp->hw_dma_cap |= HW_DMA_CAP_64B;
 	}
 #endif
-- 
2.34.1



