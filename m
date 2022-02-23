Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1E84C07DF
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbiBWC3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbiBWC3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:29:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5F93DDC6;
        Tue, 22 Feb 2022 18:28:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DA9DB81DD2;
        Wed, 23 Feb 2022 02:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FADC340F1;
        Wed, 23 Feb 2022 02:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583312;
        bh=fLqIYr3a11V/hiFrqChIvb88lZsImseqXDa0AusqyDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBh0M6yye3nGenRIogM5MzViqLCxzdrc2kAiBN7wzUXj9p/cyjREl5BX99uVJbUlq
         ZT6tO8GG/QDyxmI9ZsY6y9I7YmPzMTqhUGyDjs18so6zd2oTHsELXACI5unq5ZGdY3
         40tWngmJmIeuqrf4keoONM/bhlfl3X3NePNQ0soLN9HfrSM6HffbcUVR2o2vOSptgR
         atBcPVedzaz+8Agc1Ng3FLTAI7l8bbyRDkcnTyVItGxh/y9PO4PlIgv4oX2Wk5i8EF
         Nn+INTi1bcbnIAiaH+RNPTNRWYf0M9Ke5l29WfPjM1i50qr9dC7LCXMoIy22Ri1HoK
         CT90yGs9+8jkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 05/30] ASoC: rt5682s: do not block workqueue if card is unbound
Date:   Tue, 22 Feb 2022 21:27:54 -0500
Message-Id: <20220223022820.240649-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022820.240649-1-sashal@kernel.org>
References: <20220223022820.240649-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit d7b530fdc45e75a54914a194c4becd9672a4e24f ]

The current rt5682s_jack_detect_handler() assumes the component
and card will always show up and implements an infinite usleep
loop waiting for them to show up.

This does not hold true if a codec interrupt (or other
event) occurs when the card is unbound. The codec driver's
remove  or shutdown functions cannot cancel the workqueue due
to the wait loop. As a result, code can either end up blocking
the workqueue, or hit a kernel oops when the card is freed.

Fix the issue by rescheduling the jack detect handler in
case the card is not ready. In case card never shows up,
the shutdown/remove/suspend calls can now cancel the detect
task.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20220207153000.3452802-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682s.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index d49a4f68566d2..d79b548d23fa4 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -824,11 +824,13 @@ static void rt5682s_jack_detect_handler(struct work_struct *work)
 		container_of(work, struct rt5682s_priv, jack_detect_work.work);
 	int val, btn_type;
 
-	while (!rt5682s->component)
-		usleep_range(10000, 15000);
-
-	while (!rt5682s->component->card->instantiated)
-		usleep_range(10000, 15000);
+	if (!rt5682s->component || !rt5682s->component->card ||
+	    !rt5682s->component->card->instantiated) {
+		/* card not yet ready, try later */
+		mod_delayed_work(system_power_efficient_wq,
+				 &rt5682s->jack_detect_work, msecs_to_jiffies(15));
+		return;
+	}
 
 	mutex_lock(&rt5682s->jdet_mutex);
 	mutex_lock(&rt5682s->calibrate_mutex);
-- 
2.34.1

