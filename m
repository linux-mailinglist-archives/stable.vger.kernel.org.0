Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6865615DD7A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387571AbgBNP6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388666AbgBNP6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D0C24680;
        Fri, 14 Feb 2020 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695923;
        bh=1cIvgbQumL/bZuCtORG9WNL/02NREKUgNOvzr9i7L+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGI8Ixam+74NrbdeoWBOZbdDwUPkp6ON9tjYbkWSGLGpi/vjnW0ZCGqVXeiyxnY35
         BVpZtXXoi49++WZKp7vEpI3MylLeDn38Vass3CqHGDM4Mz7nz3r/KS15btQ76kS4iK
         +BkAJOUZkZQS4sNofdUnk6CpiJcKrL4kUydHyUI4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 460/542] alarmtimer: Make alarmtimer platform device child of RTC device
Date:   Fri, 14 Feb 2020 10:47:32 -0500
Message-Id: <20200214154854.6746-460-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit c79108bd19a8490315847e0c95ac6526fcd8e770 ]

The alarmtimer_suspend() function will fail if an RTC device is on a bus
such as SPI or i2c and that RTC device registers and probes after
alarmtimer_init() registers and probes the 'alarmtimer' platform device.

This is because system wide suspend suspends devices in the reverse order
of their probe. When alarmtimer_suspend() attempts to program the RTC for a
wakeup it will try to program an RTC device on a bus that has already been
suspended.

Move the alarmtimer device registration to happen when the RTC which is
used for wakeup is registered. Register the 'alarmtimer' platform device as
a child of the RTC device too, so that it can be guaranteed that the RTC
device won't be suspended when alarmtimer_suspend() is called.

Reported-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200124055849.154411-2-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/alarmtimer.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 4b11f0309eee4..b97401f6bc232 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -88,6 +88,7 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 	unsigned long flags;
 	struct rtc_device *rtc = to_rtc_device(dev);
 	struct wakeup_source *__ws;
+	struct platform_device *pdev;
 	int ret = 0;
 
 	if (rtcdev)
@@ -99,9 +100,11 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 		return -1;
 
 	__ws = wakeup_source_register(dev, "alarmtimer");
+	pdev = platform_device_register_data(dev, "alarmtimer",
+					     PLATFORM_DEVID_AUTO, NULL, 0);
 
 	spin_lock_irqsave(&rtcdev_lock, flags);
-	if (!rtcdev) {
+	if (__ws && !IS_ERR(pdev) && !rtcdev) {
 		if (!try_module_get(rtc->owner)) {
 			ret = -1;
 			goto unlock;
@@ -112,10 +115,14 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 		get_device(dev);
 		ws = __ws;
 		__ws = NULL;
+		pdev = NULL;
+	} else {
+		ret = -1;
 	}
 unlock:
 	spin_unlock_irqrestore(&rtcdev_lock, flags);
 
+	platform_device_unregister(pdev);
 	wakeup_source_unregister(__ws);
 
 	return ret;
@@ -876,8 +883,7 @@ static struct platform_driver alarmtimer_driver = {
  */
 static int __init alarmtimer_init(void)
 {
-	struct platform_device *pdev;
-	int error = 0;
+	int error;
 	int i;
 
 	alarmtimer_rtc_timer_init();
@@ -900,15 +906,7 @@ static int __init alarmtimer_init(void)
 	if (error)
 		goto out_if;
 
-	pdev = platform_device_register_simple("alarmtimer", -1, NULL, 0);
-	if (IS_ERR(pdev)) {
-		error = PTR_ERR(pdev);
-		goto out_drv;
-	}
 	return 0;
-
-out_drv:
-	platform_driver_unregister(&alarmtimer_driver);
 out_if:
 	alarmtimer_rtc_interface_remove();
 	return error;
-- 
2.20.1

