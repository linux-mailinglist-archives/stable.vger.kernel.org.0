Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C86353D8D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbhDEJAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237125AbhDEJA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A220F6139C;
        Mon,  5 Apr 2021 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613222;
        bh=LRq+CcQWSfPDIdltEEUZePB2pmtJGylrqG811skKSxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0ux3Mx3r1ByTNFOU+px8MDdqfGe/hu+Li2zL+wRSR+ULr0NiprUqEIk9JcYYNIff
         vxnkL0CFW8dcCkB88Mx+Nbb8faOVHmpNdKxGk1Kahq+mkH9WqU6/0cdKPnxZFYwGyK
         CQGx9/TiNo3BIH8TVfSYfPkCCxT8eYKkW+Up98Uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/56] ASoC: cs42l42: Always wait at least 3ms after reset
Date:   Mon,  5 Apr 2021 10:53:44 +0200
Message-Id: <20210405085022.969931069@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a8ba518ba043..fddfd227a9c0 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -1800,7 +1800,7 @@ static int cs42l42_i2c_probe(struct i2c_client *i2c_client,
 		dev_dbg(&i2c_client->dev, "Found reset GPIO\n");
 		gpiod_set_value_cansleep(cs42l42->reset_gpio, 1);
 	}
-	mdelay(3);
+	usleep_range(CS42L42_BOOT_TIME_US, CS42L42_BOOT_TIME_US * 2);
 
 	/* Request IRQ */
 	ret = devm_request_threaded_irq(&i2c_client->dev,
@@ -1925,6 +1925,7 @@ static int cs42l42_runtime_resume(struct device *dev)
 	}
 
 	gpiod_set_value_cansleep(cs42l42->reset_gpio, 1);
+	usleep_range(CS42L42_BOOT_TIME_US, CS42L42_BOOT_TIME_US * 2);
 
 	regcache_cache_only(cs42l42->regmap, false);
 	regcache_sync(cs42l42->regmap);
diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index 23b1a63315ca..bcaf4f22408d 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -744,6 +744,7 @@
 #define CS42L42_FRAC2_VAL(val)	(((val) & 0xff0000) >> 16)
 
 #define CS42L42_NUM_SUPPLIES	5
+#define CS42L42_BOOT_TIME_US	3000
 
 static const char *const cs42l42_supply_names[CS42L42_NUM_SUPPLIES] = {
 	"VA",
-- 
2.30.1



