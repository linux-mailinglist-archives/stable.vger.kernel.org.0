Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892AD4AFB5F
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbiBISp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240546AbiBISo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:44:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7A4C0A88CE;
        Wed,  9 Feb 2022 10:43:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04B6B61307;
        Wed,  9 Feb 2022 18:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EC2C340F1;
        Wed,  9 Feb 2022 18:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432179;
        bh=gBR3Ce/pJ47IRQg4FP9Z/vuY4SpFZJm7Vp0omlNnSeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWhLCy/Ah2qC9Ld0a0R6Dmb/lASFcKuiCBuGL0se7ufdDgt7onz0a5S62n0lr1gqs
         d2pJZ5T4IKTwjlINnh9kZpgEtK3jiYBRgjRJ1MfK8RtpLM+dkTL1OjlE516VgKAyhi
         G/kVZOk6O/88o8CejxSjjo1T+Zz8na1uQC1JJw/fnwrdjnT00bp/cWsO+uHvkS0PPP
         BkLORmTPc+4nC2tmZdUGhjmxtvOXx6+02vwqZV4USL1VQ0DS+auwxviIVcAraeOZdY
         jGMarS4pYUr4IKQwFAMgFi+6kBqmV9muKrRoxHghQZ9/2Sm6/o7lEFSt/5eZQEQfX3
         pSeK+31X96Yew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Alexander Popov <alex.popov@linux.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, nixiaoming@huawei.com,
        akpm@linux-foundation.org, mcgrof@kernel.org
Subject: [PATCH AUTOSEL 5.10 26/27] gcc-plugins/stackleak: Use noinstr in favor of notrace
Date:   Wed,  9 Feb 2022 13:41:02 -0500
Message-Id: <20220209184103.47635-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184103.47635-1-sashal@kernel.org>
References: <20220209184103.47635-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit dcb85f85fa6f142aae1fe86f399d4503d49f2b60 ]

While the stackleak plugin was already using notrace, objtool is now a
bit more picky.  Update the notrace uses to noinstr.  Silences the
following objtool warnings when building with:

CONFIG_DEBUG_ENTRY=y
CONFIG_STACK_VALIDATION=y
CONFIG_VMLINUX_VALIDATION=y
CONFIG_GCC_PLUGIN_STACKLEAK=y

  vmlinux.o: warning: objtool: do_syscall_64()+0x9: call to stackleak_track_stack() leaves .noinstr.text section
  vmlinux.o: warning: objtool: do_int80_syscall_32()+0x9: call to stackleak_track_stack() leaves .noinstr.text section
  vmlinux.o: warning: objtool: exc_general_protection()+0x22: call to stackleak_track_stack() leaves .noinstr.text section
  vmlinux.o: warning: objtool: fixup_bad_iret()+0x20: call to stackleak_track_stack() leaves .noinstr.text section
  vmlinux.o: warning: objtool: do_machine_check()+0x27: call to stackleak_track_stack() leaves .noinstr.text section
  vmlinux.o: warning: objtool: .text+0x5346e: call to stackleak_erase() leaves .noinstr.text section
  vmlinux.o: warning: objtool: .entry.text+0x143: call to stackleak_erase() leaves .noinstr.text section
  vmlinux.o: warning: objtool: .entry.text+0x10eb: call to stackleak_erase() leaves .noinstr.text section
  vmlinux.o: warning: objtool: .entry.text+0x17f9: call to stackleak_erase() leaves .noinstr.text section

Note that the plugin's addition of calls to stackleak_track_stack() from
noinstr functions is expected to be safe, as it isn't runtime
instrumentation and is self-contained.

Cc: Alexander Popov <alex.popov@linux.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/stackleak.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/stackleak.c b/kernel/stackleak.c
index ce161a8e8d975..dd07239ddff9f 100644
--- a/kernel/stackleak.c
+++ b/kernel/stackleak.c
@@ -48,7 +48,7 @@ int stack_erasing_sysctl(struct ctl_table *table, int write,
 #define skip_erasing()	false
 #endif /* CONFIG_STACKLEAK_RUNTIME_DISABLE */
 
-asmlinkage void notrace stackleak_erase(void)
+asmlinkage void noinstr stackleak_erase(void)
 {
 	/* It would be nice not to have 'kstack_ptr' and 'boundary' on stack */
 	unsigned long kstack_ptr = current->lowest_stack;
@@ -102,9 +102,8 @@ asmlinkage void notrace stackleak_erase(void)
 	/* Reset the 'lowest_stack' value for the next syscall */
 	current->lowest_stack = current_top_of_stack() - THREAD_SIZE/64;
 }
-NOKPROBE_SYMBOL(stackleak_erase);
 
-void __used __no_caller_saved_registers notrace stackleak_track_stack(void)
+void __used __no_caller_saved_registers noinstr stackleak_track_stack(void)
 {
 	unsigned long sp = current_stack_pointer;
 
-- 
2.34.1

