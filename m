Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BF0121250
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfLPRvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:51:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfLPRvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:51:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 023C322464;
        Mon, 16 Dec 2019 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518702;
        bh=92m9MD0g2AXDPwD4TjpCVW3W2UQi4LGyYLnHE06iveM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XS7JHondk4saeFPUjezqVtzzXtrAJjp9PjLxC4SEUMFu3WdFQ4Ecl4+4EmoZynSyG
         WuJXheGI3dUcmypCxxuHvkjL7bxqvbqwTEdfMOaRbAAOD77KvBmBqeeIvkq8lgAxTu
         OBVbJLu4X1h2RvIimeBxB/Fu4MyscvsRyvLn/Bzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 032/267] rtc: s3c-rtc: Avoid using broken ALMYEAR register
Date:   Mon, 16 Dec 2019 18:45:58 +0100
Message-Id: <20191216174852.488895969@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 50c8aec4212a966817e868056efc9bfbb73337c0 ]

(RTC,ALM)YEAR registers of Exynos built-in RTC device contains 3 BCD
characters. s3c-rtc driver uses only 2 lower of them and supports years
from 2000..2099 range. The third BCD value is typically set to 0, but it
looks that handling of it is broken in the hardware. It sometimes
defaults to a random (even non-BCD) value. This is not an issue
for handling RTCYEAR register, because bcd2bin() properly handles only
8bit values (2 BCD characters, the third one is skipped). The problem
is however with ALMYEAR register and proper RTC alarm operation. When
YEAREN bit is set for the configured alarm, RTC hardware triggers alarm
only when ALMYEAR and RTCYEAR matches. This usually doesn't happen
because of the random noise on the third BCD character.

Fix this by simply skipping setting ALMYEAR register in alarm
configuration. This workaround fixes broken alarm operation on Exynos
built-in rtc device. My tests revealed that the issue happens on the
following Exynos series: 3250, 4210, 4412, 5250 and 5410.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-s3c.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index a8992c227f611..4120a305954af 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -327,7 +327,6 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct rtc_time *tm = &alrm->time;
 	unsigned int alrm_en;
 	int ret;
-	int year = tm->tm_year - 100;
 
 	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		alrm->enabled,
@@ -356,11 +355,6 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 		writeb(bin2bcd(tm->tm_hour), info->base + S3C2410_ALMHOUR);
 	}
 
-	if (year < 100 && year >= 0) {
-		alrm_en |= S3C2410_RTCALM_YEAREN;
-		writeb(bin2bcd(year), info->base + S3C2410_ALMYEAR);
-	}
-
 	if (tm->tm_mon < 12 && tm->tm_mon >= 0) {
 		alrm_en |= S3C2410_RTCALM_MONEN;
 		writeb(bin2bcd(tm->tm_mon + 1), info->base + S3C2410_ALMMON);
-- 
2.20.1



