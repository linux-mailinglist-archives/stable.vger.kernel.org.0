Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E414290C6
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242027AbhJKOMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243253AbhJKOKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:10:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57C71610C7;
        Mon, 11 Oct 2021 14:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960951;
        bh=+Q/6xv4ZZ8kq77n5qn7BldO3d78CjdNUeqKeh4DyJGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12oRwUJxpZsrVmQzfAaRCRQTE0Q5//aRFLXlbyGFGtnyLzSd8ANyBfkeSAWLSg1Is
         pINEF3QWInNLr1IDyAyNV0Xaqm6PP4/nW1xjDQPezxp9f9mUWB3tJSjEdoPHMqPowR
         0Wlk0lxoXN06+/xcXgEEjRDfWypHaVLk89vmcs90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 123/151] riscv/vdso: Refactor asm/vdso.h
Date:   Mon, 11 Oct 2021 15:46:35 +0200
Message-Id: <20211011134521.788888454@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit bb4a23c994aebcd96c567a0be8e964d516bd4a61 ]

The asm/vdso.h will be included in vdso.lds.S in the next patch, the
following cleanup is needed to avoid syntax error:

 1.the declaration of sys_riscv_flush_icache() is moved into asm/syscall.h.
 2.the definition of struct vdso_data is moved into kernel/vdso.c.
 2.the definition of VDSO_SYMBOL is placed under "#ifndef __ASSEMBLY__".

Also remove the redundant linux/types.h include.

Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/syscall.h  |  1 +
 arch/riscv/include/asm/vdso.h     | 16 ++++++++++------
 arch/riscv/kernel/syscall_table.c |  1 -
 arch/riscv/kernel/vdso.c          |  5 ++++-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/syscall.h b/arch/riscv/include/asm/syscall.h
index b933b1583c9f..34fbb3ea21d5 100644
--- a/arch/riscv/include/asm/syscall.h
+++ b/arch/riscv/include/asm/syscall.h
@@ -82,4 +82,5 @@ static inline int syscall_get_arch(struct task_struct *task)
 #endif
 }
 
+asmlinkage long sys_riscv_flush_icache(uintptr_t, uintptr_t, uintptr_t);
 #endif	/* _ASM_RISCV_SYSCALL_H */
diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
index 893e47195e30..a4a979c89ea0 100644
--- a/arch/riscv/include/asm/vdso.h
+++ b/arch/riscv/include/asm/vdso.h
@@ -16,18 +16,22 @@
 #ifdef CONFIG_MMU
 
 #include <linux/types.h>
-#include <generated/vdso-offsets.h>
+/*
+ * All systems with an MMU have a VDSO, but systems without an MMU don't
+ * support shared libraries and therefor don't have one.
+ */
+#ifdef CONFIG_MMU
 
-#ifndef CONFIG_GENERIC_TIME_VSYSCALL
-struct vdso_data {
-};
-#endif
+#ifndef __ASSEMBLY__
+#include <generated/vdso-offsets.h>
 
 #define VDSO_SYMBOL(base, name)							\
 	(void __user *)((unsigned long)(base) + __vdso_##name##_offset)
 
 #endif /* CONFIG_MMU */
 
-asmlinkage long sys_riscv_flush_icache(uintptr_t, uintptr_t, uintptr_t);
+#endif /* !__ASSEMBLY__ */
+
+#endif /* CONFIG_MMU */
 
 #endif /* _ASM_RISCV_VDSO_H */
diff --git a/arch/riscv/kernel/syscall_table.c b/arch/riscv/kernel/syscall_table.c
index a63c667c27b3..44b1420a2270 100644
--- a/arch/riscv/kernel/syscall_table.c
+++ b/arch/riscv/kernel/syscall_table.c
@@ -7,7 +7,6 @@
 #include <linux/linkage.h>
 #include <linux/syscalls.h>
 #include <asm-generic/syscalls.h>
-#include <asm/vdso.h>
 #include <asm/syscall.h>
 
 #undef __SYSCALL
diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
index 25a3b8849599..72e93d218335 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -12,10 +12,13 @@
 #include <linux/binfmts.h>
 #include <linux/err.h>
 #include <asm/page.h>
+#include <asm/vdso.h>
+
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 #include <vdso/datapage.h>
 #else
-#include <asm/vdso.h>
+struct vdso_data {
+};
 #endif
 
 extern char vdso_start[], vdso_end[];
-- 
2.33.0



