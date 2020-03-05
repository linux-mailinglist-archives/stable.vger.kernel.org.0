Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D6917AC98
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgCEROc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:14:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgCEROb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D319621739;
        Thu,  5 Mar 2020 17:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428470;
        bh=aTdpUfC9CqY/wB251UlTwSnnH+oYCQX5mXBrUSe7RY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/QmWYthf+1g71e7SFwDVITcuGtx6jopsmB0d3xhjIkY0UjA3tA8OUTcupzoaZBCB
         WQXpJXXmt3cUwOVTjt1HkRlpVkcbKOI0BI0lZv9VefE0a63Bf2+fWHab6UL7Iwr+IN
         WJGLU9a22lPx1Pa7ufk2Y4LWk4fyyRBL9geyz7Gw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/58] ACPI: watchdog: Set default timeout in probe
Date:   Thu,  5 Mar 2020 12:13:29 -0500
Message-Id: <20200305171420.29595-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e7cf41aa26c3b..697b04ffee97c 100644
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

