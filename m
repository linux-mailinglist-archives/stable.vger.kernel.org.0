Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C61C13F70E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390271AbgAPTJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:09:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387912AbgAPRAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 631C620728;
        Thu, 16 Jan 2020 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194049;
        bh=7V3lyqBiGL4vQkI761fYQKlukMOauXF22sAU02BMDnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noDs72Lq+wC4vKO40wFrhwTqMHZ8qF8ggaxiq1NLjfKRRjdnM7sb6/io8dCAYiSjX
         ExGqjxw9n0ekrdHey5G1VnUZSh7eT0ucSlZYF6TJ0RkR71aRqiM/yoaO0PyPxJjMZg
         +8n6hmzwu9MSCMQT8hTbEq7dTA+stSedlOQczhN0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 164/671] rtc: 88pm80x: fix unintended sign extension
Date:   Thu, 16 Jan 2020 11:51:13 -0500
Message-Id: <20200116165940.10720-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit fb0b322537a831b5b0cb948c56f8f958ce493d3a ]

Shifting a u8 by 24 will cause the value to be promoted to an integer. If
the top bit of the u8 is set then the following conversion to an unsigned
long will sign extend the value causing the upper 32 bits to be set in
the result.

Fix this by casting the u8 value to an unsigned long before the shift.

Detected by CoverityScan, CID#714646-714649 ("Unintended sign extension")

Fixes: 2985c29c1964 ("rtc: Add rtc support to 88PM80X PMIC")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-88pm80x.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index cab293cb2bf0..1fc48ebd3cd0 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -114,12 +114,14 @@ static int pm80x_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	unsigned char buf[4];
 	unsigned long ticks, base, data;
 	regmap_raw_read(info->map, PM800_RTC_EXPIRE2_1, buf, 4);
-	base = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	base = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	dev_dbg(info->dev, "%x-%x-%x-%x\n", buf[0], buf[1], buf[2], buf[3]);
 
 	/* load 32-bit read-only counter */
 	regmap_raw_read(info->map, PM800_RTC_COUNTER1, buf, 4);
-	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks = base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -137,7 +139,8 @@ static int pm80x_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	/* load 32-bit read-only counter */
 	regmap_raw_read(info->map, PM800_RTC_COUNTER1, buf, 4);
-	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	base = ticks - data;
 	dev_dbg(info->dev, "set base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -158,11 +161,13 @@ static int pm80x_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	int ret;
 
 	regmap_raw_read(info->map, PM800_RTC_EXPIRE2_1, buf, 4);
-	base = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	base = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	dev_dbg(info->dev, "%x-%x-%x-%x\n", buf[0], buf[1], buf[2], buf[3]);
 
 	regmap_raw_read(info->map, PM800_RTC_EXPIRE1_1, buf, 4);
-	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks = base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -185,12 +190,14 @@ static int pm80x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	regmap_update_bits(info->map, PM800_RTC_CONTROL, PM800_ALARM1_EN, 0);
 
 	regmap_raw_read(info->map, PM800_RTC_EXPIRE2_1, buf, 4);
-	base = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	base = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	dev_dbg(info->dev, "%x-%x-%x-%x\n", buf[0], buf[1], buf[2], buf[3]);
 
 	/* load 32-bit read-only counter */
 	regmap_raw_read(info->map, PM800_RTC_COUNTER1, buf, 4);
-	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks = base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
-- 
2.20.1

