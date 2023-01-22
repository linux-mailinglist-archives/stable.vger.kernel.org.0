Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A82676FA0
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjAVPXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjAVPXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0D8CDFF
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7AB8B80B1A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3597CC433EF;
        Sun, 22 Jan 2023 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401007;
        bh=IuaODIiI4f10cBnP8hi6a6pEJAo8pR33xxVX3DduEGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOdAlfyeJDVH0qt5ql9iTRkGWjsu2TRnx4eqLCt2S/ZGH77VuTdymavCCV3AEjjBB
         9XiO2ExNRYAwL4nVsAfzdDQouAcKunjzsWnxKv30vMVfWNFuKVmQGwfnMfG3iujb9o
         cMHtJpRw4hHRnaJ298SBvARXihXUsJXopRsxs7jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haibo Chen <haibo.chen@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 075/193] mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting
Date:   Sun, 22 Jan 2023 16:03:24 +0100
Message-Id: <20230122150249.768329705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Haibo Chen <haibo.chen@nxp.com>

commit 1e336aa0c0250ec84c6f16efac40c9f0138e367d upstream.

Current code logic may be impacted by the setting of ROM/Bootloader,
so unmask these bits first, then setting these bits accordingly.

Fixes: 2b16cf326b70 ("mmc: sdhci-esdhc-imx: move tuning static configuration into hwinit function")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221207112315.1812222-1-haibo.chen@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -107,6 +107,7 @@
 #define ESDHC_TUNING_START_TAP_DEFAULT	0x1
 #define ESDHC_TUNING_START_TAP_MASK	0x7f
 #define ESDHC_TUNING_CMD_CRC_CHECK_DISABLE	(1 << 7)
+#define ESDHC_TUNING_STEP_DEFAULT	0x1
 #define ESDHC_TUNING_STEP_MASK		0x00070000
 #define ESDHC_TUNING_STEP_SHIFT		16
 
@@ -1361,7 +1362,7 @@ static void sdhci_esdhc_imx_hwinit(struc
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
 	struct cqhci_host *cq_host = host->mmc->cqe_private;
-	int tmp;
+	u32 tmp;
 
 	if (esdhc_is_usdhc(imx_data)) {
 		/*
@@ -1416,17 +1417,24 @@ static void sdhci_esdhc_imx_hwinit(struc
 
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


