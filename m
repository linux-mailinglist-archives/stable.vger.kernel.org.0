Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBA63DD7C0
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhHBNsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:07 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12437 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbhHBNrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:47:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GdfNc5hgHzck40;
        Mon,  2 Aug 2021 21:43:44 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:17 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:16 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.4 09/11] futex: Avoid freeing an active timer
Date:   Mon, 2 Aug 2021 21:46:22 +0800
Message-ID: <20210802134624.1934-10-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210802134624.1934-1-thunder.leizhen@huawei.com>
References: <20210802134624.1934-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
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
---
 kernel/futex.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e7c2e552aef4ae6..6d47b7dc1cfbee7 100644
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
-- 
2.26.0.106.g9fadedd

