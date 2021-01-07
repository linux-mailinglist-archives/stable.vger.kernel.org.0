Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F122ED2A8
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbhAGOfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:35:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbhAGOdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F18D23372;
        Thu,  7 Jan 2021 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029984;
        bh=LO47h3Fznmsposrv19zTEGCiVt7QP7PO8T5p5kVji58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUZrAVmAEvjvRrcP4bEpa/1uWqUgzTL5PLDO4WNPRu7TJyaiIm2FIZCQI65tjeho9
         aE9dPp+VJVb8/LNiKQnKeDTI7g0JyJyalgLWgLkolUKkPFZ3N0UQER/JNxrXW5uX/r
         XV8X5jIBVS2eKTzZoDx40F1q0QIeuTFsfArfD8GM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 5.10 03/20] rtc: pcf2127: move watchdog initialisation to a separate function
Date:   Thu,  7 Jan 2021 15:33:58 +0100
Message-Id: <20210107143052.885760634@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 5d78533a0c53af9659227c803df944ba27cd56e0 upstream.

The obvious advantages are:

 - The linker can drop the watchdog functions if CONFIG_WATCHDOG is off.
 - All watchdog stuff grouped together with only a single function call
   left in generic code.
 - Watchdog register is only read when it is actually used.
 - Less #ifdefery

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20200924105256.18162-2-u.kleine-koenig@pengutronix.de
Cc: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-pcf2127.c |   56 +++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -331,6 +331,36 @@ static const struct watchdog_ops pcf2127
 	.set_timeout = pcf2127_wdt_set_timeout,
 };
 
+static int pcf2127_watchdog_init(struct device *dev, struct pcf2127 *pcf2127)
+{
+	u32 wdd_timeout;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_WATCHDOG))
+		return 0;
+
+	pcf2127->wdd.parent = dev;
+	pcf2127->wdd.info = &pcf2127_wdt_info;
+	pcf2127->wdd.ops = &pcf2127_watchdog_ops;
+	pcf2127->wdd.min_timeout = PCF2127_WD_VAL_MIN;
+	pcf2127->wdd.max_timeout = PCF2127_WD_VAL_MAX;
+	pcf2127->wdd.timeout = PCF2127_WD_VAL_DEFAULT;
+	pcf2127->wdd.min_hw_heartbeat_ms = 500;
+	pcf2127->wdd.status = WATCHDOG_NOWAYOUT_INIT_STATUS;
+
+	watchdog_set_drvdata(&pcf2127->wdd, pcf2127);
+
+	/* Test if watchdog timer is started by bootloader */
+	ret = regmap_read(pcf2127->regmap, PCF2127_REG_WD_VAL, &wdd_timeout);
+	if (ret)
+		return ret;
+
+	if (wdd_timeout)
+		set_bit(WDOG_HW_RUNNING, &pcf2127->wdd.status);
+
+	return devm_watchdog_register_device(dev, &pcf2127->wdd);
+}
+
 /* Alarm */
 static int pcf2127_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
@@ -532,7 +562,6 @@ static int pcf2127_probe(struct device *
 			 int alarm_irq, const char *name, bool has_nvmem)
 {
 	struct pcf2127 *pcf2127;
-	u32 wdd_timeout;
 	int ret = 0;
 
 	dev_dbg(dev, "%s\n", __func__);
@@ -571,17 +600,6 @@ static int pcf2127_probe(struct device *
 		pcf2127->rtc->ops = &pcf2127_rtc_alrm_ops;
 	}
 
-	pcf2127->wdd.parent = dev;
-	pcf2127->wdd.info = &pcf2127_wdt_info;
-	pcf2127->wdd.ops = &pcf2127_watchdog_ops;
-	pcf2127->wdd.min_timeout = PCF2127_WD_VAL_MIN;
-	pcf2127->wdd.max_timeout = PCF2127_WD_VAL_MAX;
-	pcf2127->wdd.timeout = PCF2127_WD_VAL_DEFAULT;
-	pcf2127->wdd.min_hw_heartbeat_ms = 500;
-	pcf2127->wdd.status = WATCHDOG_NOWAYOUT_INIT_STATUS;
-
-	watchdog_set_drvdata(&pcf2127->wdd, pcf2127);
-
 	if (has_nvmem) {
 		struct nvmem_config nvmem_cfg = {
 			.priv = pcf2127,
@@ -611,19 +629,7 @@ static int pcf2127_probe(struct device *
 		return ret;
 	}
 
-	/* Test if watchdog timer is started by bootloader */
-	ret = regmap_read(pcf2127->regmap, PCF2127_REG_WD_VAL, &wdd_timeout);
-	if (ret)
-		return ret;
-
-	if (wdd_timeout)
-		set_bit(WDOG_HW_RUNNING, &pcf2127->wdd.status);
-
-#ifdef CONFIG_WATCHDOG
-	ret = devm_watchdog_register_device(dev, &pcf2127->wdd);
-	if (ret)
-		return ret;
-#endif /* CONFIG_WATCHDOG */
+	pcf2127_watchdog_init(dev, pcf2127);
 
 	/*
 	 * Disable battery low/switch-over timestamp and interrupts.


