Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A026D57430C
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiGNE3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235691AbiGNE2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:28:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1267D3138B;
        Wed, 13 Jul 2022 21:24:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FF0D61EBA;
        Thu, 14 Jul 2022 04:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B4BC36AE5;
        Thu, 14 Jul 2022 04:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772684;
        bh=U/U+/pbPd0nXOgKMQT8FyspifEtcz4QPkhnCcVQdsHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CY7rPlEdxKg7AeBElAHaJc/lD9GZOkfhcpSXL0Jz+AilH6zz0QCau9dBzod1oruuS
         c3vmXiERFgPaMTrsofWuVLNY7w5tNR4ZERCSLzkN6nNVwv8Vm5pdIrq+hKLlkFuAZc
         bp8ahHAJmp19WpmU6Ip7Et7jUr0Rs9RZ0mhAw8kIBdj63BRJusaLUCXr1hkND6EMZg
         nXqC8fAM2+9OWNM17MEfK+UrRfew8K6d5LYZwXmw/2KwfrqqA4W5osPq+bokyOLEiN
         MIE6gaieg0uGFcan/OzJUd9fd0X3ZaiOJNZhHMPKajs32Kgtlv/NnSj7F4rnfNu8Si
         W1BseezvAnl0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 06/28] ASoC: rt711: fix calibrate mutex initialization
Date:   Thu, 14 Jul 2022 00:24:07 -0400
Message-Id: <20220714042429.281816-6-sashal@kernel.org>
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
index a7c5608a0ef8..6f3a26bf53d0 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -1196,6 +1196,7 @@ int rt711_init(struct device *dev, struct regmap *sdw_regmap,
 	rt711->sdw_regmap = sdw_regmap;
 	rt711->regmap = regmap;
 
+	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
 	/*
@@ -1310,7 +1311,6 @@ int rt711_io_init(struct device *dev, struct sdw_slave *slave)
 			rt711_jack_detect_handler);
 		INIT_DELAYED_WORK(&rt711->jack_btn_check_work,
 			rt711_btn_check_handler);
-		mutex_init(&rt711->calibrate_mutex);
 		INIT_WORK(&rt711->calibration_work, rt711_calibration_work);
 		schedule_work(&rt711->calibration_work);
 	}
-- 
2.35.1

