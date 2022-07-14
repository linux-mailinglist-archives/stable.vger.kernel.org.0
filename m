Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EC3574315
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiGNE3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbiGNE3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:29:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6585A28E36;
        Wed, 13 Jul 2022 21:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 019C361EB2;
        Thu, 14 Jul 2022 04:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC80C34114;
        Thu, 14 Jul 2022 04:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772688;
        bh=pKDMyWlO9kR+C6ViZ9yan6wE0QuZsKfeViglCg+/zgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyplbyV7ReUzSFLwNZuK1DhO16vsTzpWzh6DdqmKo5ow/tIO26WCD6Z4Lzl1tv5E9
         Aodi30sjLoK9QpfqLsayuMle0ZYMT79q8gzx9Vnly5PD2ptpMwXDjo3pOY6XtFLFcN
         ozVYQHZiuDJXqSq9FgXlBDHr/t7frftg0yv0q+SytGxaw6Vqa0t2Tp2Xy+VF2yrQDO
         o8bpj/mrohVVf9/w5WcBYMiEBxHPTdfmmlgidVebbxSAo7r1Px7PQUrmUkap4TuYNT
         x73rT3SgFmyyct0GL6ESURwm3luRV/BtfD8hrgVxWy3zZlYz3N5CZXFuOoF/iDWBe8
         zWXiztzTsfXhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 08/28] ASoC: codecs: rt700/rt711/rt711-sdca: initialize workqueues in probe
Date:   Thu, 14 Jul 2022 00:24:09 -0400
Message-Id: <20220714042429.281816-8-sashal@kernel.org>
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

[ Upstream commit ba98d7d8b60ba410aa03834f6aa48fd3b2e68478 ]

The workqueues are initialized in the io_init functions, which isn't
quite right. In some tests, this leads to warnings throw from
__queue_delayed_work()

WARN_ON_FUNCTION_MISMATCH(timer->function, delayed_work_timer_fn);

Move all the initializations to the probe functions.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220606203752.144159-7-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt700.c      | 12 +++++-------
 sound/soc/codecs/rt711-sdca.c | 10 +++-------
 sound/soc/codecs/rt711.c      | 12 +++++-------
 3 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/sound/soc/codecs/rt700.c b/sound/soc/codecs/rt700.c
index 0c7416a5eb50..5cf910e7940b 100644
--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -1114,6 +1114,11 @@ int rt700_init(struct device *dev, struct regmap *sdw_regmap,
 
 	mutex_init(&rt700->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt700->jack_detect_work,
+			  rt700_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt700->jack_btn_check_work,
+			  rt700_btn_check_handler);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1208,13 +1213,6 @@ int rt700_io_init(struct device *dev, struct sdw_slave *slave)
 	/* Finish Initial Settings, set power to D3 */
 	regmap_write(rt700->regmap, RT700_SET_AUDIO_POWER_STATE, AC_PWRST_D3);
 
-	if (!rt700->first_hw_init) {
-		INIT_DELAYED_WORK(&rt700->jack_detect_work,
-			rt700_jack_detect_handler);
-		INIT_DELAYED_WORK(&rt700->jack_btn_check_work,
-			rt700_btn_check_handler);
-	}
-
 	/*
 	 * if set_jack callback occurred early than io_init,
 	 * we set up the jack detection function now
diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index e77a3b5ad63b..9438fd264405 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -1414,6 +1414,9 @@ int rt711_sdca_init(struct device *dev, struct regmap *regmap,
 	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt711->jack_detect_work, rt711_sdca_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt711->jack_btn_check_work, rt711_sdca_btn_check_handler);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1545,13 +1548,6 @@ int rt711_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 	rt711_sdca_index_update_bits(rt711, RT711_VENDOR_HDA_CTL,
 		RT711_PUSH_BTN_INT_CTL0, 0x20, 0x00);
 
-	if (!rt711->first_hw_init) {
-		INIT_DELAYED_WORK(&rt711->jack_detect_work,
-			rt711_sdca_jack_detect_handler);
-		INIT_DELAYED_WORK(&rt711->jack_btn_check_work,
-			rt711_sdca_btn_check_handler);
-	}
-
 	/* calibration */
 	ret = rt711_sdca_calibration(rt711);
 	if (ret < 0)
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index eadcfb31b5e8..4c734e48073f 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -1199,6 +1199,10 @@ int rt711_init(struct device *dev, struct regmap *sdw_regmap,
 	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt711->jack_detect_work, rt711_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt711->jack_btn_check_work, rt711_btn_check_handler);
+	INIT_WORK(&rt711->calibration_work, rt711_calibration_work);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1306,14 +1310,8 @@ int rt711_io_init(struct device *dev, struct sdw_slave *slave)
 
 	if (rt711->first_hw_init)
 		rt711_calibration(rt711);
-	else {
-		INIT_DELAYED_WORK(&rt711->jack_detect_work,
-			rt711_jack_detect_handler);
-		INIT_DELAYED_WORK(&rt711->jack_btn_check_work,
-			rt711_btn_check_handler);
-		INIT_WORK(&rt711->calibration_work, rt711_calibration_work);
+	else
 		schedule_work(&rt711->calibration_work);
-	}
 
 	/*
 	 * if set_jack callback occurred early than io_init,
-- 
2.35.1

