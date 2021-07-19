Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425C83CE020
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345811AbhGSPNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345169AbhGSPMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:12:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2567860FDA;
        Mon, 19 Jul 2021 15:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709977;
        bh=xjtot0216/wpvfIJf40cXj0R8WILV3RUAH5XeVdLLh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIfTcikCpq7AnTiyCZPzklWhvwg41UZZW+HU99nAf+lSUJcvroRuBxVYN0ti0RCXu
         3jCDh7qwS9tsY9B8yxoo5ELbCxatxZ97l1GqrODFHHb4f/h+nBBGpiyeM1sUatEpqS
         EmQPpEDXjAK68upu67zQ+Xg7GWAzzest5Ykbfe3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Libin Yang <libin.yang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/243] ASoC: Intel: sof_sdw: add mutual exclusion between PCH DMIC and RT715
Date:   Mon, 19 Jul 2021 16:50:53 +0200
Message-Id: <20210719144941.708307251@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 75a0bfedb449..2770e8179983 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -354,6 +354,7 @@ static struct sof_sdw_codec_info codec_info_list[] = {
 		.part_id = 0x714,
 		.version_id = 3,
 		.direction = {false, true},
+		.ignore_pch_dmic = true,
 		.dai_name = "rt715-aif2",
 		.init = sof_sdw_rt715_sdca_init,
 	},
@@ -361,6 +362,7 @@ static struct sof_sdw_codec_info codec_info_list[] = {
 		.part_id = 0x715,
 		.version_id = 3,
 		.direction = {false, true},
+		.ignore_pch_dmic = true,
 		.dai_name = "rt715-aif2",
 		.init = sof_sdw_rt715_sdca_init,
 	},
@@ -368,6 +370,7 @@ static struct sof_sdw_codec_info codec_info_list[] = {
 		.part_id = 0x714,
 		.version_id = 2,
 		.direction = {false, true},
+		.ignore_pch_dmic = true,
 		.dai_name = "rt715-aif2",
 		.init = sof_sdw_rt715_init,
 	},
@@ -375,6 +378,7 @@ static struct sof_sdw_codec_info codec_info_list[] = {
 		.part_id = 0x715,
 		.version_id = 2,
 		.direction = {false, true},
+		.ignore_pch_dmic = true,
 		.dai_name = "rt715-aif2",
 		.init = sof_sdw_rt715_init,
 	},
@@ -731,7 +735,8 @@ static int create_sdw_dailink(struct device *dev, int *be_index,
 			      int *cpu_id, bool *group_generated,
 			      struct snd_soc_codec_conf *codec_conf,
 			      int codec_count,
-			      int *codec_conf_index)
+			      int *codec_conf_index,
+			      bool *ignore_pch_dmic)
 {
 	const struct snd_soc_acpi_link_adr *link_next;
 	struct snd_soc_dai_link_component *codecs;
@@ -784,6 +789,9 @@ static int create_sdw_dailink(struct device *dev, int *be_index,
 	if (codec_index < 0)
 		return codec_index;
 
+	if (codec_info_list[codec_index].ignore_pch_dmic)
+		*ignore_pch_dmic = true;
+
 	cpu_dai_index = *cpu_id;
 	for_each_pcm_streams(stream) {
 		char *name, *cpu_name;
@@ -915,6 +923,7 @@ static int sof_card_dai_links_create(struct device *dev,
 	const struct snd_soc_acpi_link_adr *adr_link;
 	struct snd_soc_dai_link_component *cpus;
 	struct snd_soc_codec_conf *codec_conf;
+	bool ignore_pch_dmic = false;
 	int codec_conf_count;
 	int codec_conf_index = 0;
 	bool group_generated[SDW_MAX_GROUPS];
@@ -1021,7 +1030,8 @@ static int sof_card_dai_links_create(struct device *dev,
 					 sdw_cpu_dai_num, cpus, adr_link,
 					 &cpu_id, group_generated,
 					 codec_conf, codec_conf_count,
-					 &codec_conf_index);
+					 &codec_conf_index,
+					 &ignore_pch_dmic);
 		if (ret < 0) {
 			dev_err(dev, "failed to create dai link %d", be_id);
 			return -ENOMEM;
@@ -1089,6 +1099,10 @@ SSP:
 DMIC:
 	/* dmic */
 	if (dmic_num > 0) {
+		if (ignore_pch_dmic) {
+			dev_warn(dev, "Ignoring PCH DMIC\n");
+			goto HDMI;
+		}
 		cpus[cpu_id].dai_name = "DMIC01 Pin";
 		init_dai_link(links + link_id, be_id, "dmic01",
 			      0, 1, // DMIC only supports capture
@@ -1107,6 +1121,7 @@ DMIC:
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



