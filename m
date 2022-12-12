Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC28649FB3
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiLLNN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiLLNNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:13:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA54BDE
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A47161041
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BDEC433EF;
        Mon, 12 Dec 2022 13:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850818;
        bh=VDMMN/X3/rgqKLca8K03NqXl+Qz2ltK/QYslVrkhiqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQFDOP8rLQWapsI9OfEmrtAc0nXraYvz7uQhElsH8cRmSUvw00xvsOKIPAnC6mgik
         TKipjQ2tlgQVjcx7DawDf7kc6zF4iQ0yrgjv0JFlFNzUPIqrWrRxo84w6mkO1ontgn
         eoOSr92wfRa2BGSk/DnJRD9qYaEJk+PS25C/arUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/106] rtc: mc146818-lib: fix RTC presence check
Date:   Mon, 12 Dec 2022 14:09:39 +0100
Message-Id: <20221212130926.435346556@linuxfoundation.org>
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

[ Upstream commit ea6fa4961aab8f90a8aa03575a98b4bda368d4b6 ]

To prevent an infinite loop in mc146818_get_time(),
commit 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs")
added a check for RTC availability. Together with a later fix, it
checked if bit 6 in register 0x0d is cleared.

This, however, caused a false negative on a motherboard with an AMD
SB710 southbridge; according to the specification [1], bit 6 of register
0x0d of this chipset is a scratchbit. This caused a regression in Linux
5.11 - the RTC was determined broken by the kernel and not used by
rtc-cmos.c [3]. This problem was also reported in Fedora [4].

As a better alternative, check whether the UIP ("Update-in-progress")
bit is set for longer then 10ms. If that is the case, then apparently
the RTC is either absent (and all register reads return 0xff) or broken.
Also limit the number of loop iterations in mc146818_get_time() to 10 to
prevent an infinite loop there.

The functions mc146818_get_time() and mc146818_does_rtc_work() will be
refactored later in this patch series, in order to fix a separate
problem with reading / setting the RTC alarm time. This is done so to
avoid a confusion about what is being fixed when.

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

[3] Functions in arch/x86/kernel/rtc.c apparently were using it.

[4] https://bugzilla.redhat.com/show_bug.cgi?id=1936688

Fixes: 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs")
Fixes: ebb22a059436 ("rtc: mc146818: Dont test for bit 0-5 in Register D")
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211210200131.153887-5-mat.jonczyk@o2.pl
Stable-dep-of: cd17420ebea5 ("rtc: cmos: avoid UIP when writing alarm time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c         | 10 ++++------
 drivers/rtc/rtc-mc146818-lib.c | 34 ++++++++++++++++++++++++++++++----
 include/linux/mc146818rtc.h    |  1 +
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f8358bb2ae31..93ffb9eaf63a 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -807,16 +807,14 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 
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
index 3ae5c690f22b..94df6056c5c0 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -8,10 +8,36 @@
 #include <linux/acpi.h>
 #endif
 
+/*
+ * If the UIP (Update-in-progress) bit of the RTC is set for more then
+ * 10ms, the RTC is apparently broken or not present.
+ */
+bool mc146818_does_rtc_work(void)
+{
+	int i;
+	unsigned char val;
+	unsigned long flags;
+
+	for (i = 0; i < 10; i++) {
+		spin_lock_irqsave(&rtc_lock, flags);
+		val = CMOS_READ(RTC_FREQ_SELECT);
+		spin_unlock_irqrestore(&rtc_lock, flags);
+
+		if ((val & RTC_UIP) == 0)
+			return true;
+
+		mdelay(1);
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(mc146818_does_rtc_work);
+
 unsigned int mc146818_get_time(struct rtc_time *time)
 {
 	unsigned char ctrl;
 	unsigned long flags;
+	unsigned int iter_count = 0;
 	unsigned char century = 0;
 	bool retry;
 
@@ -20,13 +46,13 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 #endif
 
 again:
-	spin_lock_irqsave(&rtc_lock, flags);
-	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
-	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x40) != 0)) {
-		spin_unlock_irqrestore(&rtc_lock, flags);
+	if (iter_count > 10) {
 		memset(time, 0, sizeof(*time));
 		return -EIO;
 	}
+	iter_count++;
+
+	spin_lock_irqsave(&rtc_lock, flags);
 
 	/*
 	 * Check whether there is an update in progress during which the
diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index 1e0205811394..c246ce191915 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -125,6 +125,7 @@ struct cmos_rtc_board_info {
 #define RTC_IO_EXTENT_USED      RTC_IO_EXTENT
 #endif /* ARCH_RTC_LOCATION */
 
+bool mc146818_does_rtc_work(void);
 unsigned int mc146818_get_time(struct rtc_time *time);
 int mc146818_set_time(struct rtc_time *time);
 
-- 
2.35.1



