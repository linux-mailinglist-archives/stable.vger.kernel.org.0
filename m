Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7D44BE140
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347714AbiBUJOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350022AbiBUJNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:13:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E767A2E086;
        Mon, 21 Feb 2022 01:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 787356112F;
        Mon, 21 Feb 2022 09:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C844C340E9;
        Mon, 21 Feb 2022 09:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434377;
        bh=1DZitMsfscZqtj1V+5JG4H75SyoQCa4GwHKOPdzcUoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8ZNRoojawPGifzpNs/MYnUvNG3DfAfAnMS4x2fam1pO94uMRiF4DVOK0lYqMir9Y
         b+6ylf9qpI6liC+u6Mz1O51WWMglAPRiCjmd7axFhhsoBYtSzzsqncbZj/vf7Ds+ar
         qoI078EqySQ+4YiQVrZB+ojayBRKuKIJ+68C8sJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc St-Amand <mstamand@ciena.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/121] net: macb: Align the dma and coherent dma masks
Date:   Mon, 21 Feb 2022 09:50:01 +0100
Message-Id: <20220221084924.886570355@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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
index 1e8bf6b9834bb..2af464ac250ac 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4534,7 +4534,7 @@ static int macb_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(44));
+		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
 		bp->hw_dma_cap |= HW_DMA_CAP_64B;
 	}
 #endif
-- 
2.34.1



