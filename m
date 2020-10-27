Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD9829B5F1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796397AbgJ0PSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796351AbgJ0PRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:17:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F79D2064B;
        Tue, 27 Oct 2020 15:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811857;
        bh=P53ED4BShvDlilS5vert2xbkgwQD01dU3Jv7kDeWyIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNP//BiFagG3QLLNn6ZOLgLBGfVRgR/OVfw/9MwgT98FBq3JuyQmfHeEkywVorAdI
         NT2RxFfbSqsIJN15zQQjBDLr0dCPOxW8VGwFjsJhHmCIu2wpRDXE9uc4cKa4T4z+SV
         dmXw2O3yRYpDWalpsZ6ha0TQgEsq8UjVi1S1HkqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 614/633] ASoC: SOF: Add topology filename override based on dmi data match
Date:   Tue, 27 Oct 2020 14:55:57 +0100
Message-Id: <20201027135551.630275536@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



