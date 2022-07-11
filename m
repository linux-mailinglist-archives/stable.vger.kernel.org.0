Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9153956FBDE
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiGKJgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiGKJeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D086330;
        Mon, 11 Jul 2022 02:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 183FEB80833;
        Mon, 11 Jul 2022 09:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB0FC34115;
        Mon, 11 Jul 2022 09:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531119;
        bh=mtlslkPZOGbYO1mkm2rsME8Fmx8ft0J7wjRxl8Q0S6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTHyPNEtckOlWmioD52H87fPcpfwPgg+Xz0udjgVcw3qnedyPkqiVWqmVpUdfmdNd
         1LcQ0OPHXQ04FxeewAxHtj4kUfB8DTB7keAJMm1q6sI9erJ2euzCVGe8p6OZ5rh75S
         NCDQEZ787T68JiX51QduU5mWqVbMWZXVT9JpE5Ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samin Guo <samin.guo@starfivetech.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.18 103/112] dmaengine: dw-axi-dmac: Fix RMW on channel suspend register
Date:   Mon, 11 Jul 2022 11:07:43 +0200
Message-Id: <20220711090552.494344585@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

commit 49db68d45bdcad06e28a420d5d911e4178389666 upstream.

When the DMA is configured for more than 8 channels the bits controlling
suspend moves to another register. However when adding support for this
the new register would be completely overwritten in one case and
overwritten with values from the old register in another case.

Found by comparing the parallel implementation of more than 8 channel
support for the StarFive JH7100 SoC by Samin.

Fixes: 824351668a41 ("dmaengine: dw-axi-dmac: support DMAX_NUM_CHANNELS > 8")
Co-developed-by: Samin Guo <samin.guo@starfivetech.com>
Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Link: https://lore.kernel.org/r/20220627090939.1775717-1-emil.renner.berthing@canonical.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1164,8 +1164,9 @@ static int dma_chan_pause(struct dma_cha
 			BIT(chan->id) << DMAC_CHAN_SUSP_WE_SHIFT;
 		axi_dma_iowrite32(chan->chip, DMAC_CHEN, val);
 	} else {
-		val = BIT(chan->id) << DMAC_CHAN_SUSP2_SHIFT |
-		      BIT(chan->id) << DMAC_CHAN_SUSP2_WE_SHIFT;
+		val = axi_dma_ioread32(chan->chip, DMAC_CHSUSPREG);
+		val |= BIT(chan->id) << DMAC_CHAN_SUSP2_SHIFT |
+			BIT(chan->id) << DMAC_CHAN_SUSP2_WE_SHIFT;
 		axi_dma_iowrite32(chan->chip, DMAC_CHSUSPREG, val);
 	}
 
@@ -1190,12 +1191,13 @@ static inline void axi_chan_resume(struc
 {
 	u32 val;
 
-	val = axi_dma_ioread32(chan->chip, DMAC_CHEN);
 	if (chan->chip->dw->hdata->reg_map_8_channels) {
+		val = axi_dma_ioread32(chan->chip, DMAC_CHEN);
 		val &= ~(BIT(chan->id) << DMAC_CHAN_SUSP_SHIFT);
 		val |=  (BIT(chan->id) << DMAC_CHAN_SUSP_WE_SHIFT);
 		axi_dma_iowrite32(chan->chip, DMAC_CHEN, val);
 	} else {
+		val = axi_dma_ioread32(chan->chip, DMAC_CHSUSPREG);
 		val &= ~(BIT(chan->id) << DMAC_CHAN_SUSP2_SHIFT);
 		val |=  (BIT(chan->id) << DMAC_CHAN_SUSP2_WE_SHIFT);
 		axi_dma_iowrite32(chan->chip, DMAC_CHSUSPREG, val);


