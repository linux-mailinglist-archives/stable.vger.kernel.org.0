Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E7E374183
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhEEQit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234737AbhEEQgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE46361453;
        Wed,  5 May 2021 16:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232400;
        bh=IT+5WeIpLY9wMHs/s4Kw3Wm0X2t8cPHtpBTEP+qGz78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxO/UBAHQpUiWt4LQqkVHMmt6sZ11j3l+jPWN9yrjv2Jv4xcHMM0t3DWPTqAiuO0C
         mhceTM5Aq1KCWgYVCma7zn8xQZ8B1XZcYVjb4jzmq/WO/zRr9awW/z4m6Fd9rhXkTr
         9seVSjPRugfhUEs1U38fPDsMkLjJ2XkqxwAKrUKdUStO7XFt8EHlZvGCvKrsjvfEiT
         li8JwxGOEPpkZ5HuOQ0ZpY1epWZFTivKpVwKNG+SeQoT4l/doXlkClHXjdfpvZ2aYI
         wREehq5da4bTGLfFoJ8RwpIpBiWZ0AuHx1snlG1OsBrMlg4FqORrZlRd+4ggN5LMno
         QhXxtZzKKz/cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 081/116] ASoC: Intel: sof_sdw: add quirk for new ADL-P Rvp
Date:   Wed,  5 May 2021 12:30:49 -0400
Message-Id: <20210505163125.3460440-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>

[ Upstream commit d25bbe80485f8bcbbeb91a2a6cd8798c124b27b7 ]

Add quirks for jack detection, rt711 DAI and DMIC

Reviewed-by: Bard Liao <bard.liao@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210415175013.192862-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 8adce6417b02..ecd3f90f4bbe 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -187,6 +187,17 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
+	/* AlderLake devices */
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alder Lake Client Platform"),
+		},
+		.driver_data = (void *)(SOF_RT711_JD_SRC_JD1 |
+					SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC),
+	},
 	{}
 };
 
-- 
2.30.2

