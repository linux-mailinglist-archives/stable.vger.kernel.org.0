Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0756895AD
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbjBCKX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbjBCKXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:23:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F49C9EE05
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:22:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFBFB61ECB
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C09FC433EF;
        Fri,  3 Feb 2023 10:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419773;
        bh=+w4Mt7NQhz5wfTJKN9+gyiK/g8JApmAnN3joOItZmvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjFxccR2PrIfqBkVWyAvIwajXCXFoWdRYLQ3lbjxmaW7zRDQNHT6u6LZJQ2WZ/t6U
         OiFxQmDQTnjN8XJI5gYTXUnfaqYrnIhvdW9PeTRr6YLsrlFFHiXvV7Uv4mOj0bhzOj
         D14AkuOEK07qQjhZMtCW5PSJIKbL8hxUjVn+aKn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hao Sun <sunhao.th@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/28] bpf: Skip task with pid=1 in send_signal_common()
Date:   Fri,  3 Feb 2023 11:12:54 +0100
Message-Id: <20230203101010.237145507@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1ed08967fb97..eb8c117cc8b6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -847,6 +847,9 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
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



