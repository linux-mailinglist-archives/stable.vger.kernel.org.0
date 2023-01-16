Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C7A66CB1D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbjAPRKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbjAPRKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:10:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A0D49000
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:50:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20D8BB8109B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C053C433D2;
        Mon, 16 Jan 2023 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887828;
        bh=akRekDFSL9afJ0aif6t3Tp1GFEFPz42mOjQK4fwmt0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tc59yG6D6a2Qh9NyHCDlP4GddlNh7dm4rFBWJFWAOl5d0jqdOaJElSx/t7KUmFwfC
         CkexEQsZORw6Tn3n49ws42pDM2dGyxLkwRfy1wE9FSm4RKcEt4AMuBzOQTNyON5ahM
         55bRWRSqGLzkkOJKgbxe2gZvHU8pVzZ5FMyYSEUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mel Gorman <mgorman@techsingularity.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 267/521] rtc: cmos: Fix event handler registration ordering issue
Date:   Mon, 16 Jan 2023 16:48:49 +0100
Message-Id: <20230116154859.093707216@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index c7f6088ef91f..7962cdd933f9 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1299,10 +1299,10 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 
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
@@ -1311,13 +1311,17 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 		if (nr_legacy_irqs())
 			irq = 8;
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
@@ -1401,10 +1405,9 @@ static inline void cmos_of_init(struct platform_device *pdev) {}
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
 	struct resource *resource;
-	int irq;
+	int irq, ret;
 
 	cmos_of_init(pdev);
-	cmos_wake_setup(&pdev->dev);
 
 	if (RTC_IOMAPPED)
 		resource = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -1414,7 +1417,13 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
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



