Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9A66CAFA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbjAPRJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbjAPRI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:08:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763B3265A0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C098CCE1292
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D870C433EF;
        Mon, 16 Jan 2023 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887758;
        bh=Es2s7Szlp0TPPkZi3EfucYn76l0sHz9mSA4KF5+Hx2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oD/7jtCjvxlvVFmG7PmokcrezlQ5xXPmjXNF82+SWyA+rvErSwDmCDeN+p79Q+cT6
         ZOpVHPvA0D+Bz6u6G8B3101Vf+7ywN4ozvxgZqCMtV6Pp5W1SBm3sLZ07Q5s9El/nD
         bSkLawxStYFh1HMfLzlPAb/F5YH04YV7WTqZqHDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 271/521] rtc: cmos: Call rtc_wake_setup() from cmos_do_probe()
Date:   Mon, 16 Jan 2023 16:48:53 +0100
Message-Id: <20230116154859.264819724@linuxfoundation.org>
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

[ Upstream commit 375bbba09692fe4c5218eddee8e312dd733fa846 ]

To reduce code duplication, move the invocation of rtc_wake_setup()
into cmos_do_probe() and simplify the callers of the latter.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/2143522.irdbgypaU6@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index c51f6450daf2..91205797bd0f 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -702,6 +702,7 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 		return IRQ_NONE;
 }
 
+static inline void rtc_wake_setup(struct device *dev);
 static void cmos_wake_setup(struct device *dev);
 
 #ifdef	CONFIG_PNP
@@ -889,6 +890,13 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	if (rtc_nvmem_register(cmos_rtc.rtc, &nvmem_cfg))
 		dev_err(dev, "nvmem registration failed\n");
 
+	/*
+	 * Everything has gone well so far, so by default register a handler for
+	 * the ACPI RTC fixed event.
+	 */
+	if (!info)
+		rtc_wake_setup(dev);
+
 	dev_info(dev, "%s%s, %d bytes nvram%s\n",
 		 !is_valid_irq(rtc_irq) ? "no alarms" :
 		 cmos_rtc.mon_alrm ? "alarms up to one year" :
@@ -1304,7 +1312,7 @@ static void rtc_wake_setup(struct device *dev)
 
 static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
-	int irq, ret;
+	int irq;
 
 	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0)) {
 		irq = 0;
@@ -1320,13 +1328,7 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 		irq = pnp_irq(pnp, 0);
 	}
 
-	ret = cmos_do_probe(&pnp->dev, pnp_get_resource(pnp, IORESOURCE_IO, 0), irq);
-	if (ret)
-		return ret;
-
-	rtc_wake_setup(&pnp->dev);
-
-	return 0;
+	return cmos_do_probe(&pnp->dev, pnp_get_resource(pnp, IORESOURCE_IO, 0), irq);
 }
 
 static void cmos_pnp_remove(struct pnp_dev *pnp)
@@ -1410,7 +1412,7 @@ static inline void cmos_of_init(struct platform_device *pdev) {}
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
 	struct resource *resource;
-	int irq, ret;
+	int irq;
 
 	cmos_of_init(pdev);
 
@@ -1422,13 +1424,7 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	if (irq < 0)
 		irq = -1;
 
-	ret = cmos_do_probe(&pdev->dev, resource, irq);
-	if (ret)
-		return ret;
-
-	rtc_wake_setup(&pdev->dev);
-
-	return 0;
+	return cmos_do_probe(&pdev->dev, resource, irq);
 }
 
 static int cmos_platform_remove(struct platform_device *pdev)
-- 
2.35.1



