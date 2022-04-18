Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0F250515E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbiDRMec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239794AbiDRMd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360FD1B7A3;
        Mon, 18 Apr 2022 05:26:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE404B80EC4;
        Mon, 18 Apr 2022 12:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383B4C385A1;
        Mon, 18 Apr 2022 12:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284779;
        bh=xNVqXF/CJGdj4dmUuJDXx7TyQ41i5yaL833R072XBEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjwKf8aBANEQwyfj4AH3VQQFiViwOm8XG4m2QpPqNYM5JKqwDOyLFzkjmNXOTUbm5
         9uByyusbDMzYxEsq5zzWj/Alqu2fDYJUrbCKMAL+HYS1uL5ulOjcsadxWRdVA3uc9Q
         s5d9UQQ7aaBLsnn35HHZRy+WzS1jiD+kW2btf2Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.17 218/219] cpu/hotplug: Remove the cpu member of cpuhp_cpu_state
Date:   Mon, 18 Apr 2022 14:13:07 +0200
Message-Id: <20220418121212.968801198@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

commit b7ba6d8dc3569e49800ef0136799f26f43e237e8 upstream.

Currently the setting of the 'cpu' member of struct cpuhp_cpu_state in
cpuhp_create() is too late as it is used earlier in _cpu_up().

If kzalloc_node() in __smpboot_create_thread() fails then the rollback will
be done with st->cpu==0 causing CPU0 to be erroneously set to be dying,
causing the scheduler to get mightily confused and throw its toys out of
the pram.

However the cpu number is actually available directly, so simply remove
the 'cpu' member and avoid the problem in the first place.

Fixes: 2ea46c6fc945 ("cpumask/hotplug: Fix cpu_dying() state tracking")
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220411152233.474129-2-steven.price@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cpu.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -70,7 +70,6 @@ struct cpuhp_cpu_state {
 	bool			rollback;
 	bool			single;
 	bool			bringup;
-	int			cpu;
 	struct hlist_node	*node;
 	struct hlist_node	*last;
 	enum cpuhp_state	cb_state;
@@ -474,7 +473,7 @@ static inline bool cpu_smt_allowed(unsig
 #endif
 
 static inline enum cpuhp_state
-cpuhp_set_state(struct cpuhp_cpu_state *st, enum cpuhp_state target)
+cpuhp_set_state(int cpu, struct cpuhp_cpu_state *st, enum cpuhp_state target)
 {
 	enum cpuhp_state prev_state = st->state;
 	bool bringup = st->state < target;
@@ -485,14 +484,15 @@ cpuhp_set_state(struct cpuhp_cpu_state *
 	st->target = target;
 	st->single = false;
 	st->bringup = bringup;
-	if (cpu_dying(st->cpu) != !bringup)
-		set_cpu_dying(st->cpu, !bringup);
+	if (cpu_dying(cpu) != !bringup)
+		set_cpu_dying(cpu, !bringup);
 
 	return prev_state;
 }
 
 static inline void
-cpuhp_reset_state(struct cpuhp_cpu_state *st, enum cpuhp_state prev_state)
+cpuhp_reset_state(int cpu, struct cpuhp_cpu_state *st,
+		  enum cpuhp_state prev_state)
 {
 	bool bringup = !st->bringup;
 
@@ -519,8 +519,8 @@ cpuhp_reset_state(struct cpuhp_cpu_state
 	}
 
 	st->bringup = bringup;
-	if (cpu_dying(st->cpu) != !bringup)
-		set_cpu_dying(st->cpu, !bringup);
+	if (cpu_dying(cpu) != !bringup)
+		set_cpu_dying(cpu, !bringup);
 }
 
 /* Regular hotplug invocation of the AP hotplug thread */
@@ -540,15 +540,16 @@ static void __cpuhp_kick_ap(struct cpuhp
 	wait_for_ap_thread(st, st->bringup);
 }
 
-static int cpuhp_kick_ap(struct cpuhp_cpu_state *st, enum cpuhp_state target)
+static int cpuhp_kick_ap(int cpu, struct cpuhp_cpu_state *st,
+			 enum cpuhp_state target)
 {
 	enum cpuhp_state prev_state;
 	int ret;
 
-	prev_state = cpuhp_set_state(st, target);
+	prev_state = cpuhp_set_state(cpu, st, target);
 	__cpuhp_kick_ap(st);
 	if ((ret = st->result)) {
-		cpuhp_reset_state(st, prev_state);
+		cpuhp_reset_state(cpu, st, prev_state);
 		__cpuhp_kick_ap(st);
 	}
 
@@ -580,7 +581,7 @@ static int bringup_wait_for_ap(unsigned
 	if (st->target <= CPUHP_AP_ONLINE_IDLE)
 		return 0;
 
-	return cpuhp_kick_ap(st, st->target);
+	return cpuhp_kick_ap(cpu, st, st->target);
 }
 
 static int bringup_cpu(unsigned int cpu)
@@ -703,7 +704,7 @@ static int cpuhp_up_callbacks(unsigned i
 			 ret, cpu, cpuhp_get_step(st->state)->name,
 			 st->state);
 
-		cpuhp_reset_state(st, prev_state);
+		cpuhp_reset_state(cpu, st, prev_state);
 		if (can_rollback_cpu(st))
 			WARN_ON(cpuhp_invoke_callback_range(false, cpu, st,
 							    prev_state));
@@ -720,7 +721,6 @@ static void cpuhp_create(unsigned int cp
 
 	init_completion(&st->done_up);
 	init_completion(&st->done_down);
-	st->cpu = cpu;
 }
 
 static int cpuhp_should_run(unsigned int cpu)
@@ -874,7 +874,7 @@ static int cpuhp_kick_ap_work(unsigned i
 	cpuhp_lock_release(true);
 
 	trace_cpuhp_enter(cpu, st->target, prev_state, cpuhp_kick_ap_work);
-	ret = cpuhp_kick_ap(st, st->target);
+	ret = cpuhp_kick_ap(cpu, st, st->target);
 	trace_cpuhp_exit(cpu, st->state, prev_state, ret);
 
 	return ret;
@@ -1106,7 +1106,7 @@ static int cpuhp_down_callbacks(unsigned
 			 ret, cpu, cpuhp_get_step(st->state)->name,
 			 st->state);
 
-		cpuhp_reset_state(st, prev_state);
+		cpuhp_reset_state(cpu, st, prev_state);
 
 		if (st->state < prev_state)
 			WARN_ON(cpuhp_invoke_callback_range(true, cpu, st,
@@ -1133,7 +1133,7 @@ static int __ref _cpu_down(unsigned int
 
 	cpuhp_tasks_frozen = tasks_frozen;
 
-	prev_state = cpuhp_set_state(st, target);
+	prev_state = cpuhp_set_state(cpu, st, target);
 	/*
 	 * If the current CPU state is in the range of the AP hotplug thread,
 	 * then we need to kick the thread.
@@ -1164,7 +1164,7 @@ static int __ref _cpu_down(unsigned int
 	ret = cpuhp_down_callbacks(cpu, st, target);
 	if (ret && st->state < prev_state) {
 		if (st->state == CPUHP_TEARDOWN_CPU) {
-			cpuhp_reset_state(st, prev_state);
+			cpuhp_reset_state(cpu, st, prev_state);
 			__cpuhp_kick_ap(st);
 		} else {
 			WARN(1, "DEAD callback error for CPU%d", cpu);
@@ -1351,7 +1351,7 @@ static int _cpu_up(unsigned int cpu, int
 
 	cpuhp_tasks_frozen = tasks_frozen;
 
-	cpuhp_set_state(st, target);
+	cpuhp_set_state(cpu, st, target);
 	/*
 	 * If the current CPU state is in the range of the AP hotplug thread,
 	 * then we need to kick the thread once more.


