Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FEC37AF5A
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 21:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhEKTdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 15:33:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46008 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhEKTdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 15:33:45 -0400
Date:   Tue, 11 May 2021 19:32:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620761557;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7c/gAvL2OFqWiTz4vBaXOW7xSRuv+onlTRvNRn0sAj8=;
        b=wLxi9o+hYgWUV0Zda16mkawXm5XOj16AabFEjCKQSNnuMx5fl15jTMU8C8U26W1lDxW43J
        YGj2eQvilp36GYAJLdFCjwgDqIBSTPq7O2e24aiR0yTNHfa7MHg9J+x8/8VqbVwLKQ/4g0
        q+9AOxG7Bn3w4ymMS5sUDQf3/R6aRpUBtAHSNeLWi9GNUunfj3yvP2DkNhUSM4Kqg1b7sX
        DybOxY0dK4n+I/nVQ5YHvbP60EHUZQYMM0nuAsAIW7uAd2A+Nj83OvRBliAQFenRBBDMX5
        Wa/Gj6Pc+dyI1qiwDQgxsvd7ZCc48ZADKGMtagtsJ7QEVvrfb8te+QCMVhIHbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620761557;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7c/gAvL2OFqWiTz4vBaXOW7xSRuv+onlTRvNRn0sAj8=;
        b=2pFXVVI3gxxUaMARldoJlyTpD2rXzHMQ3Fl0LzxnYOmQxG+Sa7RgQaBEvcFw8g4TJlUVmA
        e5taYIr4xewO9wCA==
From:   "tip-bot2 for Alexandre Belloni" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] alarmtimer: Check RTC features instead of ops
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210511014516.563031-1-alexandre.belloni@bootlin.com>
References: <20210511014516.563031-1-alexandre.belloni@bootlin.com>
MIME-Version: 1.0
Message-ID: <162076155630.29796.6492074988685235162.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     e09784a8a751e539dffc94d43bc917b0ac1e934a
Gitweb:        https://git.kernel.org/tip/e09784a8a751e539dffc94d43bc917b0ac1e934a
Author:        Alexandre Belloni <alexandre.belloni@bootlin.com>
AuthorDate:    Tue, 11 May 2021 03:45:16 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 11 May 2021 21:28:04 +02:00

alarmtimer: Check RTC features instead of ops

RTC drivers used to leave .set_alarm() NULL in order to signal the RTC
device doesn't support alarms. The drivers are now clearing the
RTC_FEATURE_ALARM bit for that purpose in order to keep the rtc_class_ops
structure const. So now, .set_alarm() is set unconditionally and this
possibly causes the alarmtimer code to select an RTC device that doesn't
support alarms.

Test RTC_FEATURE_ALARM instead of relying on ops->set_alarm to determine
whether alarms are available.

Fixes: 7ae41220ef58 ("rtc: introduce features bitfield")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511014516.563031-1-alexandre.belloni@bootlin.com

---
 kernel/time/alarmtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index bea9d08..5897828 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -92,7 +92,7 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 	if (rtcdev)
 		return -EBUSY;
 
-	if (!rtc->ops->set_alarm)
+	if (!test_bit(RTC_FEATURE_ALARM, rtc->features))
 		return -1;
 	if (!device_may_wakeup(rtc->dev.parent))
 		return -1;
