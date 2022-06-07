Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C34541D03
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383568AbiFGWHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383735AbiFGWGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA00A2534CB;
        Tue,  7 Jun 2022 12:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6282CCE246B;
        Tue,  7 Jun 2022 19:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C78BC385A2;
        Tue,  7 Jun 2022 19:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629444;
        bh=RAJ3x2ZhfBQAjh19mcMTVM1NJu9fP1fRaAIm4q3mR/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1eDloyQLOMLvFN1s2BXMC32cJO5kUc0kno6gEp+gz4pAkHWJr6jwSKzbj4v67xiC
         Kb/hMBAx5NKOXVyhu6id+7a/PTFaiPUAkD3mmHc2qrdGof6iZgaAimE5ukgxloH78r
         9AUa4XcPzLi7rKpZD9Z/U9ncG73DhxJdtAM5NeU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 693/879] RISC-V: Split out the XIP fixups into their own file
Date:   Tue,  7 Jun 2022 19:03:31 +0200
Message-Id: <20220607165022.963428462@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit e7681beba992d5a196476d5d79dfcb48f2a2c477 ]

This was broken by the original refactoring (as the XIP definitions
depend on <asm/pgtable.h>) and then more broken by the merge (as I
accidentally took the old version).  This fixes both breakages, while
also pulling this out of <asm/asm.h> to avoid polluting most assembly
files with the XIP fixups.

Fixes: bee7fbc38579 ("RISC-V CPU Idle Support")
Fixes: 63b13e64a829 ("RISC-V: Add arch functions for non-retentive suspend entry/exit")
Link: https://lore.kernel.org/r/20220420184056.7886-4-palmer@rivosinc.com
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/asm.h       | 26 -------------------------
 arch/riscv/include/asm/xip_fixup.h | 31 ++++++++++++++++++++++++++++++
 arch/riscv/kernel/head.S           |  1 +
 arch/riscv/kernel/suspend_entry.S  |  1 +
 4 files changed, 33 insertions(+), 26 deletions(-)
 create mode 100644 arch/riscv/include/asm/xip_fixup.h

diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
index 8c2549b16ac0..618d7c5af1a2 100644
--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -67,30 +67,4 @@
 #error "Unexpected __SIZEOF_SHORT__"
 #endif
 
-#ifdef __ASSEMBLY__
-
-/* Common assembly source macros */
-
-#ifdef CONFIG_XIP_KERNEL
-.macro XIP_FIXUP_OFFSET reg
-	REG_L t0, _xip_fixup
-	add \reg, \reg, t0
-.endm
-.macro XIP_FIXUP_FLASH_OFFSET reg
-	la t1, __data_loc
-	REG_L t1, _xip_phys_offset
-	sub \reg, \reg, t1
-	add \reg, \reg, t0
-.endm
-_xip_fixup: .dword CONFIG_PHYS_RAM_BASE - CONFIG_XIP_PHYS_ADDR - XIP_OFFSET
-_xip_phys_offset: .dword CONFIG_XIP_PHYS_ADDR + XIP_OFFSET
-#else
-.macro XIP_FIXUP_OFFSET reg
-.endm
-.macro XIP_FIXUP_FLASH_OFFSET reg
-.endm
-#endif /* CONFIG_XIP_KERNEL */
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* _ASM_RISCV_ASM_H */
diff --git a/arch/riscv/include/asm/xip_fixup.h b/arch/riscv/include/asm/xip_fixup.h
new file mode 100644
index 000000000000..d4ffc3c37649
--- /dev/null
+++ b/arch/riscv/include/asm/xip_fixup.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * XIP fixup macros, only useful in assembly.
+ */
+#ifndef _ASM_RISCV_XIP_FIXUP_H
+#define _ASM_RISCV_XIP_FIXUP_H
+
+#include <linux/pgtable.h>
+
+#ifdef CONFIG_XIP_KERNEL
+.macro XIP_FIXUP_OFFSET reg
+        REG_L t0, _xip_fixup
+        add \reg, \reg, t0
+.endm
+.macro XIP_FIXUP_FLASH_OFFSET reg
+	la t1, __data_loc
+	REG_L t1, _xip_phys_offset
+	sub \reg, \reg, t1
+	add \reg, \reg, t0
+.endm
+
+_xip_fixup: .dword CONFIG_PHYS_RAM_BASE - CONFIG_XIP_PHYS_ADDR - XIP_OFFSET
+_xip_phys_offset: .dword CONFIG_XIP_PHYS_ADDR + XIP_OFFSET
+#else
+.macro XIP_FIXUP_OFFSET reg
+.endm
+.macro XIP_FIXUP_FLASH_OFFSET reg
+.endm
+#endif /* CONFIG_XIP_KERNEL */
+
+#endif
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index b605fb1e6a9c..b865046e4dbb 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -14,6 +14,7 @@
 #include <asm/cpu_ops_sbi.h>
 #include <asm/hwcap.h>
 #include <asm/image.h>
+#include <asm/xip_fixup.h>
 #include "efi-header.S"
 
 __HEAD
diff --git a/arch/riscv/kernel/suspend_entry.S b/arch/riscv/kernel/suspend_entry.S
index 4b07b809a2b8..aafcca58c19d 100644
--- a/arch/riscv/kernel/suspend_entry.S
+++ b/arch/riscv/kernel/suspend_entry.S
@@ -8,6 +8,7 @@
 #include <asm/asm.h>
 #include <asm/asm-offsets.h>
 #include <asm/csr.h>
+#include <asm/xip_fixup.h>
 
 	.text
 	.altmacro
-- 
2.35.1



