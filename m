Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FC7649FB8
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiLLNOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiLLNNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:13:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAA1B4B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A6B9B80D3C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E536C433EF;
        Mon, 12 Dec 2022 13:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850830;
        bh=Ab9cm2nN0an6sgaB9m1CEfDhWMDoSqZY9mlYwppv6XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oo3GZrbdyI4S0fhQyFNF//WKaegKOfuIyIrCbTcvSkgfNE7m9njrOJR8YD9v+cfwT
         7GeKMu8BNzsLyq3IpD6FRCgwMfj5Jsw6cYWD8dZsuocxDnB3s7KQJgNYRlziWlPwPI
         yn819QIJmoa0v86IJ54peh9Hm8YQEVnk+TCERweQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/106] rtc: cmos: avoid UIP when reading alarm time
Date:   Mon, 12 Dec 2022 14:09:42 +0100
Message-Id: <20221212130926.569758829@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

[ Upstream commit cdedc45c579faf8cc6608d3ef81576ee0d512aa4 ]

Some Intel chipsets disconnect the time and date RTC registers when the
clock update is in progress: during this time reads may return bogus
values and writes fail silently. This includes the RTC alarm registers.
[1]

cmos_read_alarm() did not take account for that, which caused alarm time
reads to sometimes return bogus values. This can be shown with a test
patch that I am attaching to this patch series.

Fix this, by using mc146818_avoid_UIP().

[1] 7th Generation Intel ® Processor Family I/O for U/Y Platforms [...]
Datasheet, Volume 1 of 2 (Intel's Document Number: 334658-006)
Page 208
https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/7th-and-8th-gen-core-family-mobile-u-y-processor-lines-i-o-datasheet-vol-1.pdf
        "If a RAM read from the ten time and date bytes is attempted
        during an update cycle, the value read do not necessarily
        represent the true contents of those locations. Any RAM writes
        under the same conditions are ignored."

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211210200131.153887-9-mat.jonczyk@o2.pl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 72 ++++++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 601e3967e1f0..d419eb988b22 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -249,10 +249,46 @@ static int cmos_set_time(struct device *dev, struct rtc_time *t)
 	return mc146818_set_time(t);
 }
 
+struct cmos_read_alarm_callback_param {
+	struct cmos_rtc *cmos;
+	struct rtc_time *time;
+	unsigned char	rtc_control;
+};
+
+static void cmos_read_alarm_callback(unsigned char __always_unused seconds,
+				     void *param_in)
+{
+	struct cmos_read_alarm_callback_param *p =
+		(struct cmos_read_alarm_callback_param *)param_in;
+	struct rtc_time *time = p->time;
+
+	time->tm_sec = CMOS_READ(RTC_SECONDS_ALARM);
+	time->tm_min = CMOS_READ(RTC_MINUTES_ALARM);
+	time->tm_hour = CMOS_READ(RTC_HOURS_ALARM);
+
+	if (p->cmos->day_alrm) {
+		/* ignore upper bits on readback per ACPI spec */
+		time->tm_mday = CMOS_READ(p->cmos->day_alrm) & 0x3f;
+		if (!time->tm_mday)
+			time->tm_mday = -1;
+
+		if (p->cmos->mon_alrm) {
+			time->tm_mon = CMOS_READ(p->cmos->mon_alrm);
+			if (!time->tm_mon)
+				time->tm_mon = -1;
+		}
+	}
+
+	p->rtc_control = CMOS_READ(RTC_CONTROL);
+}
+
 static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned char	rtc_control;
+	struct cmos_read_alarm_callback_param p = {
+		.cmos = cmos,
+		.time = &t->time,
+	};
 
 	/* This not only a rtc_op, but also called directly */
 	if (!is_valid_irq(cmos->irq))
@@ -263,28 +299,18 @@ static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	 * the future.
 	 */
 
-	spin_lock_irq(&rtc_lock);
-	t->time.tm_sec = CMOS_READ(RTC_SECONDS_ALARM);
-	t->time.tm_min = CMOS_READ(RTC_MINUTES_ALARM);
-	t->time.tm_hour = CMOS_READ(RTC_HOURS_ALARM);
-
-	if (cmos->day_alrm) {
-		/* ignore upper bits on readback per ACPI spec */
-		t->time.tm_mday = CMOS_READ(cmos->day_alrm) & 0x3f;
-		if (!t->time.tm_mday)
-			t->time.tm_mday = -1;
-
-		if (cmos->mon_alrm) {
-			t->time.tm_mon = CMOS_READ(cmos->mon_alrm);
-			if (!t->time.tm_mon)
-				t->time.tm_mon = -1;
-		}
-	}
-
-	rtc_control = CMOS_READ(RTC_CONTROL);
-	spin_unlock_irq(&rtc_lock);
+	/* Some Intel chipsets disconnect the alarm registers when the clock
+	 * update is in progress - during this time reads return bogus values
+	 * and writes may fail silently. See for example "7th Generation Intel®
+	 * Processor Family I/O for U/Y Platforms [...] Datasheet", section
+	 * 27.7.1
+	 *
+	 * Use the mc146818_avoid_UIP() function to avoid this.
+	 */
+	if (!mc146818_avoid_UIP(cmos_read_alarm_callback, &p))
+		return -EIO;
 
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
+	if (!(p.rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		if (((unsigned)t->time.tm_sec) < 0x60)
 			t->time.tm_sec = bcd2bin(t->time.tm_sec);
 		else
@@ -313,7 +339,7 @@ static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 		}
 	}
 
-	t->enabled = !!(rtc_control & RTC_AIE);
+	t->enabled = !!(p.rtc_control & RTC_AIE);
 	t->pending = 0;
 
 	return 0;
-- 
2.35.1



