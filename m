Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A02F8978
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 08:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfKLHRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 02:17:01 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:60924 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfKLHRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 02:17:00 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iUQQ3-0005Vk-HK; Tue, 12 Nov 2019 08:16:55 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id AEB471C0084;
        Tue, 12 Nov 2019 08:16:54 +0100 (CET)
Date:   Tue, 12 Nov 2019 07:16:54 -0000
From:   "tip-bot2 for Arnd Bergmann" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] ntp/y2038: Remove incorrect time_t truncation
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191108203435.112759-2-arnd@arndb.de>
References: <20191108203435.112759-2-arnd@arndb.de>
MIME-Version: 1.0
Message-ID: <157354301429.29376.9889491292971482073.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     2f5841349df281ecf8f81cc82d869b8476f0db0b
Gitweb:        https://git.kernel.org/tip/2f5841349df281ecf8f81cc82d869b8476f0db0b
Author:        Arnd Bergmann <arnd@arndb.de>
AuthorDate:    Fri, 08 Nov 2019 21:34:24 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 12 Nov 2019 08:13:44 +01:00

ntp/y2038: Remove incorrect time_t truncation

A cast to 'time_t' was accidentally left in place during the
conversion of __do_adjtimex() to 64-bit timestamps, so the
resulting value is incorrectly truncated.

Remove the cast so the 64-bit time gets propagated correctly.

Fixes: ead25417f82e ("timex: use __kernel_timex internally")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20191108203435.112759-2-arnd@arndb.de

---
 kernel/time/ntp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 65eb796..069ca78 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -771,7 +771,7 @@ int __do_adjtimex(struct __kernel_timex *txc, const struct timespec64 *ts,
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	txc->time.tv_sec = (time_t)ts->tv_sec;
+	txc->time.tv_sec = ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec = ts->tv_nsec / NSEC_PER_USEC;
