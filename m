Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA874CF952
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbiCGKEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240500AbiCGKBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402B1BC8C;
        Mon,  7 Mar 2022 01:49:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE2826077B;
        Mon,  7 Mar 2022 09:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F87C340F5;
        Mon,  7 Mar 2022 09:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646558;
        bh=fLqIYr3a11V/hiFrqChIvb88lZsImseqXDa0AusqyDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ln6xOasMxWFKJpR2mY+WfWasRkWdDBsVa4+u6ZsCMCkjYb+8kL2JcuCmJnzcRHYV5
         xGl8Xs3k49XXcrdR5w9qMV/GGdpvmcdnXffAQ2710J5TeKQPo9cMBI7zycRwWvAOTs
         ndVFx55TM0cxFFF66PxY2QHLNKsAeHEaOz1HdCB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 004/186] ASoC: rt5682s: do not block workqueue if card is unbound
Date:   Mon,  7 Mar 2022 10:17:22 +0100
Message-Id: <20220307091654.219631402@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



