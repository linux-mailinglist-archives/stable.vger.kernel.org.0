Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CA2375A07
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 20:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhEFSPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 14:15:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41834 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbhEFSPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 14:15:34 -0400
Date:   Thu, 06 May 2021 18:14:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620324873;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PHyssgLvqvSlZCXo7fvGxABBPeuQD4QpoMYwArdniiU=;
        b=xK5PL52ia92pVopjqi/imDLQz8c4c4Q8+4zCtWp3IRQrKrujyBbu+hSvgO+kAfJl1E+uw7
        E6pPWt14RAvrXhVCUPH/ulLDuTyDRqMC0C2CNnk5CgfAQWADJ3i5jgJag2k9ikZVUs9egL
        4KUHeIVrumwilXmbJ0ux7nX9CSSQKNnKakDPhYrIRXCbG5ffmqB8VHYySzZSOK1IAn8sAP
        +SNGwJ8CYE8bd6682tpFsWBs70ycLmpXOIsTGdHQDVZch7bWGvX10yY+VoVZVZxY5Oyl5S
        N7YNlBX5ODjzBM22V8oEpykJiZF3u/RL1vbuA7Gr3Q3IOFsmhnVthJVmRMHSZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620324873;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PHyssgLvqvSlZCXo7fvGxABBPeuQD4QpoMYwArdniiU=;
        b=fqdqy/nQlM8IqDTgVmsVTJPOMfxo/eY+YkISNfYbpcrcRlK2DMmVBh+sjHtM4JuE0QUkGP
        HKHNWdO3YTCcV5Dg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] futex: Do not apply time namespace adjustment
 on FUTEX_LOCK_PI
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210422194704.984540159@linutronix.de>
References: <20210422194704.984540159@linutronix.de>
MIME-Version: 1.0
Message-ID: <162032487280.29796.15925063332304898548.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     cdf78db4070967869e4d027c11f4dd825d8f815a
Gitweb:        https://git.kernel.org/tip/cdf78db4070967869e4d027c11f4dd825d8f815a
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 22 Apr 2021 21:44:19 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 06 May 2021 20:12:40 +02:00

futex: Do not apply time namespace adjustment on FUTEX_LOCK_PI

FUTEX_LOCK_PI does not require to have the FUTEX_CLOCK_REALTIME bit set
because it has been using CLOCK_REALTIME based absolute timeouts
forever. Due to that, the time namespace adjustment which is applied when
FUTEX_CLOCK_REALTIME is not set, will wrongly take place for FUTEX_LOCK_PI
and wreckage the timeout.

Exclude it from that procedure.

Fixes: c2f7d08cccf4 ("futex: Adjust absolute futex timeouts with per time namespace offset")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210422194704.984540159@linutronix.de

---
 kernel/futex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4740200..b0f5304 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3780,7 +3780,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
-		else if (!(op & FUTEX_CLOCK_REALTIME))
+		else if (cmd != FUTEX_LOCK_PI && !(op & FUTEX_CLOCK_REALTIME))
 			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
@@ -3974,7 +3974,7 @@ SYSCALL_DEFINE6(futex_time32, u32 __user *, uaddr, int, op, u32, val,
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
-		else if (!(op & FUTEX_CLOCK_REALTIME))
+		else if (cmd != FUTEX_LOCK_PI && !(op & FUTEX_CLOCK_REALTIME))
 			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
