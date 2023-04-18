Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93556E63EC
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjDRMod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbjDRMod (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:44:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC38219A6
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6923C63373
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719F3C433D2;
        Tue, 18 Apr 2023 12:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821870;
        bh=VKnqOnmHp7CK4bPnkeQ3nnLx3pQJqwfCsspfDMUnl0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtHe5RKU2t0a3/w5OqJgIhpd+d5luSokmF9AANY/DKJYxQS++2LPanUTuxjJAAUr1
         DU3yGfoGR0z40h5m8CUUjW6Ojv1Bwqm5PVP9kou3doMYsWYkr/L+c4MWoOlCoNUMs8
         9eQTK+ei8qt6egfAeuSs+4BDp6jsVd8dK10zRDC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florent Revest <revest@chromium.org>,
        Xu Kuohai <xukuohai@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/134] bpf, arm64: Fixed a BTI error on returning to patched function
Date:   Tue, 18 Apr 2023 14:21:41 +0200
Message-Id: <20230418120314.497466124@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 738a96c4a8c36950803fdd27e7c30aca92dccefd ]

When BPF_TRAMP_F_CALL_ORIG is set, BPF trampoline uses BLR to jump
back to the instruction next to call site to call the patched function.
For BTI-enabled kernel, the instruction next to call site is usually
PACIASP, in this case, it's safe to jump back with BLR. But when
the call site is not followed by a PACIASP or bti, a BTI exception
is triggered.

Here is a fault log:

 Unhandled 64-bit el1h sync exception on CPU0, ESR 0x0000000034000002 -- BTI
 CPU: 0 PID: 263 Comm: test_progs Tainted: GF
 Hardware name: linux,dummy-virt (DT)
 pstate: 40400805 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=-c)
 pc : bpf_fentry_test1+0xc/0x30
 lr : bpf_trampoline_6442573892_0+0x48/0x1000
 sp : ffff80000c0c3a50
 x29: ffff80000c0c3a90 x28: ffff0000c2e6c080 x27: 0000000000000000
 x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000050
 x23: 0000000000000000 x22: 0000ffffcfd2a7f0 x21: 000000000000000a
 x20: 0000ffffcfd2a7f0 x19: 0000000000000000 x18: 0000000000000000
 x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffffcfd2a7f0
 x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
 x11: 0000000000000000 x10: ffff80000914f5e4 x9 : ffff8000082a1528
 x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0101010101010101
 x5 : 0000000000000000 x4 : 00000000fffffff2 x3 : 0000000000000001
 x2 : ffff8001f4b82000 x1 : 0000000000000000 x0 : 0000000000000001
 Kernel panic - not syncing: Unhandled exception
 CPU: 0 PID: 263 Comm: test_progs Tainted: GF
 Hardware name: linux,dummy-virt (DT)
 Call trace:
  dump_backtrace+0xec/0x144
  show_stack+0x24/0x7c
  dump_stack_lvl+0x8c/0xb8
  dump_stack+0x18/0x34
  panic+0x1cc/0x3ec
  __el0_error_handler_common+0x0/0x130
  el1h_64_sync_handler+0x60/0xd0
  el1h_64_sync+0x78/0x7c
  bpf_fentry_test1+0xc/0x30
  bpf_fentry_test1+0xc/0x30
  bpf_prog_test_run_tracing+0xdc/0x2a0
  __sys_bpf+0x438/0x22a0
  __arm64_sys_bpf+0x30/0x54
  invoke_syscall+0x78/0x110
  el0_svc_common.constprop.0+0x6c/0x1d0
  do_el0_svc+0x38/0xe0
  el0_svc+0x30/0xd0
  el0t_64_sync_handler+0x1ac/0x1b0
  el0t_64_sync+0x1a0/0x1a4
 Kernel Offset: disabled
 CPU features: 0x0000,00034c24,f994fdab
 Memory Limit: none

And the instruction next to call site of bpf_fentry_test1 is ADD,
not PACIASP:

<bpf_fentry_test1>:
	bti     c
	nop
	nop
	add     w0, w0, #0x1
	paciasp

For BPF prog, JIT always puts a PACIASP after call site for BTI-enabled
kernel, so there is no problem. To fix it, replace BLR with RET to bypass
the branch target check.

Fixes: efc9909fdce0 ("bpf, arm64: Add bpf trampoline for arm64")
Reported-by: Florent Revest <revest@chromium.org>
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Florent Revest <revest@chromium.org>
Acked-by: Florent Revest <revest@chromium.org>
Link: https://lore.kernel.org/bpf/20230401234144.3719742-1-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit.h      | 4 ++++
 arch/arm64/net/bpf_jit_comp.c | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index a6acb94ea3d63..c2edadb8ec6a3 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -281,4 +281,8 @@
 /* DMB */
 #define A64_DMB_ISH aarch64_insn_gen_dmb(AARCH64_INSN_MB_ISH)
 
+/* ADR */
+#define A64_ADR(Rd, offset) \
+	aarch64_insn_gen_adr(0, offset, Rd, AARCH64_INSN_ADR_TYPE_ADR)
+
 #endif /* _BPF_JIT_H */
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 30f76178608b3..8f16217c111c8 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1905,7 +1905,8 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 		restore_args(ctx, args_off, nargs);
 		/* call original func */
 		emit(A64_LDR64I(A64_R(10), A64_SP, retaddr_off), ctx);
-		emit(A64_BLR(A64_R(10)), ctx);
+		emit(A64_ADR(A64_LR, AARCH64_INSN_SIZE * 2), ctx);
+		emit(A64_RET(A64_R(10)), ctx);
 		/* store return value */
 		emit(A64_STR64I(A64_R(0), A64_SP, retval_off), ctx);
 		/* reserve a nop for bpf_tramp_image_put */
-- 
2.39.2



