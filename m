Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF94F66C7FE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbjAPQgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbjAPQff (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:35:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947AC30E8C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:23:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D47960FE0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32068C433EF;
        Mon, 16 Jan 2023 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886206;
        bh=WvL5M0K1N4qjUaW1n/ifDcnYtufaLBigsuYu6pbp7jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXac7QFL0MKwSEzTwymFkKrGAL9xtuOMHuvkj6FZhnCoPRO3K7P+3dLFFCFSbgCeM
         K8EnmFPaL69tUWga0ab9dg8bF1PnIZBJ1WytCeNPQGz1Ur6CyeOvCTiR8MZRqHmYCb
         H4FkyNrzPRVKpNZQruuWQTRF5MGfVQUCSEDDwhI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 342/658] rtc: cmos: Call cmos_wake_setup() from cmos_do_probe()
Date:   Mon, 16 Jan 2023 16:47:10 +0100
Message-Id: <20230116154925.194225200@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit 508ccdfb86b21da37ad091003a4d4567709d5dfb ]

Notice that cmos_wake_setup() is the only user of acpi_rtc_info and it
can operate on the cmos_rtc variable directly, so it need not set the
platform_data pointer before cmos_do_probe() is called.  Instead, it
can be called by cmos_do_probe() in the case when the platform_data
pointer is not set to implement the default behavior (which is to use
the FADT information as long as ACPI support is enabled).

Modify the code accordingly.

While at it, drop a comment that doesn't really match the code it is
supposed to be describing.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/4803444.31r3eYUQgx@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 47 ++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 3e9168cfbe5c..fa0098390315 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -698,6 +698,8 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 		return IRQ_NONE;
 }
 
+static void cmos_wake_setup(struct device *dev);
+
 #ifdef	CONFIG_PNP
 #define	INITSECTION
 
@@ -781,19 +783,27 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		if (info->address_space)
 			address_space = info->address_space;
 
-		if (info->rtc_day_alarm && info->rtc_day_alarm < 128)
-			cmos_rtc.day_alrm = info->rtc_day_alarm;
-		if (info->rtc_mon_alarm && info->rtc_mon_alarm < 128)
-			cmos_rtc.mon_alrm = info->rtc_mon_alarm;
-		if (info->rtc_century && info->rtc_century < 128)
-			cmos_rtc.century = info->rtc_century;
+		cmos_rtc.day_alrm = info->rtc_day_alarm;
+		cmos_rtc.mon_alrm = info->rtc_mon_alarm;
+		cmos_rtc.century = info->rtc_century;
 
 		if (info->wake_on && info->wake_off) {
 			cmos_rtc.wake_on = info->wake_on;
 			cmos_rtc.wake_off = info->wake_off;
 		}
+	} else {
+		cmos_wake_setup(dev);
 	}
 
+	if (cmos_rtc.day_alrm >= 128)
+		cmos_rtc.day_alrm = 0;
+
+	if (cmos_rtc.mon_alrm >= 128)
+		cmos_rtc.mon_alrm = 0;
+
+	if (cmos_rtc.century >= 128)
+		cmos_rtc.century = 0;
+
 	cmos_rtc.dev = dev;
 	dev_set_drvdata(dev, &cmos_rtc);
 
@@ -1218,13 +1228,6 @@ static void use_acpi_alarm_quirks(void)
 static inline void use_acpi_alarm_quirks(void) { }
 #endif
 
-/* Every ACPI platform has a mc146818 compatible "cmos rtc".  Here we find
- * its device node and pass extra config data.  This helps its driver use
- * capabilities that the now-obsolete mc146818 didn't have, and informs it
- * that this board's RTC is wakeup-capable (per ACPI spec).
- */
-static struct cmos_rtc_board_info acpi_rtc_info;
-
 static void cmos_wake_setup(struct device *dev)
 {
 	if (acpi_disabled)
@@ -1232,26 +1235,23 @@ static void cmos_wake_setup(struct device *dev)
 
 	use_acpi_alarm_quirks();
 
-	acpi_rtc_info.wake_on = rtc_wake_on;
-	acpi_rtc_info.wake_off = rtc_wake_off;
+	cmos_rtc.wake_on = rtc_wake_on;
+	cmos_rtc.wake_off = rtc_wake_off;
 
-	/* workaround bug in some ACPI tables */
+	/* ACPI tables bug workaround. */
 	if (acpi_gbl_FADT.month_alarm && !acpi_gbl_FADT.day_alarm) {
 		dev_dbg(dev, "bogus FADT month_alarm (%d)\n",
 			acpi_gbl_FADT.month_alarm);
 		acpi_gbl_FADT.month_alarm = 0;
 	}
 
-	acpi_rtc_info.rtc_day_alarm = acpi_gbl_FADT.day_alarm;
-	acpi_rtc_info.rtc_mon_alarm = acpi_gbl_FADT.month_alarm;
-	acpi_rtc_info.rtc_century = acpi_gbl_FADT.century;
+	cmos_rtc.day_alrm = acpi_gbl_FADT.day_alarm;
+	cmos_rtc.mon_alrm = acpi_gbl_FADT.month_alarm;
+	cmos_rtc.century = acpi_gbl_FADT.century;
 
-	/* NOTE:  S4_RTC_WAKE is NOT currently useful to Linux */
 	if (acpi_gbl_FADT.flags & ACPI_FADT_S4_RTC_WAKE)
 		dev_info(dev, "RTC can wake from S4\n");
 
-	dev->platform_data = &acpi_rtc_info;
-
 	/* RTC always wakes from S1/S2/S3, and often S4/STD */
 	device_init_wakeup(dev, 1);
 }
@@ -1302,8 +1302,6 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
 	int irq, ret;
 
-	cmos_wake_setup(&pnp->dev);
-
 	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0)) {
 		irq = 0;
 #ifdef CONFIG_X86
@@ -1411,7 +1409,6 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	int irq, ret;
 
 	cmos_of_init(pdev);
-	cmos_wake_setup(&pdev->dev);
 
 	if (RTC_IOMAPPED)
 		resource = platform_get_resource(pdev, IORESOURCE_IO, 0);
-- 
2.35.1



