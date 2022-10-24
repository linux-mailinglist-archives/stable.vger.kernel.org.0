Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB08260ABE6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiJXN7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbiJXN6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:58:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EB81151;
        Mon, 24 Oct 2022 05:45:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44E0A61311;
        Mon, 24 Oct 2022 12:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAB4C433D6;
        Mon, 24 Oct 2022 12:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615512;
        bh=g2gaW+ZGEQ4+WN4a3eyZHoD7cba+I8C6SyCyQBRVycU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWyr/4Q9pE21cdKJkDFGTD6xvizOaeBXZqW+qjrQMgMjjc1OIf+0vY/6ZWHlwVojU
         KepIpLyvZy/nkCa/Oqc16sUkxVIzlAq6eQhAg8oV921VMT67jLE+H/+NiYz2IRoIR1
         he5r65WxqnJhbR6J+WsLFHIxN/kEEVnJ2ijp569Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Li Huafei <lihuafei1@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/530] arm64: ftrace: fix module PLTs with mcount
Date:   Mon, 24 Oct 2022 13:30:06 +0200
Message-Id: <20221024113056.916331689@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8cfb08575c6d4585f1ce0deeb189e5c824776b04 ]

Li Huafei reports that mcount-based ftrace with module PLTs was broken
by commit:

  a6253579977e4c6f ("arm64: ftrace: consistently handle PLTs.")

When a module PLTs are used and a module is loaded sufficiently far away
from the kernel, we'll create PLTs for any branches which are
out-of-range. These are separate from the special ftrace trampoline
PLTs, which the module PLT code doesn't directly manipulate.

When mcount is in use this is a problem, as each mcount callsite in a
module will be initialized to point to a module PLT, but since commit
a6253579977e4c6f ftrace_make_nop() will assume that the callsite has
been initialized to point to the special ftrace trampoline PLT, and
ftrace_find_callable_addr() rejects other cases.

This means that when ftrace tries to initialize a callsite via
ftrace_make_nop(), the call to ftrace_find_callable_addr() will find
that the `_mcount` stub is out-of-range and is not handled by the ftrace
PLT, resulting in a splat:

| ftrace_test: loading out-of-tree module taints kernel.
| ftrace: no module PLT for _mcount
| ------------[ ftrace bug ]------------
| ftrace failed to modify
| [<ffff800029180014>] 0xffff800029180014
|  actual:   44:00:00:94
| Initializing ftrace call sites
| ftrace record flags: 2000000
|  (0)
|  expected tramp: ffff80000802eb3c
| ------------[ cut here ]------------
| WARNING: CPU: 3 PID: 157 at kernel/trace/ftrace.c:2120 ftrace_bug+0x94/0x270
| Modules linked in:
| CPU: 3 PID: 157 Comm: insmod Tainted: G           O       6.0.0-rc6-00151-gcd722513a189-dirty #22
| Hardware name: linux,dummy-virt (DT)
| pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : ftrace_bug+0x94/0x270
| lr : ftrace_bug+0x21c/0x270
| sp : ffff80000b2bbaf0
| x29: ffff80000b2bbaf0 x28: 0000000000000000 x27: ffff0000c4d38000
| x26: 0000000000000001 x25: ffff800009d7e000 x24: ffff0000c4d86e00
| x23: 0000000002000000 x22: ffff80000a62b000 x21: ffff8000098ebea8
| x20: ffff0000c4d38000 x19: ffff80000aa24158 x18: ffffffffffffffff
| x17: 0000000000000000 x16: 0a0d2d2d2d2d2d2d x15: ffff800009aa9118
| x14: 0000000000000000 x13: 6333626532303830 x12: 3030303866666666
| x11: 203a706d61727420 x10: 6465746365707865 x9 : 3362653230383030
| x8 : c0000000ffffefff x7 : 0000000000017fe8 x6 : 000000000000bff4
| x5 : 0000000000057fa8 x4 : 0000000000000000 x3 : 0000000000000001
| x2 : ad2cb14bb5438900 x1 : 0000000000000000 x0 : 0000000000000022
| Call trace:
|  ftrace_bug+0x94/0x270
|  ftrace_process_locs+0x308/0x430
|  ftrace_module_init+0x44/0x60
|  load_module+0x15b4/0x1ce8
|  __do_sys_init_module+0x1ec/0x238
|  __arm64_sys_init_module+0x24/0x30
|  invoke_syscall+0x54/0x118
|  el0_svc_common.constprop.4+0x84/0x100
|  do_el0_svc+0x3c/0xd0
|  el0_svc+0x1c/0x50
|  el0t_64_sync_handler+0x90/0xb8
|  el0t_64_sync+0x15c/0x160
| ---[ end trace 0000000000000000 ]---
| ---------test_init-----------

Fix this by reverting to the old behaviour of ignoring the old
instruction when initialising an mcount callsite in a module, which was
the behaviour prior to commit a6253579977e4c6f.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Fixes: a6253579977e ("arm64: ftrace: consistently handle PLTs.")
Reported-by: Li Huafei <lihuafei1@huawei.com>
Link: https://lore.kernel.org/linux-arm-kernel/20220929094134.99512-1-lihuafei1@huawei.com
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220929134525.798593-1-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ftrace.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index ae0248154981..dba774f3b8d7 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -217,11 +217,26 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 	unsigned long pc = rec->ip;
 	u32 old = 0, new;
 
+	new = aarch64_insn_gen_nop();
+
+	/*
+	 * When using mcount, callsites in modules may have been initalized to
+	 * call an arbitrary module PLT (which redirects to the _mcount stub)
+	 * rather than the ftrace PLT we'll use at runtime (which redirects to
+	 * the ftrace trampoline). We can ignore the old PLT when initializing
+	 * the callsite.
+	 *
+	 * Note: 'mod' is only set at module load time.
+	 */
+	if (!IS_ENABLED(CONFIG_DYNAMIC_FTRACE_WITH_REGS) &&
+	    IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) && mod) {
+		return aarch64_insn_patch_text_nosync((void *)pc, new);
+	}
+
 	if (!ftrace_find_callable_addr(rec, mod, &addr))
 		return -EINVAL;
 
 	old = aarch64_insn_gen_branch_imm(pc, addr, AARCH64_INSN_BRANCH_LINK);
-	new = aarch64_insn_gen_nop();
 
 	return ftrace_modify_code(pc, old, new, true);
 }
-- 
2.35.1



