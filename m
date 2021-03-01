Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34986329195
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243354AbhCAU2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:28:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47791 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243111AbhCAUVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:21:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE321653F4;
        Mon,  1 Mar 2021 18:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621874;
        bh=45PiAJj6RUDqc5W7aCX2bycT9L0iqSXRuEWHzzkpJZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvKaL9xWSEmnk3dA0IXkm0Er0W4GWvJ70XRNDnFf35jN8ZZStcLdfh7YwDbTHu1AX
         3e9/8ne8BIOkHcAeQ1OvWq/WcvKqcUgC+p2FY4WuZXJUbGbmUOjZn1cbVoSw0mwzFj
         yCJddgmx+HXleLlKcDNa80zvlEmkrF9+9evPISEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.11 676/775] rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers
Date:   Mon,  1 Mar 2021 17:14:04 +0100
Message-Id: <20210301161234.788791214@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

commit 54b7429efffc99e845ba9381bee3244f012a06c2 upstream.

Deferred wakeup of rcuog kthreads upon RCU idle mode entry is going to
be handled differently whether initiated by idle, user or guest. Prepare
with pulling that control up to rcu_eqs_enter() callers.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-2-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -644,7 +644,6 @@ static noinstr void rcu_eqs_enter(bool u
 	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	rdp = this_cpu_ptr(&rcu_data);
-	do_nocb_deferred_wakeup(rdp);
 	rcu_prepare_for_idle();
 	rcu_preempt_deferred_qs(current);
 
@@ -672,7 +671,10 @@ static noinstr void rcu_eqs_enter(bool u
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


