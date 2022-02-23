Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825164C0836
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbiBWCbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbiBWCaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:30:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45E358387;
        Tue, 22 Feb 2022 18:29:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64CA0B81E01;
        Wed, 23 Feb 2022 02:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBFEC36AE5;
        Wed, 23 Feb 2022 02:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583380;
        bh=wZH01uOAO4UsGv9C+T2IqqCCfADRCqC0wjWMBt/crTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1yH16t/wVIxlV/73ovByglOcgNu0kXBIhy+TLWXhOGcWH5zP9dyKERxcUaEhLH53
         w+Pw4qnxh2Sre5D+cx7PJ9A26ReIuYplWd6QeBBq4iT2k/YDMgrXvfhLpNpXOVYlUL
         ZJwSCRIqnD+OSQ+D4Iqcs6hM8euqCkl0TZNluvtAB1HHxjw89ekydzr/FZfe2hEB/6
         L299CMSTXSfGdk/zIUswT5DMGT84fZQqmoKq+RI+bDptbWu5F+5kMJdEdlsY+SVZIi
         mOhrWPe4pyIUS0ZBmxLbF+Ezn2xnjiDpQUwOMxzLUxiyHIL+PQewFDkjIF7TvsX3VQ
         vg7UcBwt7xuxg==
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
Subject: [PATCH AUTOSEL 5.15 04/28] ASoC: rt5668: do not block workqueue if card is unbound
Date:   Tue, 22 Feb 2022 21:29:05 -0500
Message-Id: <20220223022929.241127-4-sashal@kernel.org>
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

[ Upstream commit a6d78661dc903d90a327892bbc34268f3a5f4b9c ]

The current rt5668_jack_detect_handler() assumes the component
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
Link: https://lore.kernel.org/r/20220207153000.3452802-2-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5668.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/rt5668.c b/sound/soc/codecs/rt5668.c
index 6ab1a8bc37352..1186ceb5a978e 100644
--- a/sound/soc/codecs/rt5668.c
+++ b/sound/soc/codecs/rt5668.c
@@ -1022,11 +1022,13 @@ static void rt5668_jack_detect_handler(struct work_struct *work)
 		container_of(work, struct rt5668_priv, jack_detect_work.work);
 	int val, btn_type;
 
-	while (!rt5668->component)
-		usleep_range(10000, 15000);
-
-	while (!rt5668->component->card->instantiated)
-		usleep_range(10000, 15000);
+	if (!rt5668->component || !rt5668->component->card ||
+	    !rt5668->component->card->instantiated) {
+		/* card not yet ready, try later */
+		mod_delayed_work(system_power_efficient_wq,
+				 &rt5668->jack_detect_work, msecs_to_jiffies(15));
+		return;
+	}
 
 	mutex_lock(&rt5668->calibrate_mutex);
 
-- 
2.34.1

