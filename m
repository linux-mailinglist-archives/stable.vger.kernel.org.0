Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CBF378514
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhEJK6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233030AbhEJKyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:54:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3999A617C9;
        Mon, 10 May 2021 10:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643304;
        bh=EVCg1XGegpEbWfwV406v3j5pS0KOf3SUH5UaDhcl/Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eBcfcTWUGQuGC35/Fcvc2zreTFM1dOQ2C8RUxOKVQmCSwAAPgddhSth4utjiYPl6
         HVEeTTgI6uIGhiOdTW42o7jCUqz+yZT+o0N6nFXxJJzz1xTHvFUjbmc4H0DvMkay00
         Bx6+VnNPJbz9Q6EtmR7uX4r8VDytsLOHRFf3jKWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 261/299] futex: Do not apply time namespace adjustment on FUTEX_LOCK_PI
Date:   Mon, 10 May 2021 12:20:58 +0200
Message-Id: <20210510102013.572972268@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit cdf78db4070967869e4d027c11f4dd825d8f815a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3784,7 +3784,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
-		else if (!(op & FUTEX_CLOCK_REALTIME))
+		else if (cmd != FUTEX_LOCK_PI && !(op & FUTEX_CLOCK_REALTIME))
 			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
@@ -3978,7 +3978,7 @@ SYSCALL_DEFINE6(futex_time32, u32 __user
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
-		else if (!(op & FUTEX_CLOCK_REALTIME))
+		else if (cmd != FUTEX_LOCK_PI && !(op & FUTEX_CLOCK_REALTIME))
 			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}


