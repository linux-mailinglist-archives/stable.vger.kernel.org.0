Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFF15920F4
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbiHNPcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240558AbiHNPbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:31:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3983E1A836;
        Sun, 14 Aug 2022 08:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1023DB80B27;
        Sun, 14 Aug 2022 15:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF90C433D6;
        Sun, 14 Aug 2022 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490983;
        bh=VAZ7bw/cY6Ku/WESVFj7vU3YOdy8tsbj8N9GzWDRbVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXI8i2ia1XSm5TJypricsEdMMHdrm3FSLWuwY6/kfIP3AbCUdApzyTHVJ0GSTtBQC
         +pxm0/0lEY47wwyAoUeiTJ+BsFNpCQhWTyIFpVSp4Y+WhviqNQDCigpeqvWu+IgMEO
         sEcH6Vr2Im1rreVUgzb8SEzzhFvWYibjEtbriEc1eiJNue+qTMTF/HMaV2EeaZ7WzA
         jyvBFWeCRE855l2UOJCRBCMfXbf6fLIJd96dNG4weCpdKLRMmgjsjDAZs5hpZak8Oj
         q5Lz8hosqIQ8RV3WfCzBF0qPHo0sD6phRJJVFMB5z4vCw9EHoVQJFAWO2P+rCfaaqE
         HgMkOzuCvFIuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takeshi Saito <takeshi.saito.xv@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 46/64] mmc: renesas_sdhi: newer SoCs don't need manual tap correction
Date:   Sun, 14 Aug 2022 11:24:19 -0400
Message-Id: <20220814152437.2374207-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5fa365d0c7fd..61149c0acaae 100644
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

