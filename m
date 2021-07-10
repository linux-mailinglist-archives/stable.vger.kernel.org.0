Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AC73C2F26
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbhGJC3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233175AbhGJC2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8164F6141D;
        Sat, 10 Jul 2021 02:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883898;
        bh=OLqbH2d+gVP9ROOjklugV0zALHqGY/8Q2uzXokpItNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wgl7l59d+dpdoMbdmgqJDJSYOUaB0elbp+1MTV1MTj6JMT5/rJo9umFxjyffIZeyB
         ai/mpNpYPUwIKTsIJUC+rT/Oy8Vkj7G5w9OHq9jvnv37/anD07BvkQd9z42MoiEVpv
         2nCr3qtAPgNj4vpG/sBqYGeK/9+AGl2FBOljiTogph05unbv2UTqDyJOIm/nJDwpE3
         VULcXvCnflZVGSDgyHfqjL8Rk9FinfieuqQ6dRFDKyAJpdnDpoK0qjxwv5XI70f27P
         F2aWTy4y/A8z78+nm5UTdrOTA95vDraEVqprmFuWFa5BnbgKgeO5uJ5VRHNGxXnEMU
         zRDYRatYqglHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>,
        Yong Zhi <yong.zhi@intel.com>, Bard Liao <bard.liao@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 22/93] ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload
Date:   Fri,  9 Jul 2021 22:23:16 -0400
Message-Id: <20210710022428.3169839-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>

[ Upstream commit 03effde3a2ea1d82c4dd6b634fc6174545d2c34f ]

Brya is another ADL-P product.

AlderLake has support for Bluetooth audio offload capability.
Enable the BT-offload quirk for ADL-P Brya and the Intel RVP.

Signed-off-by: Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210521155632.3736393-2-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 2770e8179983..f6d957ff61d6 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -197,7 +197,21 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.driver_data = (void *)(SOF_RT711_JD_SRC_JD1 |
 					SOF_SDW_TGL_HDMI |
 					SOF_RT715_DAI_ID_FIX |
-					SOF_SDW_PCH_DMIC),
+					SOF_SDW_PCH_DMIC |
+					SOF_BT_OFFLOAD_SSP(2) |
+					SOF_SSP_BT_OFFLOAD_PRESENT),
+	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Brya"),
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC |
+					SOF_SDW_FOUR_SPK |
+					SOF_BT_OFFLOAD_SSP(2) |
+					SOF_SSP_BT_OFFLOAD_PRESENT),
 	},
 	{}
 };
-- 
2.30.2

