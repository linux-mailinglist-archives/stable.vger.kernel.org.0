Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0A565796B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiL1PBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiL1PAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B55B9D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D9661540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6354EC433F0;
        Wed, 28 Dec 2022 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239645;
        bh=avd4fX7l7hX5HTf4cz35HVWK9yS+No8I6+h2r+Fp7Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4MycWOoxSh20d4Ahilvxz8LxMXiDyshD+L720P1BRfI07FKrMx6qSzDt9pVPtnvj
         jQreyAyuJAWEejfknVue/INAwADg+oZ9bSBpMWe4d8EvoMxFEszoaMgY7DOhw9l4qc
         /erUpvBjo4SvtzcJoyzGjVUVrcuvTkmoaEJFFnp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/731] ASoC: mediatek: mt8173: Enable IRQ when pdata is ready
Date:   Wed, 28 Dec 2022 15:36:00 +0100
Message-Id: <20221228144303.896194800@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 4cbb264d4e9136acab2c8fd39e39ab1b1402b84b ]

If the device does not come straight from reset, we might receive an IRQ
before we are ready to handle it.

Fixes:

[    2.334737] Unable to handle kernel read from unreadable memory at virtual address 00000000000001e4
[    2.522601] Call trace:
[    2.525040]  regmap_read+0x1c/0x80
[    2.528434]  mt8173_afe_irq_handler+0x40/0xf0
...
[    2.598921]  start_kernel+0x338/0x42c

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Fixes: ee0bcaff109f ("ASoC: mediatek: Add AFE platform driver")
Link: https://lore.kernel.org/r/20221128-mt8173-afe-v1-0-70728221628f@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c b/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c
index 31494930433f..8092506facbd 100644
--- a/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c
+++ b/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c
@@ -1072,16 +1072,6 @@ static int mt8173_afe_pcm_dev_probe(struct platform_device *pdev)
 
 	afe->dev = &pdev->dev;
 
-	irq_id = platform_get_irq(pdev, 0);
-	if (irq_id <= 0)
-		return irq_id < 0 ? irq_id : -ENXIO;
-	ret = devm_request_irq(afe->dev, irq_id, mt8173_afe_irq_handler,
-			       0, "Afe_ISR_Handle", (void *)afe);
-	if (ret) {
-		dev_err(afe->dev, "could not request_irq\n");
-		return ret;
-	}
-
 	afe->base_addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(afe->base_addr))
 		return PTR_ERR(afe->base_addr);
@@ -1187,6 +1177,16 @@ static int mt8173_afe_pcm_dev_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_cleanup_components;
 
+	irq_id = platform_get_irq(pdev, 0);
+	if (irq_id <= 0)
+		return irq_id < 0 ? irq_id : -ENXIO;
+	ret = devm_request_irq(afe->dev, irq_id, mt8173_afe_irq_handler,
+			       0, "Afe_ISR_Handle", (void *)afe);
+	if (ret) {
+		dev_err(afe->dev, "could not request_irq\n");
+		goto err_pm_disable;
+	}
+
 	dev_info(&pdev->dev, "MT8173 AFE driver initialized.\n");
 	return 0;
 
-- 
2.35.1



