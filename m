Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554C7615949
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiKBDIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiKBDIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:08:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB60248C3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48BE7CE1E2F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE986C433D6;
        Wed,  2 Nov 2022 03:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358455;
        bh=JHGw/IMDMnMotLEnwn0hc24dqRjBoO2ZW0Adx3jQhTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKVheG2D/+mMpFSjiiO+zRkRUU2thj3YMkjRGixC5Oy1hbOi9NPPR+TLcPOjGxGoR
         DDyODfa+I/ZocAile8ao9x0dbPiRYLGJ5+5Gka4fOOV9cKwGCySjcsei8uiV4PT5e1
         qonlsAIJ3mGQHt+4mZfcGujr/PCPgRt1Y6CCrt4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/132] x86/unwind/orc: Fix unreliable stack dump with gcov
Date:   Wed,  2 Nov 2022 03:33:02 +0100
Message-Id: <20221102022101.609635284@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 230db82413c091bc16acee72650f48d419cebe49 ]

When a console stack dump is initiated with CONFIG_GCOV_PROFILE_ALL
enabled, show_trace_log_lvl() gets out of sync with the ORC unwinder,
causing the stack trace to show all text addresses as unreliable:

  # echo l > /proc/sysrq-trigger
  [  477.521031] sysrq: Show backtrace of all active CPUs
  [  477.523813] NMI backtrace for cpu 0
  [  477.524492] CPU: 0 PID: 1021 Comm: bash Not tainted 6.0.0 #65
  [  477.525295] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
  [  477.526439] Call Trace:
  [  477.526854]  <TASK>
  [  477.527216]  ? dump_stack_lvl+0xc7/0x114
  [  477.527801]  ? dump_stack+0x13/0x1f
  [  477.528331]  ? nmi_cpu_backtrace.cold+0xb5/0x10d
  [  477.528998]  ? lapic_can_unplug_cpu+0xa0/0xa0
  [  477.529641]  ? nmi_trigger_cpumask_backtrace+0x16a/0x1f0
  [  477.530393]  ? arch_trigger_cpumask_backtrace+0x1d/0x30
  [  477.531136]  ? sysrq_handle_showallcpus+0x1b/0x30
  [  477.531818]  ? __handle_sysrq.cold+0x4e/0x1ae
  [  477.532451]  ? write_sysrq_trigger+0x63/0x80
  [  477.533080]  ? proc_reg_write+0x92/0x110
  [  477.533663]  ? vfs_write+0x174/0x530
  [  477.534265]  ? handle_mm_fault+0x16f/0x500
  [  477.534940]  ? ksys_write+0x7b/0x170
  [  477.535543]  ? __x64_sys_write+0x1d/0x30
  [  477.536191]  ? do_syscall_64+0x6b/0x100
  [  477.536809]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
  [  477.537609]  </TASK>

This happens when the compiled code for show_stack() has a single word
on the stack, and doesn't use a tail call to show_stack_log_lvl().
(CONFIG_GCOV_PROFILE_ALL=y is the only known case of this.)  Then the
__unwind_start() skip logic hits an off-by-one bug and fails to unwind
all the way to the intended starting frame.

Fix it by reverting the following commit:

  f1d9a2abff66 ("x86/unwind/orc: Don't skip the first frame for inactive tasks")

The original justification for that commit no longer exists.  That
original issue was later fixed in a different way, with the following
commit:

  f2ac57a4c49d ("x86/unwind/orc: Fix inactive tasks with stack pointer in %sp on GCC 10 compiled kernels")

Fixes: f1d9a2abff66 ("x86/unwind/orc: Don't skip the first frame for inactive tasks")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
[jpoimboe: rewrite commit log]
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/unwind_orc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 3423aaea4ad8..8488966da5f1 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -700,7 +700,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 	/* Otherwise, skip ahead to the user-specified starting frame: */
 	while (!unwind_done(state) &&
 	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
-			state->sp < (unsigned long)first_frame))
+			state->sp <= (unsigned long)first_frame))
 		unwind_next_frame(state);
 
 	return;
-- 
2.35.1



