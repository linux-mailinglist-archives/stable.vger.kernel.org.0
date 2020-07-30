Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749C4232E1E
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgG3IRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729289AbgG3IJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:09:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 457582074B;
        Thu, 30 Jul 2020 08:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096582;
        bh=bg0l1n9k4A6KVnWZIK6yar3yerYLJ76C8aycKQ3omJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uvk4awaeTMNsUlGumizzb4B7MgkTPwrk+blky+hRe3ES8k7v/jJ3esobicdAjf9Kr
         /W2vz+5MOWNJDKUgPUZGDhvE92zUzxUHRzidav6ftLpdbM9z/e88U3zR64a0vvfRcd
         qUyi1tgRL3CNbWJv/ir5srjyh30Ta0Y4dwVYqUR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.9 43/61] parisc: Add atomic64_set_release() define to avoid CPU soft lockups
Date:   Thu, 30 Jul 2020 10:05:01 +0200
Message-Id: <20200730074422.924998239@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

commit be6577af0cef934ccb036445314072e8cb9217b9 upstream.

Stalls are quite frequent with recent kernels. I enabled
CONFIG_SOFTLOCKUP_DETECTOR and I caught the following stall:

watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [cc1:22803]
CPU: 0 PID: 22803 Comm: cc1 Not tainted 5.6.17+ #3
Hardware name: 9000/800/rp3440
 IAOQ[0]: d_alloc_parallel+0x384/0x688
 IAOQ[1]: d_alloc_parallel+0x388/0x688
 RP(r2): d_alloc_parallel+0x134/0x688
Backtrace:
 [<000000004036974c>] __lookup_slow+0xa4/0x200
 [<0000000040369fc8>] walk_component+0x288/0x458
 [<000000004036a9a0>] path_lookupat+0x88/0x198
 [<000000004036e748>] filename_lookup+0xa0/0x168
 [<000000004036e95c>] user_path_at_empty+0x64/0x80
 [<000000004035d93c>] vfs_statx+0x104/0x158
 [<000000004035dfcc>] __do_sys_lstat64+0x44/0x80
 [<000000004035e5a0>] sys_lstat64+0x20/0x38
 [<0000000040180054>] syscall_exit+0x0/0x14

The code was stuck in this loop in d_alloc_parallel:

    4037d414:   0e 00 10 dc     ldd 0(r16),ret0
    4037d418:   c7 fc 5f ed     bb,< ret0,1f,4037d414 <d_alloc_parallel+0x384>
    4037d41c:   08 00 02 40     nop

This is the inner loop of bit_spin_lock which is called by hlist_bl_unlock in
d_alloc_parallel:

static inline void bit_spin_lock(int bitnum, unsigned long *addr)
{
        /*
         * Assuming the lock is uncontended, this never enters
         * the body of the outer loop. If it is contended, then
         * within the inner loop a non-atomic test is used to
         * busywait with less bus contention for a good time to
         * attempt to acquire the lock bit.
         */
        preempt_disable();
#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
        while (unlikely(test_and_set_bit_lock(bitnum, addr))) {
                preempt_enable();
                do {
                        cpu_relax();
                } while (test_bit(bitnum, addr));
                preempt_disable();
        }
#endif
        __acquire(bitlock);
}

After consideration, I realized that we must be losing bit unlocks.
Then, I noticed that we missed defining atomic64_set_release().
Adding this define fixes the stalls in bit operations.

Signed-off-by: Dave Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/atomic.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -255,6 +255,8 @@ atomic64_set(atomic64_t *v, s64 i)
 	_atomic_spin_unlock_irqrestore(v, flags);
 }
 
+#define atomic64_set_release(v, i)	atomic64_set((v), (i))
+
 static __inline__ s64
 atomic64_read(const atomic64_t *v)
 {


