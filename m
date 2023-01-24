Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F944679A35
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjAXNpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbjAXNou (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:44:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07714269B;
        Tue, 24 Jan 2023 05:43:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92FA961225;
        Tue, 24 Jan 2023 13:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A53C4339B;
        Tue, 24 Jan 2023 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567817;
        bh=kDp6C65pVdVqhY4qD81CaQMBTLjF4OYidp1jbJSNjkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ql6utiWClNfPYALNLQavXuVjpVqXodtZYhhOhpOzoFWe9Y0pPRQ8nCnDGscZdo+PQ
         wU4EZaS5LTAqmCPZ+4Ax15jNuW8yp7RZ4YXodEq4CgLm+Injtd4JBOQEfe/WX/oN+S
         lZHAEuFWRxPQFj1ddKvhLmED+JojiUC+7OaProswWFfdAVH622aggP0dQU2HiGHEma
         FQ5ZS45SxlN22tRMH7KmKblKcdfuy0+VKO8zsY00M4js/gmFtSukC/lED2bWPWEJOc
         OF0Bc75r8Z7dOGZhtntDEqe2QDj2NUESW2VNYctXHbDT4vgFaYt7Lt1dWBn5m8xDgb
         z6j5+H2/VH6FA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hao Sun <sunhao.th@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        andrii@kernel.org, song@kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/8] bpf: Skip task with pid=1 in send_signal_common()
Date:   Tue, 24 Jan 2023 08:43:24 -0500
Message-Id: <20230124134328.637707-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134328.637707-1-sashal@kernel.org>
References: <20230124134328.637707-1-sashal@kernel.org>
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
index a9e074769881..ab4f51716645 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1072,6 +1072,9 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
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

