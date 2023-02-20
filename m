Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A8669CE79
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjBTN7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjBTN7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1721EBE2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2EE1B80D41
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A99C433EF;
        Mon, 20 Feb 2023 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901541;
        bh=ILzq3KjZW16H9CbPuuxC0FsIcoDFocNISTA57GaE1V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1X1dY1zc1VaAua94KXW+V01dEA4H860+IxH7KH3y1Oe7wV3bv9uyuKpgMEh6Nk90V
         I1iogovOIAfgNLxZL1u/InqwTJT5cj+u19EvhbfFsdLYAQG6xbel2N1Q1XyJ7xYpNi
         ndrsdJGXfFiHgMBfxMjMdmzGACDDjWljDyXPngZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geraldo Nascimento <geraldogabriel@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 056/118] mmc: meson-gx: fix SDIO mode if cap_sdio_irq isnt set
Date:   Mon, 20 Feb 2023 14:36:12 +0100
Message-Id: <20230220133602.687847279@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 6ea6b95a7e3ec2015954cb514ee9dbc6dc80ec8f upstream.

Some SDIO WiFi modules stopped working after SDIO interrupt mode
was added if cap_sdio_irq isn't set in device tree. This patch was
confirmed to fix the issue.

Fixes: 066ecde6d826 ("mmc: meson-gx: add SDIO interrupt support")
Reported-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Tested-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/816cba9f-ff92-31a2-60f0-aca542d1d13e@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -435,7 +435,8 @@ static int meson_mmc_clk_init(struct mes
 	clk_reg |= FIELD_PREP(CLK_CORE_PHASE_MASK, CLK_PHASE_180);
 	clk_reg |= FIELD_PREP(CLK_TX_PHASE_MASK, CLK_PHASE_0);
 	clk_reg |= FIELD_PREP(CLK_RX_PHASE_MASK, CLK_PHASE_0);
-	clk_reg |= CLK_IRQ_SDIO_SLEEP(host);
+	if (host->mmc->caps & MMC_CAP_SDIO_IRQ)
+		clk_reg |= CLK_IRQ_SDIO_SLEEP(host);
 	writel(clk_reg, host->regs + SD_EMMC_CLOCK);
 
 	/* get the mux parents */
@@ -948,16 +949,18 @@ static irqreturn_t meson_mmc_irq(int irq
 {
 	struct meson_host *host = dev_id;
 	struct mmc_command *cmd;
-	u32 status, raw_status;
+	u32 status, raw_status, irq_mask = IRQ_EN_MASK;
 	irqreturn_t ret = IRQ_NONE;
 
+	if (host->mmc->caps & MMC_CAP_SDIO_IRQ)
+		irq_mask |= IRQ_SDIO;
 	raw_status = readl(host->regs + SD_EMMC_STATUS);
-	status = raw_status & (IRQ_EN_MASK | IRQ_SDIO);
+	status = raw_status & irq_mask;
 
 	if (!status) {
 		dev_dbg(host->dev,
-			"Unexpected IRQ! irq_en 0x%08lx - status 0x%08x\n",
-			 IRQ_EN_MASK | IRQ_SDIO, raw_status);
+			"Unexpected IRQ! irq_en 0x%08x - status 0x%08x\n",
+			 irq_mask, raw_status);
 		return IRQ_NONE;
 	}
 
@@ -1204,6 +1207,11 @@ static int meson_mmc_probe(struct platfo
 		goto free_host;
 	}
 
+	mmc->caps |= MMC_CAP_CMD23;
+
+	if (mmc->caps & MMC_CAP_SDIO_IRQ)
+		mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;
+
 	host->data = (struct meson_mmc_data *)
 		of_device_get_match_data(&pdev->dev);
 	if (!host->data) {
@@ -1277,11 +1285,6 @@ static int meson_mmc_probe(struct platfo
 
 	spin_lock_init(&host->lock);
 
-	mmc->caps |= MMC_CAP_CMD23;
-
-	if (mmc->caps & MMC_CAP_SDIO_IRQ)
-		mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;
-
 	if (host->dram_access_quirk) {
 		/* Limit segments to 1 due to low available sram memory */
 		mmc->max_segs = 1;


