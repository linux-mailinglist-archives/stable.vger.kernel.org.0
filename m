Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A384499803
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353768AbiAXVSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:18:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35842 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449591AbiAXVPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:15:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BC14B811F3;
        Mon, 24 Jan 2022 21:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0F8C340E4;
        Mon, 24 Jan 2022 21:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058948;
        bh=LSL6cfHhkID5SJXenbev0csahBF86XUuUbQBpDHN27Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQYCGszN5kZYqPj4TmjfZ+H78w4CmTY2q6GkzPayELFI/g+IPyJmINcBZDZvVt5e/
         mO1YFr5uHQOWBo+TTizW7Zc5KFIBUVfHkZdBU9n8Ha90KdR5ssvvBASYn6AOhBmfBH
         Xlh59cwAiBMdGxfcjAaPRUZ44zrKgDTgcKHTlfnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0455/1039] ASoC: cs42l42: Report initial jack state
Date:   Mon, 24 Jan 2022 19:37:24 +0100
Message-Id: <20220124184140.591589225@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit fdd535283779ec9f9c35fda352585c629121214f ]

When a jack handler is registered in cs42l42_set_jack() the
initial state should be reported if an attached headphone/headset
has already been detected.

The jack detect sequence takes around 1 second: typically long
enough for the machine driver to probe and register the jack handler
in time to receive the first report from the interrupt handler. So
it is possible on some systems that the correct initial state was seen
simply because of lucky timing. Modular builds were more likely to
miss the reporting of the initial state.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 4ca239f33737 ("ASoC: cs42l42: Always enable TS_PLUG and TS_UNPLUG interrupts")
Link: https://lore.kernel.org/r/20211119124854.58939-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 22 ++++++++++++++++++++++
 sound/soc/codecs/cs42l42.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 27a1c4c73074f..a63fba4e6c9c2 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -521,8 +521,25 @@ static int cs42l42_set_jack(struct snd_soc_component *component, struct snd_soc_
 {
 	struct cs42l42_private *cs42l42 = snd_soc_component_get_drvdata(component);
 
+	/* Prevent race with interrupt handler */
+	mutex_lock(&cs42l42->jack_detect_mutex);
 	cs42l42->jack = jk;
 
+	if (jk) {
+		switch (cs42l42->hs_type) {
+		case CS42L42_PLUG_CTIA:
+		case CS42L42_PLUG_OMTP:
+			snd_soc_jack_report(jk, SND_JACK_HEADSET, SND_JACK_HEADSET);
+			break;
+		case CS42L42_PLUG_HEADPHONE:
+			snd_soc_jack_report(jk, SND_JACK_HEADPHONE, SND_JACK_HEADPHONE);
+			break;
+		default:
+			break;
+		}
+	}
+	mutex_unlock(&cs42l42->jack_detect_mutex);
+
 	return 0;
 }
 
@@ -1611,6 +1628,8 @@ static irqreturn_t cs42l42_irq_thread(int irq, void *data)
 		CS42L42_M_DETECT_FT_MASK |
 		CS42L42_M_HSBIAS_HIZ_MASK);
 
+	mutex_lock(&cs42l42->jack_detect_mutex);
+
 	/* Check auto-detect status */
 	if ((~masks[5]) & irq_params_table[5].mask) {
 		if (stickies[5] & CS42L42_HSDET_AUTO_DONE_MASK) {
@@ -1689,6 +1708,8 @@ static irqreturn_t cs42l42_irq_thread(int irq, void *data)
 		}
 	}
 
+	mutex_unlock(&cs42l42->jack_detect_mutex);
+
 	return IRQ_HANDLED;
 }
 
@@ -2033,6 +2054,7 @@ static int cs42l42_i2c_probe(struct i2c_client *i2c_client,
 
 	cs42l42->dev = &i2c_client->dev;
 	i2c_set_clientdata(i2c_client, cs42l42);
+	mutex_init(&cs42l42->jack_detect_mutex);
 
 	cs42l42->regmap = devm_regmap_init_i2c(i2c_client, &cs42l42_regmap);
 	if (IS_ERR(cs42l42->regmap)) {
diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index f45bcc9a3a62f..02128ebf8989a 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -12,6 +12,7 @@
 #ifndef __CS42L42_H__
 #define __CS42L42_H__
 
+#include <linux/mutex.h>
 #include <sound/jack.h>
 
 #define CS42L42_PAGE_REGISTER	0x00	/* Page Select Register */
@@ -838,6 +839,7 @@ struct  cs42l42_private {
 	struct gpio_desc *reset_gpio;
 	struct completion pdn_done;
 	struct snd_soc_jack *jack;
+	struct mutex jack_detect_mutex;
 	int pll_config;
 	int bclk;
 	u32 sclk;
-- 
2.34.1



