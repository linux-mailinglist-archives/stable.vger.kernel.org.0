Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA2D2EFCFA
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 03:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAICGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 21:06:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAICGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 21:06:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBE5523AA3;
        Sat,  9 Jan 2021 02:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610157944;
        bh=v791WB2v2utt682YfDHd4SulRJUpxAa2zQeuc72C4kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkPX/mOR3gDRm7NSey1D4Du9WsvRK6JUlmC/slaUymT+g/benNfPlygpMEK5WD3MO
         7l4m9qm6UN+/iCupRdK4R5+e+yZZ1bJBKCF84LuaxmXmhxIhFn6zOSBe63W/OYYkPj
         3BCrwKkiX8wAU82qJx+3q1Q8BXRMfqm+Amyr9zWc4gN/WbuYI3t2WWPul8I6ZoXD/V
         k5+NtL3JiiauD16DZssaed2jTOOymRat9jY/p5189TPTWFYwjDQKIn/k8mQOL1+dqP
         fGOpKPKI6llBSvy5htk9FR9YNVPbQ/d7PdygMl85b8pgUMoA6r289rA4SJjgrMf5+l
         hi3wGawtZDoUw==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [RFC PATCH 1/8] rcu: Remove superfluous rdp fetch
Date:   Sat,  9 Jan 2021 03:05:29 +0100
Message-Id: <20210109020536.127953-2-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109020536.127953-1-frederic@kernel.org>
References: <20210109020536.127953-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar<mingo@kernel.org>
---
 kernel/rcu/tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 40e5e3dd253e..fef90c467670 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -643,7 +643,6 @@ static noinstr void rcu_eqs_enter(bool user)
 	instrumentation_begin();
 	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
-	rdp = this_cpu_ptr(&rcu_data);
 	do_nocb_deferred_wakeup(rdp);
 	rcu_prepare_for_idle();
 	rcu_preempt_deferred_qs(current);
-- 
2.25.1

