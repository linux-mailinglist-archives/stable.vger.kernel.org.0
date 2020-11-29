Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB742C78E5
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 12:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgK2Lo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 06:44:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:8115 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727517AbgK2Lo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Nov 2020 06:44:26 -0500
IronPort-SDR: pWxYXbTZpOdiE8gJohq2P0nALiNcl+9kziI80Ot9WTKkx9XmhQI+kL6Cth55EUPiy7/0M8TY4k
 gzxUcqJ0ouZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9819"; a="236654210"
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="236654210"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2020 03:43:10 -0800
IronPort-SDR: cpjO0/NBIZu5CdhR6eFa4YtgRAEv6JePLDo0TDzdw84P+IxoFXDfEkd7H9nA+K/fYOxySF3a8u
 7rX/O/MhDnZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,379,1599548400"; 
   d="scan'208";a="480261633"
Received: from crojewsk-ctrl.igk.intel.com ([10.102.9.28])
  by orsmga004.jf.intel.com with ESMTP; 29 Nov 2020 03:43:08 -0800
From:   Cezary Rojewski <cezary.rojewski@intel.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com,
        mateusz.gorski@linux.intel.com,
        Cezary Rojewski <cezary.rojewski@intel.com>
Subject: [PATCH 3/8] ASoC: Intel: Skylake: Enable codec wakeup during chip init
Date:   Sun, 29 Nov 2020 12:41:43 +0100
Message-Id: <20201129114148.13772-4-cezary.rojewski@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201129114148.13772-1-cezary.rojewski@intel.com>
References: <20201129114148.13772-1-cezary.rojewski@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e603f11d5df8997d104ab405ff27640b90baffaa upstream.

Follow the recommendation set by hda_intel.c and enable HDMI/DP codec
wakeup during bus initialization procedure. Disable wakeup once init
completes.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200305145314.32579-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
---
 sound/soc/intel/skylake/skl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index f46b90ccb46f..1a3a3d6a3141 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -129,6 +129,7 @@ static int skl_init_chip(struct hdac_bus *bus, bool full_reset)
 	struct hdac_ext_link *hlink;
 	int ret;
 
+	snd_hdac_set_codec_wakeup(bus, true);
 	skl_enable_miscbdcge(bus->dev, false);
 	ret = snd_hdac_bus_init_chip(bus, full_reset);
 
@@ -137,6 +138,7 @@ static int skl_init_chip(struct hdac_bus *bus, bool full_reset)
 		writel(0, hlink->ml_addr + AZX_REG_ML_LOSIDV);
 
 	skl_enable_miscbdcge(bus->dev, true);
+	snd_hdac_set_codec_wakeup(bus, false);
 
 	return ret;
 }
-- 
2.17.1

