Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB6F2C78DF
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 12:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgK2LoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 06:44:01 -0500
Received: from mga07.intel.com ([134.134.136.100]:8057 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgK2LoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Nov 2020 06:44:01 -0500
IronPort-SDR: xwPGzMMyA9/+8nezFdBf85qrZRucjNAKGHHUwk1NlsVstsOlHXbMik/VLWeTOAaMvMjyAu0mfX
 qF67PeFu9Jgw==
X-IronPort-AV: E=McAfee;i="6000,8403,9819"; a="236654205"
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="236654205"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2020 03:43:05 -0800
IronPort-SDR: paXFgLysSo5pE7WEpdqKGbFDFhV0WlXq1zvJOcKmi52JClyPEeKbnxYRN7n9wC/bdu85W7ovC+
 QSwGyFIWl3GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="480261595"
Received: from crojewsk-ctrl.igk.intel.com ([10.102.9.28])
  by orsmga004.jf.intel.com with ESMTP; 29 Nov 2020 03:43:03 -0800
From:   Cezary Rojewski <cezary.rojewski@intel.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com,
        mateusz.gorski@linux.intel.com,
        Cezary Rojewski <cezary.rojewski@intel.com>
Subject: [PATCH 1/8] ASoC: Intel: Skylake: Remove superfluous chip initialization
Date:   Sun, 29 Nov 2020 12:41:41 +0100
Message-Id: <20201129114148.13772-2-cezary.rojewski@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201129114148.13772-1-cezary.rojewski@intel.com>
References: <20201129114148.13772-1-cezary.rojewski@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2ef81057d80456870b97890dd79c8f56a85b1242 upstream.

Skylake driver does the controller init operation twice:
- first during probe (only to stop it just before scheduling probe_work)
- and during said probe_work where the actual correct sequence is
executed

To properly complete boot sequence when iDisp codec is present, bus
initialization has to be called only after _i915_init() finishes.
With additional _reset_list preceding _i915_init(), iDisp codec never
gets the chance to enumerate on the link. Remove the superfluous
initialization to address the issue.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200305145314.32579-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
---
 sound/soc/intel/skylake/skl.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index 141dbbf975ac..861c07417fed 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -807,6 +807,9 @@ static void skl_probe_work(struct work_struct *work)
 			return;
 	}
 
+	skl_init_pci(skl);
+	skl_dum_set(bus);
+
 	err = skl_init_chip(bus, true);
 	if (err < 0) {
 		dev_err(bus->dev, "Init chip failed with err: %d\n", err);
@@ -922,8 +925,6 @@ static int skl_first_init(struct hdac_bus *bus)
 		return -ENXIO;
 	}
 
-	snd_hdac_bus_reset_link(bus, true);
-
 	snd_hdac_bus_parse_capabilities(bus);
 
 	/* check if PPCAP exists */
@@ -971,11 +972,7 @@ static int skl_first_init(struct hdac_bus *bus)
 	if (err < 0)
 		return err;
 
-	/* initialize chip */
-	skl_init_pci(skl);
-	skl_dum_set(bus);
-
-	return skl_init_chip(bus, true);
+	return 0;
 }
 
 static int skl_probe(struct pci_dev *pci,
@@ -1080,8 +1077,6 @@ static int skl_probe(struct pci_dev *pci,
 	if (bus->mlcap)
 		snd_hdac_ext_bus_get_ml_capabilities(bus);
 
-	snd_hdac_bus_stop_chip(bus);
-
 	/* create device for soc dmic */
 	err = skl_dmic_device_register(skl);
 	if (err < 0) {
-- 
2.17.1

