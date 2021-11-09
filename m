Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE45444B6DA
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344619AbhKIWaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:30:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344742AbhKIW23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:28:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA2761A61;
        Tue,  9 Nov 2021 22:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496420;
        bh=D0YXkbFvM3on7muiiVcfWSJQ6wyBEmnxfe0uDuKK/UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFcAIJ+kKud8gf/QpM6rGMxYldGcYh7auwWK5etaFxRu+RYnEovMxYfgXnDg3trJQ
         9kmnwSueYY8XJeh4FttdL0K7vNNbz4Pj/rbghPWAy2TFaUVdJpJYdPCBnKgFZD0t+d
         kpwLlgasVxn6hpVYiRU0jlJxu127+szlqDoCIH2bqde5QLOHRygyUZij1qYL5a8vad
         zZnHXTB3hzG8x9cdeAY8WqlXdtnDxvmmKH1Z1p0a9S+jACJZMIej9X8KAQ0xKidekz
         zKJopjb/3XxUMBc1SNb5NTIvPStpGW5xOEjxS/abrypRTupobqK0TQgQMztclT5xWC
         zQP/cbtDyw3Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.14 45/75] ASoC: Intel: sof_sdw: add missing quirk for Dell SKU 0A45
Date:   Tue,  9 Nov 2021 17:18:35 -0500
Message-Id: <20211109221905.1234094-45-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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
index cb3afc4519cf6..041717c71c930 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -189,6 +189,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
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

