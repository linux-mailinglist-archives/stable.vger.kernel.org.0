Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987A96A2D9F
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjBZDoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjBZDoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:44:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FFC12844;
        Sat, 25 Feb 2023 19:43:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AE8760BEC;
        Sun, 26 Feb 2023 03:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D1CC433EF;
        Sun, 26 Feb 2023 03:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382985;
        bh=gJQDl+6gt6pDDRZxyMcb9EXsji4noq6fNOEZsH36Rqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiEK8llv1XFeOh1RTRn511f3U82lnVQ2k7PpVzpDXQ0fsEqF3hzyd/arkW3TdcidJ
         Ao5OgInZujMmsQ7P/0tj6MX/9FS7N7D54Kv5jD0+IlmSROM/+fWFHQLdRUnvBrJkMM
         g2q1ZKJ5RC8rKBFEDy0uLaAMjIcZLW1F10FOdgtVXZKCgW4mft5ybforgJe+MaL6JO
         AFWsdStP0mtepPT78eTMbuZ+PBvc8VAgY7n+sNSl7gYa5UtHB0w1kZa7RQNy0T3Xuf
         9/HNMhe8c1Dhi4T166B/w6rNH5Hlq8A3jjTci3+Tr0Hv9tSDAGg8ZY65qM2PxBFTwm
         Rj1WgcePrUr6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>, keescook@chromium.org,
        akpm@linux-foundation.org, catalin.marinas@arm.com,
        yuzhao@google.com, jannh@google.com, mark.rutland@arm.com,
        mingo@kernel.org, oleg@redhat.com
Subject: [PATCH AUTOSEL 6.1 05/21] exit: Detect and fix irq disabled state in oops
Date:   Sat, 25 Feb 2023 22:42:40 -0500
Message-Id: <20230226034256.771769-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034256.771769-1-sashal@kernel.org>
References: <20230226034256.771769-1-sashal@kernel.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 001c28e57187570e4b5aa4492c7a957fb6d65d7b ]

If a task oopses with irqs disabled, this can cause various cascading
problems in the oops path such as sleep-from-invalid warnings, and
potentially worse.

Since commit 0258b5fd7c712 ("coredump: Limit coredumps to a single
thread group"), the unconditional irq enable in coredump_task_exit()
will "fix" the irq state to be enabled early in do_exit(), so currently
this may not be triggerable, but that is coincidental and fragile.

Detect and fix the irqs_disabled() condition in the oops path before
calling do_exit(), similarly to the way in_atomic() is handled.

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lore.kernel.org/lkml/20221004094401.708299-1-npiggin@gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/exit.c b/kernel/exit.c
index 15dc2ec80c467..bccfa4218356e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -807,6 +807,8 @@ void __noreturn do_exit(long code)
 	struct task_struct *tsk = current;
 	int group_dead;
 
+	WARN_ON(irqs_disabled());
+
 	synchronize_group_exit(tsk, code);
 
 	WARN_ON(tsk->plug);
@@ -938,6 +940,11 @@ void __noreturn make_task_dead(int signr)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	if (unlikely(irqs_disabled())) {
+		pr_info("note: %s[%d] exited with irqs disabled\n",
+			current->comm, task_pid_nr(current));
+		local_irq_enable();
+	}
 	if (unlikely(in_atomic())) {
 		pr_info("note: %s[%d] exited with preempt_count %d\n",
 			current->comm, task_pid_nr(current),
-- 
2.39.0

