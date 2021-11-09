Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995F844B5D1
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhKIWXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:23:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343730AbhKIWV1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:21:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5753F611BF;
        Tue,  9 Nov 2021 22:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496289;
        bh=tMpF6sRtb7jnAh7DhZkd89nBO5Qf/AhhWvMTNOESrGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuQR8a5THZGyntAgEbQ04g4+UxRyZy6DwpMMf9Nx2JhZ96PiqJq3bY4tSDtUTvRMo
         lsNCySUS0WTaDBOUG8QakcdQa+G8p+mrUK+xzqVexSWfqZF49avFVkDdN1x5gVIfFv
         eG3zNM9xKuGyteJBBSbE6Ourat0FmBU1LEiSi0QTr/BaYZRoWLapUe4fqwCIco86Sr
         IiBrRwdijue6XJEqnSex3a6K38ch30VAkTyQdJCml/RdZg+8gCjPAy7iUvv3AcZI3D
         BHHj3K7iFpEIZdpc1gbfFa3keDpCOJligmamUv/EJswkDrTpMrywjaO4Vll+KQ9Qz9
         6iGgMuZk977CA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 47/82] ASoC: Intel: soc-acpi: add missing quirk for TGL SDCA single amp
Date:   Tue,  9 Nov 2021 17:16:05 -0500
Message-Id: <20211109221641.1233217-47-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit f2470679b070a77ea22f8b791fae7084c2340c7d ]

We don't have a configuration for a single amp on link1.

BugLink: https://github.com/thesofproject/linux/issues/3161
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20211004213512.220836-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/common/soc-acpi-intel-tgl-match.c   | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-tgl-match.c b/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
index 785d5f5f8a9c9..11801b905ecc2 100644
--- a/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
@@ -156,6 +156,15 @@ static const struct snd_soc_acpi_adr_device rt711_sdca_0_adr[] = {
 	}
 };
 
+static const struct snd_soc_acpi_adr_device rt1316_1_single_adr[] = {
+	{
+		.adr = 0x000131025D131601ull,
+		.num_endpoints = 1,
+		.endpoints = &single_endpoint,
+		.name_prefix = "rt1316-1"
+	}
+};
+
 static const struct snd_soc_acpi_adr_device rt1316_1_group1_adr[] = {
 	{
 		.adr = 0x000131025D131601ull, /* unique ID is set for some reason */
@@ -320,6 +329,25 @@ static const struct snd_soc_acpi_link_adr tgl_3_in_1_sdca[] = {
 	{}
 };
 
+static const struct snd_soc_acpi_link_adr tgl_3_in_1_sdca_mono[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(rt711_sdca_0_adr),
+		.adr_d = rt711_sdca_0_adr,
+	},
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(rt1316_1_single_adr),
+		.adr_d = rt1316_1_single_adr,
+	},
+	{
+		.mask = BIT(3),
+		.num_adr = ARRAY_SIZE(rt714_3_adr),
+		.adr_d = rt714_3_adr,
+	},
+	{}
+};
+
 static const struct snd_soc_acpi_codecs tgl_max98373_amp = {
 	.num_codecs = 1,
 	.codecs = {"MX98373"}
@@ -412,6 +440,19 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_tgl_sdw_machines[] = {
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-tgl-rt711-rt1316-rt714.tplg",
 	},
+	{
+		/*
+		 * link_mask should be 0xB, but all links are enabled by BIOS.
+		 * This entry will be selected if there is no rt1316 amplifier exposed
+		 * on link2 since it will fail to match the above entry.
+		 */
+
+		.link_mask = 0xF, /* 4 active links required */
+		.links = tgl_3_in_1_sdca_mono,
+		.drv_name = "sof_sdw",
+		.sof_tplg_filename = "sof-tgl-rt711-l0-rt1316-l1-mono-rt714-l3.tplg",
+	},
+
 	{
 		.link_mask = 0x3, /* rt711 on link 0 and 1 rt1308 on link 1 */
 		.links = tgl_hp,
-- 
2.33.0

