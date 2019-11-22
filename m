Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040F61064DD
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfKVFwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:52:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:58228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbfKVFwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CFAA20721;
        Fri, 22 Nov 2019 05:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401949;
        bh=EXOHNontjrs9tf8tmpw/5AGqGwMHf8WFi3vd8JcVRN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoPFMTOPdcjjv8tPpgucS8zUEWZKeNV0ejjePYEsJh7bWx6g/OLqv8PbMLOzNbWHq
         8iG0vWKda0khozFirNubLO7unQ9Gz6sHnSXUUSw4jkRif4K13AfXXREbsfSqobd8et
         wh8xNaFIM+GhDhlwxPqUbTOrvSs4/POLXKUUC9EI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 172/219] ata: ahci: mvebu: do Armada 38x configuration only on relevant SoCs
Date:   Fri, 22 Nov 2019 00:48:24 -0500
Message-Id: <20191122054911.1750-165-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 96dbcb40e4b1a387cdb9b21f43638c759aebb5a4 ]

At the beginning, only Armada 38x SoCs where supported by the
ahci_mvebu.c driver. Commit 15d3ce7b63bd ("ata: ahci_mvebu: add
support for Armada 3700 variant") introduced Armada 3700 support. As
opposed to Armada 38x SoCs, the 3700 variants do not have to configure
mbus and the regret option. This patch took care of avoiding such
configuration when not needed in the probe function, but failed to do
the same in the resume path. While doing so looks harmless by
experience, let's clean the driver logic and avoid doing this useless
configuration with Armada 3700 SoCs.

Because the logic is very similar between these two places, it has
been decided to factorize this code and put it in a "Armada 38x
configuration function". This function is part of a new
(per-compatible) platform data structure, so that the addition of such
configuration function for Armada 3700 will be eased.

Fixes: 15d3ce7b63bd ("ata: ahci_mvebu: add support for Armada 3700 variant")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_mvebu.c | 68 ++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 17 deletions(-)

diff --git a/drivers/ata/ahci_mvebu.c b/drivers/ata/ahci_mvebu.c
index f9cb51be38ebf..a54214291481f 100644
--- a/drivers/ata/ahci_mvebu.c
+++ b/drivers/ata/ahci_mvebu.c
@@ -28,6 +28,10 @@
 #define AHCI_WINDOW_BASE(win)	(0x64 + ((win) << 4))
 #define AHCI_WINDOW_SIZE(win)	(0x68 + ((win) << 4))
 
+struct ahci_mvebu_plat_data {
+	int (*plat_config)(struct ahci_host_priv *hpriv);
+};
+
 static void ahci_mvebu_mbus_config(struct ahci_host_priv *hpriv,
 				   const struct mbus_dram_target_info *dram)
 {
@@ -62,6 +66,22 @@ static void ahci_mvebu_regret_option(struct ahci_host_priv *hpriv)
 	writel(0x80, hpriv->mmio + AHCI_VENDOR_SPECIFIC_0_DATA);
 }
 
+static int ahci_mvebu_armada_380_config(struct ahci_host_priv *hpriv)
+{
+	const struct mbus_dram_target_info *dram;
+	int rc = 0;
+
+	dram = mv_mbus_dram_info();
+	if (dram)
+		ahci_mvebu_mbus_config(hpriv, dram);
+	else
+		rc = -ENODEV;
+
+	ahci_mvebu_regret_option(hpriv);
+
+	return rc;
+}
+
 /**
  * ahci_mvebu_stop_engine
  *
@@ -126,13 +146,10 @@ static int ahci_mvebu_resume(struct platform_device *pdev)
 {
 	struct ata_host *host = platform_get_drvdata(pdev);
 	struct ahci_host_priv *hpriv = host->private_data;
-	const struct mbus_dram_target_info *dram;
+	const struct ahci_mvebu_plat_data *pdata = hpriv->plat_data;
 
-	dram = mv_mbus_dram_info();
-	if (dram)
-		ahci_mvebu_mbus_config(hpriv, dram);
-
-	ahci_mvebu_regret_option(hpriv);
+	if (pdata->plat_config)
+		pdata->plat_config(hpriv);
 
 	return ahci_platform_resume_host(&pdev->dev);
 }
@@ -154,28 +171,31 @@ static struct scsi_host_template ahci_platform_sht = {
 
 static int ahci_mvebu_probe(struct platform_device *pdev)
 {
+	const struct ahci_mvebu_plat_data *pdata;
 	struct ahci_host_priv *hpriv;
-	const struct mbus_dram_target_info *dram;
 	int rc;
 
+	pdata = of_device_get_match_data(&pdev->dev);
+	if (!pdata)
+		return -EINVAL;
+
 	hpriv = ahci_platform_get_resources(pdev, 0);
 	if (IS_ERR(hpriv))
 		return PTR_ERR(hpriv);
 
+	hpriv->plat_data = (void *)pdata;
+
 	rc = ahci_platform_enable_resources(hpriv);
 	if (rc)
 		return rc;
 
 	hpriv->stop_engine = ahci_mvebu_stop_engine;
 
-	if (of_device_is_compatible(pdev->dev.of_node,
-				    "marvell,armada-380-ahci")) {
-		dram = mv_mbus_dram_info();
-		if (!dram)
-			return -ENODEV;
-
-		ahci_mvebu_mbus_config(hpriv, dram);
-		ahci_mvebu_regret_option(hpriv);
+	pdata = hpriv->plat_data;
+	if (pdata->plat_config) {
+		rc = pdata->plat_config(hpriv);
+		if (rc)
+			goto disable_resources;
 	}
 
 	rc = ahci_platform_init_host(pdev, hpriv, &ahci_mvebu_port_info,
@@ -190,9 +210,23 @@ static int ahci_mvebu_probe(struct platform_device *pdev)
 	return rc;
 }
 
+static const struct ahci_mvebu_plat_data ahci_mvebu_armada_380_plat_data = {
+	.plat_config = ahci_mvebu_armada_380_config,
+};
+
+static const struct ahci_mvebu_plat_data ahci_mvebu_armada_3700_plat_data = {
+	.plat_config = NULL,
+};
+
 static const struct of_device_id ahci_mvebu_of_match[] = {
-	{ .compatible = "marvell,armada-380-ahci", },
-	{ .compatible = "marvell,armada-3700-ahci", },
+	{
+		.compatible = "marvell,armada-380-ahci",
+		.data = &ahci_mvebu_armada_380_plat_data,
+	},
+	{
+		.compatible = "marvell,armada-3700-ahci",
+		.data = &ahci_mvebu_armada_3700_plat_data,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, ahci_mvebu_of_match);
-- 
2.20.1

