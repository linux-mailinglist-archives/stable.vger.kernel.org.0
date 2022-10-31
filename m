Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFAB613092
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiJaGkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJaGkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:40:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065535FDA
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4825B81141
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2861C433D6;
        Mon, 31 Oct 2022 06:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667198405;
        bh=Yb2+HVO8e/qnPqf3Fk5wR3/1pjrwrylaMYNy2XjRqZM=;
        h=Subject:To:Cc:From:Date:From;
        b=qC9CytH5xrRgmAJ15CuvfpovrTSk9M3ZX8X/AyDoqC8BaQQ+hH4zSP3H/2pjgT9XQ
         KbNvihyF14Oxzl5hM+rjp2dcz8emfvQ64U1E49nqcKYoQ6hjMlaHqLmLqDil+bpBre
         QbUx0KrcmwgDFHbTWMI0oFP4OFxNk6DWMEpkUsJ8=
Subject: FAILED: patch "[PATCH] mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on" failed to apply to 5.10-stable tree
To:     s.hauer@pengutronix.de, haibo.chen@nxp.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:40:56 +0100
Message-ID: <166719845613250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1ed5c3b22fc7 ("mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus")
2991ad76d253 ("mmc: sdhci-esdhc-imx: advertise HS400 mode through MMC caps")
854a22997ad5 ("mmc: sdhci-esdhc-imx: Convert the driver to DT-only")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ed5c3b22fc78735c539e4767832aea58db6761c Mon Sep 17 00:00:00 2001
From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Thu, 13 Oct 2022 11:32:48 +0200
Subject: [PATCH] mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on
 8bit bus

The core issues the warning "drop HS400 support since no 8-bit bus" when
one of the ESDHC_FLAG_HS400* flags is set on a non 8bit capable host. To
avoid this warning set these flags only on hosts that actually can do
8bit, i.e. have bus-width = <8> set in the device tree.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Fixes: 029e2476f9e6 ("mmc: sdhci-esdhc-imx: add HS400_ES support for i.MX8QXP")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221013093248.2220802-1-s.hauer@pengutronix.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 55981b0f0b10..747df79d90ee 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1660,6 +1660,10 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 		host->mmc_host_ops.execute_tuning = usdhc_execute_tuning;
 	}
 
+	err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
+	if (err)
+		goto disable_ahb_clk;
+
 	if (imx_data->socdata->flags & ESDHC_FLAG_MAN_TUNING)
 		sdhci_esdhc_ops.platform_execute_tuning =
 					esdhc_executing_tuning;
@@ -1667,13 +1671,15 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	if (imx_data->socdata->flags & ESDHC_FLAG_ERR004536)
 		host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
 
-	if (imx_data->socdata->flags & ESDHC_FLAG_HS400)
+	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	    imx_data->socdata->flags & ESDHC_FLAG_HS400)
 		host->mmc->caps2 |= MMC_CAP2_HS400;
 
 	if (imx_data->socdata->flags & ESDHC_FLAG_BROKEN_AUTO_CMD23)
 		host->quirks2 |= SDHCI_QUIRK2_ACMD23_BROKEN;
 
-	if (imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
+	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	    imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
 		host->mmc->caps2 |= MMC_CAP2_HS400_ES;
 		host->mmc_host_ops.hs400_enhanced_strobe =
 					esdhc_hs400_enhanced_strobe;
@@ -1695,10 +1701,6 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 			goto disable_ahb_clk;
 	}
 
-	err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
-	if (err)
-		goto disable_ahb_clk;
-
 	sdhci_esdhc_imx_hwinit(host);
 
 	err = sdhci_add_host(host);

