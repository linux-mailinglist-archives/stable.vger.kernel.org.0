Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526354BCDA6
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 11:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243460AbiBTJLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 04:11:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243443AbiBTJLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 04:11:24 -0500
X-Greylist: delayed 398 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Feb 2022 01:11:02 PST
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B9626565
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 01:11:02 -0800 (PST)
Received: (wp-smtpd smtp.tlen.pl 23161 invoked from network); 20 Feb 2022 10:04:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1645347860; bh=X+qXjhMw4ablrWBQcUFh/9RQ37lVwgA+fXmJmWBXEBs=;
          h=From:To:Cc:Subject;
          b=OwmhmOB65Z+svcWXNDTfJdHDSZSVc59X6f/5Yyh8Qp+bWY/F2Lh3yIc4UtUx79ijc
           FGXlT4h59kNjAW3JJjSXxmQBnv8NNdpq6TZd4xYfAvWx3fBgPetcZun75ArDN01R/n
           Dlz1LV+uEYpHI+NMFBXKzL2uInDwZ6M8IHjn3qSU=
Received: from aaew227.neoplus.adsl.tpnet.pl (HELO localhost.localdomain) (mat.jonczyk@o2.pl@[83.4.126.227])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with SMTP
          for <linux-rtc@vger.kernel.org>; 20 Feb 2022 10:04:19 +0100
From:   =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To:     linux-rtc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH] rtc-mc146818-lib: fix locking in mc146818_set_time
Date:   Sun, 20 Feb 2022 10:04:03 +0100
Message-Id: <20220220090403.153928-1-mat.jonczyk@o2.pl>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: e253a7ce734dbc8d685bdec651998b01
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [QWMU]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In mc146818_set_time(), CMOS_READ(RTC_CONTROL) was performed without the
rtc_lock taken, which is required for CMOS accesses. Fix this.

Nothing in kernel modifies RTC_DM_BINARY, so a separate critical section
is allowed here.

Fixes: dcf257e92622 ("rtc: mc146818: Reduce spinlock section in mc146818_set_time()")
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/rtc/rtc-mc146818-lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index ae9f131b43c0..562f99b664a2 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -232,8 +232,10 @@ int mc146818_set_time(struct rtc_time *time)
 	if (yrs >= 100)
 		yrs -= 100;
 
-	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY)
-	    || RTC_ALWAYS_BCD) {
+	spin_lock_irqsave(&rtc_lock, flags);
+	save_control = CMOS_READ(RTC_CONTROL);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		sec = bin2bcd(sec);
 		min = bin2bcd(min);
 		hrs = bin2bcd(hrs);

base-commit: 754e0b0e35608ed5206d6a67a791563c631cec07
-- 
2.25.1

