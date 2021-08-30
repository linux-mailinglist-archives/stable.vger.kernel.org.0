Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45E3FBAE2
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 19:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbhH3R1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 13:27:05 -0400
Received: from mx-out.tlen.pl ([193.222.135.175]:10429 "EHLO mx-out.tlen.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhH3R1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 13:27:05 -0400
Received: (wp-smtpd smtp.tlen.pl 21362 invoked from network); 30 Aug 2021 19:26:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1630344369; bh=4X/yZ1ojBs7hoJvotzd+ipQiT/uhdl8K5BGgHHVn90E=;
          h=From:To:Cc:Subject;
          b=vpFJMJQytJC6AAnQFOZxfTw4Z8OvHPd3oKpfCGSlEvwHaTe6mxHn4lqL7hlxxg4w7
           J3dknOhukyb7JKqh8/ruZqNbT83N4C6aA68L0SfyAUaPUXo7rYfftEMnCq0qAgap1S
           rZdPuOe0s9Vy7ODGBdDX+XpNYLrUFOuXgVTrbeeM=
Received: from ablt14.neoplus.adsl.tpnet.pl (HELO localhost.localdomain) (mat.jonczyk@o2.pl@[83.7.213.14])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with SMTP
          for <linux-rtc@vger.kernel.org>; 30 Aug 2021 19:26:08 +0200
From:   =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To:     linux-rtc@vger.kernel.org
Cc:     =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH] rtc-cmos: take rtc_lock while accessing CMOS
Date:   Mon, 30 Aug 2021 19:25:41 +0200
Message-Id: <20210830172541.62588-1-mat.jonczyk@o2.pl>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: ac92081073b4ea01d3161b4d615bbfe1
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [QfMk]                               
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reading from the CMOS involves writing to the index register and then
reading from the data register. Therefore access to the CMOS has to be
serialized with a spinlock. An invocation in cmos_set_alarm was not
serialized with rtc_lock, fix this.

Use spin_lock_irq() like the rest of the function.

Nothing in kernel modifies the RTC_DM_BINARY bit, so use a separate pair
of spin_lock_irq() / spin_unlock_irq() before doing the math.

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: stable@vger.kernel.org
---
 drivers/rtc/rtc-cmos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 0fa66d1039b9..e6ff0fb7591b 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -463,7 +463,10 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	min = t->time.tm_min;
 	sec = t->time.tm_sec;
 
+	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
+	spin_unlock_irq(&rtc_lock);
+
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		/* Writing 0xff means "don't care" or "match all".  */
 		mon = (mon <= 12) ? bin2bcd(mon) : 0xff;
-- 
2.25.1

