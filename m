Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0632C78E8
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 12:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgK2Lod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 06:44:33 -0500
Received: from mga07.intel.com ([134.134.136.100]:8057 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgK2Lod (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Nov 2020 06:44:33 -0500
IronPort-SDR: sai9ie8D2pttEhklg8mHPbJQJ8pJYk/sk+CpuRrJrNTV/Fq9vi85OnNCEzuUBKk/9zhMIHhylk
 iFqfTkj2hVwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9819"; a="236654211"
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="236654211"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2020 03:43:12 -0800
IronPort-SDR: UTqLxCcKQjJf0OjHSzZEOo4sFVs3Ra0eGlQ+wvvPkSSnH2HSOKT5PqlNILnA6cBC0giRSdb+Pb
 +xdXcCFFZ9Fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="480261645"
Received: from crojewsk-ctrl.igk.intel.com ([10.102.9.28])
  by orsmga004.jf.intel.com with ESMTP; 29 Nov 2020 03:43:10 -0800
From:   Cezary Rojewski <cezary.rojewski@intel.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com,
        mateusz.gorski@linux.intel.com,
        Cezary Rojewski <cezary.rojewski@intel.com>
Subject: [PATCH 4/8] ASoC: Intel: Skylake: Shield against no-NHLT configurations
Date:   Sun, 29 Nov 2020 12:41:44 +0100
Message-Id: <20201129114148.13772-5-cezary.rojewski@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201129114148.13772-1-cezary.rojewski@intel.com>
References: <20201129114148.13772-1-cezary.rojewski@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9e6c382f5a6161eb55115fb56614b9827f2e7da3 upstream.

Some configurations expose no NHLT table at all within their
/sys/firmware/acpi/tables. To prevent NULL-dereference errors from
occurring, adjust probe flow and append additional safety checks in
functions involved in NHLT lifecycle.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200305145314.32579-5-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
---
 sound/soc/intel/skylake/skl-nhlt.c | 3 ++-
 sound/soc/intel/skylake/skl.c      | 9 +++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-nhlt.c b/sound/soc/intel/skylake/skl-nhlt.c
index 19f328d71f24..d9c8f5cb389e 100644
--- a/sound/soc/intel/skylake/skl-nhlt.c
+++ b/sound/soc/intel/skylake/skl-nhlt.c
@@ -182,7 +182,8 @@ void skl_nhlt_remove_sysfs(struct skl_dev *skl)
 {
 	struct device *dev = &skl->pci->dev;
 
-	sysfs_remove_file(&dev->kobj, &dev_attr_platform_id.attr);
+	if (skl->nhlt)
+		sysfs_remove_file(&dev->kobj, &dev_attr_platform_id.attr);
 }
 
 /*
diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index 1a3a3d6a3141..2e5fbd220923 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -632,6 +632,9 @@ static int skl_clock_device_register(struct skl_dev *skl)
 	struct platform_device_info pdevinfo = {NULL};
 	struct skl_clk_pdata *clk_pdata;
 
+	if (!skl->nhlt)
+		return 0;
+
 	clk_pdata = devm_kzalloc(&skl->pci->dev, sizeof(*clk_pdata),
 							GFP_KERNEL);
 	if (!clk_pdata)
@@ -1090,7 +1093,8 @@ static int skl_probe(struct pci_dev *pci,
 out_clk_free:
 	skl_clock_device_unregister(skl);
 out_nhlt_free:
-	intel_nhlt_free(skl->nhlt);
+	if (skl->nhlt)
+		intel_nhlt_free(skl->nhlt);
 out_free:
 	skl_free(bus);
 
@@ -1139,7 +1143,8 @@ static void skl_remove(struct pci_dev *pci)
 	skl_dmic_device_unregister(skl);
 	skl_clock_device_unregister(skl);
 	skl_nhlt_remove_sysfs(skl);
-	intel_nhlt_free(skl->nhlt);
+	if (skl->nhlt)
+		intel_nhlt_free(skl->nhlt);
 	skl_free(bus);
 	dev_set_drvdata(&pci->dev, NULL);
 }
-- 
2.17.1

