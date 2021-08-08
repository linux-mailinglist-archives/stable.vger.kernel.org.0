Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0E23E3979
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhHHHYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231444AbhHHHXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:23:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7631561078;
        Sun,  8 Aug 2021 07:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628407399;
        bh=KN7RioHkbUYpen5v2+u3FXY+CFPQSgLiPsGCX2wQpn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2bwoaheQYc/ca8hYJV/y8u70ypXHomGXT0RMn/qAAAOogS6dAd7Or/mzpzh1rzNk
         qam36JFoi39ARudWG/XYKnhDpx0S+5SkZt09eZU4vlp7AhtxisaJhlyL3TafbjYTLH
         W6lWSatnOcpeAUMZxRMSKmuJ81cM3rtgAMbH5I5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Levin <alexander.levin@verizon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Joe Korty <joe.korty@concurrent-rt.com>
Subject: [PATCH 4.4 09/11] futex: Avoid freeing an active timer
Date:   Sun,  8 Aug 2021 09:22:44 +0200
Message-Id: <20210808072217.637655944@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210808072217.322468704@linuxfoundation.org>
References: <20210808072217.322468704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 97181f9bd57405b879403763284537e27d46963d ]

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
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Joe Korty <joe.korty@concurrent-rt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2960,8 +2960,10 @@ out_unlock_put_key:
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


