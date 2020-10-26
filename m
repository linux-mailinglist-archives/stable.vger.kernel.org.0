Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214E1298ABD
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 11:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771758AbgJZKvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 06:51:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39090 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1770960AbgJZKvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 06:51:05 -0400
Date:   Mon, 26 Oct 2020 10:51:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603709462;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAT90Ww8AO0M+YiJyfFcemR1v6O5CkiPMwWvyQYV/fY=;
        b=JI5VgPrlb2sTVfT/EimV2Coyich9hMADy/nTs8fJ0wSeBt6g6kgFuvS4BrThrly+nihtjQ
        rhvbypVaCm5OEE3UanpOVdBWg5a+jR9SMCnMfAo59UTRF1I3JcuGZfr4uyhwKVov83tYK+
        Ca9XdnPF6wKGgsMbHCcr0R3CXoJdcf3JKcFde/qYrettkSKEoXxMJhROFPWUyujJmIuaM0
        /ntZWqhnt0XMxzEm1etYlUxwh3f/kfmNH/Sv9q4PCosTzExDJ8WOE23naogACZpNIb59HU
        /soV9A73uxCc4Tz9UcDzYPOOF4JA7wsGlYnbpbkuqyXrnC2pKSi6PRuAyAiIMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603709462;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAT90Ww8AO0M+YiJyfFcemR1v6O5CkiPMwWvyQYV/fY=;
        b=/EyD07S9+m1wwo4b3U5xNZT8cbgDs5As2B7r9hqv9utfobVOpsUCcNFT39wM1fuwc0Ctp3
        O0XbT5N76ZQufhAQ==
From:   "tip-bot2 for Zeng Tao" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] time: Prevent undefined behaviour in timespec64_to_ns()
Cc:     Zeng Tao <prime.zeng@hisilicon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1598952616-6416-1-git-send-email-prime.zeng@hisilicon.com>
References: <1598952616-6416-1-git-send-email-prime.zeng@hisilicon.com>
MIME-Version: 1.0
Message-ID: <160370946176.397.12992652264857362737.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     cb47755725da7b90fecbb2aa82ac3b24a7adb89b
Gitweb:        https://git.kernel.org/tip/cb47755725da7b90fecbb2aa82ac3b24a7adb89b
Author:        Zeng Tao <prime.zeng@hisilicon.com>
AuthorDate:    Tue, 01 Sep 2020 17:30:13 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 26 Oct 2020 11:48:11 +01:00

time: Prevent undefined behaviour in timespec64_to_ns()

UBSAN reports:

Undefined behaviour in ./include/linux/time64.h:127:27
signed integer overflow:
17179869187 * 1000000000 cannot be represented in type 'long long int'
Call Trace:
 timespec64_to_ns include/linux/time64.h:127 [inline]
 set_cpu_itimer+0x65c/0x880 kernel/time/itimer.c:180
 do_setitimer+0x8e/0x740 kernel/time/itimer.c:245
 __x64_sys_setitimer+0x14c/0x2c0 kernel/time/itimer.c:336
 do_syscall_64+0xa1/0x540 arch/x86/entry/common.c:295

Commit bd40a175769d ("y2038: itimer: change implementation to timespec64")
replaced the original conversion which handled time clamping correctly with
timespec64_to_ns() which has no overflow protection.

Fix it in timespec64_to_ns() as this is not necessarily limited to the
usage in itimers.

[ tglx: Added comment and adjusted the fixes tag ]

Fixes: 361a3bf00582 ("time64: Add time64.h header and define struct timespec64")
Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1598952616-6416-1-git-send-email-prime.zeng@hisilicon.com
---
 include/linux/time64.h | 4 ++++
 kernel/time/itimer.c   | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/time64.h b/include/linux/time64.h
index c9dcb3e..5117cb5 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -124,6 +124,10 @@ static inline bool timespec64_valid_settod(const struct timespec64 *ts)
  */
 static inline s64 timespec64_to_ns(const struct timespec64 *ts)
 {
+	/* Prevent multiplication overflow */
+	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
+		return KTIME_MAX;
+
 	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
 }
 
diff --git a/kernel/time/itimer.c b/kernel/time/itimer.c
index ca4e6d5..00629e6 100644
--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -172,10 +172,6 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	u64 oval, nval, ointerval, ninterval;
 	struct cpu_itimer *it = &tsk->signal->it[clock_id];
 
-	/*
-	 * Use the to_ktime conversion because that clamps the maximum
-	 * value to KTIME_MAX and avoid multiplication overflows.
-	 */
 	nval = timespec64_to_ns(&value->it_value);
 	ninterval = timespec64_to_ns(&value->it_interval);
 
