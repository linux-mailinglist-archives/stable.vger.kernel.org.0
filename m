Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C50315DF1
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 04:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhBJDvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 22:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhBJDvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 22:51:13 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AB1C061574
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 19:50:32 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id n10so347763pgl.10
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 19:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YMzNOFpQK3tdXCz04PvQCSRwyCzZzBZrPMbwp4j5y6E=;
        b=b2brF10q4JwVpt8NbSYWrJ8KCZa/DK5qdTJ4mEtrUMvJNPWUfRyQ9BPWlk/DKsUIbU
         5BSSE+wq61Fc+14Be405C55ao4kMWD0oKGpwyrM93fhRLRph7BJI1Htqy+LmbNBs8+GO
         k0M1nw8/ybNg3ViLoZSGxBCickPDfTIw/APPEdB55Pfq6sDGD4pyPsVyWNk/+7YjT010
         /mYrnI/DAgBQCGCG31Nz4a7wkbHvXgcgCO7aAkewf0WSWTbr6L8gyQ7nzsXxpF+15+a7
         3MfbT1tnpiboGA80fK+rVvmMe8Mfj74jlJjumqR/MJDZVZHUNRAkgzFzd1K7vXZFqe0J
         N6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YMzNOFpQK3tdXCz04PvQCSRwyCzZzBZrPMbwp4j5y6E=;
        b=CbhnT2MGp8Hqz1/AiGG4XGHF0EClOybaXe3yYvJTHYRNDBvOHoCteAxALA1uwV0M7/
         d922CYnl7k4SyYKBAA4CD1RBIiPYPVTqn66QIZlqdtedtuxguOpSlaf9Pu0XtCN2Mks4
         i/B24KHAoGR305nsha5Jb4fhaMViQI9/6jZ+Hzk8njlP4fA8QuFmaYovpeA91nbshz37
         ElsyMkB6+yKn04/GZBQlyOyZXz1m60k3mD3KEZGyJMv/KKWjVJn+U1rq925oFg/ss9+m
         oZkIihWnGVn6NvFXaKQHliqXeKudOePfmMOASHBoJG4qEaacBr2M6CEss/ZeU3HpOKlz
         ROWQ==
X-Gm-Message-State: AOAM532yqD5mYqPlnJJentAOnUjb4Fa+j/s4kBNurLCOn6Pqvpfqb1BS
        OPq0mbq7/1vKOv5j/CoUmjLbPQ==
X-Google-Smtp-Source: ABdhPJyLwBA7gN5wlijQgPR6l1/+cLCNmPNRgKC9ffxhvrF7LJcWNjnaYEPaCEcj1Z35l/vvazmw6w==
X-Received: by 2002:a63:d256:: with SMTP id t22mr1198442pgi.351.1612929032269;
        Tue, 09 Feb 2021 19:50:32 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id h8sm331301pfv.154.2021.02.09.19.50.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 19:50:31 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     pmladek@suse.com, sergey.senozhatsky@gmail.com,
        rostedt@goodmis.org, john.ogness@linutronix.de,
        akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH v3] printk: fix deadlock when kernel panic
Date:   Wed, 10 Feb 2021 11:48:23 +0800
Message-Id: <20210210034823.64867-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 kernel/printk/printk_safe.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk_safe.c b/kernel/printk/printk_safe.c
index a0e6f746de6c..2e9e3ed7d63e 100644
--- a/kernel/printk/printk_safe.c
+++ b/kernel/printk/printk_safe.c
@@ -45,6 +45,8 @@ struct printk_safe_seq_buf {
 static DEFINE_PER_CPU(struct printk_safe_seq_buf, safe_print_seq);
 static DEFINE_PER_CPU(int, printk_context);
 
+static DEFINE_RAW_SPINLOCK(safe_read_lock);
+
 #ifdef CONFIG_PRINTK_NMI
 static DEFINE_PER_CPU(struct printk_safe_seq_buf, nmi_print_seq);
 #endif
@@ -180,8 +182,6 @@ static void report_message_lost(struct printk_safe_seq_buf *s)
  */
 static void __printk_safe_flush(struct irq_work *work)
 {
-	static raw_spinlock_t read_lock =
-		__RAW_SPIN_LOCK_INITIALIZER(read_lock);
 	struct printk_safe_seq_buf *s =
 		container_of(work, struct printk_safe_seq_buf, work);
 	unsigned long flags;
@@ -195,7 +195,7 @@ static void __printk_safe_flush(struct irq_work *work)
 	 * different CPUs. This is especially important when printing
 	 * a backtrace.
 	 */
-	raw_spin_lock_irqsave(&read_lock, flags);
+	raw_spin_lock_irqsave(&safe_read_lock, flags);
 
 	i = 0;
 more:
@@ -232,7 +232,7 @@ static void __printk_safe_flush(struct irq_work *work)
 
 out:
 	report_message_lost(s);
-	raw_spin_unlock_irqrestore(&read_lock, flags);
+	raw_spin_unlock_irqrestore(&safe_read_lock, flags);
 }
 
 /**
@@ -278,6 +278,14 @@ void printk_safe_flush_on_panic(void)
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
 
-- 
2.11.0

