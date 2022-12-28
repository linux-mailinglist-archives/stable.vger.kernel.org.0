Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B785657BE5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiL1P04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiL1P0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F2B289
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 308E3CE1367
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21330C433EF;
        Wed, 28 Dec 2022 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241188;
        bh=x8LP2p0FqhcGtkWtYU6FzhuVszX+/S87JStwgvPaZys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRTpBQ/EjbvKoaJt2uJYB9N5fqCZWHFWRi2pNCZdi1eJQPMGA4Q//j2XGRerUFUQG
         XlDcS3GlBKi37WoUjxEmOojfKRmDG5YmLtRZGRuQR1yudwIFpYLvyW3lHuBvFrAOMc
         1sagerwlZ1WmIwVKf+oCzQ/VATRIeAZd/qpgtkLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0217/1146] ASoC: Intel: avs: Fix DMA mask assignment
Date:   Wed, 28 Dec 2022 15:29:16 +0100
Message-Id: <20221228144336.039915113@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 83375566a7a7042cb34b24986d100f46bfa0c1e5 ]

Spelling error leads to incorrect behavior when setting up DMA mask.

Fixes: a5bbbde2b81e ("ASoC: Intel: avs: Use helper function to set up DMA")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20221010121955.718168-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index bb0719c58ca4..4f93639ce488 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -440,7 +440,7 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (bus->mlcap)
 		snd_hdac_ext_bus_get_ml_capabilities(bus);
 
-	if (!dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
+	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
 		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	dma_set_max_seg_size(dev, UINT_MAX);
 
-- 
2.35.1



tion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/rt5682.txt b/Documentation/devicetree/bindings/sound/rt5682.txt
index c5f2b8febcee..6b87db68337c 100644
--- a/Documentation/devicetree/bindings/sound/rt5682.txt
+++ b/Documentation/devicetree/bindings/sound/rt5682.txt
@@ -46,7 +46,7 @@ Optional properties:
 
 - realtek,dmic-clk-driving-high : Set the high driving of the DMIC clock out.
 
-- #sound-dai-cells: Should be set to '<0>'.
+- #sound-dai-cells: Should be set to '<1>'.
 
 Pins on the device (for linking into audio routes) for RT5682:
 
-- 
2.35.1



