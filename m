Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DB0348FCA
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhCYL3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhCYL10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:27:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12B3A61A72;
        Thu, 25 Mar 2021 11:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671628;
        bh=hTaUs/AFJ1IfhtHqzUxdrQe0xhEMM47KW9UwRqj7Lo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNJOKsFVRtOsLcb0M8VoRg4ktxG8O4JC0GYPY7ftqXcJFl4QxygFPRlSCx9OfTj3i
         XKZk2kykhvZTDQ0u9yKmx7rce+3AUi6MrA2ZFoiWAucPula5La9LMApI10s0oyXbpE
         ZjrVRNubNoDbsEMVHNkDvT1h0IKEXWk39+2Nro6OYMoy/d17kUe4UCkOg4Ek3Z5mO4
         5i/GOhAvkMnM8a8vpuAjuAQ+XNmDBGzOhvgONzgblOPo+i06lcGswLkdvklejQSfxI
         ZAmdMO8hnTB5O6kxttOE1Bsv/w3uif1flvCfzPPMuyyrjAlFBrwV2hUBBIWFo13fx2
         vQlAt3kJxtlnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 13/24] ASoC: cs42l42: Always wait at least 3ms after reset
Date:   Thu, 25 Mar 2021 07:26:39 -0400
Message-Id: <20210325112651.1927828-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112651.1927828-1-sashal@kernel.org>
References: <20210325112651.1927828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Tanure <tanureal@opensource.cirrus.com>

[ Upstream commit 19325cfea04446bc79b36bffd4978af15f46a00e ]

This delay is part of the power-up sequence defined in the datasheet.
A runtime_resume is a power-up so must also include the delay.

Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210305173442.195740-6-tanureal@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 3 ++-
 sound/soc/codecs/cs42l42.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 95930018a1a4..dcd2acb2c3ce 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -1796,7 +1796,7 @@ static int cs42l42_i2c_probe(struct i2c_client *i2c_client,
 		dev_dbg(&i2c_client->dev, "Found reset GPIO\n");
 		gpiod_set_value_cansleep(cs42l42->reset_gpio, 1);
 	}
-	mdelay(3);
+	usleep_range(CS42L42_BOOT_TIME_US, CS42L42_BOOT_TIME_US * 2);
 
 	/* Request IRQ */
 	ret = devm_request_threaded_irq(&i2c_client->dev,
@@ -1921,6 +1921,7 @@ static int cs42l42_runtime_resume(struct device *dev)
 	}
 
 	gpiod_set_value_cansleep(cs42l42->reset_gpio, 1);
+	usleep_range(CS42L42_BOOT_TIME_US, CS42L42_BOOT_TIME_US * 2);
 
 	regcache_cache_only(cs42l42->regmap, false);
 	regcache_sync(cs42l42->regmap);
diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index 9b017b76828a..866d7c873e3c 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -740,6 +740,7 @@
 #define CS42L42_FRAC2_VAL(val)	(((val) & 0xff0000) >> 16)
 
 #define CS42L42_NUM_SUPPLIES	5
+#define CS42L42_BOOT_TIME_US	3000
 
 static const char *const cs42l42_supply_names[CS42L42_NUM_SUPPLIES] = {
 	"VA",
-- 
2.30.1

