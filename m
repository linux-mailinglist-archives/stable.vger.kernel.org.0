Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE4A3831DE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbhEQOlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241068AbhEQOjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:39:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E39C6193E;
        Mon, 17 May 2021 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261115;
        bh=xX2nbimtUVyR0Sp6NpIABddS2O1F5k0+Im8naCZcRJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xuqs5A5QEkck0BYqg+jnJ/tv4Hwb3T7fA2W2PeQkGX0Zs1Li4h/al7XzKT/s4T5vF
         W2a+oEBSCUDW8iGKsSMTs6ADgp01V4+Bmwx+jzuBOqP5/KG+YpktbXerIZltBGkcQN
         hs0mfpbocHFqb0YnoGTJiz/L4yUN/DuhKdB8wvEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6beae4000559d41d80f8@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 278/363] KVM: x86: Prevent deadlock against tk_core.seq
Date:   Mon, 17 May 2021 16:02:24 +0200
Message-Id: <20210517140312.013938261@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 3f804f6d201ca93adf4c3df04d1bfd152c1129d6 ]

syzbot reported a possible deadlock in pvclock_gtod_notify():

CPU 0  		  	   	    	    CPU 1
write_seqcount_begin(&tk_core.seq);
  pvclock_gtod_notify()			    spin_lock(&pool->lock);
    queue_work(..., &pvclock_gtod_work)	    ktime_get()
     spin_lock(&pool->lock);		      do {
     						seq = read_seqcount_begin(tk_core.seq)
						...
				              } while (read_seqcount_retry(&tk_core.seq, seq);

While this is unlikely to happen, it's possible.

Delegate queue_work() to irq_work() which postpones it until the
tk_core.seq write held region is left and interrupts are reenabled.

Fixes: 16e8d74d2da9 ("KVM: x86: notifier for clocksource changes")
Reported-by: syzbot+6beae4000559d41d80f8@syzkaller.appspotmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Message-Id: <87h7jgm1zy.ffs@nanos.tec.linutronix.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1fd52eddabf..c37c23c6b178 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7964,6 +7964,18 @@ static void pvclock_gtod_update_fn(struct work_struct *work)
 
 static DECLARE_WORK(pvclock_gtod_work, pvclock_gtod_update_fn);
 
+/*
+ * Indirection to move queue_work() out of the tk_core.seq write held
+ * region to prevent possible deadlocks against time accessors which
+ * are invoked with work related locks held.
+ */
+static void pvclock_irq_work_fn(struct irq_work *w)
+{
+	queue_work(system_long_wq, &pvclock_gtod_work);
+}
+
+static DEFINE_IRQ_WORK(pvclock_irq_work, pvclock_irq_work_fn);
+
 /*
  * Notification about pvclock gtod data update.
  */
@@ -7975,13 +7987,14 @@ static int pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
 
 	update_pvclock_gtod(tk);
 
-	/* disable master clock if host does not trust, or does not
-	 * use, TSC based clocksource.
+	/*
+	 * Disable master clock if host does not trust, or does not use,
+	 * TSC based clocksource. Delegate queue_work() to irq_work as
+	 * this is invoked with tk_core.seq write held.
 	 */
 	if (!gtod_is_based_on_tsc(gtod->clock.vclock_mode) &&
 	    atomic_read(&kvm_guest_has_master_clock) != 0)
-		queue_work(system_long_wq, &pvclock_gtod_work);
-
+		irq_work_queue(&pvclock_irq_work);
 	return 0;
 }
 
@@ -8096,6 +8109,7 @@ void kvm_arch_exit(void)
 	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
+	irq_work_sync(&pvclock_irq_work);
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
-- 
2.30.2



