Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2DC3291AB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhCAU3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:29:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243301AbhCAUXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB401653FB;
        Mon,  1 Mar 2021 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621912;
        bh=jndP/atYEx1DXAoD9+8u6UWOuQz+iYeZGp1liYsxr4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzi6M6Lk45WWvJh8MWuRcV7PigD6cFFEvT142jqyzU76o4p28vcZegXlcE8DaEUm5
         LtwOwoR8dftHpXvfO4f8a4CZpnCUp66ZHuf1DG3T+TTGm9apEFlYzMv4U+CzBYDN6O
         AhpEmQXLe0ESiQ6bMOvIashfcZUaIfGYFW+HzlJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.11 688/775] arm64: spectre: Prevent lockdep splat on v4 mitigation enable path
Date:   Mon,  1 Mar 2021 17:14:16 +0100
Message-Id: <20210301161235.384895940@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit a2c42bbabbe260b7626d8459093631a6e16ee0ee upstream.

The Spectre-v4 workaround is re-configured when resuming from suspend,
as the firmware may have re-enabled the mitigation despite the user
previously asking for it to be disabled.

Enabling or disabling the workaround can result in an undefined
instruction exception on CPUs which implement PSTATE.SSBS but only allow
it to be configured by adjusting the SPSR on exception return. We handle
this by installing an 'undef hook' which effectively emulates the access.

Installing this hook requires us to take a couple of spinlocks both to
avoid corrupting the internal list of hooks but also to ensure that we
don't run into an unhandled exception. Unfortunately, when resuming from
suspend, we haven't yet called rcu_idle_exit() and so lockdep gets angry
about "suspicious RCU usage". In doing so, it tries to print a warning,
which leads it to get even more suspicious, this time about itself:

 |  rcu_scheduler_active = 2, debug_locks = 1
 |  RCU used illegally from extended quiescent state!
 |  1 lock held by swapper/0:
 |   #0: (logbuf_lock){-.-.}-{2:2}, at: vprintk_emit+0x88/0x198
 |
 |  Call trace:
 |   dump_backtrace+0x0/0x1d8
 |   show_stack+0x18/0x24
 |   dump_stack+0xe0/0x17c
 |   lockdep_rcu_suspicious+0x11c/0x134
 |   trace_lock_release+0xa0/0x160
 |   lock_release+0x3c/0x290
 |   _raw_spin_unlock+0x44/0x80
 |   vprintk_emit+0xbc/0x198
 |   vprintk_default+0x44/0x6c
 |   vprintk_func+0x1f4/0x1fc
 |   printk+0x54/0x7c
 |   lockdep_rcu_suspicious+0x30/0x134
 |   trace_lock_acquire+0xa0/0x188
 |   lock_acquire+0x50/0x2fc
 |   _raw_spin_lock+0x68/0x80
 |   spectre_v4_enable_mitigation+0xa8/0x30c
 |   __cpu_suspend_exit+0xd4/0x1a8
 |   cpu_suspend+0xa0/0x104
 |   psci_cpu_suspend_enter+0x3c/0x5c
 |   psci_enter_idle_state+0x44/0x74
 |   cpuidle_enter_state+0x148/0x2f8
 |   cpuidle_enter+0x38/0x50
 |   do_idle+0x1f0/0x2b4

Prevent these splats by running __cpu_suspend_exit() with RCU watching.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Suggested-by: "Paul E . McKenney" <paulmck@kernel.org>
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Fixes: c28762070ca6 ("arm64: Rewrite Spectre-v4 mitigation code")
Cc: <stable@vger.kernel.org>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20210218140346.5224-1-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/suspend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -119,7 +119,7 @@ int cpu_suspend(unsigned long arg, int (
 		if (!ret)
 			ret = -EOPNOTSUPP;
 	} else {
-		__cpu_suspend_exit();
+		RCU_NONIDLE(__cpu_suspend_exit());
 	}
 
 	unpause_graph_tracing();


