Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44718574303
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiGNE3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiGNE2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:28:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E36030F57;
        Wed, 13 Jul 2022 21:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0851661E1B;
        Thu, 14 Jul 2022 04:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36814C36AE3;
        Thu, 14 Jul 2022 04:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772679;
        bh=hrhyR0PquUIdfLfSQKpeMvCnSErNrBrDbTXMT4JsZmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHyFDctA9vgrTxoX/rnxYK77gNN2Vg3R1hKF40KLoWpYzA5d33CupyKRuSfWxwY2r
         3zVOqcphBvQnAnw4tPuLXAYl/3eG1H6//eOkhTWctAFLqZpk+jUimue0MP6Ld42oh6
         4r4f2Ob7/uWyAe7Cyh9VPaYZIR6f8stispTine9XMAvQ/HxY634+AfwiwtueuveYKG
         8I7tdpzJUweQWAYWFike0vKpiuIkEfmnM/+AtTR91IM9guu+oVke7E5UWJnICZZJKl
         79jWwkOnFnUAm7P2lnzqbMhcBEG7oDq60aGiVoB/BFkF3aK9dR6F20BTXN4rTy7IJk
         Ebr+6O4gTj8tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 04/28] ASoC: rt711-sdca-sdw: fix calibrate mutex initialization
Date:   Thu, 14 Jul 2022 00:24:05 -0400
Message-Id: <20220714042429.281816-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042429.281816-1-sashal@kernel.org>
References: <20220714042429.281816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit ed0a7fb29c9fd4f53eeb37d1fe2354df7a038047 ]

In codec driver bind/unbind test, the following warning is thrown:

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
...
[  699.182495]  rt711_sdca_jack_init+0x1b/0x1d0 [snd_soc_rt711_sdca]
[  699.182498]  rt711_sdca_set_jack_detect+0x3b/0x90 [snd_soc_rt711_sdca]
[  699.182500]  snd_soc_component_set_jack+0x24/0x50 [snd_soc_core]

A quick check in the code shows that the 'calibrate_mutex' used by
this driver are not initialized at probe time. Moving the
initialization to the probe removes the issue.

BugLink: https://github.com/thesofproject/linux/issues/3644
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220606203752.144159-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca-sdw.c | 3 +++
 sound/soc/codecs/rt711-sdca.c     | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index c722a2b0041f..a085b2f530aa 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -373,6 +373,9 @@ static int rt711_sdca_sdw_remove(struct sdw_slave *slave)
 	if (rt711->first_hw_init)
 		pm_runtime_disable(&slave->dev);
 
+	mutex_destroy(&rt711->calibrate_mutex);
+	mutex_destroy(&rt711->disable_irq_lock);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index 2e992589f1e4..f041e036b05f 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -1411,6 +1411,7 @@ int rt711_sdca_init(struct device *dev, struct regmap *regmap,
 	rt711->regmap = regmap;
 	rt711->mbq_regmap = mbq_regmap;
 
+	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
 	/*
@@ -1549,7 +1550,6 @@ int rt711_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 			rt711_sdca_jack_detect_handler);
 		INIT_DELAYED_WORK(&rt711->jack_btn_check_work,
 			rt711_sdca_btn_check_handler);
-		mutex_init(&rt711->calibrate_mutex);
 	}
 
 	/* calibration */
-- 
2.35.1

