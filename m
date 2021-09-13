Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE89C409511
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346100AbhIMOhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347809AbhIMOfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:35:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5A1461989;
        Mon, 13 Sep 2021 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541222;
        bh=ohwEJtFRB3PaxDtINta776MDdnaHFIlz/gMmTM7tb7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3Osv2qqtSKpSFTnsm68M4n6ZAuRuJQ0JVBoqAu4YZf+zDZYdwCwmz+2xqymGR2Zr
         tsJuc2hyjvo3N/Ft+eSxMSIXkDewDaXoUJdGTxABZ712cNUPU2IqoNLrX/D3poauRr
         eE5TEfUCujDS7m5Pv164aBtFqijsUn7w4/WS7KBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 213/334] PM: cpu: Make notifier chain use a raw_spinlock_t
Date:   Mon, 13 Sep 2021 15:14:27 +0200
Message-Id: <20210913131120.629151058@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit b2f6662ac08d0e7c25574ce53623c71bdae9dd78 ]

Invoking atomic_notifier_chain_notify() requires acquiring a spinlock_t,
which can block under CONFIG_PREEMPT_RT. Notifications for members of the
cpu_pm notification chain will be issued by the idle task, which can never
block.

Making *all* atomic_notifiers use a raw_spinlock is too big of a hammer, as
only notifications issued by the idle task are problematic.

Special-case cpu_pm_notifier_chain by kludging a raw_notifier and
raw_spinlock_t together, matching the atomic_notifier behavior with a
raw_spinlock_t.

Fixes: 70d932985757 ("notifier: Fix broken error handling pattern")
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu_pm.c | 50 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
index f7e1d0eccdbc..246efc74e3f3 100644
--- a/kernel/cpu_pm.c
+++ b/kernel/cpu_pm.c
@@ -13,19 +13,32 @@
 #include <linux/spinlock.h>
 #include <linux/syscore_ops.h>
 
-static ATOMIC_NOTIFIER_HEAD(cpu_pm_notifier_chain);
+/*
+ * atomic_notifiers use a spinlock_t, which can block under PREEMPT_RT.
+ * Notifications for cpu_pm will be issued by the idle task itself, which can
+ * never block, IOW it requires using a raw_spinlock_t.
+ */
+static struct {
+	struct raw_notifier_head chain;
+	raw_spinlock_t lock;
+} cpu_pm_notifier = {
+	.chain = RAW_NOTIFIER_INIT(cpu_pm_notifier.chain),
+	.lock  = __RAW_SPIN_LOCK_UNLOCKED(cpu_pm_notifier.lock),
+};
 
 static int cpu_pm_notify(enum cpu_pm_event event)
 {
 	int ret;
 
 	/*
-	 * atomic_notifier_call_chain has a RCU read critical section, which
-	 * could be disfunctional in cpu idle. Copy RCU_NONIDLE code to let
-	 * RCU know this.
+	 * This introduces a RCU read critical section, which could be
+	 * disfunctional in cpu idle. Copy RCU_NONIDLE code to let RCU know
+	 * this.
 	 */
 	rcu_irq_enter_irqson();
-	ret = atomic_notifier_call_chain(&cpu_pm_notifier_chain, event, NULL);
+	rcu_read_lock();
+	ret = raw_notifier_call_chain(&cpu_pm_notifier.chain, event, NULL);
+	rcu_read_unlock();
 	rcu_irq_exit_irqson();
 
 	return notifier_to_errno(ret);
@@ -33,10 +46,13 @@ static int cpu_pm_notify(enum cpu_pm_event event)
 
 static int cpu_pm_notify_robust(enum cpu_pm_event event_up, enum cpu_pm_event event_down)
 {
+	unsigned long flags;
 	int ret;
 
 	rcu_irq_enter_irqson();
-	ret = atomic_notifier_call_chain_robust(&cpu_pm_notifier_chain, event_up, event_down, NULL);
+	raw_spin_lock_irqsave(&cpu_pm_notifier.lock, flags);
+	ret = raw_notifier_call_chain_robust(&cpu_pm_notifier.chain, event_up, event_down, NULL);
+	raw_spin_unlock_irqrestore(&cpu_pm_notifier.lock, flags);
 	rcu_irq_exit_irqson();
 
 	return notifier_to_errno(ret);
@@ -49,12 +65,17 @@ static int cpu_pm_notify_robust(enum cpu_pm_event event_up, enum cpu_pm_event ev
  * Add a driver to a list of drivers that are notified about
  * CPU and CPU cluster low power entry and exit.
  *
- * This function may sleep, and has the same return conditions as
- * raw_notifier_chain_register.
+ * This function has the same return conditions as raw_notifier_chain_register.
  */
 int cpu_pm_register_notifier(struct notifier_block *nb)
 {
-	return atomic_notifier_chain_register(&cpu_pm_notifier_chain, nb);
+	unsigned long flags;
+	int ret;
+
+	raw_spin_lock_irqsave(&cpu_pm_notifier.lock, flags);
+	ret = raw_notifier_chain_register(&cpu_pm_notifier.chain, nb);
+	raw_spin_unlock_irqrestore(&cpu_pm_notifier.lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(cpu_pm_register_notifier);
 
@@ -64,12 +85,17 @@ EXPORT_SYMBOL_GPL(cpu_pm_register_notifier);
  *
  * Remove a driver from the CPU PM notifier list.
  *
- * This function may sleep, and has the same return conditions as
- * raw_notifier_chain_unregister.
+ * This function has the same return conditions as raw_notifier_chain_unregister.
  */
 int cpu_pm_unregister_notifier(struct notifier_block *nb)
 {
-	return atomic_notifier_chain_unregister(&cpu_pm_notifier_chain, nb);
+	unsigned long flags;
+	int ret;
+
+	raw_spin_lock_irqsave(&cpu_pm_notifier.lock, flags);
+	ret = raw_notifier_chain_unregister(&cpu_pm_notifier.chain, nb);
+	raw_spin_unlock_irqrestore(&cpu_pm_notifier.lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(cpu_pm_unregister_notifier);
 
-- 
2.30.2



