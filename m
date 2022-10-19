Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE85F603E8E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiJSJQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbiJSJPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:15:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C703D0192;
        Wed, 19 Oct 2022 02:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E54086186A;
        Wed, 19 Oct 2022 09:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD5AC433D7;
        Wed, 19 Oct 2022 09:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170351;
        bh=YSgRrx6e5C9KaV05ykt6gXCGLEwA9I+qydBcSRY1t0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=du0mcH1CETpgxxiPFA5MGeVq0Wz+74fJO+0muw6dQJ+CMXWKa+ScvSdGG4D8h/k9e
         LSIRrITK7OmXDLDEXlz7/r8ha+2Dtr8QitFkfT/fKhKfuYBV0mD+gVEuNmGADVpwlJ
         a07YbM5gaxKq1rhZZDie7xJAf+1OLN7b2ajA2/4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Huafei <lihuafei1@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 622/862] powerpc/kprobes: Fix null pointer reference in arch_prepare_kprobe()
Date:   Wed, 19 Oct 2022 10:31:49 +0200
Message-Id: <20221019083317.425875660@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit 97f88a3d723162781d6cbfdc7b9617eefab55b19 ]

I found a null pointer reference in arch_prepare_kprobe():

  # echo 'p cmdline_proc_show' > kprobe_events
  # echo 'p cmdline_proc_show+16' >> kprobe_events
  Kernel attempted to read user page (0) - exploit attempt? (uid: 0)
  BUG: Kernel NULL pointer dereference on read at 0x00000000
  Faulting instruction address: 0xc000000000050bfc
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA PowerNV
  Modules linked in:
  CPU: 0 PID: 122 Comm: sh Not tainted 6.0.0-rc3-00007-gdcf8e5633e2e #10
  NIP:  c000000000050bfc LR: c000000000050bec CTR: 0000000000005bdc
  REGS: c0000000348475b0 TRAP: 0300   Not tainted  (6.0.0-rc3-00007-gdcf8e5633e2e)
  MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 88002444  XER: 20040006
  CFAR: c00000000022d100 DAR: 0000000000000000 DSISR: 40000000 IRQMASK: 0
  ...
  NIP arch_prepare_kprobe+0x10c/0x2d0
  LR  arch_prepare_kprobe+0xfc/0x2d0
  Call Trace:
    0xc0000000012f77a0 (unreliable)
    register_kprobe+0x3c0/0x7a0
    __register_trace_kprobe+0x140/0x1a0
    __trace_kprobe_create+0x794/0x1040
    trace_probe_create+0xc4/0xe0
    create_or_delete_trace_kprobe+0x2c/0x80
    trace_parse_run_command+0xf0/0x210
    probes_write+0x20/0x40
    vfs_write+0xfc/0x450
    ksys_write+0x84/0x140
    system_call_exception+0x17c/0x3a0
    system_call_vectored_common+0xe8/0x278
  --- interrupt: 3000 at 0x7fffa5682de0
  NIP:  00007fffa5682de0 LR: 0000000000000000 CTR: 0000000000000000
  REGS: c000000034847e80 TRAP: 3000   Not tainted  (6.0.0-rc3-00007-gdcf8e5633e2e)
  MSR:  900000000280f033 <SF,HV,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 44002408  XER: 00000000

The address being probed has some special:

  cmdline_proc_show: Probe based on ftrace
  cmdline_proc_show+16: Probe for the next instruction at the ftrace location

The ftrace-based kprobe does not generate kprobe::ainsn::insn, it gets
set to NULL. In arch_prepare_kprobe() it will check for:

  ...
  prev = get_kprobe(p->addr - 1);
  preempt_enable_no_resched();
  if (prev && ppc_inst_prefixed(ppc_inst_read(prev->ainsn.insn))) {
  ...

If prev is based on ftrace, 'ppc_inst_read(prev->ainsn.insn)' will occur
with a null pointer reference. At this point prev->addr will not be a
prefixed instruction, so the check can be skipped.

Check if prev is ftrace-based kprobe before reading 'prev->ainsn.insn'
to fix this problem.

Fixes: b4657f7650ba ("powerpc/kprobes: Don't allow breakpoints on suffixes")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
[mpe: Trim oops]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220923093253.177298-1-lihuafei1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/kprobes.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 912d4f8a13be..bd7b1a035459 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -161,7 +161,13 @@ int arch_prepare_kprobe(struct kprobe *p)
 	preempt_disable();
 	prev = get_kprobe(p->addr - 1);
 	preempt_enable_no_resched();
-	if (prev && ppc_inst_prefixed(ppc_inst_read(prev->ainsn.insn))) {
+
+	/*
+	 * When prev is a ftrace-based kprobe, we don't have an insn, and it
+	 * doesn't probe for prefixed instruction.
+	 */
+	if (prev && !kprobe_ftrace(prev) &&
+	    ppc_inst_prefixed(ppc_inst_read(prev->ainsn.insn))) {
 		printk("Cannot register a kprobe on the second word of prefixed instruction\n");
 		ret = -EINVAL;
 	}
-- 
2.35.1



