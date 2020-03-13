Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB74183F30
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 03:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgCMCks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 22:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgCMCks (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 22:40:48 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC5E20736;
        Fri, 13 Mar 2020 02:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584067248;
        bh=/XdpGgEtuWJXlpQYE6PfA/melM7UXnrXGPeSAla6eYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wz1Sz8P3k5NeYdAKmsHoK4qeEWGixq0O1Jo7Rjs86p4j6D5JKF7SDB2bbV6usoQrP
         gC6E8CnvC+Oov1Yp3lRocjxaRFhvx6mW9nSyEHga74oXsZQWeC01wzyf/qnSF6QpjC
         NnKq7qQFkvuijY12886BEi1720hoI5+n3yO9q8bQ=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "# 5 . 5 . x" <stable@vger.kernel.org>
Subject: [PATCH RFC tip/core/rcu 1/2] rcu: Don't acquire lock in NMI handler in rcu_nmi_enter_common()
Date:   Thu, 12 Mar 2020 19:40:45 -0700
Message-Id: <20200313024046.27622-1-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200313024007.GA27492@paulmck-ThinkPad-P72>
References: <20200313024007.GA27492@paulmck-ThinkPad-P72>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

The rcu_nmi_enter_common() function can be invoked both in interrupt
and NMI handlers.  If it is invoked from process context (as opposed
to userspace or idle context) on a nohz_full CPU, it might acquire the
CPU's leaf rcu_node structure's ->lock.  Because this lock is held only
with interrupts disabled, this is safe from an interrupt handler, but
doing so from an NMI handler can result in self-deadlock.

This commit therefore adds "irq" to the "if" condition so as to only
acquire the ->lock from irq handlers or process context, never from
an NMI handler.

Fixes: 5b14557b073c ("rcu: Avoid tick_dep_set_cpu() misordering")
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: <stable@vger.kernel.org> # 5.5.x
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index d3f52c3..f7d3e48 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -825,7 +825,7 @@ static __always_inline void rcu_nmi_enter_common(bool irq)
 			rcu_cleanup_after_idle();
 
 		incby = 1;
-	} else if (tick_nohz_full_cpu(rdp->cpu) &&
+	} else if (irq && tick_nohz_full_cpu(rdp->cpu) &&
 		   rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
 		   READ_ONCE(rdp->rcu_urgent_qs) &&
 		   !READ_ONCE(rdp->rcu_forced_tick)) {
-- 
2.9.5

