Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854BC383265
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240988AbhEQOrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241558AbhEQOpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:45:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 859C2613B0;
        Mon, 17 May 2021 14:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261267;
        bh=3ryTMeDjAtUSDUejj0cVzdtYD63X9CEyOhQPZ6FCQ34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RetrOTNwI4K9YvwAQ14HfTv96USkYD3AgZBcz/M7pr5IBtKwDsaCfL8thVkoijECK
         DbeQA16Y7KERa9cmmW/LBzv37OyCFdUgNMgjGxv19acu69uwwgbkTXLVIJ4nN36Meb
         GlmP/zColEUbU5sTu2ZRZ6TkWftccYQBfEE+1beA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.12 327/363] alarmtimer: Check RTC features instead of ops
Date:   Mon, 17 May 2021 16:03:13 +0200
Message-Id: <20210517140313.662801818@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit e09784a8a751e539dffc94d43bc917b0ac1e934a upstream.

RTC drivers used to leave .set_alarm() NULL in order to signal the RTC
device doesn't support alarms. The drivers are now clearing the
RTC_FEATURE_ALARM bit for that purpose in order to keep the rtc_class_ops
structure const. So now, .set_alarm() is set unconditionally and this
possibly causes the alarmtimer code to select an RTC device that doesn't
support alarms.

Test RTC_FEATURE_ALARM instead of relying on ops->set_alarm to determine
whether alarms are available.

Fixes: 7ae41220ef58 ("rtc: introduce features bitfield")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511014516.563031-1-alexandre.belloni@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/alarmtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -92,7 +92,7 @@ static int alarmtimer_rtc_add_device(str
 	if (rtcdev)
 		return -EBUSY;
 
-	if (!rtc->ops->set_alarm)
+	if (!test_bit(RTC_FEATURE_ALARM, rtc->features))
 		return -1;
 	if (!device_may_wakeup(rtc->dev.parent))
 		return -1;


