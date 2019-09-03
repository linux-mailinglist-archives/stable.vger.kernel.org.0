Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F220CA6FFA
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbfICQfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730500AbfICQ1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77C5123789;
        Tue,  3 Sep 2019 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528061;
        bh=+ItCqgWYRJjOhPpDJikclwg8Eu/+KA6wJDHRAQozRts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fn7DICNKmPCigLW2SzSkZ8jlbh+WHU7Q5mUV8Ie9/HXVbLetyJv9fY54I5cVGQR/h
         w+YI2pM37taEwTzs+PDpWBUGabCiO3lJ3STClR13iOsOSl15ueK3INMjX1D2WY38H+
         LmOAarC8H5PeLRBVWvdUnu8bQzi+k4cuoNeOb3w4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takeshi Saito <takeshi.saito.xv@renesas.com>,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Simon Horman <horms+renesas@verge.net.au>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 076/167] mmc: renesas_sdhi: Fix card initialization failure in high speed mode
Date:   Tue,  3 Sep 2019 12:23:48 -0400
Message-Id: <20190903162519.7136-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takeshi Saito <takeshi.saito.xv@renesas.com>

[ Upstream commit d30ae056adb81e1d2b8b953efa74735a020b8e3b ]

This fixes card initialization failure in high speed mode.

If U-Boot uses SDR or HS200/400 mode before starting Linux and Linux
DT does not enable SDR/HS200/HS400 mode, card initialization fails in
high speed mode.

It is necessary to initialize SCC registers during card initialization
phase. HW reset function is registered only for a port with either of
SDR/HS200/HS400 properties in device tree. If SDR/HS200/HS400 properties
are not present in device tree, SCC registers will not be reset. In SoC
that support SCC registers, HW reset function should be registered
regardless of the configuration of device tree.

Reproduction procedure:
- Use U-Boot that support MMC HS200/400 mode.
- Delete HS200/HS400 properties in device tree.
  (Delete mmc-hs200-1_8v and mmc-hs400-1_8v)
- MMC port works high speed mode and all commands fail.

Signed-off-by: Takeshi Saito <takeshi.saito.xv@renesas.com>
Signed-off-by: Marek Vasut <marek.vasut+renesas@gmail.com>
Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 45baf5d9120e3..61f0faddfd889 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -636,6 +636,13 @@ int renesas_sdhi_probe(struct platform_device *pdev,
 		host->ops.card_busy = renesas_sdhi_card_busy;
 		host->ops.start_signal_voltage_switch =
 			renesas_sdhi_start_signal_voltage_switch;
+
+		/* SDR and HS200/400 registers requires HW reset */
+		if (of_data && of_data->scc_offset) {
+			priv->scc_ctl = host->ctl + of_data->scc_offset;
+			host->mmc->caps |= MMC_CAP_HW_RESET;
+			host->hw_reset = renesas_sdhi_hw_reset;
+		}
 	}
 
 	/* Orginally registers were 16 bit apart, could be 32 or 64 nowadays */
@@ -693,8 +700,6 @@ int renesas_sdhi_probe(struct platform_device *pdev,
 		const struct renesas_sdhi_scc *taps = of_data->taps;
 		bool hit = false;
 
-		host->mmc->caps |= MMC_CAP_HW_RESET;
-
 		for (i = 0; i < of_data->taps_num; i++) {
 			if (taps[i].clk_rate == 0 ||
 			    taps[i].clk_rate == host->mmc->f_max) {
@@ -707,12 +712,10 @@ int renesas_sdhi_probe(struct platform_device *pdev,
 		if (!hit)
 			dev_warn(&host->pdev->dev, "Unknown clock rate for SDR104\n");
 
-		priv->scc_ctl = host->ctl + of_data->scc_offset;
 		host->init_tuning = renesas_sdhi_init_tuning;
 		host->prepare_tuning = renesas_sdhi_prepare_tuning;
 		host->select_tuning = renesas_sdhi_select_tuning;
 		host->check_scc_error = renesas_sdhi_check_scc_error;
-		host->hw_reset = renesas_sdhi_hw_reset;
 		host->prepare_hs400_tuning =
 			renesas_sdhi_prepare_hs400_tuning;
 		host->hs400_downgrade = renesas_sdhi_disable_scc;
-- 
2.20.1

