Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BFA316867
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 14:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhBJNyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 08:54:35 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:60042 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbhBJNyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 08:54:18 -0500
Date:   Wed, 10 Feb 2021 13:53:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612965213;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUXBNZUZM/zV02r3o2nkfk/PjR5NE+dSINynC9k6j70=;
        b=IcMo0k45yVD/uWtj/kAph+BAXHU/LfcYZnE08focEMQztkF0Edo7Qc09RGrRWapSZsJSBV
        wCEIAHzEcvK9YFnjBX0hYasYjFrDRgMD0xzGgTLSdXOZdweRcCZOoGo38d7z+DkJJT3MqK
        dowvl+MyF58beb799cb5QKY8cUym3ftk26//056XhjqAB+ZKbdGqULE/nyIcvDCg8achx2
        fAfkxUrJrW7XR7hKbJx5E92gALXGg7gbjyN3mBCO/GACR8pxGPT+XpUruPl0qTZ+knhp4T
        WSrhGdsFJaTNUeP/gaP7SyxcoKZNIpCUnIaekzoj8+QPD1+nik9KIjDoCPtA+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612965213;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUXBNZUZM/zV02r3o2nkfk/PjR5NE+dSINynC9k6j70=;
        b=QLkwd3rZPQBRPul9DRTEr0QrY5+Xb5o4/K1sON+TaW5P4P7shMKaAza5zXGdKYQ+a+P62b
        PBqZL/c+2LPyE+Bw==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210131230548.32970-2-frederic@kernel.org>
References: <20210131230548.32970-2-frederic@kernel.org>
MIME-Version: 1.0
Message-ID: <161296521285.23325.9412427201506411097.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     e4234f21d2ea7674bcc1aeaca9d382b50ca1efec
Gitweb:        https://git.kernel.org/tip/e4234f21d2ea7674bcc1aeaca9d382b50ca1efec
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Mon, 01 Feb 2021 00:05:44 +01:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 10 Feb 2021 14:44:49 +01:00

rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers

Deferred wakeup of rcuog kthreads upon RCU idle mode entry is going to
be handled differently whether initiated by idle, user or guest. Prepare
with pulling that control up to rcu_eqs_enter() callers.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-2-frederic@kernel.org
---
 kernel/rcu/tree.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 40e5e3d..63032e5 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -644,7 +644,6 @@ static noinstr void rcu_eqs_enter(bool user)
 	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	rdp = this_cpu_ptr(&rcu_data);
-	do_nocb_deferred_wakeup(rdp);
 	rcu_prepare_for_idle();
 	rcu_preempt_deferred_qs(current);
 
@@ -672,7 +671,10 @@ static noinstr void rcu_eqs_enter(bool user)
  */
 void rcu_idle_enter(void)
 {
+	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
+
 	lockdep_assert_irqs_disabled();
+	do_nocb_deferred_wakeup(rdp);
 	rcu_eqs_enter(false);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -691,7 +693,14 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
  */
 noinstr void rcu_user_enter(void)
 {
+	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
+
 	lockdep_assert_irqs_disabled();
+
+	instrumentation_begin();
+	do_nocb_deferred_wakeup(rdp);
+	instrumentation_end();
+
 	rcu_eqs_enter(true);
 }
 #endif /* CONFIG_NO_HZ_FULL */
