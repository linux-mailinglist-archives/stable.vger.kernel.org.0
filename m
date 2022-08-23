Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB16859D927
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236890AbiHWJWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiHWJWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:22:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1C08E0FB;
        Tue, 23 Aug 2022 01:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47EE6B81C1C;
        Tue, 23 Aug 2022 08:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844B1C433D6;
        Tue, 23 Aug 2022 08:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243608;
        bh=TPy/KETqUmQZnZolpNzXaphI9rczF7IPRF6bkrILUNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJj7kE49icp3SDmC4ZMcnu5r8Lj5UD3RVcnoPFVEvh4KZsXzPiGhh2Caeg7iz4Nh9
         fMruXXdvuPfcjR8lYfwEfopIK+h3NQ/ndrHsckGAJ0Nacee+tpX99y4/lVXFjGVlay
         ePFyQ0Qe7Bl9g3ewdc1NmQNpG5BxY2vDX2VIrH5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takeshi Saito <takeshi.saito.xv@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 301/365] mmc: renesas_sdhi: newer SoCs dont need manual tap correction
Date:   Tue, 23 Aug 2022 10:03:22 +0200
Message-Id: <20220823080130.777525058@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takeshi Saito <takeshi.saito.xv@renesas.com>

[ Upstream commit 00e8c11c137b2e4b2bf54dc9881cf32e3441ddb4 ]

The newest Gen3 SoCs and Gen4 SoCs do not need manual tap correction
with HS400 anymore. So, instead of checking the SDHI version, add a
quirk flag and set manual tap correction only for affected SoCs.

Signed-off-by: Takeshi Saito <takeshi.saito.xv@renesas.com>
[wsa: rebased, renamed the quirk variable, removed stale comment]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20220720072901.1266-1-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi.h               | 1 +
 drivers/mmc/host/renesas_sdhi_core.c          | 5 ++---
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 6 ++++++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/renesas_sdhi.h b/drivers/mmc/host/renesas_sdhi.h
index 1a1e3e020a8c..c4abfee1ebae 100644
--- a/drivers/mmc/host/renesas_sdhi.h
+++ b/drivers/mmc/host/renesas_sdhi.h
@@ -43,6 +43,7 @@ struct renesas_sdhi_quirks {
 	bool hs400_4taps;
 	bool fixed_addr_mode;
 	bool dma_one_rx_only;
+	bool manual_tap_correction;
 	u32 hs400_bad_taps;
 	const u8 (*hs400_calib_table)[SDHI_CALIB_TABLE_MAX];
 };
diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 55f7b27c3de7..6edbf5c161ab 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -380,8 +380,7 @@ static void renesas_sdhi_hs400_complete(struct mmc_host *mmc)
 	sd_scc_write32(host, priv, SH_MOBILE_SDHI_SCC_DT2FF,
 		       priv->scc_tappos_hs400);
 
-	/* Gen3 can't do automatic tap correction with HS400, so disable it */
-	if (sd_ctrl_read16(host, CTL_VERSION) == SDHI_VER_GEN3_SDMMC)
+	if (priv->quirks && priv->quirks->manual_tap_correction)
 		sd_scc_write32(host, priv, SH_MOBILE_SDHI_SCC_RVSCNTL,
 			       ~SH_MOBILE_SDHI_SCC_RVSCNTL_RVSEN &
 			       sd_scc_read32(host, priv, SH_MOBILE_SDHI_SCC_RVSCNTL));
@@ -718,7 +717,7 @@ static bool renesas_sdhi_manual_correction(struct tmio_mmc_host *host, bool use_
 	sd_scc_write32(host, priv, SH_MOBILE_SDHI_SCC_RVSREQ, 0);
 
 	/* Change TAP position according to correction status */
-	if (sd_ctrl_read16(host, CTL_VERSION) == SDHI_VER_GEN3_SDMMC &&
+	if (priv->quirks && priv->quirks->manual_tap_correction &&
 	    host->mmc->ios.timing == MMC_TIMING_MMC_HS400) {
 		u32 bad_taps = priv->quirks ? priv->quirks->hs400_bad_taps : 0;
 		/*
diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index 3084b15ae2cb..52915404eb07 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -170,6 +170,7 @@ static const struct renesas_sdhi_quirks sdhi_quirks_4tap_nohs400_one_rx = {
 static const struct renesas_sdhi_quirks sdhi_quirks_4tap = {
 	.hs400_4taps = true,
 	.hs400_bad_taps = BIT(2) | BIT(3) | BIT(6) | BIT(7),
+	.manual_tap_correction = true,
 };
 
 static const struct renesas_sdhi_quirks sdhi_quirks_nohs400 = {
@@ -182,25 +183,30 @@ static const struct renesas_sdhi_quirks sdhi_quirks_fixed_addr = {
 
 static const struct renesas_sdhi_quirks sdhi_quirks_bad_taps1357 = {
 	.hs400_bad_taps = BIT(1) | BIT(3) | BIT(5) | BIT(7),
+	.manual_tap_correction = true,
 };
 
 static const struct renesas_sdhi_quirks sdhi_quirks_bad_taps2367 = {
 	.hs400_bad_taps = BIT(2) | BIT(3) | BIT(6) | BIT(7),
+	.manual_tap_correction = true,
 };
 
 static const struct renesas_sdhi_quirks sdhi_quirks_r8a7796_es13 = {
 	.hs400_4taps = true,
 	.hs400_bad_taps = BIT(2) | BIT(3) | BIT(6) | BIT(7),
 	.hs400_calib_table = r8a7796_es13_calib_table,
+	.manual_tap_correction = true,
 };
 
 static const struct renesas_sdhi_quirks sdhi_quirks_r8a77965 = {
 	.hs400_bad_taps = BIT(2) | BIT(3) | BIT(6) | BIT(7),
 	.hs400_calib_table = r8a77965_calib_table,
+	.manual_tap_correction = true,
 };
 
 static const struct renesas_sdhi_quirks sdhi_quirks_r8a77990 = {
 	.hs400_calib_table = r8a77990_calib_table,
+	.manual_tap_correction = true,
 };
 
 /*
-- 
2.35.1



