Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C5944B79D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345208AbhKIWf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345318AbhKIWdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:33:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ED73619A6;
        Tue,  9 Nov 2021 22:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496512;
        bh=EQDITavXQyMrsWXUtLCWsvNIKbQFktmfNv7ub8fx2/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/P1Zaik4Wh6HTAjGQ5PPkhllF5JeOSWQdeFC4fcD4RtDrezXZhe+Gx7eMfp7nYbC
         gvkCdlhzuIV78KFdcmE1wb7ukuM3BZsUKg+q3a4PehZbkeGqswMRWoFSsSHYImK7Mg
         vPVE7EnXVdpDk6za1vARvfecQnAiL8duoZkHs+ElAEtTvrJg7mFhtd6wu28LwpJ7/H
         QEu/DtMQw8X2Zze/0TPeLhVdt5u7U8WKC4Phn6KIn+NIjxfYGUxvOTqjKb2mhE9l1h
         OjnUrd3n7j43CVidecKPJKSsLpjVUkcS29zTl+byY57OKdlgdyUXLriPk/FjainBUU
         LQGeGinHS1BpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Huajun Li <huajun.li@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 29/50] ALSA: intel-dsp-config: add quirk for APL/GLK/TGL devices based on ES8336 codec
Date:   Tue,  9 Nov 2021 17:20:42 -0500
Message-Id: <20211109222103.1234885-29-sashal@kernel.org>
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

[ Upstream commit 9d36ceab94151f07cf3fcb067213ac87937adf12 ]

These devices are based on an I2C/I2S device, we need to force the use
of the SOF driver otherwise the legacy HDaudio driver will be loaded -
only HDMI will be supported.

Co-developed-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211004213512.220836-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 61e1de6d7be0a..6cdb3db7507b1 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -30,6 +30,7 @@ struct config_entry {
 	u32 flags;
 	u16 device;
 	const struct dmi_system_id *dmi_table;
+	u8 codec_hid[ACPI_ID_LEN];
 };
 
 /*
@@ -55,7 +56,7 @@ static const struct config_entry config_table[] = {
 /*
  * Apollolake (Broxton-P)
  * the legacy HDAudio driver is used except on Up Squared (SOF) and
- * Chromebooks (SST)
+ * Chromebooks (SST), as well as devices based on the ES8336 codec
  */
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_APOLLOLAKE)
 	{
@@ -72,6 +73,11 @@ static const struct config_entry config_table[] = {
 			{}
 		}
 	},
+	{
+		.flags = FLAG_SOF,
+		.device = 0x5a98,
+		.codec_hid = "ESSX8336",
+	},
 #endif
 #if IS_ENABLED(CONFIG_SND_SOC_INTEL_APL)
 	{
@@ -136,7 +142,7 @@ static const struct config_entry config_table[] = {
 
 /*
  * Geminilake uses legacy HDAudio driver except for Google
- * Chromebooks
+ * Chromebooks and devices based on the ES8336 codec
  */
 /* Geminilake */
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_GEMINILAKE)
@@ -153,6 +159,11 @@ static const struct config_entry config_table[] = {
 			{}
 		}
 	},
+	{
+		.flags = FLAG_SOF,
+		.device = 0x3198,
+		.codec_hid = "ESSX8336",
+	},
 #endif
 
 /*
@@ -310,6 +321,11 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x43c8,
 	},
+	{
+		.flags = FLAG_SOF,
+		.device = 0xa0c8,
+		.codec_hid = "ESSX8336",
+	},
 #endif
 
 /* Elkhart Lake */
@@ -337,6 +353,8 @@ static const struct config_entry *snd_intel_dsp_find_config
 			continue;
 		if (table->dmi_table && !dmi_check_system(table->dmi_table))
 			continue;
+		if (table->codec_hid[0] && !acpi_dev_present(table->codec_hid, NULL, -1))
+			continue;
 		return table;
 	}
 	return NULL;
-- 
2.33.0

