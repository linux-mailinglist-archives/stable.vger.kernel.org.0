Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C851657CFE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiL1PiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiL1PiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:38:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7601164B9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:38:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F30B61553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DEEC433EF;
        Wed, 28 Dec 2022 15:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241891;
        bh=DDk4+06B47Uoq1ujpyTdqwBDT1EF6lfJcHThzqhsqqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1R/mtcqQL/Y8hdOi2YPwaJUPiFTIvterYhL2d4hfqsKXCWKRqYfe0m/6vDeeBayMb
         5vb6TAVVofkbfM0blpDfavTscXzAlYbUCcY0TrGdPZ/j7CpghF1b/Us6V+UR16f58p
         ZdVZKb4PucC8SIaQALyAxff42vmuCuo7IbTz0EGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mel Gorman <mgorman@techsingularity.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 539/731] rtc: cmos: Fix event handler registration ordering issue
Date:   Wed, 28 Dec 2022 15:40:46 +0100
Message-Id: <20221228144312.166908966@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 4919d3eb2ec0ee364f7e3cf2d99646c1b224fae8 ]

Because acpi_install_fixed_event_handler() enables the event
automatically on success, it is incorrect to call it before the
handler routine passed to it is ready to handle events.

Unfortunately, the rtc-cmos driver does exactly the incorrect thing
by calling cmos_wake_setup(), which passes rtc_handler() to
acpi_install_fixed_event_handler(), before cmos_do_probe(), because
rtc_handler() uses dev_get_drvdata() to get to the cmos object
pointer and the driver data pointer is only populated in
cmos_do_probe().

This leads to a NULL pointer dereference in rtc_handler() on boot
if the RTC fixed event happens to be active at the init time.

To address this issue, change the initialization ordering of the
driver so that cmos_wake_setup() is always called after a successful
cmos_do_probe() call.

While at it, change cmos_pnp_probe() to call cmos_do_probe() after
the initial if () statement used for computing the IRQ argument to
be passed to cmos_do_probe() which is cleaner than calling it in
each branch of that if () (local variable "irq" can be of type int,
because it is passed to that function as an argument of type int).

Note that commit 6492fed7d8c9 ("rtc: rtc-cmos: Do not check
ACPI_FADT_LOW_POWER_S0") caused this issue to affect a larger number
of systems, because previously it only affected systems with
ACPI_FADT_LOW_POWER_S0 set, but it is present regardless of that
commit.

Fixes: 6492fed7d8c9 ("rtc: rtc-cmos: Do not check ACPI_FADT_LOW_POWER_S0")
Fixes: a474aaedac99 ("rtc-cmos: move wake setup from ACPI glue into RTC driver")
Link: https://lore.kernel.org/linux-acpi/20221010141630.zfzi7mk7zvnmclzy@techsingularity.net/
Reported-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Mel Gorman <mgorman@techsingularity.net>
Link: https://lore.kernel.org/r/5629262.DvuYhMxLoT@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index bdb1df843c78..610413b4e9ca 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1352,10 +1352,10 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 
 static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
-	cmos_wake_setup(&pnp->dev);
+	int irq, ret;
 
 	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0)) {
-		unsigned int irq = 0;
+		irq = 0;
 #ifdef CONFIG_X86
 		/* Some machines contain a PNP entry for the RTC, but
 		 * don't define the IRQ. It should always be safe to
@@ -1364,13 +1364,17 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 		if (nr_legacy_irqs())
 			irq = RTC_IRQ;
 #endif
-		return cmos_do_probe(&pnp->dev,
-				pnp_get_resource(pnp, IORESOURCE_IO, 0), irq);
 	} else {
-		return cmos_do_probe(&pnp->dev,
-				pnp_get_resource(pnp, IORESOURCE_IO, 0),
-				pnp_irq(pnp, 0));
+		irq = pnp_irq(pnp, 0);
 	}
+
+	ret = cmos_do_probe(&pnp->dev, pnp_get_resource(pnp, IORESOURCE_IO, 0), irq);
+	if (ret)
+		return ret;
+
+	cmos_wake_setup(&pnp->dev);
+
+	return 0;
 }
 
 static void cmos_pnp_remove(struct pnp_dev *pnp)
@@ -1454,10 +1458,9 @@ static inline void cmos_of_init(struct platform_device *pdev) {}
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
 	struct resource *resource;
-	int irq;
+	int irq, ret;
 
 	cmos_of_init(pdev);
-	cmos_wake_setup(&pdev->dev);
 
 	if (RTC_IOMAPPED)
 		resource = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -1467,7 +1470,13 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	if (irq < 0)
 		irq = -1;
 
-	return cmos_do_probe(&pdev->dev, resource, irq);
+	ret = cmos_do_probe(&pdev->dev, resource, irq);
+	if (ret)
+		return ret;
+
+	cmos_wake_setup(&pdev->dev);
+
+	return 0;
 }
 
 static int cmos_platform_remove(struct platform_device *pdev)
-- 
2.35.1



