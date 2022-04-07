Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C544F70C0
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbiDGBW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238670AbiDGBS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:18:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE2F199E07;
        Wed,  6 Apr 2022 18:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3888961DA8;
        Thu,  7 Apr 2022 01:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495A1C385A3;
        Thu,  7 Apr 2022 01:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294001;
        bh=o4q0gVs0gfviaTGGB5AnUBByDUtGawb79C5sVvmKWRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7sFwUUWUqGOFUWPYDrDiw0ylWYeSDTrw3+Q3UnnSJF0SrcnJqeUuHWzLOjh8TP6w
         4hsMclFU5mhXqjnvg+Gsi6FmeKjHK2NUfOybX+jHLnEA9xr/vYS4e0tvI1ySZdQFmg
         Ci0vfkxo5WXgrzHnk/n4huRdfJNZCZOTVviZahfYsG27xVrLiXKDdM14CNhRFNaT4r
         Jc4sisVw5MiF51k/kP73but/CqIKJ47sj/zgcpqSYyNOY2xkvHyYJ8xLTjYqjhlpyP
         uT7eEAoIK7VyoeUdTD7cmixd5sAnBuvp4ZleVs3mDxLjIs91tcbe9FxW1vvsjRR4In
         jeJtxPs4v+sAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        wens@csie.org, samuel@sholland.org, linux-rtc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 10/27] rtc: sun6i: Fix time overflow handling
Date:   Wed,  6 Apr 2022 21:12:40 -0400
Message-Id: <20220407011257.114287-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011257.114287-1-sashal@kernel.org>
References: <20220407011257.114287-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 9f6cd82eca7e91a0d0311242a87c6aa3c2737968 ]

Using "unsigned long" for UNIX timestamps is never a good idea, and
comparing the value of such a variable against U32_MAX does not do
anything useful on 32-bit systems.

Use the proper time64_t type when dealing with timestamps, and avoid
cutting down the time range unnecessarily. This also fixes the flawed
check for the alarm time being too far into the future.

The check for this condition is actually somewhat theoretical, as the
RTC counts till 2033 only anyways, and 2^32 seconds from now is not
before the year 2157 - at which point I hope nobody will be using this
hardware anymore.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220211122643.1343315-4-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sun6i.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index adec1b14a8de..c551ebf0ac00 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -138,7 +138,7 @@ struct sun6i_rtc_dev {
 	const struct sun6i_rtc_clk_data *data;
 	void __iomem *base;
 	int irq;
-	unsigned long alarm;
+	time64_t alarm;
 
 	struct clk_hw hw;
 	struct clk_hw *int_osc;
@@ -510,10 +510,8 @@ static int sun6i_rtc_setalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	struct sun6i_rtc_dev *chip = dev_get_drvdata(dev);
 	struct rtc_time *alrm_tm = &wkalrm->time;
 	struct rtc_time tm_now;
-	unsigned long time_now = 0;
-	unsigned long time_set = 0;
-	unsigned long time_gap = 0;
-	int ret = 0;
+	time64_t time_now, time_set;
+	int ret;
 
 	ret = sun6i_rtc_gettime(dev, &tm_now);
 	if (ret < 0) {
@@ -528,9 +526,7 @@ static int sun6i_rtc_setalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 		return -EINVAL;
 	}
 
-	time_gap = time_set - time_now;
-
-	if (time_gap > U32_MAX) {
+	if ((time_set - time_now) > U32_MAX) {
 		dev_err(dev, "Date too far in the future\n");
 		return -EINVAL;
 	}
@@ -539,7 +535,7 @@ static int sun6i_rtc_setalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	writel(0, chip->base + SUN6I_ALRM_COUNTER);
 	usleep_range(100, 300);
 
-	writel(time_gap, chip->base + SUN6I_ALRM_COUNTER);
+	writel(time_set - time_now, chip->base + SUN6I_ALRM_COUNTER);
 	chip->alarm = time_set;
 
 	sun6i_rtc_setaie(wkalrm->enabled, chip);
-- 
2.35.1

