Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC566CC2EB
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbjC1Ot4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbjC1Otf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:49:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50687E1BD
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A7EB61820
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5CCC433EF;
        Tue, 28 Mar 2023 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014938;
        bh=d1Gu4I77URN5QEaJHGjPJI+hx44zSke0jWWcjYI015Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qURA6tKRgfHCMDZBT8G2FNYvNq2AWDzBEhqX7rjzUgive8rokwTQN4Trjl+PRQyYQ
         tatyrYkHCQIki/j10NdER7ntoTpUYxx3JOZNrcT6RkdUaY5+ROr/AZYF+vobF30CJ+
         82t7vREnTJ5+5uB/IwzyzKlC5ws2Ms4bkt11QZug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josh Poimboeuf <jpoimboe@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 108/240] entry: Fix noinstr warning in __enter_from_user_mode()
Date:   Tue, 28 Mar 2023 16:41:11 +0200
Message-Id: <20230328142624.285278136@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit f87d28673b71b35b248231a2086f9404afbb7f28 ]

__enter_from_user_mode() is triggering noinstr warnings with
CONFIG_DEBUG_PREEMPT due to its call of preempt_count_add() via
ct_state().

The preemption disable isn't needed as interrupts are already disabled.
And the context_tracking_enabled() check in ct_state() also isn't needed
as that's already being done by the CT_WARN_ON().

Just use __ct_state() instead.

Fixes the following warnings:

  vmlinux.o: warning: objtool: enter_from_user_mode+0xba: call to preempt_count_add() leaves .noinstr.text section
  vmlinux.o: warning: objtool: syscall_enter_from_user_mode+0xf9: call to preempt_count_add() leaves .noinstr.text section
  vmlinux.o: warning: objtool: syscall_enter_from_user_mode_prepare+0xc7: call to preempt_count_add() leaves .noinstr.text section
  vmlinux.o: warning: objtool: irqentry_enter_from_user_mode+0xba: call to preempt_count_add() leaves .noinstr.text section

Fixes: 171476775d32 ("context_tracking: Convert state to atomic_t")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/d8955fa6d68dc955dda19baf13ae014ae27926f5.1677369694.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/context_tracking.h       | 1 +
 include/linux/context_tracking_state.h | 2 ++
 kernel/entry/common.c                  | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index d4afa8508a806..3a7909ed54980 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -96,6 +96,7 @@ static inline void user_exit_irqoff(void) { }
 static inline int exception_enter(void) { return 0; }
 static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline int ct_state(void) { return -1; }
+static inline int __ct_state(void) { return -1; }
 static __always_inline bool context_tracking_guest_enter(void) { return false; }
 static inline void context_tracking_guest_exit(void) { }
 #define CT_WARN_ON(cond) do { } while (0)
diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
index 4a4d56f771802..fdd537ea513ff 100644
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -46,7 +46,9 @@ struct context_tracking {
 
 #ifdef CONFIG_CONTEXT_TRACKING
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
+#endif
 
+#ifdef CONFIG_CONTEXT_TRACKING_USER
 static __always_inline int __ct_state(void)
 {
 	return arch_atomic_read(this_cpu_ptr(&context_tracking.state)) & CT_STATE_MASK;
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 846add8394c41..1314894d2efad 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -21,7 +21,7 @@ static __always_inline void __enter_from_user_mode(struct pt_regs *regs)
 	arch_enter_from_user_mode(regs);
 	lockdep_hardirqs_off(CALLER_ADDR0);
 
-	CT_WARN_ON(ct_state() != CONTEXT_USER);
+	CT_WARN_ON(__ct_state() != CONTEXT_USER);
 	user_exit_irqoff();
 
 	instrumentation_begin();
-- 
2.39.2



