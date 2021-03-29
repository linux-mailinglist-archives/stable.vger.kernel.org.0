Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BED334C5E7
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhC2IDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhC2IDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8356619AA;
        Mon, 29 Mar 2021 08:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004992;
        bh=A6LnIq9Ny7Qd4Rzyprd6DSPguREoTQjKIkCsXOZZAvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qY7d3A6nU4+xXSL+nUfuSVvdI8t75cAhkBTuv8oHb5eDEqelAULBz3frhXGzm41mR
         /trNcC8cB+ejIpX444ShoaIqcX2aAlL4T7rv2+/9vR+RpJQI4r6Sv85pSqkEubgbyP
         PVDVr2P7Cnz5oTwYIszXAixvZ1p+SMZtOJAKyPnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Levin <alexander.levin@verizon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 41/53] futex: Avoid freeing an active timer
Date:   Mon, 29 Mar 2021 09:58:16 +0200
Message-Id: <20210329075608.863398296@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 97181f9bd57405b879403763284537e27d46963d upstream.

Alexander reported a hrtimer debug_object splat:

  ODEBUG: free active (active state 0) object type: hrtimer hint: hrtimer_wakeup (kernel/time/hrtimer.c:1423)

  debug_object_free (lib/debugobjects.c:603)
  destroy_hrtimer_on_stack (kernel/time/hrtimer.c:427)
  futex_lock_pi (kernel/futex.c:2740)
  do_futex (kernel/futex.c:3399)
  SyS_futex (kernel/futex.c:3447 kernel/futex.c:3415)
  do_syscall_64 (arch/x86/entry/common.c:284)
  entry_SYSCALL64_slow_path (arch/x86/entry/entry_64.S:249)

Which was caused by commit:

  cfafcd117da0 ("futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()")

... losing the hrtimer_cancel() in the shuffle. Where previously the
hrtimer_cancel() was done by rt_mutex_slowlock() we now need to do it
manually.

Reported-by: Alexander Levin <alexander.levin@verizon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Fixes: cfafcd117da0 ("futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()")
Link: http://lkml.kernel.org/r/alpine.DEB.2.20.1704101802370.2906@nanos
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3018,8 +3018,10 @@ out_unlock_put_key:
 out_put_key:
 	put_futex_key(&q.key);
 out:
-	if (to)
+	if (to) {
+		hrtimer_cancel(&to->timer);
 		destroy_hrtimer_on_stack(&to->timer);
+	}
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:


