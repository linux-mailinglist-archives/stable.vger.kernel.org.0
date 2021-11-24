Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C4745C45D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351604AbhKXNrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349474AbhKXNpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:45:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0852611F2;
        Wed, 24 Nov 2021 13:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758842;
        bh=tMpF6sRtb7jnAh7DhZkd89nBO5Qf/AhhWvMTNOESrGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEoCamA6k/637vz2jQSTbRolKAd1+PrqDxsXFym6xX3gfxni42XA+qg96WCJcuLwR
         1kF8CAPF8cSxwoacFcyemqGV4iEgkc3yaQEpek648/QMd1x/tcfRNEgNGtpc2VDTgc
         1MBsG6roBOv7gQJapBsdfvCM3JG9zZcMFxSEpxcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/279] ASoC: Intel: soc-acpi: add missing quirk for TGL SDCA single amp
Date:   Wed, 24 Nov 2021 12:55:33 +0100
Message-Id: <20211124115720.324978990@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



