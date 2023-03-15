Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18946BB1A1
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjCOM3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbjCOM2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A1496610
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F0A61D3E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C5FC433D2;
        Wed, 15 Mar 2023 12:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883271;
        bh=t8hzOsiwd90uJQpMRFpv/nakPxavP3wq+XYLqrmCCyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vF2Kfq5DfoIJDQLSeVl1zOjF9int5m128dVQ4adm1tsmfJGZXf6Mt8yoSd65iZqwa
         YwpQnp1B0631zycvUAICK4JhKdAoFsDliw/vSFGec7T2jg9juUKjGrXyneSYVqxDCq
         3BuuVsocG/UyM9iFoK2xONfMipXtxRQYIkJ0MCtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>,
        Changbin Du <changbin.du@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/145] RISC-V: Dont check text_mutex during stop_machine
Date:   Wed, 15 Mar 2023 13:12:27 +0100
Message-Id: <20230315115741.667087648@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 2a8db5ec4a28a0fce822d10224db9471a44b6925 ]

We're currently using stop_machine() to update ftrace & kprobes, which
means that the thread that takes text_mutex during may not be the same
as the thread that eventually patches the code.  This isn't actually a
race because the lock is still held (preventing any other concurrent
accesses) and there is only one thread running during stop_machine(),
but it does trigger a lockdep failure.

This patch just elides the lockdep check during stop_machine.

Fixes: c15ac4fd60d5 ("riscv/ftrace: Add dynamic function tracer support")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230303143754.4005217-1-conor.dooley@microchip.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/ftrace.h |  2 +-
 arch/riscv/include/asm/patch.h  |  2 ++
 arch/riscv/kernel/ftrace.c      | 14 ++++++++++++--
 arch/riscv/kernel/patch.c       | 28 +++++++++++++++++++++++++---
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
index 9e73922e1e2e5..d47d87c2d7e3d 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -109,6 +109,6 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec);
 #define ftrace_init_nop ftrace_init_nop
 #endif
 
-#endif
+#endif /* CONFIG_DYNAMIC_FTRACE */
 
 #endif /* _ASM_RISCV_FTRACE_H */
diff --git a/arch/riscv/include/asm/patch.h b/arch/riscv/include/asm/patch.h
index 9a7d7346001ee..98d9de07cba17 100644
--- a/arch/riscv/include/asm/patch.h
+++ b/arch/riscv/include/asm/patch.h
@@ -9,4 +9,6 @@
 int patch_text_nosync(void *addr, const void *insns, size_t len);
 int patch_text(void *addr, u32 insn);
 
+extern int riscv_patch_in_stop_machine;
+
 #endif /* _ASM_RISCV_PATCH_H */
diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index 47b43d8ee9a6c..1bf92cfa6764e 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -15,11 +15,21 @@
 int ftrace_arch_code_modify_prepare(void) __acquires(&text_mutex)
 {
 	mutex_lock(&text_mutex);
+
+	/*
+	 * The code sequences we use for ftrace can't be patched while the
+	 * kernel is running, so we need to use stop_machine() to modify them
+	 * for now.  This doesn't play nice with text_mutex, we use this flag
+	 * to elide the check.
+	 */
+	riscv_patch_in_stop_machine = true;
+
 	return 0;
 }
 
 int ftrace_arch_code_modify_post_process(void) __releases(&text_mutex)
 {
+	riscv_patch_in_stop_machine = false;
 	mutex_unlock(&text_mutex);
 	return 0;
 }
@@ -109,9 +119,9 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
 {
 	int out;
 
-	ftrace_arch_code_modify_prepare();
+	mutex_lock(&text_mutex);
 	out = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
-	ftrace_arch_code_modify_post_process();
+	mutex_unlock(&text_mutex);
 
 	return out;
 }
diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 765004b605132..e099961453cca 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -11,6 +11,7 @@
 #include <asm/kprobes.h>
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
+#include <asm/ftrace.h>
 #include <asm/patch.h>
 
 struct patch_insn {
@@ -19,6 +20,8 @@ struct patch_insn {
 	atomic_t cpu_count;
 };
 
+int riscv_patch_in_stop_machine = false;
+
 #ifdef CONFIG_MMU
 /*
  * The fix_to_virt(, idx) needs a const value (not a dynamic variable of
@@ -59,8 +62,15 @@ static int patch_insn_write(void *addr, const void *insn, size_t len)
 	 * Before reaching here, it was expected to lock the text_mutex
 	 * already, so we don't need to give another lock here and could
 	 * ensure that it was safe between each cores.
+	 *
+	 * We're currently using stop_machine() for ftrace & kprobes, and while
+	 * that ensures text_mutex is held before installing the mappings it
+	 * does not ensure text_mutex is held by the calling thread.  That's
+	 * safe but triggers a lockdep failure, so just elide it for that
+	 * specific case.
 	 */
-	lockdep_assert_held(&text_mutex);
+	if (!riscv_patch_in_stop_machine)
+		lockdep_assert_held(&text_mutex);
 
 	if (across_pages)
 		patch_map(addr + len, FIX_TEXT_POKE1);
@@ -121,13 +131,25 @@ NOKPROBE_SYMBOL(patch_text_cb);
 
 int patch_text(void *addr, u32 insn)
 {
+	int ret;
 	struct patch_insn patch = {
 		.addr = addr,
 		.insn = insn,
 		.cpu_count = ATOMIC_INIT(0),
 	};
 
-	return stop_machine_cpuslocked(patch_text_cb,
-				       &patch, cpu_online_mask);
+	/*
+	 * kprobes takes text_mutex, before calling patch_text(), but as we call
+	 * calls stop_machine(), the lockdep assertion in patch_insn_write()
+	 * gets confused by the context in which the lock is taken.
+	 * Instead, ensure the lock is held before calling stop_machine(), and
+	 * set riscv_patch_in_stop_machine to skip the check in
+	 * patch_insn_write().
+	 */
+	lockdep_assert_held(&text_mutex);
+	riscv_patch_in_stop_machine = true;
+	ret = stop_machine_cpuslocked(patch_text_cb, &patch, cpu_online_mask);
+	riscv_patch_in_stop_machine = false;
+	return ret;
 }
 NOKPROBE_SYMBOL(patch_text);
-- 
2.39.2



