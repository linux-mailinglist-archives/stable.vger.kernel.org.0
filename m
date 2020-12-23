Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261012E12A5
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgLWCXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbgLWCXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8C5122A83;
        Wed, 23 Dec 2020 02:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690146;
        bh=qCPqxc3GCFxiq19gUvEoJmscfz6qfLlcGbd4U/IqWjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAjzh8gRAZPFQz7DX0nAoT9g1v0FeMDh1ODeiPfjO/sVTlF34TP6INCvJ8JM3sfX8
         8ZEX+lZZxyglPiJx1Ai8GLaMEZh9EybUzma9WC2BY6l81EfniOQ4zJ84IRhVzX3d9d
         blnpiinJCVQmIH5vOweufkpbW8OLJGOjiiD039S895OB6sc/b0MA0f1uWRxzfNE+8u
         mSQnZOQJir36tCu3eOvH5LzulYIxaEoJ7R7Ytzi2EN4MRjGll+MK1xHFNliH3NXJLv
         SxqHH8SNVKR3828vrc7VmqwkXF+NuePSpZC0RwKnzecQ3++PWr9EU+QMKpvVvhFIUh
         lzMsP/26hjvbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Chiu <chiu@endlessos.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 67/87] ASoC: Intel: bytcr_rt5640: Add quirk for ARCHOS Cesium 140
Date:   Tue, 22 Dec 2020 21:20:43 -0500
Message-Id: <20201223022103.2792705-67-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index ec630127ef2f3..f23ddb9f810ae 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -431,6 +431,18 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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
2.27.0

