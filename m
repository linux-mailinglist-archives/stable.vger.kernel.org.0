Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1899627F4D
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbiKNM51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237589AbiKNM5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:57:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B317B27FD1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:57:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53C196117F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E909C433D6;
        Mon, 14 Nov 2022 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430641;
        bh=tSQISS3gORybFkFzwiU/LH2zMU4W8Uy94MZNT7g48jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLySlHOOMgriEzS6GApqb0BnsK+BaLteG67INOwn/hkP64xQx8Wl6C3RwnkbPvJIy
         vmbUQveOTSZ9bwK6shWUQrhhm9Dw29MsUwS1Com03D/N0PDK/HT2WQmUhUTSs0eCtb
         ZQ7fCPB2IfpcJZ5uMTHn1yryX70I574V5UfdniUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haibo Chen <haibo.chen@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 088/131] mmc: sdhci-esdhc-imx: use the correct host caps for MMC_CAP_8_BIT_DATA
Date:   Mon, 14 Nov 2022 13:45:57 +0100
Message-Id: <20221114124452.440069942@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

commit f002f45a00ee14214d96b18b9a555fe2c56afb20 upstream.

MMC_CAP_8_BIT_DATA belongs to struct mmc_host, not struct sdhci_host.
So correct it here.

Fixes: 1ed5c3b22fc7 ("mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Cc: stable@vger.kernel.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/1667893503-20583-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1654,14 +1654,14 @@ static int sdhci_esdhc_imx_probe(struct
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


