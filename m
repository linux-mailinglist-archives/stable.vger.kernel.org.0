Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDDF333E40
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhCJNZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232950AbhCJNZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 715B464FE0;
        Wed, 10 Mar 2021 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382709;
        bh=KdCT76QiVLJzUWD0rj2dbnAIGH1XGWGiiy0yBdD0XNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2bfOV+H8viaRQfe2dWm5Il4s2MkA32kp2aJr8trxXWkxXHheg/IB5OC8QONwo01M
         uMZ3KYyMf+fPOdbbW+Olbir3Ahz1hJPPulPv0bNSRhmwqEykVsvbrnssOVBfb65pkD
         2KTd8qahTLyFXEJXkElYiJe9UiZGcUFYdtLTBrXw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessos.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/24] ASoC: Intel: bytcr_rt5640: Add quirk for ARCHOS Cesium 140
Date:   Wed, 10 Mar 2021 14:24:29 +0100
Message-Id: <20210310132321.073017675@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.550932445@linuxfoundation.org>
References: <20210310132320.550932445@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Chris Chiu <chiu@endlessos.org>

[ Upstream commit 1bea2256aa96a2d7b1b576eb74e29d79edc9bea8 ]

Tha ARCHOS Cesium 140 tablet has problem with the jack-sensing,
thus the heaset functions are not working.

Add quirk for this model to select the correct input map, jack-detect
options and channel map to enable jack sensing and headset microphone.
This device uses IN1 for its internal MIC and JD2 for jack-detect.

Signed-off-by: Chris Chiu <chiu@endlessos.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20201208060414.27646-1-chiu@endlessos.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 9ee610504bac..cfd307717473 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -435,6 +435,18 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ARCHOS"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "ARCHOS 140 CESIUM"),
+		},
+		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
2.30.1



