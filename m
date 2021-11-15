Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03356452648
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343517AbhKPCEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:04:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239578AbhKOSDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8750363256;
        Mon, 15 Nov 2021 17:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997874;
        bh=sdsidGcPE7DXp6zNXMskRefZeui9K0bcLJxqJqIkqX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwhB9Zw644mPBnzBwNsgv9be0oBR4gNFCjbtpVW7k0HFShZ5sDpl5ue1nu3/bGIlJ
         Av+KwdlNRLu7Fv1eEFABzPKhyef8fLI4bqsVHMrZQ/3qozW2AdECtfVUQu5kkIMTfY
         bx9c0eSgV4M26ngqv0NmylqmZ3HVEEDxVa8/lov0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/575] rcu: Always inline rcu_dynticks_task*_{enter,exit}()
Date:   Mon, 15 Nov 2021 18:00:31 +0100
Message-Id: <20211115165354.373668302@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7663ad9a5dbcc27f3090e6bfd192c7e59222709f ]

RCU managed to grow a few noinstr violations:

  vmlinux.o: warning: objtool: rcu_dynticks_eqs_enter()+0x0: call to rcu_dynticks_task_trace_enter() leaves .noinstr.text section
  vmlinux.o: warning: objtool: rcu_dynticks_eqs_exit()+0xe: call to rcu_dynticks_task_trace_exit() leaves .noinstr.text section

Fix them by adding __always_inline to the relevant trivial functions.

Also replace the noinstr with __always_inline for the existing
rcu_dynticks_task_*() functions since noinstr would force noinline
them, even when empty, which seems silly.

Fixes: 7d0c9c50c5a1 ("rcu-tasks: Avoid IPIing userspace/idle tasks if kernel is so built")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c5091aeaa37bb..6ed153f226b39 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2573,7 +2573,7 @@ static void rcu_bind_gp_kthread(void)
 }
 
 /* Record the current task on dyntick-idle entry. */
-static void noinstr rcu_dynticks_task_enter(void)
+static __always_inline void rcu_dynticks_task_enter(void)
 {
 #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
 	WRITE_ONCE(current->rcu_tasks_idle_cpu, smp_processor_id());
@@ -2581,7 +2581,7 @@ static void noinstr rcu_dynticks_task_enter(void)
 }
 
 /* Record no current task on dyntick-idle exit. */
-static void noinstr rcu_dynticks_task_exit(void)
+static __always_inline void rcu_dynticks_task_exit(void)
 {
 #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
 	WRITE_ONCE(current->rcu_tasks_idle_cpu, -1);
@@ -2589,7 +2589,7 @@ static void noinstr rcu_dynticks_task_exit(void)
 }
 
 /* Turn on heavyweight RCU tasks trace readers on idle/user entry. */
-static void rcu_dynticks_task_trace_enter(void)
+static __always_inline void rcu_dynticks_task_trace_enter(void)
 {
 #ifdef CONFIG_TASKS_TRACE_RCU
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB))
@@ -2598,7 +2598,7 @@ static void rcu_dynticks_task_trace_enter(void)
 }
 
 /* Turn off heavyweight RCU tasks trace readers on idle/user exit. */
-static void rcu_dynticks_task_trace_exit(void)
+static __always_inline void rcu_dynticks_task_trace_exit(void)
 {
 #ifdef CONFIG_TASKS_TRACE_RCU
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB))
-- 
2.33.0



