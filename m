Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0AA6667647
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbjALOae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237651AbjALO3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:29:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A5F5D880
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:21:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 826B761F4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CD3C433EF;
        Thu, 12 Jan 2023 14:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533267;
        bh=U4JW3Wc00mfZytz+cDbBTS0bFAOki9WIfvlbdV3IxIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDT7QeGJJt2/iHIsoxnlicWcb1f2qDpJneFihMaR/jOhB/vzb1x9/TroGzNEKExs4
         m7MoVxxC0uaMMIsGnvKc7HFCqogr8lBbCTsFFUBLCfkSapuDX0EYej3/65HGGUh+S6
         zD0xRGkVHlo70U0U7dDmlxUyIqkb4i3BgfdbFbCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/783] rtc: cmos: Eliminate forward declarations of some functions
Date:   Thu, 12 Jan 2023 14:52:19 +0100
Message-Id: <20230112135543.929244728@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit dca4d3b71c8a09a16951add656711fbd6f5bfbb0 ]

Reorder the ACPI-related code before cmos_do_probe() so as to eliminate
excessive forward declarations of some functions.

While at it, for consistency, add the inline modifier to the
definitions of empty stub static funtions and remove it from the
corresponding definitions of functions with non-empty bodies.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/13157911.uLZWGnKmhe@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 304 ++++++++++++++++++++---------------------
 1 file changed, 149 insertions(+), 155 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 445089cad471..541cdae587eb 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -750,8 +750,155 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 		return IRQ_NONE;
 }
 
-static inline void rtc_wake_setup(struct device *dev);
-static void cmos_wake_setup(struct device *dev);
+#ifdef	CONFIG_ACPI
+
+#include <linux/acpi.h>
+
+static u32 rtc_handler(void *context)
+{
+	struct device *dev = context;
+	struct cmos_rtc *cmos = dev_get_drvdata(dev);
+	unsigned char rtc_control = 0;
+	unsigned char rtc_intr;
+	unsigned long flags;
+
+
+	/*
+	 * Always update rtc irq when ACPI is used as RTC Alarm.
+	 * Or else, ACPI SCI is enabled during suspend/resume only,
+	 * update rtc irq in that case.
+	 */
+	if (cmos_use_acpi_alarm())
+		cmos_interrupt(0, (void *)cmos->rtc);
+	else {
+		/* Fix me: can we use cmos_interrupt() here as well? */
+		spin_lock_irqsave(&rtc_lock, flags);
+		if (cmos_rtc.suspend_ctrl)
+			rtc_control = CMOS_READ(RTC_CONTROL);
+		if (rtc_control & RTC_AIE) {
+			cmos_rtc.suspend_ctrl &= ~RTC_AIE;
+			CMOS_WRITE(rtc_control, RTC_CONTROL);
+			rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
+			rtc_update_irq(cmos->rtc, 1, rtc_intr);
+		}
+		spin_unlock_irqrestore(&rtc_lock, flags);
+	}
+
+	pm_wakeup_hard_event(dev);
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
+	return ACPI_INTERRUPT_HANDLED;
+}
+
+static void rtc_wake_setup(struct device *dev)
+{
+	if (acpi_disabled)
+		return;
+
+	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, dev);
+	/*
+	 * After the RTC handler is installed, the Fixed_RTC event should
+	 * be disabled. Only when the RTC alarm is set will it be enabled.
+	 */
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
+}
+
+static void rtc_wake_on(struct device *dev)
+{
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_enable_event(ACPI_EVENT_RTC, 0);
+}
+
+static void rtc_wake_off(struct device *dev)
+{
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
+}
+
+#ifdef CONFIG_X86
+/* Enable use_acpi_alarm mode for Intel platforms no earlier than 2015 */
+static void use_acpi_alarm_quirks(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return;
+
+	if (!is_hpet_enabled())
+		return;
+
+	if (dmi_get_bios_year() < 2015)
+		return;
+
+	use_acpi_alarm = true;
+}
+#else
+static inline void use_acpi_alarm_quirks(void) { }
+#endif
+
+static void cmos_wake_setup(struct device *dev)
+{
+	if (acpi_disabled)
+		return;
+
+	use_acpi_alarm_quirks();
+
+	cmos_rtc.wake_on = rtc_wake_on;
+	cmos_rtc.wake_off = rtc_wake_off;
+
+	/* ACPI tables bug workaround. */
+	if (acpi_gbl_FADT.month_alarm && !acpi_gbl_FADT.day_alarm) {
+		dev_dbg(dev, "bogus FADT month_alarm (%d)\n",
+			acpi_gbl_FADT.month_alarm);
+		acpi_gbl_FADT.month_alarm = 0;
+	}
+
+	cmos_rtc.day_alrm = acpi_gbl_FADT.day_alarm;
+	cmos_rtc.mon_alrm = acpi_gbl_FADT.month_alarm;
+	cmos_rtc.century = acpi_gbl_FADT.century;
+
+	if (acpi_gbl_FADT.flags & ACPI_FADT_S4_RTC_WAKE)
+		dev_info(dev, "RTC can wake from S4\n");
+
+	/* RTC always wakes from S1/S2/S3, and often S4/STD */
+	device_init_wakeup(dev, 1);
+}
+
+static void cmos_check_acpi_rtc_status(struct device *dev,
+					      unsigned char *rtc_control)
+{
+	struct cmos_rtc *cmos = dev_get_drvdata(dev);
+	acpi_event_status rtc_status;
+	acpi_status status;
+
+	if (acpi_gbl_FADT.flags & ACPI_FADT_FIXED_RTC)
+		return;
+
+	status = acpi_get_event_status(ACPI_EVENT_RTC, &rtc_status);
+	if (ACPI_FAILURE(status)) {
+		dev_err(dev, "Could not get RTC status\n");
+	} else if (rtc_status & ACPI_EVENT_FLAG_SET) {
+		unsigned char mask;
+		*rtc_control &= ~RTC_AIE;
+		CMOS_WRITE(*rtc_control, RTC_CONTROL);
+		mask = CMOS_READ(RTC_INTR_FLAGS);
+		rtc_update_irq(cmos->rtc, 1, mask);
+	}
+}
+
+#else /* !CONFIG_ACPI */
+
+static inline void rtc_wake_setup(struct device *dev)
+{
+}
+
+static inline void cmos_wake_setup(struct device *dev)
+{
+}
+
+static inline void cmos_check_acpi_rtc_status(struct device *dev,
+					      unsigned char *rtc_control)
+{
+}
+#endif /* CONFIG_ACPI */
 
 #ifdef	CONFIG_PNP
 #define	INITSECTION
@@ -1145,9 +1292,6 @@ static void cmos_check_wkalrm(struct device *dev)
 	}
 }
 
-static void cmos_check_acpi_rtc_status(struct device *dev,
-				       unsigned char *rtc_control);
-
 static int __maybe_unused cmos_resume(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -1214,156 +1358,6 @@ static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
  * predate even PNPBIOS should set up platform_bus devices.
  */
 
-#ifdef	CONFIG_ACPI
-
-#include <linux/acpi.h>
-
-static u32 rtc_handler(void *context)
-{
-	struct device *dev = context;
-	struct cmos_rtc *cmos = dev_get_drvdata(dev);
-	unsigned char rtc_control = 0;
-	unsigned char rtc_intr;
-	unsigned long flags;
-
-
-	/*
-	 * Always update rtc irq when ACPI is used as RTC Alarm.
-	 * Or else, ACPI SCI is enabled during suspend/resume only,
-	 * update rtc irq in that case.
-	 */
-	if (cmos_use_acpi_alarm())
-		cmos_interrupt(0, (void *)cmos->rtc);
-	else {
-		/* Fix me: can we use cmos_interrupt() here as well? */
-		spin_lock_irqsave(&rtc_lock, flags);
-		if (cmos_rtc.suspend_ctrl)
-			rtc_control = CMOS_READ(RTC_CONTROL);
-		if (rtc_control & RTC_AIE) {
-			cmos_rtc.suspend_ctrl &= ~RTC_AIE;
-			CMOS_WRITE(rtc_control, RTC_CONTROL);
-			rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
-			rtc_update_irq(cmos->rtc, 1, rtc_intr);
-		}
-		spin_unlock_irqrestore(&rtc_lock, flags);
-	}
-
-	pm_wakeup_hard_event(dev);
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
-	return ACPI_INTERRUPT_HANDLED;
-}
-
-static inline void rtc_wake_setup(struct device *dev)
-{
-	if (acpi_disabled)
-		return;
-
-	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, dev);
-	/*
-	 * After the RTC handler is installed, the Fixed_RTC event should
-	 * be disabled. Only when the RTC alarm is set will it be enabled.
-	 */
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
-}
-
-static void rtc_wake_on(struct device *dev)
-{
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_enable_event(ACPI_EVENT_RTC, 0);
-}
-
-static void rtc_wake_off(struct device *dev)
-{
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
-}
-
-#ifdef CONFIG_X86
-/* Enable use_acpi_alarm mode for Intel platforms no earlier than 2015 */
-static void use_acpi_alarm_quirks(void)
-{
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
-		return;
-
-	if (!is_hpet_enabled())
-		return;
-
-	if (dmi_get_bios_year() < 2015)
-		return;
-
-	use_acpi_alarm = true;
-}
-#else
-static inline void use_acpi_alarm_quirks(void) { }
-#endif
-
-static void cmos_wake_setup(struct device *dev)
-{
-	if (acpi_disabled)
-		return;
-
-	use_acpi_alarm_quirks();
-
-	cmos_rtc.wake_on = rtc_wake_on;
-	cmos_rtc.wake_off = rtc_wake_off;
-
-	/* ACPI tables bug workaround. */
-	if (acpi_gbl_FADT.month_alarm && !acpi_gbl_FADT.day_alarm) {
-		dev_dbg(dev, "bogus FADT month_alarm (%d)\n",
-			acpi_gbl_FADT.month_alarm);
-		acpi_gbl_FADT.month_alarm = 0;
-	}
-
-	cmos_rtc.day_alrm = acpi_gbl_FADT.day_alarm;
-	cmos_rtc.mon_alrm = acpi_gbl_FADT.month_alarm;
-	cmos_rtc.century = acpi_gbl_FADT.century;
-
-	if (acpi_gbl_FADT.flags & ACPI_FADT_S4_RTC_WAKE)
-		dev_info(dev, "RTC can wake from S4\n");
-
-	/* RTC always wakes from S1/S2/S3, and often S4/STD */
-	device_init_wakeup(dev, 1);
-}
-
-static void cmos_check_acpi_rtc_status(struct device *dev,
-				       unsigned char *rtc_control)
-{
-	struct cmos_rtc *cmos = dev_get_drvdata(dev);
-	acpi_event_status rtc_status;
-	acpi_status status;
-
-	if (acpi_gbl_FADT.flags & ACPI_FADT_FIXED_RTC)
-		return;
-
-	status = acpi_get_event_status(ACPI_EVENT_RTC, &rtc_status);
-	if (ACPI_FAILURE(status)) {
-		dev_err(dev, "Could not get RTC status\n");
-	} else if (rtc_status & ACPI_EVENT_FLAG_SET) {
-		unsigned char mask;
-		*rtc_control &= ~RTC_AIE;
-		CMOS_WRITE(*rtc_control, RTC_CONTROL);
-		mask = CMOS_READ(RTC_INTR_FLAGS);
-		rtc_update_irq(cmos->rtc, 1, mask);
-	}
-}
-
-#else
-
-static void cmos_wake_setup(struct device *dev)
-{
-}
-
-static void cmos_check_acpi_rtc_status(struct device *dev,
-				       unsigned char *rtc_control)
-{
-}
-
-static void rtc_wake_setup(struct device *dev)
-{
-}
-#endif
-
 #ifdef	CONFIG_PNP
 
 #include <linux/pnp.h>
-- 
2.35.1



