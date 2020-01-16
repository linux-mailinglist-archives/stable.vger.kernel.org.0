Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E0A13F23E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403787AbgAPRYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403767AbgAPRYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07453246AE;
        Thu, 16 Jan 2020 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195481;
        bh=/7Jt2WKsId0mWZYHVt27b4RtZaiSQACvRaQAiKA8aTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbbMc+dSe2wbkXq/ruUN/wX4Vquaa6g7VorsRkwXkBt6Y/vPmvPSrTgrTw6e759AK
         c1kUMQ426ymQmbEnhnGYiRpaEreFUI/7pEa59tea5lB45OvRw466nTBqZMUjlomR8U
         i9kKQkDuV0bi5PREO4+Dy/exoTluFsfoYZjT24Aw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 086/371] rtc: 88pm860x: fix unintended sign extension
Date:   Thu, 16 Jan 2020 12:19:18 -0500
Message-Id: <20200116172403.18149-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit dc9e47160626cdb58d5c39a4f43dcfdb27a5c004 ]

Shifting a u8 by 24 will cause the value to be promoted to an integer. If
the top bit of the u8 is set then the following conversion to an unsigned
long will sign extend the value causing the upper 32 bits to be set in
the result.

Fix this by casting the u8 value to an unsigned long before the shift.

Detected by CoverityScan, CID#144925-144928 ("Unintended sign extension")

Fixes: 008b30408c40 ("mfd: Add rtc support to 88pm860x")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-88pm860x.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 166faae3a59c..7d3e5168fcef 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -115,11 +115,13 @@ static int pm860x_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	pm860x_page_bulk_read(info->i2c, REG0_ADDR, 8, buf);
 	dev_dbg(info->dev, "%x-%x-%x-%x-%x-%x-%x-%x\n", buf[0], buf[1],
 		buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
-	base = (buf[1] << 24) | (buf[3] << 16) | (buf[5] << 8) | buf[7];
+	base = ((unsigned long)buf[1] << 24) | (buf[3] << 16) |
+		(buf[5] << 8) | buf[7];
 
 	/* load 32-bit read-only counter */
 	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
-	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks = base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -145,7 +147,8 @@ static int pm860x_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	/* load 32-bit read-only counter */
 	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
-	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	base = ticks - data;
 	dev_dbg(info->dev, "set base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -170,10 +173,12 @@ static int pm860x_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	pm860x_page_bulk_read(info->i2c, REG0_ADDR, 8, buf);
 	dev_dbg(info->dev, "%x-%x-%x-%x-%x-%x-%x-%x\n", buf[0], buf[1],
 		buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
-	base = (buf[1] << 24) | (buf[3] << 16) | (buf[5] << 8) | buf[7];
+	base = ((unsigned long)buf[1] << 24) | (buf[3] << 16) |
+		(buf[5] << 8) | buf[7];
 
 	pm860x_bulk_read(info->i2c, PM8607_RTC_EXPIRE1, 4, buf);
-	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks = base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -198,11 +203,13 @@ static int pm860x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	pm860x_page_bulk_read(info->i2c, REG0_ADDR, 8, buf);
 	dev_dbg(info->dev, "%x-%x-%x-%x-%x-%x-%x-%x\n", buf[0], buf[1],
 		buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
-	base = (buf[1] << 24) | (buf[3] << 16) | (buf[5] << 8) | buf[7];
+	base = ((unsigned long)buf[1] << 24) | (buf[3] << 16) |
+		(buf[5] << 8) | buf[7];
 
 	/* load 32-bit read-only counter */
 	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
-	data = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks = base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
-- 
2.20.1

