Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299FD4FD267
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345213AbiDLHLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347691AbiDLHJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:09:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F30849F1F;
        Mon, 11 Apr 2022 23:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47D43B81B35;
        Tue, 12 Apr 2022 06:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913BCC385A1;
        Tue, 12 Apr 2022 06:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746168;
        bh=RiLSKr4bPia4+WtT/d78uazNGyfqTpLSiw8pG2sy0Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYoJMXPVx+dP/bmar1ww2FD0W2wtGGsdQyf3+uppmaYkTJNp5uH9LvZD02HftZz9K
         qyRwX1b6LoSk0TEiNhbcO5WxKAxxEc1M2EGOQ8WbuTmDmiU2KPIa2MRMoyy2kYJyRH
         sLf4wOnKlYrJgvcwcC5XTiWqNeTVogsAqn+3oRP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-alpha@vger.kernel.org, x86@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/277] rtc: Check return value from mc146818_get_time()
Date:   Tue, 12 Apr 2022 08:29:08 +0200
Message-Id: <20220412062946.231414058@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

[ Upstream commit 0dd8d6cb9eddfe637bcd821bbfd40ebd5a0737b9 ]

There are 4 users of mc146818_get_time() and none of them was checking
the return value from this function. Change this.

Print the appropriate warnings in callers of mc146818_get_time() instead
of in the function mc146818_get_time() itself, in order not to add
strings to rtc-mc146818-lib.c, which is kind of a library.

The callers of alpha_rtc_read_time() and cmos_read_time() may use the
contents of (struct rtc_time *) even when the functions return a failure
code. Therefore, set the contents of (struct rtc_time *) to 0x00,
which looks more sensible then 0xff and aligns with the (possibly
stale?) comment in cmos_read_time:

	/*
	 * If pm_trace abused the RTC for storage, set the timespec to 0,
	 * which tells the caller that this RTC value is unusable.
	 */

For consistency, do this in mc146818_get_time().

Note: hpet_rtc_interrupt() may call mc146818_get_time() many times a
second. It is very unlikely, though, that the RTC suddenly stops
working and mc146818_get_time() would consistently fail.

Only compile-tested on alpha.

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: linux-alpha@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211210200131.153887-4-mat.jonczyk@o2.pl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/rtc.c        | 7 ++++++-
 arch/x86/kernel/hpet.c         | 8 ++++++--
 drivers/base/power/trace.c     | 6 +++++-
 drivers/rtc/rtc-cmos.c         | 9 ++++++++-
 drivers/rtc/rtc-mc146818-lib.c | 2 +-
 5 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/kernel/rtc.c b/arch/alpha/kernel/rtc.c
index ce3077946e1d..fb3025396ac9 100644
--- a/arch/alpha/kernel/rtc.c
+++ b/arch/alpha/kernel/rtc.c
@@ -80,7 +80,12 @@ init_rtc_epoch(void)
 static int
 alpha_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	mc146818_get_time(tm);
+	int ret = mc146818_get_time(tm);
+
+	if (ret < 0) {
+		dev_err_ratelimited(dev, "unable to read current time\n");
+		return ret;
+	}
 
 	/* Adjust for non-default epochs.  It's easier to depend on the
 	   generic __get_rtc_time and adjust the epoch here than create
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 882213df3713..71f336425e58 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1435,8 +1435,12 @@ irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 	hpet_rtc_timer_reinit();
 	memset(&curr_time, 0, sizeof(struct rtc_time));
 
-	if (hpet_rtc_flags & (RTC_UIE | RTC_AIE))
-		mc146818_get_time(&curr_time);
+	if (hpet_rtc_flags & (RTC_UIE | RTC_AIE)) {
+		if (unlikely(mc146818_get_time(&curr_time) < 0)) {
+			pr_err_ratelimited("unable to read current time from RTC\n");
+			return IRQ_HANDLED;
+		}
+	}
 
 	if (hpet_rtc_flags & RTC_UIE &&
 	    curr_time.tm_sec != hpet_prev_update_sec) {
diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index 94665037f4a3..72b7a92337b1 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -120,7 +120,11 @@ static unsigned int read_magic_time(void)
 	struct rtc_time time;
 	unsigned int val;
 
-	mc146818_get_time(&time);
+	if (mc146818_get_time(&time) < 0) {
+		pr_err("Unable to read current time from RTC\n");
+		return 0;
+	}
+
 	pr_info("RTC time: %ptRt, date: %ptRd\n", &time, &time);
 	val = time.tm_year;				/* 100 years */
 	if (val > 100)
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index dc3f8b0dde98..d0f58cca5c20 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -222,6 +222,8 @@ static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
 
 static int cmos_read_time(struct device *dev, struct rtc_time *t)
 {
+	int ret;
+
 	/*
 	 * If pm_trace abused the RTC for storage, set the timespec to 0,
 	 * which tells the caller that this RTC value is unusable.
@@ -229,7 +231,12 @@ static int cmos_read_time(struct device *dev, struct rtc_time *t)
 	if (!pm_trace_rtc_valid())
 		return -EIO;
 
-	mc146818_get_time(t);
+	ret = mc146818_get_time(t);
+	if (ret < 0) {
+		dev_err_ratelimited(dev, "unable to read current time\n");
+		return ret;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index bd48cee3027e..97e3cebb4da9 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -24,7 +24,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
 	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x40) != 0)) {
 		spin_unlock_irqrestore(&rtc_lock, flags);
-		memset(time, 0xff, sizeof(*time));
+		memset(time, 0, sizeof(*time));
 		return -EIO;
 	}
 
-- 
2.35.1



