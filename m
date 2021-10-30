Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7EB440BED
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 23:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhJ3Vtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 17:49:52 -0400
Received: from mx-out.tlen.pl ([193.222.135.142]:53517 "EHLO mx-out.tlen.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbhJ3Vtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 17:49:51 -0400
Received: (wp-smtpd smtp.tlen.pl 18014 invoked from network); 30 Oct 2021 23:47:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1635630439; bh=UHf1ypbd17Kopy+oZJ9KeBqXEW0Si75CBEqlrPjJ6Rk=;
          h=From:To:Cc:Subject;
          b=a6y0t1C3tsRjCk8AL99mIbGm3R9C7U4wZogvCvyNVG/FIVAg67KFIMrLuQJRk/obq
           m5nbnINkjAx570jT+RL090Ek+Fkk+q2V5BHdLPAeoA0Nh+Bw5QE/xfgMSRPy4NXriT
           sQarAOAnJnzNQNdMQ/l1g4IG2ErAjH4Cu7Iv5zrA=
Received: from ablz112.neoplus.adsl.tpnet.pl (HELO localhost.localdomain) (mat.jonczyk@o2.pl@[83.7.219.112])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with SMTP
          for <linux-rtc@vger.kernel.org>; 30 Oct 2021 23:47:18 +0200
From:   =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To:     linux-rtc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 1/7] rtc-cmos: take rtc_lock while reading from CMOS
Date:   Sat, 30 Oct 2021 23:46:29 +0200
Message-Id: <20211030214636.49602-2-mat.jonczyk@o2.pl>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211030214636.49602-1-mat.jonczyk@o2.pl>
References: <20211030214636.49602-1-mat.jonczyk@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 38f52ece292cce571491b757614f8bd2
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [oUN0]                               
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reading from the CMOS involves writing to the index register and then
reading from the data register. Therefore access to the CMOS has to be
serialized with rtc_lock. This invocation of CMOS_READ was not
serialized, which could cause trouble when other code is accessing CMOS
at the same time.

Use spin_lock_irq() like the rest of the function.

Nothing in kernel modifies the RTC_DM_BINARY bit, so there could be a
separate pair of spin_lock_irq() / spin_unlock_irq() before doing the
math.

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Reviewed-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: stable@vger.kernel.org
---
 drivers/rtc/rtc-cmos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 4eb53412b808..dc3f8b0dde98 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -457,7 +457,10 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
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

