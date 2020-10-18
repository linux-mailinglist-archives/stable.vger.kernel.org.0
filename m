Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E05A291DB8
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbgJRTrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729749AbgJRTWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE7B3222E8;
        Sun, 18 Oct 2020 19:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048937;
        bh=P53ED4BShvDlilS5vert2xbkgwQD01dU3Jv7kDeWyIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fToFWezSrRSwS4ms7l2Btdui5sc4Jld1386KMl8eXqwVLWHa3mcDGU9gVnkPpJFTj
         Izs78rfO/132IXKvvdxXM6q2sGzzK8C4qplKWoyjjEBqZTXx5U65kiHhnthWtHt4/u
         DaIMtuRdoK47dXdqtowtlF933bKU8EQKRJ8aEGso=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.8 092/101] ASoC: SOF: Add topology filename override based on dmi data match
Date:   Sun, 18 Oct 2020 15:20:17 -0400
Message-Id: <20201018192026.4053674-92-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>

[ Upstream commit 5253a73d567dcd75e62834ff5f502ea9470e5722 ]

Add topology filename override based on system DMI data matching,
typically to account for a different hardware layout.

In ACPI based systems, the tplg_filename is pre-defined in an ACPI
machine table. When a DMI quirk is detected, the
sof_pdata->tplg_filename is not set with the hard-coded ACPI value,
and instead is set with the DMI-specific filename.

Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200821195603.215535-14-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c   |  8 +++++++-
 sound/soc/sof/sof-pci-dev.c | 24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 63ca920c8e6e0..7152e6d1cf673 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1179,7 +1179,13 @@ void hda_machine_select(struct snd_sof_dev *sdev)
 
 	mach = snd_soc_acpi_find_machine(desc->machines);
 	if (mach) {
-		sof_pdata->tplg_filename = mach->sof_tplg_filename;
+		/*
+		 * If tplg file name is overridden, use it instead of
+		 * the one set in mach table
+		 */
+		if (!sof_pdata->tplg_filename)
+			sof_pdata->tplg_filename = mach->sof_tplg_filename;
+
 		sof_pdata->machine = mach;
 
 		if (mach->link_mask) {
diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index aa3532ba14349..f3a8140773db5 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -35,8 +35,28 @@ static int sof_pci_debug;
 module_param_named(sof_pci_debug, sof_pci_debug, int, 0444);
 MODULE_PARM_DESC(sof_pci_debug, "SOF PCI debug options (0x0 all off)");
 
+static const char *sof_override_tplg_name;
+
 #define SOF_PCI_DISABLE_PM_RUNTIME BIT(0)
 
+static int sof_tplg_cb(const struct dmi_system_id *id)
+{
+	sof_override_tplg_name = id->driver_data;
+	return 1;
+}
+
+static const struct dmi_system_id sof_tplg_table[] = {
+	{
+		.callback = sof_tplg_cb,
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google_Volteer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Terrador"),
+		},
+		.driver_data = "sof-tgl-rt5682-ssp0-max98373-ssp2.tplg",
+	},
+	{}
+};
+
 static const struct dmi_system_id community_key_platforms[] = {
 	{
 		.ident = "Up Squared",
@@ -347,6 +367,10 @@ static int sof_pci_probe(struct pci_dev *pci,
 		sof_pdata->tplg_filename_prefix =
 			sof_pdata->desc->default_tplg_path;
 
+	dmi_check_system(sof_tplg_table);
+	if (sof_override_tplg_name)
+		sof_pdata->tplg_filename = sof_override_tplg_name;
+
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE)
 	/* set callback to enable runtime_pm */
 	sof_pdata->sof_probe_complete = sof_pci_probe_complete;
-- 
2.25.1

