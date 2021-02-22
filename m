Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE32532217F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBVVfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:35:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:15293 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230036AbhBVVfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 16:35:18 -0500
IronPort-SDR: zfBVFYEKuEtNwtd5E0krJUHDvKu55vtDVvz3pCQL91GHbYvFTZZRrR7EP75XlgB0DCx0TfAG1G
 7UmqFejq0MaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="204010614"
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="204010614"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 13:33:18 -0800
IronPort-SDR: 9pENbONdmUNgFfBiV9sgGlDe//X0vmsEgq8IEKI/mRC1sU20uqnrz+yC5vuubiYyaijLdiRIWb
 cjcPjb/KoOKg==
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="423270696"
Received: from sspurohi-mobl1.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.212.54.136])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 13:33:16 -0800
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/6] ASoC: samsung: tm2_wm5510: fix check of of_parse return value
Date:   Mon, 22 Feb 2021 15:33:01 -0600
Message-Id: <20210222213306.22654-2-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222213306.22654-1-pierre-louis.bossart@linux.intel.com>
References: <20210222213306.22654-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cppcheck warning:

sound/soc/samsung/tm2_wm5110.c:605:6: style: Variable 'ret' is
reassigned a value before the old one has been
used. [redundantAssignment]
 ret = devm_snd_soc_register_component(dev, &tm2_component,
     ^
sound/soc/samsung/tm2_wm5110.c:554:7: note: ret is assigned
  ret = of_parse_phandle_with_args(dev->of_node, "i2s-controller",
      ^
sound/soc/samsung/tm2_wm5110.c:605:6: note: ret is overwritten
 ret = devm_snd_soc_register_component(dev, &tm2_component,
     ^

The args is a stack variable, so it could have junk (uninitialized)
therefore args.np could have a non-NULL and random value even though
property was missing. Later could trigger invalid pointer dereference.

This patch provides the correct fix, there's no need to check for
args.np because args.np won't be initialized on errors.

Fixes: 75fa6833aef3 ("ASoC: samsung: tm2_wm5110: check of_parse return value")
Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2board")
Cc: <stable@vger.kernel.org>
Suggested-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
---
 sound/soc/samsung/tm2_wm5110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/tm2_wm5110.c b/sound/soc/samsung/tm2_wm5110.c
index da6204248f82..125e07f65d2b 100644
--- a/sound/soc/samsung/tm2_wm5110.c
+++ b/sound/soc/samsung/tm2_wm5110.c
@@ -553,7 +553,7 @@ static int tm2_probe(struct platform_device *pdev)
 
 		ret = of_parse_phandle_with_args(dev->of_node, "i2s-controller",
 						 cells_name, i, &args);
-		if (ret || !args.np) {
+		if (ret) {
 			dev_err(dev, "i2s-controller property parse error: %d\n", i);
 			ret = -EINVAL;
 			goto dai_node_put;
-- 
2.25.1

