Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA83C2DA6
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhGJCYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhGJCYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:24:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A8F0613CC;
        Sat, 10 Jul 2021 02:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883719;
        bh=V17iZAtlDJtdmfky34MKjTT9SgYihWsXZKBHvFlFewE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZj9Lxz8t4bnGRBFnYNHLY16SDElKVBsgCfAUZ0CWT6StwT5ioEWOiYtVCYXrP5LK
         vzm7cFaM/Rr37r5HtC2g0h4CyNnUmrpqJvyx5A5KAwNHIN1WX1aZJNxrmL5wG7CS+p
         E6jmIrkamYAq/z5tduE8piD+2wD6p44MtfPVa3Vlizz/UrJrFmsgz9wZBk8E1Oc3U7
         A3QyAaHS2iimyesXxGEsvrRUMoJIM2pfuqXNXy1lQkZ88ylvJnCRPdNWx8RwMztUe4
         IClJeoMX/8AHmapE9vqozzGDEAfEp9z/HOief7Ir+NlyZg+7MGZZX6qxxc1cSgNGOS
         duzl+nzVUF4vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Libin Yang <libin.yang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 002/104] ASoC: Intel: sof_sdw: add mutual exclusion between PCH DMIC and RT715
Date:   Fri,  9 Jul 2021 22:20:14 -0400
Message-Id: <20210710022156.3168825-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 35564e2bf94611c3eb51d35362addb3cb394ad54 ]

When external RT714/715 devices are used for capture, we don't want
the PCH DMICs to be used.

Any information provided by the SOF platform driver or DMI quirks will
be overridden.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Libin Yang <libin.yang@intel.com>
Link: https://lore.kernel.org/r/20210505163705.305616-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c        | 19 +++++++++++++++++--
 sound/soc/intel/boards/sof_sdw_common.h |  1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index ecd3f90f4bbe..85a2797c2550 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -353,6 +353,7 @@ static struct sof_sdw_codec_info codec_info_list[] = {
 		.part_id = 0x714,
 		.version_id = 3,
 		.direction = {false, true},
+		.ignore_pch_dmic = true,
 		.dai_name = "rt715-aif2",
 		.init = sof_sdw_rt715_sdca_init,
 	},
@@ -360,6 +361,7 @@ static struct sof_sdw_codec_info codec_info_list[] = {
 		.part_id = 0x715,
 		.version_id = 3,
 		.direction = {false, true},
+		.ignore_pch_dmic = true,
 		.dai_name = "rt715-aif2",
 		.init = sof_sdw_rt715_sdca_init,
 	},
@@ -367,6 +369,7 @@ static struct sof_sdw_codec_info codec_info_list[] = {
 		.part_id = 0x714,
 		.version_id = 2,
 		.direction = {false, true},
+		.ignore_pch_dmic = true,
 		.dai_name = "rt715-aif2",
 		.init = sof_sdw_rt715_init,
 	},
@@ -374,6 +377,7 @@ static struct sof_sdw_codec_info codec_info_list[] = {
 		.part_id = 0x715,
 		.version_id = 2,
 		.direction = {false, true},
+		.ignore_pch_dmic = true,
 		.dai_name = "rt715-aif2",
 		.init = sof_sdw_rt715_init,
 	},
@@ -729,7 +733,8 @@ static int create_sdw_dailink(struct device *dev, int *be_index,
 			      int *cpu_id, bool *group_generated,
 			      struct snd_soc_codec_conf *codec_conf,
 			      int codec_count,
-			      int *codec_conf_index)
+			      int *codec_conf_index,
+			      bool *ignore_pch_dmic)
 {
 	const struct snd_soc_acpi_link_adr *link_next;
 	struct snd_soc_dai_link_component *codecs;
@@ -782,6 +787,9 @@ static int create_sdw_dailink(struct device *dev, int *be_index,
 	if (codec_index < 0)
 		return codec_index;
 
+	if (codec_info_list[codec_index].ignore_pch_dmic)
+		*ignore_pch_dmic = true;
+
 	cpu_dai_index = *cpu_id;
 	for_each_pcm_streams(stream) {
 		char *name, *cpu_name;
@@ -913,6 +921,7 @@ static int sof_card_dai_links_create(struct device *dev,
 	const struct snd_soc_acpi_link_adr *adr_link;
 	struct snd_soc_dai_link_component *cpus;
 	struct snd_soc_codec_conf *codec_conf;
+	bool ignore_pch_dmic = false;
 	int codec_conf_count;
 	int codec_conf_index = 0;
 	bool group_generated[SDW_MAX_GROUPS];
@@ -1019,7 +1028,8 @@ static int sof_card_dai_links_create(struct device *dev,
 					 sdw_cpu_dai_num, cpus, adr_link,
 					 &cpu_id, group_generated,
 					 codec_conf, codec_conf_count,
-					 &codec_conf_index);
+					 &codec_conf_index,
+					 &ignore_pch_dmic);
 		if (ret < 0) {
 			dev_err(dev, "failed to create dai link %d", be_id);
 			return -ENOMEM;
@@ -1087,6 +1097,10 @@ static int sof_card_dai_links_create(struct device *dev,
 DMIC:
 	/* dmic */
 	if (dmic_num > 0) {
+		if (ignore_pch_dmic) {
+			dev_warn(dev, "Ignoring PCH DMIC\n");
+			goto HDMI;
+		}
 		cpus[cpu_id].dai_name = "DMIC01 Pin";
 		init_dai_link(dev, links + link_id, be_id, "dmic01",
 			      0, 1, // DMIC only supports capture
@@ -1105,6 +1119,7 @@ static int sof_card_dai_links_create(struct device *dev,
 		INC_ID(be_id, cpu_id, link_id);
 	}
 
+HDMI:
 	/* HDMI */
 	if (hdmi_num > 0) {
 		idisp_components = devm_kcalloc(dev, hdmi_num,
diff --git a/sound/soc/intel/boards/sof_sdw_common.h b/sound/soc/intel/boards/sof_sdw_common.h
index f3cb6796363e..ea60e8ed215c 100644
--- a/sound/soc/intel/boards/sof_sdw_common.h
+++ b/sound/soc/intel/boards/sof_sdw_common.h
@@ -56,6 +56,7 @@ struct sof_sdw_codec_info {
 	int amp_num;
 	const u8 acpi_id[ACPI_ID_LEN];
 	const bool direction[2]; // playback & capture support
+	const bool ignore_pch_dmic;
 	const char *dai_name;
 	const struct snd_soc_ops *ops;
 
-- 
2.30.2

