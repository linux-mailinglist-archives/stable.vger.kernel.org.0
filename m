Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56EE96213E3
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiKHNzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiKHNzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:55:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA5A19C06
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5FEDB81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4048C433C1;
        Tue,  8 Nov 2022 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915701;
        bh=mKQCnW94OFN6xpOYGjoVNWgRVfo/S9CYCA/2Y8f8LI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2s/dNj7u9Avw1R5tUDCUz3lDVtDEA1cwPTxWofmeDqx6UlV1wVTCnJb1TZDrx7Rao
         QkGcRVQ4OgLtC7PHaFBvemqtFPn8/yAJSaxKNoIf6ut3K+xa8y4CkYvvSfwWGj8mEH
         OZHVn1jCt+hgWX4o8g6142vezIPcc9s4dfDgV4+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sascha Hauer <s.hauer@pengutronix.de>,
        Haibo Chen <haibo.chen@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/118] mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus
Date:   Tue,  8 Nov 2022 14:38:47 +0100
Message-Id: <20221108133342.827504781@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 1ed5c3b22fc78735c539e4767832aea58db6761c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index a4bd85b200a3..be4e5cdda1fa 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1692,6 +1692,10 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 		host->mmc_host_ops.execute_tuning = usdhc_execute_tuning;
 	}
 
+	err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
+	if (err)
+		goto disable_ahb_clk;
+
 	if (imx_data->socdata->flags & ESDHC_FLAG_MAN_TUNING)
 		sdhci_esdhc_ops.platform_execute_tuning =
 					esdhc_executing_tuning;
@@ -1699,13 +1703,15 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	if (imx_data->socdata->flags & ESDHC_FLAG_ERR004536)
 		host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
 
-	if (imx_data->socdata->flags & ESDHC_FLAG_HS400)
+	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	    imx_data->socdata->flags & ESDHC_FLAG_HS400)
 		host->quirks2 |= SDHCI_QUIRK2_CAPS_BIT63_FOR_HS400;
 
 	if (imx_data->socdata->flags & ESDHC_FLAG_BROKEN_AUTO_CMD23)
 		host->quirks2 |= SDHCI_QUIRK2_ACMD23_BROKEN;
 
-	if (imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
+	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	    imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
 		host->mmc->caps2 |= MMC_CAP2_HS400_ES;
 		host->mmc_host_ops.hs400_enhanced_strobe =
 					esdhc_hs400_enhanced_strobe;
@@ -1727,13 +1733,6 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 			goto disable_ahb_clk;
 	}
 
-	if (of_id)
-		err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
-	else
-		err = sdhci_esdhc_imx_probe_nondt(pdev, host, imx_data);
-	if (err)
-		goto disable_ahb_clk;
-
 	sdhci_esdhc_imx_hwinit(host);
 
 	err = sdhci_add_host(host);
-- 
2.35.1



