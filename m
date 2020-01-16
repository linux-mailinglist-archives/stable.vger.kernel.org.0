Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CDD13EFDD
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395175AbgAPSRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:17:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404226AbgAPR27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 600D0246E3;
        Thu, 16 Jan 2020 17:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195738;
        bh=yVEIWg/Qhu2H3z5ZhV7BPUrVlpawvdNKn/VbgxC5zOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3vp3zRjuSCDdNdCVGyw2wOD2sqSFtU1zd+rl0cbvGmvwcZoi2POsgUa1UKrBxmXU
         HPorXdHeKq6VNeXLRhIniHZU2Mia+UU7RWkvBK6oIMFTet5EdRxEYn4Bbt+6FaHeMv
         8cCyX3tyPfaYMYT+CnCl3RFmq3LZ9UjMNlqeKzZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 275/371] rtc: pcf2127: bugfix: read rtc disables watchdog
Date:   Thu, 16 Jan 2020 12:22:27 -0500
Message-Id: <20200116172403.18149-218-sashal@kernel.org>
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

From: Bruno Thomsen <bruno.thomsen@gmail.com>

[ Upstream commit 7f43020e3bdb63d65661ed377682702f8b34d3ea ]

The previous fix listed bulk read of registers as root cause of
accendential disabling of watchdog, since the watchdog counter
register (WD_VAL) was zeroed.

Fixes: 3769a375ab83 rtc: pcf2127: bulk read only date and time registers.

Tested with the same PCF2127 chip as Sean reveled root cause
of WD_VAL register value zeroing was caused by reading CTRL2
register which is one of the watchdog feature control registers.

So the solution is to not read the first two control registers
(CTRL1 and CTRL2) in pcf2127_rtc_read_time as they are not
needed anyway. Size of local buf variable is kept to allow
easy usage of register defines to improve readability of code.

Debug trace line was updated after CTRL1 and CTRL2 are no longer
read from the chip. Also replaced magic numbers in buf access
with register defines.

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Link: https://lore.kernel.org/r/20190822131936.18772-3-bruno.thomsen@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf2127.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2127.c b/drivers/rtc/rtc-pcf2127.c
index 9f1b14bf91ae..367e0f803440 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -52,20 +52,14 @@ static int pcf2127_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	struct pcf2127 *pcf2127 = dev_get_drvdata(dev);
 	unsigned char buf[10];
 	int ret;
-	int i;
 
-	for (i = 0; i <= PCF2127_REG_CTRL3; i++) {
-		ret = regmap_read(pcf2127->regmap, PCF2127_REG_CTRL1 + i,
-				  (unsigned int *)(buf + i));
-		if (ret) {
-			dev_err(dev, "%s: read error\n", __func__);
-			return ret;
-		}
-	}
-
-	ret = regmap_bulk_read(pcf2127->regmap, PCF2127_REG_SC,
-			       (buf + PCF2127_REG_SC),
-			       ARRAY_SIZE(buf) - PCF2127_REG_SC);
+	/*
+	 * Avoid reading CTRL2 register as it causes WD_VAL register
+	 * value to reset to 0 which means watchdog is stopped.
+	 */
+	ret = regmap_bulk_read(pcf2127->regmap, PCF2127_REG_CTRL3,
+			       (buf + PCF2127_REG_CTRL3),
+			       ARRAY_SIZE(buf) - PCF2127_REG_CTRL3);
 	if (ret) {
 		dev_err(dev, "%s: read error\n", __func__);
 		return ret;
@@ -86,14 +80,12 @@ static int pcf2127_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	}
 
 	dev_dbg(dev,
-		"%s: raw data is cr1=%02x, cr2=%02x, cr3=%02x, "
-		"sec=%02x, min=%02x, hr=%02x, "
+		"%s: raw data is cr3=%02x, sec=%02x, min=%02x, hr=%02x, "
 		"mday=%02x, wday=%02x, mon=%02x, year=%02x\n",
-		__func__,
-		buf[0], buf[1], buf[2],
-		buf[3], buf[4], buf[5],
-		buf[6], buf[7], buf[8], buf[9]);
-
+		__func__, buf[PCF2127_REG_CTRL3], buf[PCF2127_REG_SC],
+		buf[PCF2127_REG_MN], buf[PCF2127_REG_HR],
+		buf[PCF2127_REG_DM], buf[PCF2127_REG_DW],
+		buf[PCF2127_REG_MO], buf[PCF2127_REG_YR]);
 
 	tm->tm_sec = bcd2bin(buf[PCF2127_REG_SC] & 0x7F);
 	tm->tm_min = bcd2bin(buf[PCF2127_REG_MN] & 0x7F);
-- 
2.20.1

