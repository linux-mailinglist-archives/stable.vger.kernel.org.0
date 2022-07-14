Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52FB574240
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbiGNEWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiGNEWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F60227B09;
        Wed, 13 Jul 2022 21:22:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 283BDB82371;
        Thu, 14 Jul 2022 04:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D2DC3411C;
        Thu, 14 Jul 2022 04:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772552;
        bh=OEWXMHSWT917Fw8am9Qo09APHrxq7qb4VM0bIGWLQDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yz6D4Vuo6e9S5MQV76mBB9aZvlReYUTpI3Z2JjzxnAf4EJ58iFTDJmXXPcCCAF1DI
         UuB2tayb3iKpcI+9uG/OuqxMhu6VS5emcZ8kvU3AKOJBdBUmJ2Cee5AEweqSFm5bwZ
         5eapCExm1/lObZhpc6c50RmIxVlKAMZhkgRaPeItp1rMbzmMP51cal36XN0rZ8BsRi
         ij8g3HVbz0acl3pfS5o4s/jTKZZ9krAYwar1EX8gh9mX2SUOJL1UcyULq/vVSBvK7n
         m+W2YgMv5Zi4FXQH3F4fVv2PP0DgZWyZivzeEfkqmeBrCCVBxtWGUtrqA4dNebUXN7
         uAogRU4mCHWwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 04/41] ASoC: rt711-sdca-sdw: fix calibrate mutex initialization
Date:   Thu, 14 Jul 2022 00:21:44 -0400
Message-Id: <20220714042221.281187-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
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
index bdb1375f0338..e5a0ec984bdd 100644
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

