Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E846B3285F0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhCARBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:01:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232387AbhCAQys (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:54:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D1564FC8;
        Mon,  1 Mar 2021 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616510;
        bh=zmOEjISHg1VmeqkfzGiNVGFtl/fkgNBrLD5d/zOl8Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meoOxbGfHStxsiFoAHKg0d+yv3OnwFwzhRaL0hn7GouTCFsRCdqDXxx8MPr05wEAL
         BgDtth38iKqx2etEygdbUn3A58eTCSZ3UYL3kqigVmCeaNK3O4OxNNXGUUbzU1IYOI
         VHOUdTHY0YtzO4oV1zBM5YZ7k6EYpFl8XPfW2N3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 4.14 160/176] printk: fix deadlock when kernel panic
Date:   Mon,  1 Mar 2021 17:13:53 +0100
Message-Id: <20210301161028.973979578@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 8a8109f303e25a27f92c1d8edd67d7cbbc60a4eb upstream.

printk_safe_flush_on_panic() caused the following deadlock on our
server:

CPU0:                                         CPU1:
panic                                         rcu_dump_cpu_stacks
  kdump_nmi_shootdown_cpus                      nmi_trigger_cpumask_backtrace
    register_nmi_handler(crash_nmi_callback)      printk_safe_flush
                                                    __printk_safe_flush
                                                      raw_spin_lock_irqsave(&read_lock)
    // send NMI to other processors
    apic_send_IPI_allbutself(NMI_VECTOR)
                                                        // NMI interrupt, dead loop
                                                        crash_nmi_callback
  printk_safe_flush_on_panic
    printk_safe_flush
      __printk_safe_flush
        // deadlock
        raw_spin_lock_irqsave(&read_lock)

DEADLOCK: read_lock is taken on CPU1 and will never get released.

It happens when panic() stops a CPU by NMI while it has been in
the middle of printk_safe_flush().

Handle the lock the same way as logbuf_lock. The printk_safe buffers
are flushed only when both locks can be safely taken. It can avoid
the deadlock _in this particular case_ at expense of losing contents
of printk_safe buffers.

Note: It would actually be safe to re-init the locks when all CPUs were
      stopped by NMI. But it would require passing this information
      from arch-specific code. It is not worth the complexity.
      Especially because logbuf_lock and printk_safe buffers have been
      obsoleted by the lockless ring buffer.

Fixes: cf9b1106c81c ("printk/nmi: flush NMI messages on the system panic")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210210034823.64867-1-songmuchun@bytedance.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/printk/printk_safe.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/kernel/printk/printk_safe.c
+++ b/kernel/printk/printk_safe.c
@@ -56,6 +56,8 @@ struct printk_safe_seq_buf {
 static DEFINE_PER_CPU(struct printk_safe_seq_buf, safe_print_seq);
 static DEFINE_PER_CPU(int, printk_context);
 
+static DEFINE_RAW_SPINLOCK(safe_read_lock);
+
 #ifdef CONFIG_PRINTK_NMI
 static DEFINE_PER_CPU(struct printk_safe_seq_buf, nmi_print_seq);
 #endif
@@ -194,8 +196,6 @@ static void report_message_lost(struct p
  */
 static void __printk_safe_flush(struct irq_work *work)
 {
-	static raw_spinlock_t read_lock =
-		__RAW_SPIN_LOCK_INITIALIZER(read_lock);
 	struct printk_safe_seq_buf *s =
 		container_of(work, struct printk_safe_seq_buf, work);
 	unsigned long flags;
@@ -209,7 +209,7 @@ static void __printk_safe_flush(struct i
 	 * different CPUs. This is especially important when printing
 	 * a backtrace.
 	 */
-	raw_spin_lock_irqsave(&read_lock, flags);
+	raw_spin_lock_irqsave(&safe_read_lock, flags);
 
 	i = 0;
 more:
@@ -246,7 +246,7 @@ more:
 
 out:
 	report_message_lost(s);
-	raw_spin_unlock_irqrestore(&read_lock, flags);
+	raw_spin_unlock_irqrestore(&safe_read_lock, flags);
 }
 
 /**
@@ -292,6 +292,14 @@ void printk_safe_flush_on_panic(void)
 		raw_spin_lock_init(&logbuf_lock);
 	}
 
+	if (raw_spin_is_locked(&safe_read_lock)) {
+		if (num_online_cpus() > 1)
+			return;
+
+		debug_locks_off();
+		raw_spin_lock_init(&safe_read_lock);
+	}
+
 	printk_safe_flush();
 }
 


