Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4725D531AA5
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241201AbiEWRai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242980AbiEWR2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0718B8DDCF;
        Mon, 23 May 2022 10:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4497CB80FF4;
        Mon, 23 May 2022 17:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC88C385A9;
        Mon, 23 May 2022 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326699;
        bh=8C4PATx0O8Jqsari8A1PCzDaVw8WREZnXuzovcN9IPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wv2rH1WD3yL0QR3bgKS6I4dqQWJZW6viNVYb0eMpV/7kjr2xXjkvSlOd/8s5BvZnA
         dQ6QF3bRL8dvDZeUKcdwscjGCZ0PIqQjC/pyyPgtr7TF5m8m3Msa35j9IgEn1aE0WS
         6liMOl8vY03Vtih6Q8DFlpvltltz61UhpHQrvOag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@amd.com>,
        Terry Bowman <terry.bowman@amd.com>,
        Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 012/158] Watchdog: sp5100_tco: Move timer initialization into function
Date:   Mon, 23 May 2022 19:02:49 +0200
Message-Id: <20220523165832.639720507@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Terry Bowman <terry.bowman@amd.com>

commit abd71a948f7aab47ca49d3e7fe6afa6c48c8aae0 upstream.

Refactor driver's timer initialization into new function. This is needed
inorder to support adding new device layouts while using common timer
initialization.

Co-developed-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Tested-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220202153525.1693378-2-terry.bowman@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/sp5100_tco.c |   65 +++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -223,6 +223,41 @@ static u32 sp5100_tco_read_pm_reg32(u8 i
 	return val;
 }
 
+static int sp5100_tco_timer_init(struct sp5100_tco *tco)
+{
+	struct watchdog_device *wdd = &tco->wdd;
+	struct device *dev = wdd->parent;
+	u32 val;
+
+	val = readl(SP5100_WDT_CONTROL(tco->tcobase));
+	if (val & SP5100_WDT_DISABLED) {
+		dev_err(dev, "Watchdog hardware is disabled\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Save WatchDogFired status, because WatchDogFired flag is
+	 * cleared here.
+	 */
+	if (val & SP5100_WDT_FIRED)
+		wdd->bootstatus = WDIOF_CARDRESET;
+
+	/* Set watchdog action to reset the system */
+	val &= ~SP5100_WDT_ACTION_RESET;
+	writel(val, SP5100_WDT_CONTROL(tco->tcobase));
+
+	/* Set a reasonable heartbeat before we stop the timer */
+	tco_timer_set_timeout(wdd, wdd->timeout);
+
+	/*
+	 * Stop the TCO before we change anything so we don't race with
+	 * a zeroed timer.
+	 */
+	tco_timer_stop(wdd);
+
+	return 0;
+}
+
 static int sp5100_tco_setupdevice(struct device *dev,
 				  struct watchdog_device *wdd)
 {
@@ -348,35 +383,7 @@ static int sp5100_tco_setupdevice(struct
 	/* Setup the watchdog timer */
 	tco_timer_enable(tco);
 
-	val = readl(SP5100_WDT_CONTROL(tco->tcobase));
-	if (val & SP5100_WDT_DISABLED) {
-		dev_err(dev, "Watchdog hardware is disabled\n");
-		ret = -ENODEV;
-		goto unreg_region;
-	}
-
-	/*
-	 * Save WatchDogFired status, because WatchDogFired flag is
-	 * cleared here.
-	 */
-	if (val & SP5100_WDT_FIRED)
-		wdd->bootstatus = WDIOF_CARDRESET;
-	/* Set watchdog action to reset the system */
-	val &= ~SP5100_WDT_ACTION_RESET;
-	writel(val, SP5100_WDT_CONTROL(tco->tcobase));
-
-	/* Set a reasonable heartbeat before we stop the timer */
-	tco_timer_set_timeout(wdd, wdd->timeout);
-
-	/*
-	 * Stop the TCO before we change anything so we don't race with
-	 * a zeroed timer.
-	 */
-	tco_timer_stop(wdd);
-
-	release_region(SP5100_IO_PM_INDEX_REG, SP5100_PM_IOPORTS_SIZE);
-
-	return 0;
+	ret = sp5100_tco_timer_init(tco);
 
 unreg_region:
 	release_region(SP5100_IO_PM_INDEX_REG, SP5100_PM_IOPORTS_SIZE);


