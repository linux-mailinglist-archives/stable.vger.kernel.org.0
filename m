Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E713E579CD0
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241325AbiGSMnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbiGSMnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:43:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3248051F;
        Tue, 19 Jul 2022 05:16:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB07461835;
        Tue, 19 Jul 2022 12:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAAEC341C6;
        Tue, 19 Jul 2022 12:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232999;
        bh=xBPwjux9Bz7aWd1/UgILLOUdNPSQvAaFFU4PMe+ej7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x33v2dY3sYQ3yznBNoGNkYZYD+iQ2Td+paARRlPvSrOZhm0kXT8aFjjZFv9vcOqGM
         qL7l24v5b/1xJpO0BGvqJ2ZptcaUb6lzYWoO4ADNl/4YY9SheuEc1/Kablqp2Yaray
         RTcdKNf72Yw0W/IxzneE5g/egHH8EmmSIxL6pRgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/167] ASoC: codecs: rt700/rt711/rt711-sdca: initialize workqueues in probe
Date:   Tue, 19 Jul 2022 13:54:30 +0200
Message-Id: <20220719114709.860475784@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 sound/soc/codecs/rt700.c      |   12 +++++-------
 sound/soc/codecs/rt711-sdca.c |   10 +++-------
 sound/soc/codecs/rt711.c      |   12 +++++-------
 3 files changed, 13 insertions(+), 21 deletions(-)

--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -1124,6 +1124,11 @@ int rt700_init(struct device *dev, struc
 
 	mutex_init(&rt700->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt700->jack_detect_work,
+			  rt700_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt700->jack_btn_check_work,
+			  rt700_btn_check_handler);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1218,13 +1223,6 @@ int rt700_io_init(struct device *dev, st
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
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -1417,6 +1417,9 @@ int rt711_sdca_init(struct device *dev,
 	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt711->jack_detect_work, rt711_sdca_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt711->jack_btn_check_work, rt711_sdca_btn_check_handler);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1548,13 +1551,6 @@ int rt711_sdca_io_init(struct device *de
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
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -1202,6 +1202,10 @@ int rt711_init(struct device *dev, struc
 	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt711->jack_detect_work, rt711_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt711->jack_btn_check_work, rt711_btn_check_handler);
+	INIT_WORK(&rt711->calibration_work, rt711_calibration_work);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1309,14 +1313,8 @@ int rt711_io_init(struct device *dev, st
 
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


