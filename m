Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B574C0835
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiBWCbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbiBWCao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:30:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6A753E22;
        Tue, 22 Feb 2022 18:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57D3AB81E0D;
        Wed, 23 Feb 2022 02:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC62C36AE2;
        Wed, 23 Feb 2022 02:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583382;
        bh=mqQlBlOzmeSF6kjm5/81gVYISa9Xaknvi26FPi+wghc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOWwDV57DJuhcSectMsEx8w8e1cBYZZHU/3nlyxKiwpZgNrxKKfUgcl/wQrBAaI4F
         a9onQJudcU/bETJWHTXtRkYXwt5uE7f1Z62/4ZhIgoQyaIgIfTMmVuGqcjb+oxxgsp
         +jc+2C0K72Xb4NBXGd3d3j6rNMljMyodMi9raIHNbYPG88RHVM7nl6aH8XvO+LAKQa
         uVwyeCVUJOspZVouY59dLu5TxQfJ4mxmcc8LpCcBlksP6G04FA5Q/CxXS2MD+wGOWJ
         Gcqp8QWhwzOJWVsR0rMaovKoHKXPeBBc6acQIazWBp3Nd99/mvzvTbjPxuEo+iLNc+
         IBOMMv3VHjfbw==
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
Subject: [PATCH AUTOSEL 5.15 05/28] ASoC: rt5682: do not block workqueue if card is unbound
Date:   Tue, 22 Feb 2022 21:29:06 -0500
Message-Id: <20220223022929.241127-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
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

[ Upstream commit 4c33de0673ced9c7c37b3bbd9bfe0fda72340b2a ]

The current rt5682_jack_detect_handler() assumes the component
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
Link: https://lore.kernel.org/r/20220207153000.3452802-3-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 757d1362b5f48..6ad3159eceb98 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -1090,11 +1090,13 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		container_of(work, struct rt5682_priv, jack_detect_work.work);
 	int val, btn_type;
 
-	while (!rt5682->component)
-		usleep_range(10000, 15000);
-
-	while (!rt5682->component->card->instantiated)
-		usleep_range(10000, 15000);
+	if (!rt5682->component || !rt5682->component->card ||
+	    !rt5682->component->card->instantiated) {
+		/* card not yet ready, try later */
+		mod_delayed_work(system_power_efficient_wq,
+				 &rt5682->jack_detect_work, msecs_to_jiffies(15));
+		return;
+	}
 
 	mutex_lock(&rt5682->calibrate_mutex);
 
-- 
2.34.1

