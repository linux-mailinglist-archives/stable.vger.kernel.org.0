Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9473966C7FD
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbjAPQgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbjAPQfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:35:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996FF30B29
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:23:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1240DCE1282
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FAAC433D2;
        Mon, 16 Jan 2023 16:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886201;
        bh=DEUpT4ZErLIONqaWmLDcPKHxHhGr9hbLAo3ToBR6jpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vh1ujMTafVXjoGqa4rBFd4+SYMBmAvW5PJqg/FKuWcTZPkBDXGVK7gTfJnGyYn5Dv
         jg95gOaCi42wMJqGkrPC1xCjWmpo3pKfEavLuGSw9q5fioLmG050SJgtr25Ayb9v9W
         O2YT3PW0XVgOR7lwibMIdaYZ3uhKVO4lkVfjjBYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Rui <rui.zhang@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 340/658] rtc: cmos: Fix wake alarm breakage
Date:   Mon, 16 Jan 2023 16:47:08 +0100
Message-Id: <20230116154925.096818055@linuxfoundation.org>
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

[ Upstream commit 0782b66ed2fbb035dda76111df0954515e417b24 ]

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
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5ba7de382ab2..e5f752ce28f9 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1176,6 +1176,9 @@ static u32 rtc_handler(void *context)
 
 static inline void rtc_wake_setup(struct device *dev)
 {
+	if (acpi_disabled)
+		return;
+
 	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, dev);
 	/*
 	 * After the RTC handler is installed, the Fixed_RTC event should
@@ -1229,7 +1232,6 @@ static void cmos_wake_setup(struct device *dev)
 
 	use_acpi_alarm_quirks();
 
-	rtc_wake_setup(dev);
 	acpi_rtc_info.wake_on = rtc_wake_on;
 	acpi_rtc_info.wake_off = rtc_wake_off;
 
@@ -1297,6 +1299,8 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
 	int irq, ret;
 
+	cmos_wake_setup(&pnp->dev);
+
 	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0)) {
 		irq = 0;
 #ifdef CONFIG_X86
@@ -1315,7 +1319,7 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	if (ret)
 		return ret;
 
-	cmos_wake_setup(&pnp->dev);
+	rtc_wake_setup(&pnp->dev);
 
 	return 0;
 }
@@ -1404,6 +1408,7 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	int irq, ret;
 
 	cmos_of_init(pdev);
+	cmos_wake_setup(&pdev->dev);
 
 	if (RTC_IOMAPPED)
 		resource = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -1417,7 +1422,7 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	cmos_wake_setup(&pdev->dev);
+	rtc_wake_setup(&pdev->dev);
 
 	return 0;
 }
-- 
2.35.1



