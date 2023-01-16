Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EF866CB1E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbjAPRKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbjAPRKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:10:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E1D30EA1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:50:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA720B810A0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AA3C433D2;
        Mon, 16 Jan 2023 16:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887831;
        bh=yxEXryx1ynYHLIoPetSylwy7bCEhzogdxA7y0PL1MgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q97G44R8hQS+gYFK9G2IoGwmVhdnYGw27zWM9jieMjnPKtFO0iuNdhIu0vRdfMnQx
         LqqDTk8SszU6SU2dVI5h9NOjWmDVu3Xb7zeCqqgc+w/FOmtwD8JQex1I433kQSPdPw
         IjvTzDcr0MgNLiFQNxee5hyYlH5zdwnQ+MAZ2PAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Rui <rui.zhang@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 268/521] rtc: cmos: Fix wake alarm breakage
Date:   Mon, 16 Jan 2023 16:48:50 +0100
Message-Id: <20230116154859.144942165@linuxfoundation.org>
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
index 7962cdd933f9..d8384f7a7381 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1180,6 +1180,9 @@ static u32 rtc_handler(void *context)
 
 static inline void rtc_wake_setup(struct device *dev)
 {
+	if (acpi_disabled)
+		return;
+
 	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, dev);
 	/*
 	 * After the RTC handler is installed, the Fixed_RTC event should
@@ -1233,7 +1236,6 @@ static void cmos_wake_setup(struct device *dev)
 
 	use_acpi_alarm_quirks();
 
-	rtc_wake_setup(dev);
 	acpi_rtc_info.wake_on = rtc_wake_on;
 	acpi_rtc_info.wake_off = rtc_wake_off;
 
@@ -1301,6 +1303,8 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
 	int irq, ret;
 
+	cmos_wake_setup(&pnp->dev);
+
 	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0)) {
 		irq = 0;
 #ifdef CONFIG_X86
@@ -1319,7 +1323,7 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	if (ret)
 		return ret;
 
-	cmos_wake_setup(&pnp->dev);
+	rtc_wake_setup(&pnp->dev);
 
 	return 0;
 }
@@ -1408,6 +1412,7 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	int irq, ret;
 
 	cmos_of_init(pdev);
+	cmos_wake_setup(&pdev->dev);
 
 	if (RTC_IOMAPPED)
 		resource = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -1421,7 +1426,7 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	cmos_wake_setup(&pdev->dev);
+	rtc_wake_setup(&pdev->dev);
 
 	return 0;
 }
-- 
2.35.1



