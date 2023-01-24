Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF2679A5D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbjAXNq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbjAXNpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:45:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA0247EE6;
        Tue, 24 Jan 2023 05:44:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82764B811DA;
        Tue, 24 Jan 2023 13:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8D0C4339C;
        Tue, 24 Jan 2023 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567829;
        bh=uCIiHQzpCzLj7w5EfDpGVIqc92qbFsqM5jiyi3oFMOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUCwpsA2+uYyyJqGPuIgqHRh2qbOh7Bw8xhNeFE9iCT87exvN5wmUoRoHJEu1u27O
         ybybUNnxJAUnYJJObTZMl5NaPI/+mNJD6bsAJtl0x3lSghoe7qONVJXIPBvwaqv8L4
         DOZ8q4NosiVQtUCjKfEHFL6tJRIR1v4ERIPe1YH1wCt1s782Ku59sysoinJvORMk3x
         d+HdUpmBupPJYdDvvUwyaUoF3AFoSEJRyKPbO8JoNdynko7TuekAy4GOM7kMuXXX/S
         1R3GtDC1Sp2gzA3N1oMsf7oBQofZH1zoEdSbwwNqauUVNornZubK1I3oiKg1JgrAFH
         xOwB8q5hIKXkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hao Sun <sunhao.th@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>, song@kernel.org,
        ast@kernel.org, andrii@kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/6] bpf: Skip task with pid=1 in send_signal_common()
Date:   Tue, 24 Jan 2023 08:43:40 -0500
Message-Id: <20230124134344.637846-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134344.637846-1-sashal@kernel.org>
References: <20230124134344.637846-1-sashal@kernel.org>
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

From: Hao Sun <sunhao.th@gmail.com>

[ Upstream commit a3d81bc1eaef48e34dd0b9b48eefed9e02a06451 ]

The following kernel panic can be triggered when a task with pid=1 attaches
a prog that attempts to send killing signal to itself, also see [1] for more
details:

  Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
  CPU: 3 PID: 1 Comm: systemd Not tainted 6.1.0-09652-g59fe41b5255f #148
  Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x100/0x178 lib/dump_stack.c:106
  panic+0x2c4/0x60f kernel/panic.c:275
  do_exit.cold+0x63/0xe4 kernel/exit.c:789
  do_group_exit+0xd4/0x2a0 kernel/exit.c:950
  get_signal+0x2460/0x2600 kernel/signal.c:2858
  arch_do_signal_or_restart+0x78/0x5d0 arch/x86/kernel/signal.c:306
  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
  exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
  do_syscall_64+0x44/0xb0 arch/x86/entry/common.c:86
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

So skip task with pid=1 in bpf_send_signal_common() to avoid the panic.

  [1] https://lore.kernel.org/bpf/20221222043507.33037-1-sunhao.th@gmail.com

Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20230106084838.12690-1-sunhao.th@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 4d9f81802911..1e1345cd21b4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -649,6 +649,9 @@ BPF_CALL_1(bpf_send_signal, u32, sig)
 		return -EPERM;
 	if (unlikely(!nmi_uaccess_okay()))
 		return -EPERM;
+	/* Task should not be pid=1 to avoid kernel panic. */
+	if (unlikely(is_global_init(current)))
+		return -EPERM;
 
 	if (irqs_disabled()) {
 		/* Do an early check on signal validity. Otherwise,
-- 
2.39.0

