Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184F4537FDD
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbiE3OKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238821AbiE3OEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DB1CE5D4;
        Mon, 30 May 2022 06:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33B4A60F2A;
        Mon, 30 May 2022 13:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA96C3411E;
        Mon, 30 May 2022 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918026;
        bh=3os4nm//VWdtnukH4DMduEp3AKayG5T+pbN7X5F8Egs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bps66xW/rNe9sDWn74JYcDwwCvBYakaNWubJvFv4LTT79u2u4t4bqYZEEo/v3qJK6
         T7eblw4o+cTDV2yxYOurHnyqnxJUbveJaOcLnMuV/zUOf+Pw3d69aIABXGiGboSmGf
         E7V57cJ92Bes0sqCdBhqA/6X3MbQtkSeHn7Uu40J0K3ONaYqUfyv7d8/lECvcovbPS
         h/OiusErAS29LvxPcCgi0huM1k+U1oMEZxD//1O7mULjWOaQbyvBXZetF1zSUd1RKk
         ss4m6OQHnIh8V/d4iXKPYW5nI9335JdsekjYbNrwVTo+j95j113V+NA+gheME0N7xV
         lAtBHmBtZ4B6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, adrian.hunter@intel.com,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 037/109] drivers: mmc: sdhci_am654: Add the quirk to set TESTCD bit
Date:   Mon, 30 May 2022 09:37:13 -0400
Message-Id: <20220530133825.1933431-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit c7666240ec76422cb7546bd07cc8ae80dc0ccdd2 ]

The ARASAN MMC controller on Keystone 3 class of devices need the SDCD
line to be connected for proper functioning. Similar to the issue pointed
out in sdhci-of-arasan.c driver, commit 3794c542641f ("mmc:
sdhci-of-arasan: Set controller to test mode when no CD bit").

In cases where this can't be connected, add a quirk to force the
controller into test mode and set the TESTCD bit. Use the flag
"ti,fails-without-test-cd", to implement this above quirk when required.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Link: https://lore.kernel.org/r/20220425063120.10135-3-a-govindraju@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_am654.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index b4891bb26648..a3e62e212631 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -147,6 +147,9 @@ struct sdhci_am654_data {
 	int drv_strength;
 	int strb_sel;
 	u32 flags;
+	u32 quirks;
+
+#define SDHCI_AM654_QUIRK_FORCE_CDTEST BIT(0)
 };
 
 struct sdhci_am654_driver_data {
@@ -369,6 +372,21 @@ static void sdhci_am654_write_b(struct sdhci_host *host, u8 val, int reg)
 	}
 }
 
+static void sdhci_am654_reset(struct sdhci_host *host, u8 mask)
+{
+	u8 ctrl;
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
+
+	sdhci_reset(host, mask);
+
+	if (sdhci_am654->quirks & SDHCI_AM654_QUIRK_FORCE_CDTEST) {
+		ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
+		ctrl |= SDHCI_CTRL_CDTEST_INS | SDHCI_CTRL_CDTEST_EN;
+		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
+	}
+}
+
 static int sdhci_am654_execute_tuning(struct mmc_host *mmc, u32 opcode)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
@@ -500,7 +518,7 @@ static struct sdhci_ops sdhci_j721e_4bit_ops = {
 	.set_clock = sdhci_j721e_4bit_set_clock,
 	.write_b = sdhci_am654_write_b,
 	.irq = sdhci_am654_cqhci_irq,
-	.reset = sdhci_reset,
+	.reset = sdhci_am654_reset,
 };
 
 static const struct sdhci_pltfm_data sdhci_j721e_4bit_pdata = {
@@ -719,6 +737,9 @@ static int sdhci_am654_get_of_property(struct platform_device *pdev,
 	device_property_read_u32(dev, "ti,clkbuf-sel",
 				 &sdhci_am654->clkbuf_sel);
 
+	if (device_property_read_bool(dev, "ti,fails-without-test-cd"))
+		sdhci_am654->quirks |= SDHCI_AM654_QUIRK_FORCE_CDTEST;
+
 	sdhci_get_of_property(pdev);
 
 	return 0;
-- 
2.35.1

