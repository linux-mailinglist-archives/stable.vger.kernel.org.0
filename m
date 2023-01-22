Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAEC676CF6
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 13:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjAVMom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 07:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjAVMol (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 07:44:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9421E1C3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 04:44:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 041FEB80AD3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 12:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5967BC433D2;
        Sun, 22 Jan 2023 12:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674391477;
        bh=ucrKP41QMSCvdZX4CBVKamTsjdxUiqXrGSIIBJrPZMY=;
        h=Subject:To:Cc:From:Date:From;
        b=PgrVvgCq2flcBsNas037fn0PRIN7YT+YMvgg4+tYhkBrEpeaCVGdi/4bbNwtQ+fCo
         yDd6NVpeW+chRxajMipZxUVXACZ0Ysz8SeqCHHURrnEINeUmlU6oWTolWIjOXGOwST
         4ulRytrbAEh4Y6OHPUQNg/uELeSTqXeCk5dfB1kk=
Subject: FAILED: patch "[PATCH] mmc: sdhci-esdhc-imx: correct the tuning start tap and step" failed to apply to 4.14-stable tree
To:     haibo.chen@nxp.com, adrian.hunter@intel.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 13:44:25 +0100
Message-ID: <167439146522730@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1e336aa0c025 ("mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting")
16e40e5b1e3c ("mmc: sdhci-esdhc-imx: disable the CMD CRC check for standard tuning")
1194be8c949b ("mmc: sdhci-esdhc-imx: fix the mask for tuning start point")
982cf37da3ee ("mmc: sdhci-esdhc-imx: clear pending interrupt and halt cqhci")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1e336aa0c0250ec84c6f16efac40c9f0138e367d Mon Sep 17 00:00:00 2001
From: Haibo Chen <haibo.chen@nxp.com>
Date: Wed, 7 Dec 2022 19:23:15 +0800
Subject: [PATCH] mmc: sdhci-esdhc-imx: correct the tuning start tap and step
 setting

Current code logic may be impacted by the setting of ROM/Bootloader,
so unmask these bits first, then setting these bits accordingly.

Fixes: 2b16cf326b70 ("mmc: sdhci-esdhc-imx: move tuning static configuration into hwinit function")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221207112315.1812222-1-haibo.chen@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 89ef0c80ac37..9e73c34b6401 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -107,6 +107,7 @@
 #define ESDHC_TUNING_START_TAP_DEFAULT	0x1
 #define ESDHC_TUNING_START_TAP_MASK	0x7f
 #define ESDHC_TUNING_CMD_CRC_CHECK_DISABLE	(1 << 7)
+#define ESDHC_TUNING_STEP_DEFAULT	0x1
 #define ESDHC_TUNING_STEP_MASK		0x00070000
 #define ESDHC_TUNING_STEP_SHIFT		16
 
@@ -1368,7 +1369,7 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
 	struct cqhci_host *cq_host = host->mmc->cqe_private;
-	int tmp;
+	u32 tmp;
 
 	if (esdhc_is_usdhc(imx_data)) {
 		/*
@@ -1423,17 +1424,24 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 
 		if (imx_data->socdata->flags & ESDHC_FLAG_STD_TUNING) {
 			tmp = readl(host->ioaddr + ESDHC_TUNING_CTRL);
-			tmp |= ESDHC_STD_TUNING_EN |
-				ESDHC_TUNING_START_TAP_DEFAULT;
-			if (imx_data->boarddata.tuning_start_tap) {
-				tmp &= ~ESDHC_TUNING_START_TAP_MASK;
+			tmp |= ESDHC_STD_TUNING_EN;
+
+			/*
+			 * ROM code or bootloader may config the start tap
+			 * and step, unmask them first.
+			 */
+			tmp &= ~(ESDHC_TUNING_START_TAP_MASK | ESDHC_TUNING_STEP_MASK);
+			if (imx_data->boarddata.tuning_start_tap)
 				tmp |= imx_data->boarddata.tuning_start_tap;
-			}
+			else
+				tmp |= ESDHC_TUNING_START_TAP_DEFAULT;
 
 			if (imx_data->boarddata.tuning_step) {
-				tmp &= ~ESDHC_TUNING_STEP_MASK;
 				tmp |= imx_data->boarddata.tuning_step
 					<< ESDHC_TUNING_STEP_SHIFT;
+			} else {
+				tmp |= ESDHC_TUNING_STEP_DEFAULT
+					<< ESDHC_TUNING_STEP_SHIFT;
 			}
 
 			/* Disable the CMD CRC check for tuning, if not, need to

