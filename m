Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155C33368C5
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 01:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhCKAfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 19:35:37 -0500
Received: from mga06.intel.com ([134.134.136.31]:62399 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhCKAf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 19:35:26 -0500
IronPort-SDR: i/Y1sUu9ttCH9AfXZ574PPLykQDv0nXcPbcC7itQDTcNr+IVGoYOQnn/96tMsjzcA2yrXZLXa7
 DPHl9kweU1Ew==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="249957221"
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="249957221"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 16:35:25 -0800
IronPort-SDR: sYLPrL7yZckuxKhDQANKqVHa4zpwtNKVbsbtKwHrNkQUQGsUVNn5zqdHYGKqFtg9lSMLX1E+qc
 yZAqzUD+z0tw==
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="520919936"
Received: from theer-mobl2.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.212.101.109])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 16:35:24 -0800
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 1/2] ASoC: samsung: tm2_wm5110: check of of_parse return value
Date:   Wed, 10 Mar 2021 18:35:15 -0600
Message-Id: <20210311003516.120003-2-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311003516.120003-1-pierre-louis.bossart@linux.intel.com>
References: <20210311003516.120003-1-pierre-louis.bossart@linux.intel.com>
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

There's no need to check for args.np because args.np won't be
initialized on errors.

Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2board")
Cc: <stable@vger.kernel.org>
Suggested-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
---
 sound/soc/samsung/tm2_wm5110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/tm2_wm5110.c b/sound/soc/samsung/tm2_wm5110.c
index 9300fef9bf26..125e07f65d2b 100644
--- a/sound/soc/samsung/tm2_wm5110.c
+++ b/sound/soc/samsung/tm2_wm5110.c
@@ -553,7 +553,7 @@ static int tm2_probe(struct platform_device *pdev)
 
 		ret = of_parse_phandle_with_args(dev->of_node, "i2s-controller",
 						 cells_name, i, &args);
-		if (!args.np) {
+		if (ret) {
 			dev_err(dev, "i2s-controller property parse error: %d\n", i);
 			ret = -EINVAL;
 			goto dai_node_put;
-- 
2.25.1

