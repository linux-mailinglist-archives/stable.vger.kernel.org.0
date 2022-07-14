Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240DC57424D
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiGNEXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiGNEWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:22:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C1B27CDE;
        Wed, 13 Jul 2022 21:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75890B82373;
        Thu, 14 Jul 2022 04:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD409C341CF;
        Thu, 14 Jul 2022 04:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772558;
        bh=/yLYH+geq49XNoPjucPvvOS5nstF1WxYkuZ8Nv55o/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMz+4A+tdHtqXjB51ndYNqaoxrg06wvBDdMRg+V/Vcv9MFO8SYGf2Ziug5CvCeFzi
         BPcxQPpK8tAcxJ45FZCFUEAUimx9yL+7HcFZAjKXnib3sz5X27NmzU9kEqAgHivAbB
         jONhtcmLih92YuyWR3lIE7wCkosIXHRJbxQnW2/YHN6gWwR75wSNgoeHKAETMh3RUX
         0GNXSwPqMtEwL/JEf3a1YgatK4uJCPaxIk/1dWQAv8WLiG85Bf2RJ9zfLphtfE+eh4
         Cp5imureJbgxIhe5WGKnOS43/a+hRg1xOJFyjQznwl5+/PXKy5nt0I5dD2DxUI5Odu
         J+TKjVjYcl9MA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 06/41] ASoC: rt711: fix calibrate mutex initialization
Date:   Thu, 14 Jul 2022 00:21:46 -0400
Message-Id: <20220714042221.281187-6-sashal@kernel.org>
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

[ Upstream commit 08bb5dc6ce02374169213cea772b1c297eaf32d5 ]

Follow the same flow as rt711-sdca and initialize all mutexes at probe
time.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220606203752.144159-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdw.c | 3 +++
 sound/soc/codecs/rt711.c     | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt711-sdw.c b/sound/soc/codecs/rt711-sdw.c
index f49c94baa37c..4fe68bcf2a7c 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -474,6 +474,9 @@ static int rt711_sdw_remove(struct sdw_slave *slave)
 	if (rt711->first_hw_init)
 		pm_runtime_disable(&slave->dev);
 
+	mutex_destroy(&rt711->calibrate_mutex);
+	mutex_destroy(&rt711->disable_irq_lock);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index ea25fd58d43a..39f7ded1371e 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -1203,6 +1203,7 @@ int rt711_init(struct device *dev, struct regmap *sdw_regmap,
 	rt711->sdw_regmap = sdw_regmap;
 	rt711->regmap = regmap;
 
+	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
 	/*
@@ -1317,7 +1318,6 @@ int rt711_io_init(struct device *dev, struct sdw_slave *slave)
 			rt711_jack_detect_handler);
 		INIT_DELAYED_WORK(&rt711->jack_btn_check_work,
 			rt711_btn_check_handler);
-		mutex_init(&rt711->calibrate_mutex);
 		INIT_WORK(&rt711->calibration_work, rt711_calibration_work);
 		schedule_work(&rt711->calibration_work);
 	}
-- 
2.35.1

