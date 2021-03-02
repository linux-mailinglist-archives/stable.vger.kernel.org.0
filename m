Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD19032AEEF
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbhCCAJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:09:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:56646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240483AbhCBKDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 05:03:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614679359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OSC0RMb4jQ8vLtAy/2lrY+WzohUmliZWQjgjoo9BBmk=;
        b=uB2FnJ8mEyD7HKxvihmKbQodVAWJkZJFF2EaBg++M9iORUmfZrdofkznU5gEHi+NAHq/sd
        iWMMAMVvA/OvAa2jLsk3aLN18x9XtJuVnl3s3ZAN6ecZE2ZXQ9tuB3RYfi3fEubIAHtRBz
        JKcpzIIXogKu7NMCbwrh6PvpY4bHpoQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 83B29ABF4;
        Tue,  2 Mar 2021 10:02:39 +0000 (UTC)
Date:   Tue, 2 Mar 2021 11:02:39 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] printk: fix deadlock when kernel panic"
 failed to apply to 4.9-stable tree
Message-ID: <YD4NP2ffit64F/kB@alley>
References: <1614604832185174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614604832185174@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 2021-03-01 14:20:32, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Please, find below the backport for stable-4.9:

From bfc246e5ed94300431bc8d74b67c74b6f66e75ff Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Wed, 10 Feb 2021 11:48:23 +0800
Subject: [PATCH] printk: fix deadlock when kernel panic

printk_nmi_flush_on_panic() caused the following deadlock on our
server:

CPU0:                                         CPU1:
panic                                         rcu_dump_cpu_stacks
  kdump_nmi_shootdown_cpus                      nmi_trigger_cpumask_backtrace
    register_nmi_handler(crash_nmi_callback)      printk_nmi_flush
                                                    __printk_nmi_flush
                                                      raw_spin_lock_irqsave(&read_lock)
    // send NMI to other processors
    apic_send_IPI_allbutself(NMI_VECTOR)
                                                        // NMI interrupt, dead loop
                                                        crash_nmi_callback
  printk_nmi_flush_on_panic
    printk_nmi_flush
      __printk_nmi_flush
        // deadlock
        raw_spin_lock_irqsave(&read_lock)

DEADLOCK: read_lock is taken on CPU1 and will never get released.

It happens when panic() stops a CPU by NMI while it has been in
the middle of printk_nmi_flush().

Handle the lock the same way as logbuf_lock. The printk_nmi buffers
are flushed only when both locks can be safely taken. It can avoid
the deadlock _in this particular case_ at expense of losing contents
of printk_nmi buffers.

Note: It would actually be safe to re-init the locks when all CPUs were
      stopped by NMI. But it would require passing this information
      from arch-specific code. It is not worth the complexity.
      Especially because logbuf_lock and printk_nmi buffers have been
      obsoleted by the lockless ring buffer.

This is a backport of the commit 8a8109f303e25a27f92c ("printk: fix
deadlock when kernel panic") for the stable 4.9 kernel.

Fixes: cf9b1106c81c ("printk/nmi: flush NMI messages on the system panic")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210210034823.64867-1-songmuchun@bytedance.com
---
 kernel/printk/nmi.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/nmi.c b/kernel/printk/nmi.c
index 2c3e7f024c15..7a50b405ad28 100644
--- a/kernel/printk/nmi.c
+++ b/kernel/printk/nmi.c
@@ -52,6 +52,8 @@ struct nmi_seq_buf {
 };
 static DEFINE_PER_CPU(struct nmi_seq_buf, nmi_print_seq);
 
+static DEFINE_RAW_SPINLOCK(nmi_read_lock);
+
 /*
  * Safe printk() for NMI context. It uses a per-CPU buffer to
  * store the message. NMIs are not nested, so there is always only
@@ -134,8 +136,6 @@ static void printk_nmi_flush_seq_line(struct nmi_seq_buf *s,
  */
 static void __printk_nmi_flush(struct irq_work *work)
 {
-	static raw_spinlock_t read_lock =
-		__RAW_SPIN_LOCK_INITIALIZER(read_lock);
 	struct nmi_seq_buf *s = container_of(work, struct nmi_seq_buf, work);
 	unsigned long flags;
 	size_t len, size;
@@ -148,7 +148,7 @@ static void __printk_nmi_flush(struct irq_work *work)
 	 * different CPUs. This is especially important when printing
 	 * a backtrace.
 	 */
-	raw_spin_lock_irqsave(&read_lock, flags);
+	raw_spin_lock_irqsave(&nmi_read_lock, flags);
 
 	i = 0;
 more:
@@ -197,7 +197,7 @@ static void __printk_nmi_flush(struct irq_work *work)
 		goto more;
 
 out:
-	raw_spin_unlock_irqrestore(&read_lock, flags);
+	raw_spin_unlock_irqrestore(&nmi_read_lock, flags);
 }
 
 /**
@@ -239,6 +239,14 @@ void printk_nmi_flush_on_panic(void)
 		raw_spin_lock_init(&logbuf_lock);
 	}
 
+	if (in_nmi() && raw_spin_is_locked(&nmi_read_lock)) {
+		if (num_online_cpus() > 1)
+			return;
+
+		debug_locks_off();
+		raw_spin_lock_init(&nmi_read_lock);
+	}
+
 	printk_nmi_flush();
 }
 
-- 
2.16.4

