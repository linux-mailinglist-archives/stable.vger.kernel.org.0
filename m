Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB80644B793
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345026AbhKIWfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345334AbhKIWdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:33:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C8161A8B;
        Tue,  9 Nov 2021 22:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496513;
        bh=8gin4xYFGZZvnvIufp+YTmpLpY//PfSLSiDa2pG5IrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoA9y6W0OBaJ0SwLwrNricAnVu4EnEsChSEjiLXsQTOZdm+dGzjPtRx3gvgynQE+Y
         N3PiZjo/cqWmbZW8y2JwO7LvXtSft23jjSLrn77MUjQm1Z3UgrsI/g7BMeAsyT86qD
         G1f85yIoi4sbJwWDaF6DDMFgWVYmbKz/t8yzve/vxwqG3A+OZnlepms/b/dCeAN89m
         +XTTjffarOB4BL+KYnYQZMtR3YESpz/jfpqvPM3V3CF6DabMBjZAxn2417AcYS5aG5
         9o4iFgr73PEvaWaXl87yTHmn6jtdauO+6qRoZQ9Wx894vJ0A/wZnarnP9mkEEghoK6
         c2Pta/hRkdBbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 30/50] ASoC: Intel: sof_sdw: add missing quirk for Dell SKU 0A45
Date:   Tue,  9 Nov 2021 17:20:43 -0500
Message-Id: <20211109222103.1234885-30-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 64ba6d2ce72ffde70dc5a1794917bf1573203716 ]

This device is based on SDCA codecs but with a single amplifier
instead of two.

BugLink: https://github.com/thesofproject/linux/issues/3161
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20211004213512.220836-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 25548555d8d79..d9b864856be19 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -187,6 +187,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A45")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2 |
+					SOF_RT715_DAI_ID_FIX),
+	},
 	/* AlderLake devices */
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.33.0

