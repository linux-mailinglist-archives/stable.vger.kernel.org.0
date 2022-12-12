Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE305649FD1
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiLLNPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiLLNPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:15:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB6E13CED
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C766E61043
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49F3C433D2;
        Mon, 12 Dec 2022 13:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850894;
        bh=nLh0JoeSK4XgCKXYPdKHukGcVydhO6tH4LpZk2p1wxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nygg7i+gAgkCAqOkKWA7Xea03JTqGVe97BThx6LQVdZ0Kh3HMSdothvmPXx4xo94u
         2IKY9857cKcbF7xL2ZvTZyg4zLw82CoptuH+rZPyJb5SVJm1SaxsK4u1SF6dVuSLZr
         iMm/mrzSOxUhwmG1r8Ql73pJ9SSIm5nCJ96T5fKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/106] rtc: mc146818: Prevent reading garbage
Date:   Mon, 12 Dec 2022 14:09:33 +0100
Message-Id: <20221212130926.168341282@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 05a0302c35481e9b47fb90ba40922b0a4cae40d8 ]

The MC146818 driver is prone to read garbage from the RTC. There are
several issues all related to the update cycle of the MC146818. The chip
increments seconds obviously once per second and indicates that by a bit in
a register. The bit goes high 244us before the actual update starts. During
the update the readout of the time values is undefined.

The code just checks whether the update in progress bit (UIP) is set before
reading the clock. If it's set it waits arbitrary 20ms before retrying,
which is ample because the maximum update time is ~2ms.

But this check does not guarantee that the UIP bit goes high and the actual
update happens during the readout. So the following can happen

 0.997 	       UIP = False
   -> Interrupt/NMI/preemption
 0.998	       UIP -> True
 0.999	       Readout	<- Undefined

To prevent this rework the code so it checks UIP before and after the
readout and if set after the readout try again.

But that's not enough to cover the following:

 0.997 	       UIP = False
 	       Readout seconds
   -> NMI (or vCPU scheduled out)
 0.998	       UIP -> True
 	       update completes
	       UIP -> False
 1.000	       Readout	minutes,....
 	       UIP check succeeds

That can make the readout wrong up to 59 seconds.

To prevent this, read the seconds value before the first UIP check,
validate it after checking UIP and after reading out the rest.

It's amazing that the original i386 code had this actually correct and
the generic implementation of the MC146818 driver got it wrong in 2002 and
it stayed that way until today.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201206220541.594826678@linutronix.de
Stable-dep-of: cd17420ebea5 ("rtc: cmos: avoid UIP when writing alarm time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 64 +++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index b036ff33fbe6..8364e4141670 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -8,41 +8,41 @@
 #include <linux/acpi.h>
 #endif
 
-/*
- * Returns true if a clock update is in progress
- */
-static inline unsigned char mc146818_is_updating(void)
-{
-	unsigned char uip;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	uip = (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return uip;
-}
-
 unsigned int mc146818_get_time(struct rtc_time *time)
 {
 	unsigned char ctrl;
 	unsigned long flags;
 	unsigned char century = 0;
+	bool retry;
 
 #ifdef CONFIG_MACH_DECSTATION
 	unsigned int real_year;
 #endif
 
+again:
+	spin_lock_irqsave(&rtc_lock, flags);
 	/*
-	 * read RTC once any update in progress is done. The update
-	 * can take just over 2ms. We wait 20ms. There is no need to
-	 * to poll-wait (up to 1s - eeccch) for the falling edge of RTC_UIP.
-	 * If you need to know *exactly* when a second has started, enable
-	 * periodic update complete interrupts, (via ioctl) and then
-	 * immediately read /dev/rtc which will block until you get the IRQ.
-	 * Once the read clears, read the RTC time (again via ioctl). Easy.
+	 * Check whether there is an update in progress during which the
+	 * readout is unspecified. The maximum update time is ~2ms. Poll
+	 * every msec for completion.
+	 *
+	 * Store the second value before checking UIP so a long lasting NMI
+	 * which happens to hit after the UIP check cannot make an update
+	 * cycle invisible.
 	 */
-	if (mc146818_is_updating())
-		mdelay(20);
+	time->tm_sec = CMOS_READ(RTC_SECONDS);
+
+	if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {
+		spin_unlock_irqrestore(&rtc_lock, flags);
+		mdelay(1);
+		goto again;
+	}
+
+	/* Revalidate the above readout */
+	if (time->tm_sec != CMOS_READ(RTC_SECONDS)) {
+		spin_unlock_irqrestore(&rtc_lock, flags);
+		goto again;
+	}
 
 	/*
 	 * Only the values that we read from the RTC are set. We leave
@@ -50,8 +50,6 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 	 * RTC has RTC_DAY_OF_WEEK, we ignore it, as it is only updated
 	 * by the RTC when initially set to a non-zero value.
 	 */
-	spin_lock_irqsave(&rtc_lock, flags);
-	time->tm_sec = CMOS_READ(RTC_SECONDS);
 	time->tm_min = CMOS_READ(RTC_MINUTES);
 	time->tm_hour = CMOS_READ(RTC_HOURS);
 	time->tm_mday = CMOS_READ(RTC_DAY_OF_MONTH);
@@ -66,8 +64,24 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 		century = CMOS_READ(acpi_gbl_FADT.century);
 #endif
 	ctrl = CMOS_READ(RTC_CONTROL);
+	/*
+	 * Check for the UIP bit again. If it is set now then
+	 * the above values may contain garbage.
+	 */
+	retry = CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP;
+	/*
+	 * A NMI might have interrupted the above sequence so check whether
+	 * the seconds value has changed which indicates that the NMI took
+	 * longer than the UIP bit was set. Unlikely, but possible and
+	 * there is also virt...
+	 */
+	retry |= time->tm_sec != CMOS_READ(RTC_SECONDS);
+
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
+	if (retry)
+		goto again;
+
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
 	{
 		time->tm_sec = bcd2bin(time->tm_sec);
-- 
2.35.1



