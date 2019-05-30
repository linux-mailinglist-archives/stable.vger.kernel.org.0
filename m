Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA222F142
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfE3ELY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730821AbfE3DQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:49 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A876024628;
        Thu, 30 May 2019 03:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186207;
        bh=n+mQP6Ot/bSNwz8Z1NLu1w72gjU1a7QBXhVgmvvJSEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atqCpRwY9Yc7Gg4jFZ0ruHrpfDw5TrJVNIIxX3mvPome4YrCwW6Z1BCsMm0ltYUrd
         pLyT3UUTAtP0WcdKd20qo92HXe96LC+c0vRa+lZ0nJbx9J6h3lOzmdpIc34XKLNZwg
         wJiyXesycslhSFDM9Jp8ybVSfP5vrQegcHudJVpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Nadav Amit <namit@vmware.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        akpm@linux-foundation.org, ard.biesheuvel@linaro.org,
        deneen.t.dock@intel.com, kernel-hardening@lists.openwall.com,
        kristen@linux.intel.com, linux_dti@icloud.com, will.deacon@arm.com,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/276] x86/modules: Avoid breaking W^X while loading modules
Date:   Wed, 29 May 2019 20:03:57 -0700
Message-Id: <20190530030531.331779845@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f2c65fb3221adc6b73b0549fc7ba892022db9797 ]

When modules and BPF filters are loaded, there is a time window in
which some memory is both writable and executable. An attacker that has
already found another vulnerability (e.g., a dangling pointer) might be
able to exploit this behavior to overwrite kernel code. Prevent having
writable executable PTEs in this stage.

In addition, avoiding having W+X mappings can also slightly simplify the
patching of modules code on initialization (e.g., by alternatives and
static-key), as would be done in the next patch. This was actually the
main motivation for this patch.

To avoid having W+X mappings, set them initially as RW (NX) and after
they are set as RO set them as X as well. Setting them as executable is
done as a separate step to avoid one core in which the old PTE is cached
(hence writable), and another which sees the updated PTE (executable),
which would break the W^X protection.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <akpm@linux-foundation.org>
Cc: <ard.biesheuvel@linaro.org>
Cc: <deneen.t.dock@intel.com>
Cc: <kernel-hardening@lists.openwall.com>
Cc: <kristen@linux.intel.com>
Cc: <linux_dti@icloud.com>
Cc: <will.deacon@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Link: https://lkml.kernel.org/r/20190426001143.4983-12-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/alternative.c | 28 +++++++++++++++++++++-------
 arch/x86/kernel/module.c      |  2 +-
 include/linux/filter.h        |  1 +
 kernel/module.c               |  5 +++++
 4 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index b9d5e7c9ef43e..918a23704c0c5 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -662,15 +662,29 @@ void __init alternative_instructions(void)
  * handlers seeing an inconsistent instruction while you patch.
  */
 void *__init_or_module text_poke_early(void *addr, const void *opcode,
-					      size_t len)
+				       size_t len)
 {
 	unsigned long flags;
-	local_irq_save(flags);
-	memcpy(addr, opcode, len);
-	local_irq_restore(flags);
-	sync_core();
-	/* Could also do a CLFLUSH here to speed up CPU recovery; but
-	   that causes hangs on some VIA CPUs. */
+
+	if (boot_cpu_has(X86_FEATURE_NX) &&
+	    is_module_text_address((unsigned long)addr)) {
+		/*
+		 * Modules text is marked initially as non-executable, so the
+		 * code cannot be running and speculative code-fetches are
+		 * prevented. Just change the code.
+		 */
+		memcpy(addr, opcode, len);
+	} else {
+		local_irq_save(flags);
+		memcpy(addr, opcode, len);
+		local_irq_restore(flags);
+		sync_core();
+
+		/*
+		 * Could also do a CLFLUSH here to speed up CPU recovery; but
+		 * that causes hangs on some VIA CPUs.
+		 */
+	}
 	return addr;
 }
 
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index f58336af095c9..6645f123419c6 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -87,7 +87,7 @@ void *module_alloc(unsigned long size)
 	p = __vmalloc_node_range(size, MODULE_ALIGN,
 				    MODULES_VADDR + get_module_load_offset(),
 				    MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				    PAGE_KERNEL, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 	if (p && (kasan_module_alloc(p, size) < 0)) {
 		vfree(p);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 6ecef32fd8bcd..d52a7484aeb2d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -684,6 +684,7 @@ static inline void bpf_prog_unlock_ro(struct bpf_prog *fp)
 static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
 {
 	set_memory_ro((unsigned long)hdr, hdr->pages);
+	set_memory_x((unsigned long)hdr, hdr->pages);
 }
 
 static inline void bpf_jit_binary_unlock_ro(struct bpf_binary_header *hdr)
diff --git a/kernel/module.c b/kernel/module.c
index 38bf28b5cc202..f797c6ace7121 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1949,8 +1949,13 @@ void module_enable_ro(const struct module *mod, bool after_init)
 		return;
 
 	frob_text(&mod->core_layout, set_memory_ro);
+	frob_text(&mod->core_layout, set_memory_x);
+
 	frob_rodata(&mod->core_layout, set_memory_ro);
+
 	frob_text(&mod->init_layout, set_memory_ro);
+	frob_text(&mod->init_layout, set_memory_x);
+
 	frob_rodata(&mod->init_layout, set_memory_ro);
 
 	if (after_init)
-- 
2.20.1



