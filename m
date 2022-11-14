Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B555D627EDB
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbiKNMwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbiKNMwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:52:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E3A24F36
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:52:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F009B80EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941A3C433D6;
        Mon, 14 Nov 2022 12:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430338;
        bh=7IxYRpzAfcw0NE7ZtzcT1hrQ9jkYNODiGwheE+4JyVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUCvYDd7zTapAlkZ+/twlwRjCLhGBwmFxAoD4HGkarUEaSFsuGnSRXAkxlrDrF6SN
         PqC4cEVzK+o34wPUhVN+30IHX4Se0yUBVd34ZgfXwEaDwombFCMNprN6DMMRCkc7Bi
         sSY4eNnDctJ76/OuauvH40tKzjwKmD5Kl5FFv4WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@gmail.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 95/95] mmc: sdhci-esdhc-imx: Convert the driver to DT-only
Date:   Mon, 14 Nov 2022 13:46:29 +0100
Message-Id: <20221114124446.434875111@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

From: Fabio Estevam <festevam@gmail.com>

commit 854a22997ad5d6c9860a2d695c40cd4004151d5b upstream.

Since 5.10-rc1 i.MX is a devicetree-only platform, so simplify the code
by removing the unused non-DT support.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/r/20201117113750.25053-1-festevam@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   86 -------------------------------------
 1 file changed, 1 insertion(+), 85 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -295,22 +295,6 @@ struct pltfm_imx_data {
 	struct pm_qos_request pm_qos_req;
 };
 
-static const struct platform_device_id imx_esdhc_devtype[] = {
-	{
-		.name = "sdhci-esdhc-imx25",
-		.driver_data = (kernel_ulong_t) &esdhc_imx25_data,
-	}, {
-		.name = "sdhci-esdhc-imx35",
-		.driver_data = (kernel_ulong_t) &esdhc_imx35_data,
-	}, {
-		.name = "sdhci-esdhc-imx51",
-		.driver_data = (kernel_ulong_t) &esdhc_imx51_data,
-	}, {
-		/* sentinel */
-	}
-};
-MODULE_DEVICE_TABLE(platform, imx_esdhc_devtype);
-
 static const struct of_device_id imx_esdhc_dt_ids[] = {
 	{ .compatible = "fsl,imx25-esdhc", .data = &esdhc_imx25_data, },
 	{ .compatible = "fsl,imx35-esdhc", .data = &esdhc_imx35_data, },
@@ -1546,72 +1530,6 @@ sdhci_esdhc_imx_probe_dt(struct platform
 }
 #endif
 
-static int sdhci_esdhc_imx_probe_nondt(struct platform_device *pdev,
-			 struct sdhci_host *host,
-			 struct pltfm_imx_data *imx_data)
-{
-	struct esdhc_platform_data *boarddata = &imx_data->boarddata;
-	int err;
-
-	if (!host->mmc->parent->platform_data) {
-		dev_err(mmc_dev(host->mmc), "no board data!\n");
-		return -EINVAL;
-	}
-
-	imx_data->boarddata = *((struct esdhc_platform_data *)
-				host->mmc->parent->platform_data);
-	/* write_protect */
-	if (boarddata->wp_type == ESDHC_WP_GPIO) {
-		host->mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
-
-		err = mmc_gpiod_request_ro(host->mmc, "wp", 0, 0);
-		if (err) {
-			dev_err(mmc_dev(host->mmc),
-				"failed to request write-protect gpio!\n");
-			return err;
-		}
-	}
-
-	/* card_detect */
-	switch (boarddata->cd_type) {
-	case ESDHC_CD_GPIO:
-		err = mmc_gpiod_request_cd(host->mmc, "cd", 0, false, 0);
-		if (err) {
-			dev_err(mmc_dev(host->mmc),
-				"failed to request card-detect gpio!\n");
-			return err;
-		}
-		fallthrough;
-
-	case ESDHC_CD_CONTROLLER:
-		/* we have a working card_detect back */
-		host->quirks &= ~SDHCI_QUIRK_BROKEN_CARD_DETECTION;
-		break;
-
-	case ESDHC_CD_PERMANENT:
-		host->mmc->caps |= MMC_CAP_NONREMOVABLE;
-		break;
-
-	case ESDHC_CD_NONE:
-		break;
-	}
-
-	switch (boarddata->max_bus_width) {
-	case 8:
-		host->mmc->caps |= MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA;
-		break;
-	case 4:
-		host->mmc->caps |= MMC_CAP_4_BIT_DATA;
-		break;
-	case 1:
-	default:
-		host->quirks |= SDHCI_QUIRK_FORCE_1_BIT_DATA;
-		break;
-	}
-
-	return 0;
-}
-
 static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
@@ -1631,8 +1549,7 @@ static int sdhci_esdhc_imx_probe(struct
 
 	imx_data = sdhci_pltfm_priv(pltfm_host);
 
-	imx_data->socdata = of_id ? of_id->data : (struct esdhc_soc_data *)
-						  pdev->id_entry->driver_data;
+	imx_data->socdata = of_id->data;
 
 	if (imx_data->socdata->flags & ESDHC_FLAG_PMQOS)
 		cpu_latency_qos_add_request(&imx_data->pm_qos_req, 0);
@@ -1944,7 +1861,6 @@ static struct platform_driver sdhci_esdh
 		.of_match_table = imx_esdhc_dt_ids,
 		.pm	= &sdhci_esdhc_pmops,
 	},
-	.id_table	= imx_esdhc_devtype,
 	.probe		= sdhci_esdhc_imx_probe,
 	.remove		= sdhci_esdhc_imx_remove,
 };


