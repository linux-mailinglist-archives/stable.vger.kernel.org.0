Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0D13284C0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbhCAQmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:42:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231990AbhCAQfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:35:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD6964F73;
        Mon,  1 Mar 2021 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615975;
        bh=WNCAVJ/vKWgsoYvC6iBp3ixDnLPffgkpsBXKWvHyhE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDcB5NFif/RKALqbInoGhMGxFyqjnWRqqoQHYQLtcLJ6aylSy7SbNtMFtNA8esfNw
         lQ98tU3u4VwYx+VDNc+99p7dzByzMRm8OtYzZ6sG1VLoT29ZS45RYjgcBJXZVZ8PWX
         xYx2bAu8j/1PISvsTDCbwxO/+NxkiYeAy2n9VgNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [PATCH 4.9 126/134] futex: Fix OWNER_DEAD fixup
Date:   Mon,  1 Mar 2021 17:13:47 +0100
Message-Id: <20210301161019.791353827@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.

Both Geert and DaveJ reported that the recent futex commit:

  c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")

introduced a problem with setting OWNER_DEAD. We set the bit on an
uninitialized variable and then entirely optimize it away as a
dead-store.

Move the setting of the bit to where it is more useful.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
Link: http://lkml.kernel.org/r/20180122103947.GD2228@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2424,9 +2424,6 @@ static int __fixup_pi_state_owner(u32 __
 	int err = 0;
 
 	oldowner = pi_state->owner;
-	/* Owner died? */
-	if (!pi_state->owner)
-		newtid |= FUTEX_OWNER_DIED;
 
 	/*
 	 * We are here because either:
@@ -2484,6 +2481,9 @@ retry:
 	}
 
 	newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
+	/* Owner died? */
+	if (!pi_state->owner)
+		newtid |= FUTEX_OWNER_DIED;
 
 	if (get_futex_value_locked(&uval, uaddr))
 		goto handle_fault;


