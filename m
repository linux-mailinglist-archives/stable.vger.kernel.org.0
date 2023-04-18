Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FB86E6502
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjDRMx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjDRMxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D800016FB1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAFE863473
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB755C4339B;
        Tue, 18 Apr 2023 12:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822421;
        bh=2Zfz/45ui6SGNUHMsEl4ommOIT4sYmyBiR8zMME8p+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLvdkDxj8g6SwRQToemPmmVfSWceRNr+Ln5jUYGQTfJvFvkaQPTwjSk/6krc1jqXH
         1ETpiL1hePhpyzV3uHrn9mPPy5fUzhpDNwshg0B+V6u8/C7lpyygzrSIemdkIayRba
         DbLmTJ9kOlahQc7VMY32NZ1GcQkctF58nGdVq4qM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 136/139] RISC-V: add infrastructure to allow different str* implementations
Date:   Tue, 18 Apr 2023 14:23:21 +0200
Message-Id: <20230418120319.027178851@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@vrull.eu>

[ Upstream commit 56e0790c7f9e59ba6a0f4b59981d1d6fbf43efb0 ]

Depending on supported extensions on specific RISC-V cores,
optimized str* functions might make sense.

This adds basic infrastructure to allow patching the function calls
via alternatives later on.

The Linux kernel provides standard implementations for string functions
but when architectures want to extend them, they need to provide their
own.

The added generic string functions are done in assembler (taken from
disassembling the main-kernel functions for now) to allow us to control
the used registers and extend them with optimized variants.

This doesn't override the compiler's use of builtin replacements. So still
first of all the compiler will select if a builtin will be better suitable
i.e. for known strings. For all regular cases we will want to later
select possible optimized variants and in the worst case fall back to the
generic implemention added with this change.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230113212301.3534711-2-heiko@sntech.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: d83806c4c0cc ("purgatory: fix disabling debug info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/string.h | 10 ++++++++
 arch/riscv/kernel/riscv_ksyms.c |  3 +++
 arch/riscv/lib/Makefile         |  3 +++
 arch/riscv/lib/strcmp.S         | 36 +++++++++++++++++++++++++++++
 arch/riscv/lib/strlen.S         | 28 ++++++++++++++++++++++
 arch/riscv/lib/strncmp.S        | 41 +++++++++++++++++++++++++++++++++
 arch/riscv/purgatory/Makefile   | 13 +++++++++++
 7 files changed, 134 insertions(+)
 create mode 100644 arch/riscv/lib/strcmp.S
 create mode 100644 arch/riscv/lib/strlen.S
 create mode 100644 arch/riscv/lib/strncmp.S

diff --git a/arch/riscv/include/asm/string.h b/arch/riscv/include/asm/string.h
index 9090493665555..a96b1fea24fe4 100644
--- a/arch/riscv/include/asm/string.h
+++ b/arch/riscv/include/asm/string.h
@@ -18,6 +18,16 @@ extern asmlinkage void *__memcpy(void *, const void *, size_t);
 #define __HAVE_ARCH_MEMMOVE
 extern asmlinkage void *memmove(void *, const void *, size_t);
 extern asmlinkage void *__memmove(void *, const void *, size_t);
+
+#define __HAVE_ARCH_STRCMP
+extern asmlinkage int strcmp(const char *cs, const char *ct);
+
+#define __HAVE_ARCH_STRLEN
+extern asmlinkage __kernel_size_t strlen(const char *);
+
+#define __HAVE_ARCH_STRNCMP
+extern asmlinkage int strncmp(const char *cs, const char *ct, size_t count);
+
 /* For those files which don't want to check by kasan. */
 #if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
 #define memcpy(dst, src, len) __memcpy(dst, src, len)
diff --git a/arch/riscv/kernel/riscv_ksyms.c b/arch/riscv/kernel/riscv_ksyms.c
index 5ab1c7e1a6ed5..a72879b4249a5 100644
--- a/arch/riscv/kernel/riscv_ksyms.c
+++ b/arch/riscv/kernel/riscv_ksyms.c
@@ -12,6 +12,9 @@
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memmove);
+EXPORT_SYMBOL(strcmp);
+EXPORT_SYMBOL(strlen);
+EXPORT_SYMBOL(strncmp);
 EXPORT_SYMBOL(__memset);
 EXPORT_SYMBOL(__memcpy);
 EXPORT_SYMBOL(__memmove);
diff --git a/arch/riscv/lib/Makefile b/arch/riscv/lib/Makefile
index 25d5c9664e57e..6c74b0bedd60d 100644
--- a/arch/riscv/lib/Makefile
+++ b/arch/riscv/lib/Makefile
@@ -3,6 +3,9 @@ lib-y			+= delay.o
 lib-y			+= memcpy.o
 lib-y			+= memset.o
 lib-y			+= memmove.o
+lib-y			+= strcmp.o
+lib-y			+= strlen.o
+lib-y			+= strncmp.o
 lib-$(CONFIG_MMU)	+= uaccess.o
 lib-$(CONFIG_64BIT)	+= tishift.o
 
diff --git a/arch/riscv/lib/strcmp.S b/arch/riscv/lib/strcmp.S
new file mode 100644
index 0000000000000..8babd712b9587
--- /dev/null
+++ b/arch/riscv/lib/strcmp.S
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm-generic/export.h>
+
+/* int strcmp(const char *cs, const char *ct) */
+SYM_FUNC_START(strcmp)
+	/*
+	 * Returns
+	 *   a0 - comparison result, value like strcmp
+	 *
+	 * Parameters
+	 *   a0 - string1
+	 *   a1 - string2
+	 *
+	 * Clobbers
+	 *   t0, t1
+	 */
+1:
+	lbu	t0, 0(a0)
+	lbu	t1, 0(a1)
+	addi	a0, a0, 1
+	addi	a1, a1, 1
+	bne	t0, t1, 2f
+	bnez	t0, 1b
+	li	a0, 0
+	ret
+2:
+	/*
+	 * strcmp only needs to return (< 0, 0, > 0) values
+	 * not necessarily -1, 0, +1
+	 */
+	sub	a0, t0, t1
+	ret
+SYM_FUNC_END(strcmp)
diff --git a/arch/riscv/lib/strlen.S b/arch/riscv/lib/strlen.S
new file mode 100644
index 0000000000000..0a3b11853efdb
--- /dev/null
+++ b/arch/riscv/lib/strlen.S
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm-generic/export.h>
+
+/* int strlen(const char *s) */
+SYM_FUNC_START(strlen)
+	/*
+	 * Returns
+	 *   a0 - string length
+	 *
+	 * Parameters
+	 *   a0 - String to measure
+	 *
+	 * Clobbers:
+	 *   t0, t1
+	 */
+	mv	t1, a0
+1:
+	lbu	t0, 0(t1)
+	beqz	t0, 2f
+	addi	t1, t1, 1
+	j	1b
+2:
+	sub	a0, t1, a0
+	ret
+SYM_FUNC_END(strlen)
diff --git a/arch/riscv/lib/strncmp.S b/arch/riscv/lib/strncmp.S
new file mode 100644
index 0000000000000..1f644d0a93f68
--- /dev/null
+++ b/arch/riscv/lib/strncmp.S
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm-generic/export.h>
+
+/* int strncmp(const char *cs, const char *ct, size_t count) */
+SYM_FUNC_START(strncmp)
+	/*
+	 * Returns
+	 *   a0 - comparison result, value like strncmp
+	 *
+	 * Parameters
+	 *   a0 - string1
+	 *   a1 - string2
+	 *   a2 - number of characters to compare
+	 *
+	 * Clobbers
+	 *   t0, t1, t2
+	 */
+	li	t2, 0
+1:
+	beq	a2, t2, 2f
+	lbu	t0, 0(a0)
+	lbu	t1, 0(a1)
+	addi	a0, a0, 1
+	addi	a1, a1, 1
+	bne	t0, t1, 3f
+	addi	t2, t2, 1
+	bnez	t0, 1b
+2:
+	li	a0, 0
+	ret
+3:
+	/*
+	 * strncmp only needs to return (< 0, 0, > 0) values
+	 * not necessarily -1, 0, +1
+	 */
+	sub	a0, t0, t1
+	ret
+SYM_FUNC_END(strncmp)
diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
index dd58e1d993972..d16bf715a586b 100644
--- a/arch/riscv/purgatory/Makefile
+++ b/arch/riscv/purgatory/Makefile
@@ -2,6 +2,7 @@
 OBJECT_FILES_NON_STANDARD := y
 
 purgatory-y := purgatory.o sha256.o entry.o string.o ctype.o memcpy.o memset.o
+purgatory-y += strcmp.o strlen.o strncmp.o
 
 targets += $(purgatory-y)
 PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
@@ -18,6 +19,15 @@ $(obj)/memcpy.o: $(srctree)/arch/riscv/lib/memcpy.S FORCE
 $(obj)/memset.o: $(srctree)/arch/riscv/lib/memset.S FORCE
 	$(call if_changed_rule,as_o_S)
 
+$(obj)/strcmp.o: $(srctree)/arch/riscv/lib/strcmp.S FORCE
+	$(call if_changed_rule,as_o_S)
+
+$(obj)/strlen.o: $(srctree)/arch/riscv/lib/strlen.S FORCE
+	$(call if_changed_rule,as_o_S)
+
+$(obj)/strncmp.o: $(srctree)/arch/riscv/lib/strncmp.S FORCE
+	$(call if_changed_rule,as_o_S)
+
 $(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
@@ -77,6 +87,9 @@ CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
 AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
 AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
 AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
+AFLAGS_REMOVE_strcmp.o		+= -Wa,-gdwarf-2
+AFLAGS_REMOVE_strlen.o		+= -Wa,-gdwarf-2
+AFLAGS_REMOVE_strncmp.o		+= -Wa,-gdwarf-2
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
-- 
2.39.2



