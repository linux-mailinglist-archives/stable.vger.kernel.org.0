Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681B7157C18
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgBJNeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:34:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgBJMfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:25 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8265620661;
        Mon, 10 Feb 2020 12:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338124;
        bh=ORUBw7O67TyN1UqRgeVdqFmlZz/TLP7kWLLyPL5R8lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkNZ/BsSzpLwi7fUtdJq8pZSqB/CWVrtCwcJbag/aahLRGIWR+oNnQ7EDvP2g24QN
         zoJNAEMDRcrCetZf4iQB1almh84JH7y64JPYZ89aethnS13AFyoL0NMjhsxIop3e/e
         m2znRM0eS5DPM1lijZlBDsos0AKv/GtMxZTJNEXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 4.19 063/195] alarmtimer: Unregister wakeup source when module get fails
Date:   Mon, 10 Feb 2020 04:32:01 -0800
Message-Id: <20200210122312.019064458@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 6b6d188aae79a630957aefd88ff5c42af6553ee3 upstream.

The alarmtimer_rtc_add_device() function creates a wakeup source and then
tries to grab a module reference. If that fails the function returns early
with an error code, but fails to remove the wakeup source.

Cleanup this exit path so there is no dangling wakeup source, which is
named 'alarmtime' left allocated which will conflict with another RTC
device that may be registered later.

Fixes: 51218298a25e ("alarmtimer: Ensure RTC module is not unloaded")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200109155910.907-2-swboyd@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/alarmtimer.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -91,6 +91,7 @@ static int alarmtimer_rtc_add_device(str
 	unsigned long flags;
 	struct rtc_device *rtc = to_rtc_device(dev);
 	struct wakeup_source *__ws;
+	int ret = 0;
 
 	if (rtcdev)
 		return -EBUSY;
@@ -105,8 +106,8 @@ static int alarmtimer_rtc_add_device(str
 	spin_lock_irqsave(&rtcdev_lock, flags);
 	if (!rtcdev) {
 		if (!try_module_get(rtc->owner)) {
-			spin_unlock_irqrestore(&rtcdev_lock, flags);
-			return -1;
+			ret = -1;
+			goto unlock;
 		}
 
 		rtcdev = rtc;
@@ -115,11 +116,12 @@ static int alarmtimer_rtc_add_device(str
 		ws = __ws;
 		__ws = NULL;
 	}
+unlock:
 	spin_unlock_irqrestore(&rtcdev_lock, flags);
 
 	wakeup_source_unregister(__ws);
 
-	return 0;
+	return ret;
 }
 
 static inline void alarmtimer_rtc_timer_init(void)


