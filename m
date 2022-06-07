Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DD25381FA
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbiE3OVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241286AbiE3OR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C726311906D;
        Mon, 30 May 2022 06:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 186A4B80DB9;
        Mon, 30 May 2022 13:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E800EC3411E;
        Mon, 30 May 2022 13:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918303;
        bh=HNytHS3bxqCOXMxDzMBLrIaw03gY24xaeS8ZM9yxTB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4Ug5DbrMZCmMELJBdsxjbBMAeGc5drFbT3D0i+5zCcSI4kteSb/A1yBaCRMhFZy9
         /+4Mh9g0k+fI/7y3VB3OW/aW+7lFsJmDI+JnmMp779CwxYvfiK1wLdSQxbKL/OuY1B
         l9FvyhkOaFLsUL1zNi2iuO8pIBsgLdjby891iiqsb20fjKe5BzqXdSeVYmvJF6XLsK
         Fs0RD294lfOjM5DMnS0ULgnpRvRP12TISophHyyqK5Qrc7dsmr7ichSIPzZe03pE4A
         p70qK/M426rWqA7bRWCepwa2VeYhrfB7kswDjAgBeoJw8JJE+oYzNt6Wf7Xod8DyIN
         EefyORVBST9uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, adrian.hunter@intel.com,
        linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/76] drivers: mmc: sdhci_am654: Add the quirk to set TESTCD bit
Date:   Mon, 30 May 2022 09:43:16 -0400
Message-Id: <20220530134406.1934928-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
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
index a64ea143d185..7cab9d831afb 100644
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

