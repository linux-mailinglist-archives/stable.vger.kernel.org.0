Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2606C579EE1
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbiGSNHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242960AbiGSNHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:07:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1155680F60;
        Tue, 19 Jul 2022 05:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66699B81B36;
        Tue, 19 Jul 2022 12:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9890BC36AE3;
        Tue, 19 Jul 2022 12:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233636;
        bh=VA4K+y68qUHY/W7GPWrViPQWc1eAbJLdB8OnYT08+T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDBlH+PQ65WYiNqfZd6k0afjxvu1Zxrk/crsTp4RhAnY+/NjKeyDwH6qVx3BqoKy+
         P5BrSDbLLcZoe+Gu71n4+oQbnQVErAFhExhOh6qziOW+fz2tyAyJK0L6v5T8nb7IIQ
         kpplJDrq0OYT4+fhE6Js1XnR7nZpsfbJ0Qcu7AFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 190/231] ASoC: codecs: rt700/rt711/rt711-sdca: initialize workqueues in probe
Date:   Tue, 19 Jul 2022 13:54:35 +0200
Message-Id: <20220719114730.152731875@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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
@@ -1209,6 +1209,10 @@ int rt711_init(struct device *dev, struc
 	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt711->jack_detect_work, rt711_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt711->jack_btn_check_work, rt711_btn_check_handler);
+	INIT_WORK(&rt711->calibration_work, rt711_calibration_work);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1316,14 +1320,8 @@ int rt711_io_init(struct device *dev, st
 
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


