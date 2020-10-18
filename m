Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C70291EBF
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388539AbgJRTzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbgJRTUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B289922314;
        Sun, 18 Oct 2020 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048807;
        bh=dYPfU2nzxaMcnrWOWuW9A74av4A+cXEPOv4fMsWHBNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+CooKHp73Z1XcY6dJ3xN6C+aphzWQT64rsqU93wrW8rGX4oQU9LDF2cwhzypVf41
         kgekdPYffNaNK8X9vtELDTc0Zp3slfj62K+y/K7dSYOb6EzB2dHMyqTVAG1D2OG0kH
         bSpoYglHGrV7R3dcBSGZKt+w09satEa8zuCGT/R0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Mac Chiang <mac.chiang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.9 099/111] ASoC: Intel: sof_rt5682: override quirk data for tgl_max98373_rt5682
Date:   Sun, 18 Oct 2020 15:17:55 -0400
Message-Id: <20201018191807.4052726-99-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>

[ Upstream commit 3e1734b64ce786c54dc98adcfe67941e6011d735 ]

A Chrome System based on tgl_max98373_rt5682 has different SSP interface
configurations. Using DMI data of this variant DUT, override quirk
data.

Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
Signed-off-by: Mac Chiang <mac.chiang@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200821195603.215535-13-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 0129d23694ed5..9a6f10ede427e 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -119,6 +119,19 @@ static const struct dmi_system_id sof_rt5682_quirk_table[] = {
 		.driver_data = (void *)(SOF_RT5682_MCLK_EN |
 					SOF_RT5682_SSP_CODEC(0)),
 	},
+	{
+		.callback = sof_rt5682_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google_Volteer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Terrador"),
+		},
+		.driver_data = (void *)(SOF_RT5682_MCLK_EN |
+					SOF_RT5682_SSP_CODEC(0) |
+					SOF_SPEAKER_AMP_PRESENT |
+					SOF_MAX98373_SPEAKER_AMP_PRESENT |
+					SOF_RT5682_SSP_AMP(2) |
+					SOF_RT5682_NUM_HDMIDEV(4)),
+	},
 	{}
 };
 
-- 
2.25.1

