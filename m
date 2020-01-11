Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58E5137ECE
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgAKKOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:14:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbgAKKOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:14:01 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53C220673;
        Sat, 11 Jan 2020 10:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737640;
        bh=LaIgDCjYNZSyIf79BWzdHZ5zY5nUBnitqsEpNBejW4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGbx5TTB9sVxv/fmKxXWoa8wY+YhTPf2xGKxQW3wOGD7JM61RpStZmk+eHXVFTXlb
         D1ZMlkQEVxnVwpilR0b7WLGOpv5fGqLdhG5OYI6sR+x1l7a8Q36NSchKPr9gZbRWzq
         9R2tdVf9wdriVrc3jBTuSYNgB+X58eXwuZHguvK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzung-Bi Shih <tzungbi@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/84] ASoC: max98090: fix possible race conditions
Date:   Sat, 11 Jan 2020 10:49:42 +0100
Message-Id: <20200111094846.266421787@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c3b28b2f4b10..89b6e187ac23 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2121,10 +2121,8 @@ static void max98090_pll_det_disable_work(struct work_struct *work)
 			    M98090_IULK_MASK, 0);
 }
 
-static void max98090_pll_work(struct work_struct *work)
+static void max98090_pll_work(struct max98090_priv *max98090)
 {
-	struct max98090_priv *max98090 =
-		container_of(work, struct max98090_priv, pll_work);
 	struct snd_soc_component *component = max98090->component;
 
 	if (!snd_soc_component_is_active(component))
@@ -2277,7 +2275,7 @@ static irqreturn_t max98090_interrupt(int irq, void *data)
 
 	if (active & M98090_ULK_MASK) {
 		dev_dbg(component->dev, "M98090_ULK_MASK\n");
-		schedule_work(&max98090->pll_work);
+		max98090_pll_work(max98090);
 	}
 
 	if (active & M98090_JDET_MASK) {
@@ -2440,7 +2438,6 @@ static int max98090_probe(struct snd_soc_component *component)
 			  max98090_pll_det_enable_work);
 	INIT_WORK(&max98090->pll_det_disable_work,
 		  max98090_pll_det_disable_work);
-	INIT_WORK(&max98090->pll_work, max98090_pll_work);
 
 	/* Enable jack detection */
 	snd_soc_component_write(component, M98090_REG_JACK_DETECT,
@@ -2493,7 +2490,6 @@ static void max98090_remove(struct snd_soc_component *component)
 	cancel_delayed_work_sync(&max98090->jack_work);
 	cancel_delayed_work_sync(&max98090->pll_det_enable_work);
 	cancel_work_sync(&max98090->pll_det_disable_work);
-	cancel_work_sync(&max98090->pll_work);
 	max98090->component = NULL;
 }
 
diff --git a/sound/soc/codecs/max98090.h b/sound/soc/codecs/max98090.h
index b1572a2d19da..388d2f74674b 100644
--- a/sound/soc/codecs/max98090.h
+++ b/sound/soc/codecs/max98090.h
@@ -1533,7 +1533,6 @@ struct max98090_priv {
 	struct delayed_work jack_work;
 	struct delayed_work pll_det_enable_work;
 	struct work_struct pll_det_disable_work;
-	struct work_struct pll_work;
 	struct snd_soc_jack *jack;
 	unsigned int dai_fmt;
 	int tdm_slots;
-- 
2.20.1



