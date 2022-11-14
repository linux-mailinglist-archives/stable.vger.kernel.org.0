Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A91627A2E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiKNKNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236066AbiKNKM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:12:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA95226E8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:12:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 679F460FB5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B65C433C1;
        Mon, 14 Nov 2022 10:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668420720;
        bh=07GQzw91NBYzw+1icirgXXq6MSWE0i148ZFfrGG202g=;
        h=Subject:To:Cc:From:Date:From;
        b=u5GWbjFKo9vatVHJ3lw63JqfYN2o1HYRICpw1gQFLb3KDIaJM8P9j37HlzD9cWMMJ
         +bwZNgIMLptpKWdukbFBSUtc1Zxhh8puRUjPwsoxuqd0AiUnutL0ubH2oi3iQkeOv6
         bY5PRlkXN1QS9YDa3VK/FlFotzjrkIcGEDPnS2Xg=
Subject: FAILED: patch "[PATCH] mmc: sdhci-esdhc-imx: use the correct host caps for" failed to apply to 5.10-stable tree
To:     haibo.chen@nxp.com, adrian.hunter@intel.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:11:57 +0100
Message-ID: <1668420717137218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

f002f45a00ee ("mmc: sdhci-esdhc-imx: use the correct host caps for MMC_CAP_8_BIT_DATA")
1ed5c3b22fc7 ("mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus")
2991ad76d253 ("mmc: sdhci-esdhc-imx: advertise HS400 mode through MMC caps")
854a22997ad5 ("mmc: sdhci-esdhc-imx: Convert the driver to DT-only")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f002f45a00ee14214d96b18b9a555fe2c56afb20 Mon Sep 17 00:00:00 2001
From: Haibo Chen <haibo.chen@nxp.com>
Date: Tue, 8 Nov 2022 15:45:03 +0800
Subject: [PATCH] mmc: sdhci-esdhc-imx: use the correct host caps for
 MMC_CAP_8_BIT_DATA

MMC_CAP_8_BIT_DATA belongs to struct mmc_host, not struct sdhci_host.
So correct it here.

Fixes: 1ed5c3b22fc7 ("mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Cc: stable@vger.kernel.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/1667893503-20583-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 89225faa242a..31ea0a2fce35 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1672,14 +1672,14 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	if (imx_data->socdata->flags & ESDHC_FLAG_ERR004536)
 		host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
 
-	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
 	    imx_data->socdata->flags & ESDHC_FLAG_HS400)
 		host->mmc->caps2 |= MMC_CAP2_HS400;
 
 	if (imx_data->socdata->flags & ESDHC_FLAG_BROKEN_AUTO_CMD23)
 		host->quirks2 |= SDHCI_QUIRK2_ACMD23_BROKEN;
 
-	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
 	    imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
 		host->mmc->caps2 |= MMC_CAP2_HS400_ES;
 		host->mmc_host_ops.hs400_enhanced_strobe =

