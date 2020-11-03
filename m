Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA542A4776
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgKCOKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:10:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:30605 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729420AbgKCOKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 09:10:44 -0500
IronPort-SDR: QmN8ODtTQpfUF+S60lFBbSF8uqmuDNPhR6L5xd4tv8g3ZWy4xNJBPzFHX7U4lGk4w8pH9peu+x
 pXYfEt93NIBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="169188549"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="169188549"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 06:10:42 -0800
IronPort-SDR: DEX41euAnkeSL9SsYWN8Zce+RWVd0TZ5gp13rj38px2ouN2Yq7jnhiRelUXZybFR1O5MbNN+Z9
 TmiXObdr/ZBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="336530104"
Received: from mgorski-all-series.igk.intel.com ([10.237.149.201])
  by orsmga002.jf.intel.com with ESMTP; 03 Nov 2020 06:10:41 -0800
From:   Mateusz Gorski <mateusz.gorski@linux.intel.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alsa-devel@alsa-project.org, cezary.rojewski@intel.com,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] ASoC: Intel: Skylake: Add alternative topology binary name
Date:   Tue,  3 Nov 2020 15:10:47 +0100
Message-Id: <20201103141047.15053-1-mateusz.gorski@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1b290ef023b3eeb4f4688b582fecb773915ef937 ]

Add alternative topology binary file name based on used machine driver
and fallback to use this name after failed attempt to load topology file
with name based on NHLT.
This change addresses multiple issues with current mechanism, for
example - there are devices without NHLT table, and that currently
results in tplg_name being empty.

Signed-off-by: Mateusz Gorski <mateusz.gorski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200427132727.24942-2-mateusz.gorski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---

This functionality is merged on upstream kernel and widely used. Merging
it to LTS kernel would improve the user experience and resolve some of the
problems regarding topology naming that the users are facing.

 sound/soc/intel/skylake/skl-topology.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index 69cd7a81bf2a..4b114ece58c6 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -14,6 +14,7 @@
 #include <linux/uuid.h>
 #include <sound/intel-nhlt.h>
 #include <sound/soc.h>
+#include <sound/soc-acpi.h>
 #include <sound/soc-topology.h>
 #include <uapi/sound/snd_sst_tokens.h>
 #include <uapi/sound/skl-tplg-interface.h>
@@ -3565,8 +3566,20 @@ int skl_tplg_init(struct snd_soc_component *component, struct hdac_bus *bus)
 
 	ret = request_firmware(&fw, skl->tplg_name, bus->dev);
 	if (ret < 0) {
-		dev_info(bus->dev, "tplg fw %s load failed with %d, falling back to dfw_sst.bin",
-				skl->tplg_name, ret);
+		char alt_tplg_name[64];
+
+		snprintf(alt_tplg_name, sizeof(alt_tplg_name), "%s-tplg.bin",
+			 skl->mach->drv_name);
+		dev_info(bus->dev, "tplg fw %s load failed with %d, trying alternative tplg name %s",
+			 skl->tplg_name, ret, alt_tplg_name);
+
+		ret = request_firmware(&fw, alt_tplg_name, bus->dev);
+		if (!ret)
+			goto component_load;
+
+		dev_info(bus->dev, "tplg %s failed with %d, falling back to dfw_sst.bin",
+			 alt_tplg_name, ret);
+
 		ret = request_firmware(&fw, "dfw_sst.bin", bus->dev);
 		if (ret < 0) {
 			dev_err(bus->dev, "Fallback tplg fw %s load failed with %d\n",
@@ -3575,6 +3588,8 @@ int skl_tplg_init(struct snd_soc_component *component, struct hdac_bus *bus)
 		}
 	}
 
+component_load:
+
 	/*
 	 * The complete tplg for SKL is loaded as index 0, we don't use
 	 * any other index
-- 
2.17.1

