Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3EC323DAE
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhBXNOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:14:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235850AbhBXNHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:07:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B7D164F77;
        Wed, 24 Feb 2021 12:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171273;
        bh=MXfxw/LtL7kawGXDTIYr26sljJBdOjN0jhx4Vf2uGj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9VsyQp7SiUcGerBqtCRysIelb7gcuRQHfKeGVa58XQUPLeQBytfUmW5UcFKxqm4C
         vp02+ZiXIpNibGdVhzxHxpjF4sKFLTwN/F3ESx/SHIjAWB6PKDZ4txAZ+3zdQLyozK
         HYuIN5BAx5ixCVHE6xlfvymqJPB6ddldy6lCI2M1jL9jzBCML5BQ6O3v+Qt8m3/AuJ
         jX/1q7Md1CNuKtE/x/p7NeLii/eO0bfRPNOEoDgSd1ZZsrMlkHZBj2NM5hRqJVebY1
         +6Vz/GmwiaY8/9/QAiDlg5IfY5zdoJSFxN40Hm6D/jj1Hs/BUGwMzWGg4zaYifQ7BH
         NQ4Ima+0a8rrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 40/40] ASoC: Intel: bytcr_rt5640: Add quirk for the Acer One S1002 tablet
Date:   Wed, 24 Feb 2021 07:53:40 -0500
Message-Id: <20210224125340.483162-40-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c58947af08aedbdee0fce5ea6e6bf3e488ae0e2c ]

The Acer One S1002 tablet is using an analog mic on IN1 and has
its jack-detect connected to JD2_IN4N, instead of using the default
IN3 for its internal mic and JD1_IN4P for jack-detect.

Note it is also using AIF2 instead of AIF1 which is somewhat unusual,
this is correctly advertised in the ACPI CHAN package, so the speakers
do work without the quirk.

Add a quirk for the mic and jack-detect settings.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210216213555.36555-5-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 00e8d589a7246..9ee610504bac9 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -400,6 +400,19 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* Acer One 10 S1002 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "One S1002"),
+		},
+		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF2 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-- 
2.27.0

