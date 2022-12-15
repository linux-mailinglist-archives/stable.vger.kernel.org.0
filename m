Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA09264E071
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiLOSOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiLOSNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:13:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931FF49B79
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D89E9B81B0B
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EA4C433EF;
        Thu, 15 Dec 2022 18:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127992;
        bh=EhtRQwmiTIg3YPCxEKm2JhGqN9VZcD67HLkWR4mRl9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stSZO09Wjq/LnqsPqMf88Z5QwsW6m/LjQRRFU77lBFlhlQOQrpkOG5xhzcLPdXzXh
         S18c498CZolz9bK/LObfZhjfZUzXOvWcNf0yevYoevJeFcbG3xN8ckCDQDTEh/bWUj
         bM8leINR+AdpKJNGh3Rfmur8EGDQPFdzaAmz58ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Rui <rui.zhang@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.0 02/16] rtc: cmos: Fix wake alarm breakage
Date:   Thu, 15 Dec 2022 19:10:46 +0100
Message-Id: <20221215172908.275219856@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
References: <20221215172908.162858817@linuxfoundation.org>
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

commit 0782b66ed2fbb035dda76111df0954515e417b24 upstream.

Commit 4919d3eb2ec0 ("rtc: cmos: Fix event handler registration
ordering issue") overlooked the fact that cmos_do_probe() depended
on the preparations carried out by cmos_wake_setup() and the wake
alarm stopped working after the ordering of them had been changed.

Address this by partially reverting commit 4919d3eb2ec0 so that
cmos_wake_setup() is called before cmos_do_probe() again and moving
the rtc_wake_setup() invocation from cmos_wake_setup() directly to the
callers of cmos_do_probe() where it will happen after a successful
completion of the latter.

Fixes: 4919d3eb2ec0 ("rtc: cmos: Fix event handler registration ordering issue")
Reported-by: Zhang Rui <rui.zhang@intel.com>
Reported-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/5887691.lOV4Wx5bFT@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-cmos.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1233,6 +1233,9 @@ static u32 rtc_handler(void *context)
 
 static inline void rtc_wake_setup(struct device *dev)
 {
+	if (acpi_disabled)
+		return;
+
 	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, dev);
 	/*
 	 * After the RTC handler is installed, the Fixed_RTC event should
@@ -1286,7 +1289,6 @@ static void cmos_wake_setup(struct devic
 
 	use_acpi_alarm_quirks();
 
-	rtc_wake_setup(dev);
 	acpi_rtc_info.wake_on = rtc_wake_on;
 	acpi_rtc_info.wake_off = rtc_wake_off;
 
@@ -1354,6 +1356,8 @@ static int cmos_pnp_probe(struct pnp_dev
 {
 	int irq, ret;
 
+	cmos_wake_setup(&pnp->dev);
+
 	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0)) {
 		irq = 0;
 #ifdef CONFIG_X86
@@ -1372,7 +1376,7 @@ static int cmos_pnp_probe(struct pnp_dev
 	if (ret)
 		return ret;
 
-	cmos_wake_setup(&pnp->dev);
+	rtc_wake_setup(&pnp->dev);
 
 	return 0;
 }
@@ -1461,6 +1465,7 @@ static int __init cmos_platform_probe(st
 	int irq, ret;
 
 	cmos_of_init(pdev);
+	cmos_wake_setup(&pdev->dev);
 
 	if (RTC_IOMAPPED)
 		resource = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -1474,7 +1479,7 @@ static int __init cmos_platform_probe(st
 	if (ret)
 		return ret;
 
-	cmos_wake_setup(&pdev->dev);
+	rtc_wake_setup(&pdev->dev);
 
 	return 0;
 }


