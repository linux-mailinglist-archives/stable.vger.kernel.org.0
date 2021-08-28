Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320883FA77E
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 22:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhH1UNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Aug 2021 16:13:36 -0400
Received: from mx-out.tlen.pl ([193.222.135.142]:52556 "EHLO mx-out.tlen.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231276AbhH1UNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Aug 2021 16:13:36 -0400
Received: (wp-smtpd smtp.tlen.pl 31805 invoked from network); 28 Aug 2021 22:06:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1630181163; bh=7+1rb95guh8tPYk0AoD82MrEntGALyARTHhDLppzSl4=;
          h=From:To:Cc:Subject;
          b=kP3gcFPGeCAfWLIFuBwlUS7bAbvGsChMTUWxlj6ig4xnaNw/Hg0yLx6OstBRw8zSt
           JjS0fPKIBmgKzO6oNNZGLvL8j053a4sfVRWeGFiCd2u+6T6aiRqxeWEQHWF8xr0zLc
           E/lA5GL5Njgl2OJtUxvPBceXoUgiwbC8EvOw9RIs=
Received: from ablt14.neoplus.adsl.tpnet.pl (HELO localhost.localdomain) (mat.jonczyk@o2.pl@[83.7.213.14])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with SMTP
          for <linux-rtc@vger.kernel.org>; 28 Aug 2021 22:06:03 +0200
From:   =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To:     linux-rtc@vger.kernel.org
Cc:     =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH] rtc-mc146818: fix RTC presence check
Date:   Sat, 28 Aug 2021 22:05:28 +0200
Message-Id: <20210828200528.83068-1-mat.jonczyk@o2.pl>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <6357c8f3-e2b0-052e-0382-b5ed093a4bfa@o2.pl>
References: <6357c8f3-e2b0-052e-0382-b5ed093a4bfa@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 44a1f8f0a50e38efa108eb38f43392e4
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [8eN0]                               
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To prevent an infinite loop in mc146818_get_time(),
commit 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs")
added a check for RTC availability. Together with a later fix, it
checked if bit 6 in register 0x0d is cleared. This, however, caused a
false negative on a motherboard with an AMD SB710 southbridge; according
to the specification [1], bit 6 of register 0x0d of this chipset is a
scratchbit.

This caused a regression in Linux 5.11 - the RTC was not used by the
kernel.

As a better alternative, check whether the UIP ("Update-in-progress")
bit is set for longer then 10ms. If that is the case, then apparently
the RTC is either absent (and all register reads return 0xff) or broken.
Also limit the number of loop iterations in mc146818_get_time() to 10.

In a previous approach to this problem, I implemented a check whether
the RTC_HOURS register contains a value <= 24. This, however, sometimes
did not work correctly on my Intel Kaby Lake laptop. According to
Intel's documentation [2], "the time and date RAM locations (0-9) are
disconnected from the external bus" during the update cycle so reading
this register without checking the UIP bit is incorrect.

[1] AMD SB700/710/750 Register Reference Guide, page 308,
https://developer.amd.com/wordpress/media/2012/10/43009_sb7xx_rrg_pub_1.00.pdf

[2] 7th Generation Intel ® Processor Family I/O for U/Y Platforms [...] Datasheet
Volume 1 of 2, page 209
Intel's Document Number: 334658-006,
https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/7th-and-8th-gen-core-family-mobile-u-y-processor-lines-i-o-datasheet-vol-1.pdf

Fixes: 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs")
Fixes: ebb22a059436 ("rtc: mc146818: Dont test for bit 0-5 in Register D")
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: stable@vger.kernel.org

---

Hello,
Please check this commit carefully as the RTC is a finicky beast and I'm
quite new to kernel development.

I have tested this on three computers, though, and found no problems.
Also, using the UIP (Update-in-progress) bit should be safe.

Greetings,
Mateusz

 drivers/rtc/rtc-cmos.c         | 10 ++++------
 drivers/rtc/rtc-mc146818-lib.c | 34 ++++++++++++++++++++++++++++++----
 include/linux/mc146818rtc.h    |  1 +
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 670fd8a2970e..0fa66d1039b9 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -796,16 +796,14 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 
 	rename_region(ports, dev_name(&cmos_rtc.rtc->dev));
 
-	spin_lock_irq(&rtc_lock);
-
-	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
-	if ((CMOS_READ(RTC_VALID) & 0x40) != 0) {
-		spin_unlock_irq(&rtc_lock);
-		dev_warn(dev, "not accessible\n");
+	if (!mc146818_does_rtc_work()) {
+		dev_warn(dev, "broken or not accessible\n");
 		retval = -ENXIO;
 		goto cleanup1;
 	}
 
+	spin_lock_irq(&rtc_lock);
+
 	if (!(flags & CMOS_RTC_FLAGS_NOFREQ)) {
 		/* force periodic irq to CMOS reset default of 1024Hz;
 		 *
diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index dcfaf09946ee..9175e11baf26 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -8,10 +8,35 @@
 #include <linux/acpi.h>
 #endif
 
+/*
+ * If the UIP (Update-in-progress) bit of the RTC is set for more then
+ * 10ms, the RTC apparently is broken or not present.
+ */
+unsigned int mc146818_does_rtc_work(void)
+{
+	int i;
+	unsigned char val;
+	unsigned long flags;
+
+	for (i = 0; i < 20; i++) {
+		spin_lock_irqsave(&rtc_lock, flags);
+		val = CMOS_READ(RTC_FREQ_SELECT);
+		spin_unlock_irqrestore(&rtc_lock, flags);
+
+		if ((val & RTC_UIP) == 0)
+			return 1;
+
+		udelay(500);
+	}
+
+	return 0;
+}
+
 unsigned int mc146818_get_time(struct rtc_time *time)
 {
 	unsigned char ctrl;
 	unsigned long flags;
+	unsigned int iter_count = 0;
 	unsigned char century = 0;
 	bool retry;
 
@@ -20,13 +45,14 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 #endif
 
 again:
-	spin_lock_irqsave(&rtc_lock, flags);
-	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
-	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x40) != 0)) {
-		spin_unlock_irqrestore(&rtc_lock, flags);
+	if (iter_count > 10) {
+		pr_err_ratelimited("Unable to read current time from RTC\n");
 		memset(time, 0xff, sizeof(*time));
 		return 0;
 	}
+	iter_count++;
+
+	spin_lock_irqsave(&rtc_lock, flags);
 
 	/*
 	 * Check whether there is an update in progress during which the
diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index 0661af17a758..046a03df1e56 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -123,6 +123,7 @@ struct cmos_rtc_board_info {
 #define RTC_IO_EXTENT_USED      RTC_IO_EXTENT
 #endif /* ARCH_RTC_LOCATION */
 
+unsigned int mc146818_does_rtc_work(void);
 unsigned int mc146818_get_time(struct rtc_time *time);
 int mc146818_set_time(struct rtc_time *time);
 
-- 
2.25.1

