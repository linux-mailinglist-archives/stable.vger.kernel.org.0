Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CD218B5D5
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgCSNV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729693AbgCSNV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:21:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E917520724;
        Thu, 19 Mar 2020 13:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624115;
        bh=zgySPb/E5gCYbNyNWaUW3DElJALVpsCE/f+L4by2fjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMOQsCxYlNmwNt6IyfJpzPN3Pe5lCMIGLJQjZr2YkWnFitmK8frfRAPOv8dXRwxxl
         75K9KHyNFgeq744b+iyCbpB9sg/m8+umZiSDgKOdWoHCqCm3HwtTntm8eo81LHxOWH
         t6jn5PW2gslE0x7sc5ZXN+Xnppvo43r9wRhN1bR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/60] ACPI: watchdog: Set default timeout in probe
Date:   Thu, 19 Mar 2020 14:03:50 +0100
Message-Id: <20200319123922.971713751@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit cabe17d0173ab04bd3f87b8199ae75f43f1ea473 ]

If the BIOS default timeout for the watchdog is too small userspace may
not have enough time to configure new timeout after opening the device
before the system is already reset. For this reason program default
timeout of 30 seconds in the driver probe and allow userspace to change
this from command line or through module parameter (wdat_wdt.timeout).

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/wdat_wdt.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/watchdog/wdat_wdt.c b/drivers/watchdog/wdat_wdt.c
index 1ce39de917f0e..88c5e6361aa05 100644
--- a/drivers/watchdog/wdat_wdt.c
+++ b/drivers/watchdog/wdat_wdt.c
@@ -54,6 +54,13 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+#define WDAT_DEFAULT_TIMEOUT	30
+
+static int timeout = WDAT_DEFAULT_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (default="
+		 __MODULE_STRING(WDAT_DEFAULT_TIMEOUT) ")");
+
 static int wdat_wdt_read(struct wdat_wdt *wdat,
 	 const struct wdat_instruction *instr, u32 *value)
 {
@@ -438,6 +445,22 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, wdat);
 
+	/*
+	 * Set initial timeout so that userspace has time to configure the
+	 * watchdog properly after it has opened the device. In some cases
+	 * the BIOS default is too short and causes immediate reboot.
+	 */
+	if (timeout * 1000 < wdat->wdd.min_hw_heartbeat_ms ||
+	    timeout * 1000 > wdat->wdd.max_hw_heartbeat_ms) {
+		dev_warn(dev, "Invalid timeout %d given, using %d\n",
+			 timeout, WDAT_DEFAULT_TIMEOUT);
+		timeout = WDAT_DEFAULT_TIMEOUT;
+	}
+
+	ret = wdat_wdt_set_timeout(&wdat->wdd, timeout);
+	if (ret)
+		return ret;
+
 	watchdog_set_nowayout(&wdat->wdd, nowayout);
 	return devm_watchdog_register_device(dev, &wdat->wdd);
 }
-- 
2.20.1



