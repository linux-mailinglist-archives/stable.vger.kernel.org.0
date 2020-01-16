Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C7F13FE8A
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391703AbgAPXgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403999AbgAPXbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:31:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D28020661;
        Thu, 16 Jan 2020 23:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217492;
        bh=KeMuUU1uohJ1StY+/CmAWDNzajPxBmntrU56E74dvHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYG12TLiPKRsyGugRtar822dSg3CaM8AdGjMk8+82Bnn2poNgRFNZbdeJ09UcM2Zy
         x7tFviznPDVK2TIgr9XHHRPbwsDPRSqS9NGFTLUUmyPDZqDgJvEKY6rj1Ez425NX8O
         1pv5GNDeninc9GUwTAn4jurlfeqrtsgAqp+i9INc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ran Bi <ran.bi@mediatek.com>,
        Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.14 20/71] rtc: mt6397: fix alarm register overwrite
Date:   Fri, 17 Jan 2020 00:18:18 +0100
Message-Id: <20200116231712.342885835@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ran Bi <ran.bi@mediatek.com>

commit 653997eeecef95c3ead4fba1b2d27e6a5854d6cd upstream.

Alarm registers high byte was reserved for other functions.
This add mask in alarm registers operation functions.
This also fix error condition in interrupt handler.

Fixes: fc2979118f3f ("rtc: mediatek: Add MT6397 RTC driver")

Signed-off-by: Ran Bi <ran.bi@mediatek.com>
Signed-off-by: Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>
Link: https://lore.kernel.org/r/1576057435-3561-6-git-send-email-hsin-hsiung.wang@mediatek.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-mt6397.c |   47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

--- a/drivers/rtc/rtc-mt6397.c
+++ b/drivers/rtc/rtc-mt6397.c
@@ -55,6 +55,14 @@
 
 #define RTC_AL_SEC		0x0018
 
+#define RTC_AL_SEC_MASK		0x003f
+#define RTC_AL_MIN_MASK		0x003f
+#define RTC_AL_HOU_MASK		0x001f
+#define RTC_AL_DOM_MASK		0x001f
+#define RTC_AL_DOW_MASK		0x0007
+#define RTC_AL_MTH_MASK		0x000f
+#define RTC_AL_YEA_MASK		0x007f
+
 #define RTC_PDN2		0x002e
 #define RTC_PDN2_PWRON_ALARM	BIT(4)
 
@@ -111,7 +119,7 @@ static irqreturn_t mtk_rtc_irq_handler_t
 		irqen = irqsta & ~RTC_IRQ_EN_AL;
 		mutex_lock(&rtc->lock);
 		if (regmap_write(rtc->regmap, rtc->addr_base + RTC_IRQ_EN,
-				 irqen) < 0)
+				 irqen) == 0)
 			mtk_rtc_write_trigger(rtc);
 		mutex_unlock(&rtc->lock);
 
@@ -233,12 +241,12 @@ static int mtk_rtc_read_alarm(struct dev
 	alm->pending = !!(pdn2 & RTC_PDN2_PWRON_ALARM);
 	mutex_unlock(&rtc->lock);
 
-	tm->tm_sec = data[RTC_OFFSET_SEC];
-	tm->tm_min = data[RTC_OFFSET_MIN];
-	tm->tm_hour = data[RTC_OFFSET_HOUR];
-	tm->tm_mday = data[RTC_OFFSET_DOM];
-	tm->tm_mon = data[RTC_OFFSET_MTH];
-	tm->tm_year = data[RTC_OFFSET_YEAR];
+	tm->tm_sec = data[RTC_OFFSET_SEC] & RTC_AL_SEC_MASK;
+	tm->tm_min = data[RTC_OFFSET_MIN] & RTC_AL_MIN_MASK;
+	tm->tm_hour = data[RTC_OFFSET_HOUR] & RTC_AL_HOU_MASK;
+	tm->tm_mday = data[RTC_OFFSET_DOM] & RTC_AL_DOM_MASK;
+	tm->tm_mon = data[RTC_OFFSET_MTH] & RTC_AL_MTH_MASK;
+	tm->tm_year = data[RTC_OFFSET_YEAR] & RTC_AL_YEA_MASK;
 
 	tm->tm_year += RTC_MIN_YEAR_OFFSET;
 	tm->tm_mon--;
@@ -259,14 +267,25 @@ static int mtk_rtc_set_alarm(struct devi
 	tm->tm_year -= RTC_MIN_YEAR_OFFSET;
 	tm->tm_mon++;
 
-	data[RTC_OFFSET_SEC] = tm->tm_sec;
-	data[RTC_OFFSET_MIN] = tm->tm_min;
-	data[RTC_OFFSET_HOUR] = tm->tm_hour;
-	data[RTC_OFFSET_DOM] = tm->tm_mday;
-	data[RTC_OFFSET_MTH] = tm->tm_mon;
-	data[RTC_OFFSET_YEAR] = tm->tm_year;
-
 	mutex_lock(&rtc->lock);
+	ret = regmap_bulk_read(rtc->regmap, rtc->addr_base + RTC_AL_SEC,
+			       data, RTC_OFFSET_COUNT);
+	if (ret < 0)
+		goto exit;
+
+	data[RTC_OFFSET_SEC] = ((data[RTC_OFFSET_SEC] & ~(RTC_AL_SEC_MASK)) |
+				(tm->tm_sec & RTC_AL_SEC_MASK));
+	data[RTC_OFFSET_MIN] = ((data[RTC_OFFSET_MIN] & ~(RTC_AL_MIN_MASK)) |
+				(tm->tm_min & RTC_AL_MIN_MASK));
+	data[RTC_OFFSET_HOUR] = ((data[RTC_OFFSET_HOUR] & ~(RTC_AL_HOU_MASK)) |
+				(tm->tm_hour & RTC_AL_HOU_MASK));
+	data[RTC_OFFSET_DOM] = ((data[RTC_OFFSET_DOM] & ~(RTC_AL_DOM_MASK)) |
+				(tm->tm_mday & RTC_AL_DOM_MASK));
+	data[RTC_OFFSET_MTH] = ((data[RTC_OFFSET_MTH] & ~(RTC_AL_MTH_MASK)) |
+				(tm->tm_mon & RTC_AL_MTH_MASK));
+	data[RTC_OFFSET_YEAR] = ((data[RTC_OFFSET_YEAR] & ~(RTC_AL_YEA_MASK)) |
+				(tm->tm_year & RTC_AL_YEA_MASK));
+
 	if (alm->enabled) {
 		ret = regmap_bulk_write(rtc->regmap,
 					rtc->addr_base + RTC_AL_SEC,


