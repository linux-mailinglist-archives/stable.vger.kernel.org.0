Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8AA147DC9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733246AbgAXKDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388994AbgAXKDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:03:10 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC33A21556;
        Fri, 24 Jan 2020 10:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860189;
        bh=FAfFGQEtiI+BurWyBl1Puz4CuqTvKub9qVOINaGqgyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaCbhj2EBgejl2pC7V2L6nNvR+btiR3IWXvlash4nhl98psQocBgvh1cOwJ8I+5Bl
         WDVhrhvVE/FdsdBgyNBGAqSvzg2hhxK5kjY5XbP4bOOs7YuA900nrZ40OEsjK9snip
         Cr8eTWP5vUp6wd9jOW7s+EQZu56FY7aVPluH0hKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Thomsen <bruno.thomsen@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 280/343] rtc: pcf2127: bugfix: read rtc disables watchdog
Date:   Fri, 24 Jan 2020 10:31:38 +0100
Message-Id: <20200124092956.899516965@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9f1b14bf91aed..367e0f803440c 100644
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



