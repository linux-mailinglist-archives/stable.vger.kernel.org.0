Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE28A64A0B2
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiLLN3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiLLN2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:28:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628DE13E0B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:28:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B784B80D52
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF438C433D2;
        Mon, 12 Dec 2022 13:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851729;
        bh=cb95x2E/PWeBwFYg+kgog4i3ZpoGV1BYXZPIpRMrf3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4BJyyHLJon0q0Wp1eH9GaO/VHqxpK8GOEr+aYlUvAIjLlKqSBPcfiM41lOZXlqr4
         zOKL5AWWyZejnrQKbgupwWGJHm1TtzOUWuVGnddSpL0HFhTMAq2BhRsnwhZpuGgL9h
         3MzGdw/cL/NxZEog9G3AsQPSW/iNhZpINLJ7o0lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/123] rtc: cmos: avoid UIP when writing alarm time
Date:   Mon, 12 Dec 2022 14:16:38 +0100
Message-Id: <20221212130928.257274291@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

[ Upstream commit cd17420ebea580c22dd3a93f7237de3d2cfafc37 ]

Some Intel chipsets disconnect the time and date RTC registers when the
clock update is in progress: during this time reads may return bogus
values and writes fail silently. This includes the RTC alarm registers.
[1]

cmos_set_alarm() did not take account for that, fix it.

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
Link: https://lore.kernel.org/r/20211210200131.153887-10-mat.jonczyk@o2.pl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 107 +++++++++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 41 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index b90a603d6b12..a3297a9cbc59 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -444,10 +444,57 @@ static int cmos_validate_alarm(struct device *dev, struct rtc_wkalrm *t)
 	return 0;
 }
 
+struct cmos_set_alarm_callback_param {
+	struct cmos_rtc *cmos;
+	unsigned char mon, mday, hrs, min, sec;
+	struct rtc_wkalrm *t;
+};
+
+/* Note: this function may be executed by mc146818_avoid_UIP() more then
+ *	 once
+ */
+static void cmos_set_alarm_callback(unsigned char __always_unused seconds,
+				    void *param_in)
+{
+	struct cmos_set_alarm_callback_param *p =
+		(struct cmos_set_alarm_callback_param *)param_in;
+
+	/* next rtc irq must not be from previous alarm setting */
+	cmos_irq_disable(p->cmos, RTC_AIE);
+
+	/* update alarm */
+	CMOS_WRITE(p->hrs, RTC_HOURS_ALARM);
+	CMOS_WRITE(p->min, RTC_MINUTES_ALARM);
+	CMOS_WRITE(p->sec, RTC_SECONDS_ALARM);
+
+	/* the system may support an "enhanced" alarm */
+	if (p->cmos->day_alrm) {
+		CMOS_WRITE(p->mday, p->cmos->day_alrm);
+		if (p->cmos->mon_alrm)
+			CMOS_WRITE(p->mon, p->cmos->mon_alrm);
+	}
+
+	if (use_hpet_alarm()) {
+		/*
+		 * FIXME the HPET alarm glue currently ignores day_alrm
+		 * and mon_alrm ...
+		 */
+		hpet_set_alarm_time(p->t->time.tm_hour, p->t->time.tm_min,
+				    p->t->time.tm_sec);
+	}
+
+	if (p->t->enabled)
+		cmos_irq_enable(p->cmos, RTC_AIE);
+}
+
 static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned char mon, mday, hrs, min, sec, rtc_control;
+	struct cmos_set_alarm_callback_param p = {
+		.cmos = cmos,
+		.t = t
+	};
+	unsigned char rtc_control;
 	int ret;
 
 	/* This not only a rtc_op, but also called directly */
@@ -458,11 +505,11 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	mon = t->time.tm_mon + 1;
-	mday = t->time.tm_mday;
-	hrs = t->time.tm_hour;
-	min = t->time.tm_min;
-	sec = t->time.tm_sec;
+	p.mon = t->time.tm_mon + 1;
+	p.mday = t->time.tm_mday;
+	p.hrs = t->time.tm_hour;
+	p.min = t->time.tm_min;
+	p.sec = t->time.tm_sec;
 
 	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
@@ -470,43 +517,21 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		/* Writing 0xff means "don't care" or "match all".  */
-		mon = (mon <= 12) ? bin2bcd(mon) : 0xff;
-		mday = (mday >= 1 && mday <= 31) ? bin2bcd(mday) : 0xff;
-		hrs = (hrs < 24) ? bin2bcd(hrs) : 0xff;
-		min = (min < 60) ? bin2bcd(min) : 0xff;
-		sec = (sec < 60) ? bin2bcd(sec) : 0xff;
+		p.mon = (p.mon <= 12) ? bin2bcd(p.mon) : 0xff;
+		p.mday = (p.mday >= 1 && p.mday <= 31) ? bin2bcd(p.mday) : 0xff;
+		p.hrs = (p.hrs < 24) ? bin2bcd(p.hrs) : 0xff;
+		p.min = (p.min < 60) ? bin2bcd(p.min) : 0xff;
+		p.sec = (p.sec < 60) ? bin2bcd(p.sec) : 0xff;
 	}
 
-	spin_lock_irq(&rtc_lock);
-
-	/* next rtc irq must not be from previous alarm setting */
-	cmos_irq_disable(cmos, RTC_AIE);
-
-	/* update alarm */
-	CMOS_WRITE(hrs, RTC_HOURS_ALARM);
-	CMOS_WRITE(min, RTC_MINUTES_ALARM);
-	CMOS_WRITE(sec, RTC_SECONDS_ALARM);
-
-	/* the system may support an "enhanced" alarm */
-	if (cmos->day_alrm) {
-		CMOS_WRITE(mday, cmos->day_alrm);
-		if (cmos->mon_alrm)
-			CMOS_WRITE(mon, cmos->mon_alrm);
-	}
-
-	if (use_hpet_alarm()) {
-		/*
-		 * FIXME the HPET alarm glue currently ignores day_alrm
-		 * and mon_alrm ...
-		 */
-		hpet_set_alarm_time(t->time.tm_hour, t->time.tm_min,
-				    t->time.tm_sec);
-	}
-
-	if (t->enabled)
-		cmos_irq_enable(cmos, RTC_AIE);
-
-	spin_unlock_irq(&rtc_lock);
+	/*
+	 * Some Intel chipsets disconnect the alarm registers when the clock
+	 * update is in progress - during this time writes fail silently.
+	 *
+	 * Use mc146818_avoid_UIP() to avoid this.
+	 */
+	if (!mc146818_avoid_UIP(cmos_set_alarm_callback, &p))
+		return -EIO;
 
 	cmos->alarm_expires = rtc_tm_to_time64(&t->time);
 
-- 
2.35.1



