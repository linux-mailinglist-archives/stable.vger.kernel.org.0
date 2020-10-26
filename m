Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FF9298B97
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 12:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772065AbgJZLR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 07:17:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39210 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771658AbgJZLR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 07:17:27 -0400
Date:   Mon, 26 Oct 2020 11:17:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603711044;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rNDs6bpZpK+4fqKA7xYj7+yLSIpGYZIr6FmNG8YWfaM=;
        b=c6ea4/xkOHuR5XuSya9Jy/sYvJRjr2Anx1mzgXmPqpeDEIYC4LetSJv4i0p8rU/rDCuIuq
        q9OA/nok6zj3NoeEtP5uAotYTym3aU7T1iXE0ipzOOZmsYISyY1DrTQUCPU2yqhiulGPiZ
        2k5Ab0SYTmdV4jprbkcmrBTyzwRPJG9rzSbZUlrGDL+i/jxOx/e+vGQLxdiM/6hN7jUHgO
        HVJvOlKtgxOna+g68gfJr5ZrihUx3fWvriMxCaKjZQh6c0QMDKmUXHfjn2TtFFBhuEjooZ
        9LTqw19TYSLphzU07vsYzaAA3UWZMe6l3d4/3AlaS0NzXvSOEIWQZPNwAMmRpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603711044;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rNDs6bpZpK+4fqKA7xYj7+yLSIpGYZIr6FmNG8YWfaM=;
        b=WnfT42vuMr+h7keSCV1GwxGX3SOecrZyHF4oFNubqad0xri25krNHFZ116LnHiTe8ghWfG
        8OOHCuzE8vKfoFDw==
From:   "tip-bot2 for Zong Li" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: smp/urgent] stop_machine, rcu: Mark functions as notrace
Cc:     Zong Li <zong.li@sifive.com>, Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <atish.patra@wdc.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20201021073839.43935-1-zong.li@sifive.com>
References: <20201021073839.43935-1-zong.li@sifive.com>
MIME-Version: 1.0
Message-ID: <160371104269.397.18106018255287440015.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the smp/urgent branch of tip:

Commit-ID:     4230e2deaa484b385aa01d598b2aea8e7f2660a6
Gitweb:        https://git.kernel.org/tip/4230e2deaa484b385aa01d598b2aea8e7f2660a6
Author:        Zong Li <zong.li@sifive.com>
AuthorDate:    Wed, 21 Oct 2020 15:38:39 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 26 Oct 2020 12:12:27 +01:00

stop_machine, rcu: Mark functions as notrace

Some architectures assume that the stopped CPUs don't make function calls
to traceable functions when they are in the stopped state. See also commit
cb9d7fd51d9f ("watchdog: Mark watchdog touch functions as notrace").

Violating this assumption causes kernel crashes when switching tracer on
RISC-V.

Mark rcu_momentary_dyntick_idle() and stop_machine_yield() notrace to
prevent this.

Fixes: 4ecf0a43e729 ("processor: get rid of cpu_relax_yield")
Fixes: 366237e7b083 ("stop_machine: Provide RCU quiescent state in multi_cpu_stop()")
Signed-off-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Atish Patra <atish.patra@wdc.com>
Tested-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201021073839.43935-1-zong.li@sifive.com
---
 kernel/rcu/tree.c     | 2 +-
 kernel/stop_machine.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 06895ef..2a52f42 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -409,7 +409,7 @@ bool rcu_eqs_special_set(int cpu)
  *
  * The caller must have disabled interrupts and must not be idle.
  */
-void rcu_momentary_dyntick_idle(void)
+notrace void rcu_momentary_dyntick_idle(void)
 {
 	int special;
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 865bb02..890b79c 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -178,7 +178,7 @@ static void ack_state(struct multi_stop_data *msdata)
 		set_state(msdata, msdata->state + 1);
 }
 
-void __weak stop_machine_yield(const struct cpumask *cpumask)
+notrace void __weak stop_machine_yield(const struct cpumask *cpumask)
 {
 	cpu_relax();
 }
