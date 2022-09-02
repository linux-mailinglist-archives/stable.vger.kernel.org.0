Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C385B5AAFD8
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237435AbiIBMou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237516AbiIBMnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5629EE690;
        Fri,  2 Sep 2022 05:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B345B829E6;
        Fri,  2 Sep 2022 12:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCB7C433D7;
        Fri,  2 Sep 2022 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121958;
        bh=v3hPVAcakroHq2YJdqRMX+F4HVlTTf3DjLVRPVwNyLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSytj6j6AFdtQclTNLk4URUvekA9ezYrgiz1yZUe7JpUhtbyDmWkug066VwGkV0F4
         /UCovvhUU5JGt407W61hk0leNoVg0k/SJJ8ivy4/SdrNGHgctNPxJP731iSfdeTXsn
         +xS557xAps2djruyg2xInFXYqw+XBA+EmA6QbqvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenbin Mei <wenbin.mei@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/73] mmc: mtk-sd: Clear interrupts when cqe off/disable
Date:   Fri,  2 Sep 2022 14:19:06 +0200
Message-Id: <20220902121405.830982325@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wenbin Mei <wenbin.mei@mediatek.com>

[ Upstream commit cc5d1692600613e72f32af60e27330fe0c79f4fe ]

Currently we don't clear MSDC interrupts when cqe off/disable, which led
to the data complete interrupt will be reserved for the next command.
If the next command with data transfer after cqe off/disable, we process
the CMD ready interrupt and trigger DMA start for data, but the data
complete interrupt is already exists, then SW assume that the data transfer
is complete, SW will trigger DMA stop, but the data may not be transmitted
yet or is transmitting, so we may encounter the following error:
mtk-msdc 11230000.mmc: CMD bus busy detected.

Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Fixes: 88bd652b3c74 ("mmc: mediatek: command queue support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220728080048.21336-1-wenbin.mei@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index f9b2897569bb4..99d8881a7d6c2 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2345,6 +2345,9 @@ static void msdc_cqe_disable(struct mmc_host *mmc, bool recovery)
 	/* disable busy check */
 	sdr_clr_bits(host->base + MSDC_PATCH_BIT1, MSDC_PB1_BUSY_CHECK_SEL);
 
+	val = readl(host->base + MSDC_INT);
+	writel(val, host->base + MSDC_INT);
+
 	if (recovery) {
 		sdr_set_field(host->base + MSDC_DMA_CTRL,
 			      MSDC_DMA_CTRL_STOP, 1);
@@ -2785,11 +2788,14 @@ static int __maybe_unused msdc_suspend(struct device *dev)
 {
 	struct mmc_host *mmc = dev_get_drvdata(dev);
 	int ret;
+	u32 val;
 
 	if (mmc->caps2 & MMC_CAP2_CQE) {
 		ret = cqhci_suspend(mmc);
 		if (ret)
 			return ret;
+		val = readl(((struct msdc_host *)mmc_priv(mmc))->base + MSDC_INT);
+		writel(val, ((struct msdc_host *)mmc_priv(mmc))->base + MSDC_INT);
 	}
 
 	return pm_runtime_force_suspend(dev);
-- 
2.35.1



