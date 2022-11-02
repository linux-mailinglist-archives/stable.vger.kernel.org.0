Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180596158F1
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiKBDBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiKBDBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:01:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E88822BDD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:01:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 008D0B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0D7C433C1;
        Wed,  2 Nov 2022 03:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358089;
        bh=ZELdLrZqpEBexc8K+cQ05J2yGpBE9vTZ2j6IsjXgM/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dr23PI8C0rziESOr3l7c4bpVLWAjByGG8/5mkJnmyG9caFggNkx3jBmOngQPx/5V9
         Iw+hS0xZBQIgIT2+weA0jj+FQngL/3DWYVYrx4vX0yC38JDQuEDOt3z/It0xQ0bR/T
         vPa218TgDltqf1WAWRMNw3j843NyTvSv7e7K/dB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sascha Hauer <s.hauer@pengutronix.de>,
        Haibo Chen <haibo.chen@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 039/132] mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus
Date:   Wed,  2 Nov 2022 03:32:25 +0100
Message-Id: <20221102022100.657790972@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 1ed5c3b22fc78735c539e4767832aea58db6761c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1643,6 +1643,10 @@ static int sdhci_esdhc_imx_probe(struct
 		host->mmc_host_ops.execute_tuning = usdhc_execute_tuning;
 	}
 
+	err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
+	if (err)
+		goto disable_ahb_clk;
+
 	if (imx_data->socdata->flags & ESDHC_FLAG_MAN_TUNING)
 		sdhci_esdhc_ops.platform_execute_tuning =
 					esdhc_executing_tuning;
@@ -1650,13 +1654,15 @@ static int sdhci_esdhc_imx_probe(struct
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
@@ -1678,10 +1684,6 @@ static int sdhci_esdhc_imx_probe(struct
 			goto disable_ahb_clk;
 	}
 
-	err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
-	if (err)
-		goto disable_ahb_clk;
-
 	sdhci_esdhc_imx_hwinit(host);
 
 	err = sdhci_add_host(host);


