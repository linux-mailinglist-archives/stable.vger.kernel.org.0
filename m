Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8194469E59
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357428AbhLFPiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388758AbhLFPeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:34:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD55C09B137;
        Mon,  6 Dec 2021 07:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83DB5B810AC;
        Mon,  6 Dec 2021 15:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B482DC341C1;
        Mon,  6 Dec 2021 15:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804041;
        bh=X0j6u6C8CebksNUurvqIieXZD7Hf7QghoEM3/NircBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpUaXGGdTW6I/M82PegK6UZ/7HMuB4c9ICL/qGR83yzsn8/n+friwR5z47uLhMnpQ
         ShzvoLTC40mSRclxDYZCYzTSVmxYHhrbYNGWIVl35S2a8tEj0d0xIRw1wgR6aQvOSy
         MAvuTKX2X26c6HL9t8HArB4H7rS/4t+4cbuAAH2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/130] x86/xen: Add xenpv_restore_regs_and_return_to_usermode()
Date:   Mon,  6 Dec 2021 15:57:04 +0100
Message-Id: <20211206145603.335959196@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit 5c8f6a2e316efebb3ba93d8c1af258155dcf5632 ]

In the native case, PER_CPU_VAR(cpu_tss_rw + TSS_sp0) is the
trampoline stack. But XEN pv doesn't use trampoline stack, so
PER_CPU_VAR(cpu_tss_rw + TSS_sp0) is also the kernel stack.

In that case, source and destination stacks are identical, which means
that reusing swapgs_restore_regs_and_return_to_usermode() in XEN pv
would cause %rsp to move up to the top of the kernel stack and leave the
IRET frame below %rsp.

This is dangerous as it can be corrupted if #NMI / #MC hit as either of
these events occurring in the middle of the stack pushing would clobber
data on the (original) stack.

And, with  XEN pv, swapgs_restore_regs_and_return_to_usermode() pushing
the IRET frame on to the original address is useless and error-prone
when there is any future attempt to modify the code.

 [ bp: Massage commit message. ]

Fixes: 7f2590a110b8 ("x86/entry/64: Use a per-CPU trampoline stack for IDT entries")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lkml.kernel.org/r/20211126101209.8613-4-jiangshanlai@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64.S |  4 ++++
 arch/x86/xen/xen-asm.S    | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index a806d68b96990..de541ea2788eb 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -575,6 +575,10 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
 	ud2
 1:
 #endif
+#ifdef CONFIG_XEN_PV
+	ALTERNATIVE "", "jmp xenpv_restore_regs_and_return_to_usermode", X86_FEATURE_XENPV
+#endif
+
 	POP_REGS pop_rdi=0
 
 	/*
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 53cf8aa35032d..011ec649f3886 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -19,6 +19,7 @@
 
 #include <linux/init.h>
 #include <linux/linkage.h>
+#include <../entry/calling.h>
 
 /*
  * Enable events.  This clears the event mask and tests the pending
@@ -235,6 +236,25 @@ SYM_CODE_START(xen_sysret64)
 	jmp hypercall_iret
 SYM_CODE_END(xen_sysret64)
 
+/*
+ * XEN pv doesn't use trampoline stack, PER_CPU_VAR(cpu_tss_rw + TSS_sp0) is
+ * also the kernel stack.  Reusing swapgs_restore_regs_and_return_to_usermode()
+ * in XEN pv would cause %rsp to move up to the top of the kernel stack and
+ * leave the IRET frame below %rsp, which is dangerous to be corrupted if #NMI
+ * interrupts. And swapgs_restore_regs_and_return_to_usermode() pushing the IRET
+ * frame at the same address is useless.
+ */
+SYM_CODE_START(xenpv_restore_regs_and_return_to_usermode)
+	UNWIND_HINT_REGS
+	POP_REGS
+
+	/* stackleak_erase() can work safely on the kernel stack. */
+	STACKLEAK_ERASE_NOCLOBBER
+
+	addq	$8, %rsp	/* skip regs->orig_ax */
+	jmp xen_iret
+SYM_CODE_END(xenpv_restore_regs_and_return_to_usermode)
+
 /*
  * Xen handles syscall callbacks much like ordinary exceptions, which
  * means we have:
-- 
2.33.0



