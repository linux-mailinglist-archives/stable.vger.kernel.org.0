Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F6E111E2C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbfLCW4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729945AbfLCW4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94BB72053B;
        Tue,  3 Dec 2019 22:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413770;
        bh=2QDZ0dMDTHhItPAm/DVEGvPgpkbqGQphOwS5UzWuQL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ph0OySAyVA9/6UniSEvpke1u0tREPclu+ii3BFkxev4fftblc7I2KYULCb6kwHjck
         QnTJH/ny/DJ0nSdBdjtX7F+fFG28PODyC9P02VkQrkZhjmUUidGGLr+Tc+6HREP7KA
         fU4Iax1Je8aObo2KSQdT3+7Mf/Y2/c8NwQY7ZtHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/321] ata: ahci: mvebu: do Armada 38x configuration only on relevant SoCs
Date:   Tue,  3 Dec 2019 23:34:42 +0100
Message-Id: <20191203223438.356530142@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -190,9 +210,23 @@ disable_resources:
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



