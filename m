Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B64B6799EB
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbjAXNnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbjAXNnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:43:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE60E46704;
        Tue, 24 Jan 2023 05:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A835FB811C6;
        Tue, 24 Jan 2023 13:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FF6C433D2;
        Tue, 24 Jan 2023 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567742;
        bh=WhbR4MKUsgKinL0jOlu+gZ1A1HqWpjQDjDpuRn+pUAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/MJ5kwzICklEY428k9j1EOuA8iMk2LfT5uyKilKkAblB9YVLCNguu0ija/5DGxs8
         ngfe2ge87+1IjMLwLkXisSTFANLLYPaJl+zUT4jOGyuZKChhCGH1dYO+6peZWunxQ3
         +XJssQIGU2SXYUm1bt9QLhkwzBxcPfJTI8URlRyd8EVFEAIM45ccgOwm6E6HIG4rhL
         Dq6kw1g4OLsLhAUAQ7C6zMvyRT1lCsuMHd5oQgHp6ymb+sj6Ipg9O24OivLPRHGm/G
         aGeUgrzOUoyYYnZyM7mB0CCKmnWi5kcZ68on+9OBMAFPSU7s2uGoNYQotAw5a/c1xd
         /k4uUtINbj8wA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jinyang He <hejinyang@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>, chenhuacai@kernel.org,
        git@xen0n.name, zhangqing@loongson.cn, jiaxun.yang@flygoat.com,
        jack@suse.cz, Jason@zx2c4.com, wangkailong@jari.cn,
        loongarch@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 17/35] LoongArch: Get frame info in unwind_start() when regs is not available
Date:   Tue, 24 Jan 2023 08:41:13 -0500
Message-Id: <20230124134131.637036-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinyang He <hejinyang@loongson.cn>

[ Upstream commit 429a9671f235c94fc4b5d6687308714b74adc820 ]

At unwind_start(), it is better to get its frame info here rather than
get them outside, even we don't have 'regs'. In this way we can simply
use unwind_{start, next_frame, done} outside.

Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/process.c         | 12 +++---------
 arch/loongarch/kernel/unwind_guess.c    |  6 ++++++
 arch/loongarch/kernel/unwind_prologue.c | 16 +++++++++++++---
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/kernel/process.c b/arch/loongarch/kernel/process.c
index ddb8ba4eb399..90a5de746332 100644
--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -185,20 +185,14 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 unsigned long __get_wchan(struct task_struct *task)
 {
-	unsigned long pc;
+	unsigned long pc = 0;
 	struct unwind_state state;
 
 	if (!try_get_task_stack(task))
 		return 0;
 
-	unwind_start(&state, task, NULL);
-	state.sp = thread_saved_fp(task);
-	get_stack_info(state.sp, state.task, &state.stack_info);
-	state.pc = thread_saved_ra(task);
-#ifdef CONFIG_UNWINDER_PROLOGUE
-	state.type = UNWINDER_PROLOGUE;
-#endif
-	for (; !unwind_done(&state); unwind_next_frame(&state)) {
+	for (unwind_start(&state, task, NULL);
+	     !unwind_done(&state); unwind_next_frame(&state)) {
 		pc = unwind_get_return_address(&state);
 		if (!pc)
 			break;
diff --git a/arch/loongarch/kernel/unwind_guess.c b/arch/loongarch/kernel/unwind_guess.c
index 5afa6064d73e..0c20e5184de6 100644
--- a/arch/loongarch/kernel/unwind_guess.c
+++ b/arch/loongarch/kernel/unwind_guess.c
@@ -25,6 +25,12 @@ void unwind_start(struct unwind_state *state, struct task_struct *task,
 	if (regs) {
 		state->sp = regs->regs[3];
 		state->pc = regs->csr_era;
+	} else if (task && task != current) {
+		state->sp = thread_saved_fp(task);
+		state->pc = thread_saved_ra(task);
+	} else {
+		state->sp = (unsigned long)__builtin_frame_address(0);
+		state->pc = (unsigned long)__builtin_return_address(0);
 	}
 
 	state->task = task;
diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index 4571c3c87cd4..1c5b65756144 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -111,12 +111,22 @@ void unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs)
 {
 	memset(state, 0, sizeof(*state));
+	state->type = UNWINDER_PROLOGUE;
 
-	if (regs &&  __kernel_text_address(regs->csr_era)) {
-		state->pc = regs->csr_era;
+	if (regs) {
 		state->sp = regs->regs[3];
+		state->pc = regs->csr_era;
 		state->ra = regs->regs[1];
-		state->type = UNWINDER_PROLOGUE;
+		if (!__kernel_text_address(state->pc))
+			state->type = UNWINDER_GUESS;
+	} else if (task && task != current) {
+		state->sp = thread_saved_fp(task);
+		state->pc = thread_saved_ra(task);
+		state->ra = 0;
+	} else {
+		state->sp = (unsigned long)__builtin_frame_address(0);
+		state->pc = (unsigned long)__builtin_return_address(0);
+		state->ra = 0;
 	}
 
 	state->task = task;
-- 
2.39.0

