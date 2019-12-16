Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67DB1121404
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfLPSHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730132AbfLPSHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:07:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 400D32072B;
        Mon, 16 Dec 2019 18:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519637;
        bh=jdLXzefjyg12GC+3pcA3MEYa1/IjbOx/xkJKHuQBapo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/FhIFkn2mLYRwiKBACG/gfLfIVFAKgttxWxRsFaJEXO89LDIHPE8p43xJPYM2qlI
         C15qvvzJAES0GkKEC5rvQ8inkZ9NGVinh8wFCdsmAfnxIRleaH0UrUyI73wgLEBwiZ
         WLJnods65i0VTJDcYRpdDxUya3xcCD/+dk3AaGck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+08116743f8ad6f9a6de7@syzkaller.appspotmail.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 4.19 134/140] rtc: disable uie before setting time and enable after
Date:   Mon, 16 Dec 2019 18:50:02 +0100
Message-Id: <20191216174828.973357613@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit 7e7c005b4b1f1f169bcc4b2c3a40085ecc663df2 upstream.

When setting the time in the future with the uie timer enabled,
rtc_timer_do_work will loop for a while because the expiration of the uie
timer was way before the current RTC time and a new timer will be enqueued
until the current rtc time is reached.

If the uie timer is enabled, disable it before setting the time and enable
it after expiring current timers (which may actually be an alarm).

This is the safest thing to do to ensure the uie timer is still
synchronized with the RTC, especially in the UIE emulation case.

Reported-by: syzbot+08116743f8ad6f9a6de7@syzkaller.appspotmail.com
Fixes: 6610e0893b8b ("RTC: Rework RTC code to use timerqueue for events")
Link: https://lore.kernel.org/r/20191020231320.8191-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/interface.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -127,7 +127,7 @@ EXPORT_SYMBOL_GPL(rtc_read_time);
 
 int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 {
-	int err;
+	int err, uie;
 
 	err = rtc_valid_tm(tm);
 	if (err != 0)
@@ -139,6 +139,17 @@ int rtc_set_time(struct rtc_device *rtc,
 
 	rtc_subtract_offset(rtc, tm);
 
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+	uie = rtc->uie_rtctimer.enabled || rtc->uie_irq_active;
+#else
+	uie = rtc->uie_rtctimer.enabled;
+#endif
+	if (uie) {
+		err = rtc_update_irq_enable(rtc, 0);
+		if (err)
+			return err;
+	}
+
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return err;
@@ -162,6 +173,12 @@ int rtc_set_time(struct rtc_device *rtc,
 	/* A timer might have just expired */
 	schedule_work(&rtc->irqwork);
 
+	if (uie) {
+		err = rtc_update_irq_enable(rtc, 1);
+		if (err)
+			return err;
+	}
+
 	trace_rtc_set_time(rtc_tm_to_time64(tm), err);
 	return err;
 }


