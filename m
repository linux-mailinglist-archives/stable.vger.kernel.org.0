Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1973B3743ED
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbhEEQxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236704AbhEEQub (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:50:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DBF06195C;
        Wed,  5 May 2021 16:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232651;
        bh=PVSiF54oj7LY3pnmZHYQ/o+FLdtwep2wBxiXVLjTfJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fm+x4tQrieiwdxstFLFevvpFaBVi1VciuCtYDCbNxNdNGG9CC4NLtTDhTwVj+420I
         knxNdoe3DtaXzo7U3kHJb1LqtWZFGwz2qw1TzL3B4esU1mC2SBJXhYCxOLzrQof2K/
         7G/ag+DDbMIICaWAKBPyTacuXAO4lEiZVHxsduiGamEfMNJ6S0RNVnTxaMpoStGe8O
         fJzIMvAfFWw80X3KQz22HzdS1iRlBtcsgFFoTkWBSplzV2OSmJF9a2SmqtbSbdK2Q6
         eFggvFBx+hSJujeyZCpkz6vrRSa9SVzKDakumEvMjLdE1Lwtei6ZBk+PvK0ntkAUSa
         pOMAUlv/NudWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 29/85] ASoC: Intel: bytcr_rt5640: Add quirk for the Chuwi Hi8 tablet
Date:   Wed,  5 May 2021 12:35:52 -0400
Message-Id: <20210505163648.3462507-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index 2d887406ca85..1ef0464249d1 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -514,6 +514,23 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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

