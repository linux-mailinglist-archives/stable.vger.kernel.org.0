Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9C12B8FF
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfL0R7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbfL0RlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65F33218AC;
        Fri, 27 Dec 2019 17:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468465;
        bh=2P31o+i19MKW4LG7ZVHR1A/vWkwuUJ4vwO0Z0lD+UXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwsD5+Sh7xfm2MTn24EVuU/Z68+Q1CG705FzesrSrXiOObq4ev9S8Wo3hi6Xa30Uo
         6SXmMRO07+jSh83hkqcSiqvSGYyGM5L8nXbHJO8VseoULxWVGDHOGg245xrg6COPVA
         oNl0vnxpSp4QtAgBebAXEO5PM1qcc1plA1xO75kQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 007/187] ASoC: max98090: fix possible race conditions
Date:   Fri, 27 Dec 2019 12:37:55 -0500
Message-Id: <20191227174055.4923-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 45dfbf56975994822cce00b7475732a49f8aefed ]

max98090_interrupt() and max98090_pll_work() run in 2 different threads.
There are 2 possible races:

Note: M98090_REG_DEVICE_STATUS = 0x01.
Note: ULK == 0, PLL is locked; ULK == 1, PLL is unlocked.

max98090_interrupt      max98090_pll_work
----------------------------------------------
schedule max98090_pll_work
                        restart max98090 codec
receive ULK INT
                        assert ULK == 0
schedule max98090_pll_work (1).

In the case (1), the PLL is locked but max98090_interrupt unnecessarily
schedules another max98090_pll_work.

max98090_interrupt      max98090_pll_work      max98090 codec
----------------------------------------------------------------------
                                               ULK = 1
receive ULK INT
read 0x01
                                               ULK = 0 (clear on read)
schedule max98090_pll_work
                        restart max98090 codec
                                               ULK = 1
receive ULK INT
read 0x01
                                               ULK = 0 (clear on read)
                        read 0x01
                        assert ULK == 0 (2).

In the case (2), both max98090_interrupt and max98090_pll_work read
the same clear-on-read register.  max98090_pll_work would falsely
thought PLL is locked.
Note: the case (2) race is introduced by the previous commit ("ASoC:
max98090: exit workaround earlier if PLL is locked") to check the status
and exit the loop earlier in max98090_pll_work.

There are 2 possible solution options:
A. turn off ULK interrupt before scheduling max98090_pll_work; and turn
on again before exiting max98090_pll_work.
B. remove the second thread of execution.

Option A cannot fix the case (2) race because it still has 2 threads
access the same clear-on-read register simultaneously.  Although we
could suppose the register is volatile and read the status via I2C could
be much slower than the hardware raises the bits.

Option B introduces a maximum 10~12 msec penalty delay in the interrupt
handler.  However, it could only punish the jack detection by extra
10~12 msec.

Adopts option B which is the better solution overall.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20191122073114.219945-4-tzungbi@google.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 8 ++------
 sound/soc/codecs/max98090.h | 1 -
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index f531e5a11bdd..e46b6ada13b1 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2103,10 +2103,8 @@ static void max98090_pll_det_disable_work(struct work_struct *work)
 			    M98090_IULK_MASK, 0);
 }
 
-static void max98090_pll_work(struct work_struct *work)
+static void max98090_pll_work(struct max98090_priv *max98090)
 {
-	struct max98090_priv *max98090 =
-		container_of(work, struct max98090_priv, pll_work);
 	struct snd_soc_component *component = max98090->component;
 	unsigned int pll;
 	int i;
@@ -2275,7 +2273,7 @@ static irqreturn_t max98090_interrupt(int irq, void *data)
 
 	if (active & M98090_ULK_MASK) {
 		dev_dbg(component->dev, "M98090_ULK_MASK\n");
-		schedule_work(&max98090->pll_work);
+		max98090_pll_work(max98090);
 	}
 
 	if (active & M98090_JDET_MASK) {
@@ -2438,7 +2436,6 @@ static int max98090_probe(struct snd_soc_component *component)
 			  max98090_pll_det_enable_work);
 	INIT_WORK(&max98090->pll_det_disable_work,
 		  max98090_pll_det_disable_work);
-	INIT_WORK(&max98090->pll_work, max98090_pll_work);
 
 	/* Enable jack detection */
 	snd_soc_component_write(component, M98090_REG_JACK_DETECT,
@@ -2491,7 +2488,6 @@ static void max98090_remove(struct snd_soc_component *component)
 	cancel_delayed_work_sync(&max98090->jack_work);
 	cancel_delayed_work_sync(&max98090->pll_det_enable_work);
 	cancel_work_sync(&max98090->pll_det_disable_work);
-	cancel_work_sync(&max98090->pll_work);
 	max98090->component = NULL;
 }
 
diff --git a/sound/soc/codecs/max98090.h b/sound/soc/codecs/max98090.h
index 57965cd678b4..a197114b0dad 100644
--- a/sound/soc/codecs/max98090.h
+++ b/sound/soc/codecs/max98090.h
@@ -1530,7 +1530,6 @@ struct max98090_priv {
 	struct delayed_work jack_work;
 	struct delayed_work pll_det_enable_work;
 	struct work_struct pll_det_disable_work;
-	struct work_struct pll_work;
 	struct snd_soc_jack *jack;
 	unsigned int dai_fmt;
 	int tdm_slots;
-- 
2.20.1

