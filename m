Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247CE59B422
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiHUNxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiHUNxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:53:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E1AA1B1
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 06:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A5E60EB0
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 13:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2540C433D6;
        Sun, 21 Aug 2022 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661090015;
        bh=HAs4DSQ5t/Lmrh3ba+OPXZEDT9zdnYrPXEkdEeDO/YM=;
        h=Subject:To:Cc:From:Date:From;
        b=mFSCTilDH1hXocB9IRJGvx65pFUHLOTVKyMH+dmH8dUlbdQKSY/RIbtiYIb4lELS/
         FsB3ZJlOZsUqlhZXSvu4TU1LLoGciTeASL6DQ/jojqP1znbmgpyoJijoh/O5C+yzUi
         uIzd48CrQTn+xKh6aKS8B4HnMFGzZeVU4sOZs0YQ=
Subject: FAILED: patch "[PATCH] mmc: sdhci-of-dwcmshc: Re-enable support for the BlueField-3" failed to apply to 5.15-stable tree
To:     limings@nvidia.com, adrian.hunter@intel.com, davwoods@nvidia.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 15:53:24 +0200
Message-ID: <166109000410728@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a0753ef66c34c1739580219dca664eda648164b7 Mon Sep 17 00:00:00 2001
From: Liming Sun <limings@nvidia.com>
Date: Tue, 9 Aug 2022 13:37:42 -0400
Subject: [PATCH] mmc: sdhci-of-dwcmshc: Re-enable support for the BlueField-3
 SoC

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

diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
index 4e904850973c..a7343d4bc50e 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -349,6 +349,15 @@ static const struct sdhci_pltfm_data sdhci_dwcmshc_pdata = {
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
@@ -431,7 +440,10 @@ MODULE_DEVICE_TABLE(of, sdhci_dwcmshc_dt_ids);
 
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
@@ -447,7 +459,7 @@ static int dwcmshc_probe(struct platform_device *pdev)
 	int err;
 	u32 extra;
 
-	pltfm_data = of_device_get_match_data(&pdev->dev);
+	pltfm_data = device_get_match_data(&pdev->dev);
 	if (!pltfm_data) {
 		dev_err(&pdev->dev, "Error: No device match data found\n");
 		return -ENODEV;

