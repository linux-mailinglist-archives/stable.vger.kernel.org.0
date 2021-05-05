Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF493744ED
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhEERC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237116AbhEEQ5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 997C8619A1;
        Wed,  5 May 2021 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232761;
        bh=zM7xKLvxLN4ktUHAaNf3ZEFbvweR13FCKR2sHSGA3SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVUYih+A386WL+CB+vFzId3uTeQEHWvEsyofEG/cc8ty6m5lO2lEeXW2s/i87hiZN
         QIl01HMF27aMGBCkLCfth39yOMJKYM4RUIgX9xM1fiy7N63RIUAMXsw/RRIGAFjeGp
         jnm8hvLaWJlWSolk4sZQywr1I5pHA2bSxkyMNHwZz6x+NLj3ts8WQJv3/Dgr/8iMqR
         Z6wllgjQgrNvN/eCipAANW1IXcqnXJssc4yGwBahzY9O287xcpTNcSua5TkiTovdDu
         nm8xrIo9jKQoYyGR+v4qMFAA1mFpmIs2LRwGyStTvmB5hOiZGugmuVJqIMZXEBV2Rr
         zLBooJBNzPblA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 17/46] ASoC: Intel: bytcr_rt5640: Add quirk for the Chuwi Hi8 tablet
Date:   Wed,  5 May 2021 12:38:27 -0400
Message-Id: <20210505163856.3463279-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 875c40eadf6ac6644c0f71842a4f30dd9968d281 ]

The Chuwi Hi8 tablet is using an analog mic on IN1 and has its
jack-detect connected to JD2_IN4N, instead of using the default
IN3 for its internal mic and JD1_IN4P for jack-detect.

It also only has 1 speaker.

Add a quirk applying the correct settings for this configuration.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210325221054.22714-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 006cf1e8b602..46a81d4f0b2d 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -512,6 +512,23 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{
+		/* Chuwi Hi8 (CWI509) */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
+			DMI_MATCH(DMI_BOARD_NAME, "BYT-PA03C"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ilife"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S806"),
+		},
+		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_MONO_SPEAKER |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Circuitco"),
-- 
2.30.2

