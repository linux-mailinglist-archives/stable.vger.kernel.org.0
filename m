Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6780A657A1C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiL1PH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiL1PH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:07:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB2113D74
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:07:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95E95B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7782C433D2;
        Wed, 28 Dec 2022 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240073;
        bh=PTAYiipJXHA7YO07kU1dB70Dca/qVX/bqfcUIs4spdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzIKdBtzg/HMhCCZGT407AyvjT32liX2C/RaIhD5uBDn+Cgj8KPMldPTz3nRDFOI6
         AHGi15fXdJeaO3bSaVQneQpq5lOZ+gFX50/fpZeclAyDB33hH8ZLn/OVZA+uXGlrMq
         NhChj3zNAySpaI6vm9RCR5mv5pDup3c42TcW/ttU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Takeshi Saito <takeshi.saito.xv@renesas.com>,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/731] mmc: renesas_sdhi: alway populate SCC pointer
Date:   Wed, 28 Dec 2022 15:36:53 +0100
Message-Id: <20221228144305.444724059@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 3d4f9898c1c74323dd61d6a8a0efca9401232ad4 ]

We need the SCC pointer to reset the device, so populate it even when we
don't need it for tuning.

Fixes: 45bffc371fef ("mmc: renesas_sdhi: only reset SCC when its pointer is populated")
Signed-off-by: Takeshi Saito <takeshi.saito.xv@renesas.com>
Signed-off-by: Takeshi Kihara <takeshi.kihara.df@renesas.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20221120113457.42010-2-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 387f2a4f693a..f443debbcb98 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -1037,11 +1037,14 @@ int renesas_sdhi_probe(struct platform_device *pdev,
 	if (ver >= SDHI_VER_GEN3_SD)
 		host->get_timeout_cycles = renesas_sdhi_gen3_get_cycles;
 
+	/* Check for SCC so we can reset it if needed */
+	if (of_data && of_data->scc_offset && ver >= SDHI_VER_GEN2_SDR104)
+		priv->scc_ctl = host->ctl + of_data->scc_offset;
+
 	/* Enable tuning iff we have an SCC and a supported mode */
-	if (of_data && of_data->scc_offset &&
-	    (host->mmc->caps & MMC_CAP_UHS_SDR104 ||
-	     host->mmc->caps2 & (MMC_CAP2_HS200_1_8V_SDR |
-				 MMC_CAP2_HS400_1_8V))) {
+	if (priv->scc_ctl && (host->mmc->caps & MMC_CAP_UHS_SDR104 ||
+	    host->mmc->caps2 & (MMC_CAP2_HS200_1_8V_SDR |
+				MMC_CAP2_HS400_1_8V))) {
 		const struct renesas_sdhi_scc *taps = of_data->taps;
 		bool use_4tap = priv->quirks && priv->quirks->hs400_4taps;
 		bool hit = false;
@@ -1061,7 +1064,6 @@ int renesas_sdhi_probe(struct platform_device *pdev,
 		if (!hit)
 			dev_warn(&host->pdev->dev, "Unknown clock rate for tuning\n");
 
-		priv->scc_ctl = host->ctl + of_data->scc_offset;
 		host->check_retune = renesas_sdhi_check_scc_error;
 		host->ops.execute_tuning = renesas_sdhi_execute_tuning;
 		host->ops.prepare_hs400_tuning = renesas_sdhi_prepare_hs400_tuning;
-- 
2.35.1



