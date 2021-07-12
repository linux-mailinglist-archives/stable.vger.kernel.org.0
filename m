Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E32A3C4A88
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbhGLGws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240074AbhGLGup (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9818F610CD;
        Mon, 12 Jul 2021 06:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072471;
        bh=CTyWB9QGIlHAP5vMGcvJDJzBqgMb6VV7ylxgstjsmxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvm8CbnC45PqT11M84lR6QTPBbAhGVU9a/VgMBjMj9VngUr1WHIy7SpzipLuDEyQw
         AQCrFUY7Poj850iw7o9t5bjkSRWncHZXNLQUqpz4xXImqJUc1TYJkxHT/mkYM/ZDuh
         WibgBMOOL1yoQqJw7my75rq3WTkJjMZgOv4qpbZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 507/593] ASoC: rt5682: fix getting the wrong device id when the suspend_stress_test
Date:   Mon, 12 Jul 2021 08:11:07 +0200
Message-Id: <20210712060947.566638948@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 867f8d18df4f5ccd6c2daf4441a6adeca0b9725b ]

This patch will be the workaround to fix getting the wrong device ID on the rare chance.
It seems like something unstable when the system resumes. e.g. the bus clock
This patch tries to read the device ID to check several times.
After the test, the driver will get the correct device ID the second time.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20210111092740.9128-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 848b79b5a130..5f8867e00923 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -375,18 +375,12 @@ static int rt5682_sdw_init(struct device *dev, struct regmap *regmap,
 static int rt5682_io_init(struct device *dev, struct sdw_slave *slave)
 {
 	struct rt5682_priv *rt5682 = dev_get_drvdata(dev);
-	int ret = 0;
+	int ret = 0, loop = 10;
 	unsigned int val;
 
 	if (rt5682->hw_init)
 		return 0;
 
-	regmap_read(rt5682->regmap, RT5682_DEVICE_ID, &val);
-	if (val != DEVICE_ID) {
-		dev_err(dev, "Device with ID register %x is not rt5682\n", val);
-		return -ENODEV;
-	}
-
 	/*
 	 * PM runtime is only enabled when a Slave reports as Attached
 	 */
@@ -406,6 +400,19 @@ static int rt5682_io_init(struct device *dev, struct sdw_slave *slave)
 
 	pm_runtime_get_noresume(&slave->dev);
 
+	while (loop > 0) {
+		regmap_read(rt5682->regmap, RT5682_DEVICE_ID, &val);
+		if (val == DEVICE_ID)
+			break;
+		dev_warn(dev, "Device with ID register %x is not rt5682\n", val);
+		usleep_range(30000, 30005);
+		loop--;
+	}
+	if (val != DEVICE_ID) {
+		dev_err(dev, "Device with ID register %x is not rt5682\n", val);
+		return -ENODEV;
+	}
+
 	if (rt5682->first_hw_init) {
 		regcache_cache_only(rt5682->regmap, false);
 		regcache_cache_bypass(rt5682->regmap, true);
-- 
2.30.2



