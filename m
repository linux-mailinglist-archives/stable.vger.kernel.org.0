Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4824F5AB06F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbiIBMyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbiIBMxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4C5FAC75;
        Fri,  2 Sep 2022 05:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 865B9B82AD7;
        Fri,  2 Sep 2022 12:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DF8C433D6;
        Fri,  2 Sep 2022 12:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122255;
        bh=offp41GCZkSMjK/menYUEckaRbWIdkOoLjZE3dJk2QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D969sbdjz2kYDxvB78BoiiwBGhe4q4ksIE9136v9PIqb6XAA6kXSVT8CHXA7KcrXq
         parCqHpHi9ft8VqA4ScCHAnMOx+CHM1Oih6PsrLwZvMjd7KAB6OXxCH3qWlO7PqSu8
         MX6rgB9EC3hoD1Ws9hBsWaSCWujpyUbtA9RT/MUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woods <davwoods@nvidia.com>,
        Liming Sun <limings@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 31/72] mmc: sdhci-of-dwcmshc: Re-enable support for the BlueField-3 SoC
Date:   Fri,  2 Sep 2022 14:19:07 +0200
Message-Id: <20220902121405.816702291@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Liming Sun <limings@nvidia.com>

[ Upstream commit a0753ef66c34c1739580219dca664eda648164b7 ]

The commit 08f3dff799d4 (mmc: sdhci-of-dwcmshc: add rockchip platform
support") introduces the use of_device_get_match_data() to check for some
chips. Unfortunately, it also breaks the BlueField-3 FW, which uses ACPI.

To fix the problem, let's add the ACPI match data and the corresponding
quirks to re-enable the support for the BlueField-3 SoC.

Reviewed-by: David Woods <davwoods@nvidia.com>
Signed-off-by: Liming Sun <limings@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 08f3dff799d4 ("mmc: sdhci-of-dwcmshc: add rockchip platform support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220809173742.178440-1-limings@nvidia.com
[Ulf: Clarified the commit message a bit]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
index f5fd88c7adef1..335c88fd849c4 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -296,6 +296,15 @@ static const struct sdhci_pltfm_data sdhci_dwcmshc_pdata = {
 	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
 };
 
+#ifdef CONFIG_ACPI
+static const struct sdhci_pltfm_data sdhci_dwcmshc_bf3_pdata = {
+	.ops = &sdhci_dwcmshc_ops,
+	.quirks = SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+		   SDHCI_QUIRK2_ACMD23_BROKEN,
+};
+#endif
+
 static const struct sdhci_pltfm_data sdhci_dwcmshc_rk35xx_pdata = {
 	.ops = &sdhci_dwcmshc_rk35xx_ops,
 	.quirks = SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
@@ -360,7 +369,10 @@ MODULE_DEVICE_TABLE(of, sdhci_dwcmshc_dt_ids);
 
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id sdhci_dwcmshc_acpi_ids[] = {
-	{ .id = "MLNXBF30" },
+	{
+		.id = "MLNXBF30",
+		.driver_data = (kernel_ulong_t)&sdhci_dwcmshc_bf3_pdata,
+	},
 	{}
 };
 #endif
@@ -376,7 +388,7 @@ static int dwcmshc_probe(struct platform_device *pdev)
 	int err;
 	u32 extra;
 
-	pltfm_data = of_device_get_match_data(&pdev->dev);
+	pltfm_data = device_get_match_data(&pdev->dev);
 	if (!pltfm_data) {
 		dev_err(&pdev->dev, "Error: No device match data found\n");
 		return -ENODEV;
-- 
2.35.1



