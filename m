Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9904C2A57D9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbgKCVqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732068AbgKCUwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA862236F;
        Tue,  3 Nov 2020 20:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436738;
        bh=Me2iG8T7EH6M0qz1inYpkb2a5RQLwzVtJ7yiKOSh94I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0C/NFS1Ic2wC6D5yE3JNQloCgHWNmBnQaQytwjfrGfZL98brD0mrd3ZDlILAPnzI8
         opF7rt8yrg3KF5YiHGdUcdNxnFG9tTpRHQLkXcaCloFW+FFgdWnrwLTonL17IuMbSm
         wFP33rBjo0cqKIhDB6J+4f/Xc4Q4vnhoGZKhJpbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zong Li <zong.li@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <atish.patra@wdc.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.9 380/391] stop_machine, rcu: Mark functions as notrace
Date:   Tue,  3 Nov 2020 21:37:11 +0100
Message-Id: <20201103203412.807084409@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong Li <zong.li@sifive.com>

commit 4230e2deaa484b385aa01d598b2aea8e7f2660a6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcu/tree.c     |    2 +-
 kernel/stop_machine.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -416,7 +416,7 @@ bool rcu_eqs_special_set(int cpu)
  *
  * The caller must have disabled interrupts and must not be idle.
  */
-void rcu_momentary_dyntick_idle(void)
+notrace void rcu_momentary_dyntick_idle(void)
 {
 	int special;
 
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -178,7 +178,7 @@ static void ack_state(struct multi_stop_
 		set_state(msdata, msdata->state + 1);
 }
 
-void __weak stop_machine_yield(const struct cpumask *cpumask)
+notrace void __weak stop_machine_yield(const struct cpumask *cpumask)
 {
 	cpu_relax();
 }


