Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59B7EED9D
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389521AbfKDWIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390219AbfKDWIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:22 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5E82084D;
        Mon,  4 Nov 2019 22:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905300;
        bh=/g46P0TulW0h/dwsxG3+s4Jb4S23l9pXlIPSTXCiciA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WByDid6dcBIMGtJ2fBkyt7D8C1bpJoZ6a0j3ctdsBSYBeAM3B0pVJi20ggAGt8Wlw
         KZMdgMxhuYgQIiuyObYa1gHyvcL3xnh6Pn+YgUnzXUjCFc84mkjsBF2H8TYFOzll5t
         JNRrgGlLePfW2lRKwiJUxFhjx0CExxquT8Rj6RKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 046/163] arm64: vdso32: Detect binutils support for dmb ishld
Date:   Mon,  4 Nov 2019 22:43:56 +0100
Message-Id: <20191104212143.556017848@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit 0df2c90eba60791148cee1823c0bf5fc66e3465c ]

Older versions of binutils (prior to 2.24) do not support the "ISHLD"
option for memory barrier instructions, which leads to a build failure
when assembling the vdso32 library.

Add a compilation time mechanism that detects if binutils supports those
instructions and configure the kernel accordingly.

Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/vdso/compat_barrier.h | 2 +-
 arch/arm64/kernel/vdso32/Makefile            | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vdso/compat_barrier.h b/arch/arm64/include/asm/vdso/compat_barrier.h
index fb60a88b5ed41..3fd8fd6d8fc25 100644
--- a/arch/arm64/include/asm/vdso/compat_barrier.h
+++ b/arch/arm64/include/asm/vdso/compat_barrier.h
@@ -20,7 +20,7 @@
 
 #define dmb(option) __asm__ __volatile__ ("dmb " #option : : : "memory")
 
-#if __LINUX_ARM_ARCH__ >= 8
+#if __LINUX_ARM_ARCH__ >= 8 && defined(CONFIG_AS_DMB_ISHLD)
 #define aarch32_smp_mb()	dmb(ish)
 #define aarch32_smp_rmb()	dmb(ishld)
 #define aarch32_smp_wmb()	dmb(ishst)
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 19e0d3115ffe0..77aa613403747 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -15,6 +15,8 @@ cc32-disable-warning = $(call try-run,\
 	$(COMPATCC) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
 cc32-ldoption = $(call try-run,\
         $(COMPATCC) $(1) -nostdlib -x c /dev/null -o "$$TMP",$(1),$(2))
+cc32-as-instr = $(call try-run,\
+	printf "%b\n" "$(1)" | $(COMPATCC) $(VDSO_AFLAGS) -c -x assembler -o "$$TMP" -,$(2),$(3))
 
 # We cannot use the global flags to compile the vDSO files, the main reason
 # being that the 32-bit compiler may be older than the main (64-bit) compiler
@@ -53,6 +55,7 @@ endif
 VDSO_CAFLAGS += -fPIC -fno-builtin -fno-stack-protector
 VDSO_CAFLAGS += -DDISABLE_BRANCH_PROFILING
 
+
 # Try to compile for ARMv8. If the compiler is too old and doesn't support it,
 # fall back to v7. There is no easy way to check for what architecture the code
 # is being compiled, so define a macro specifying that (see arch/arm/Makefile).
@@ -89,6 +92,12 @@ VDSO_CFLAGS += -Wno-int-to-pointer-cast
 VDSO_AFLAGS := $(VDSO_CAFLAGS)
 VDSO_AFLAGS += -D__ASSEMBLY__
 
+# Check for binutils support for dmb ishld
+dmbinstr := $(call cc32-as-instr,dmb ishld,-DCONFIG_AS_DMB_ISHLD=1)
+
+VDSO_CFLAGS += $(dmbinstr)
+VDSO_AFLAGS += $(dmbinstr)
+
 VDSO_LDFLAGS := $(VDSO_CPPFLAGS)
 # From arm vDSO Makefile
 VDSO_LDFLAGS += -Wl,-Bsymbolic -Wl,--no-undefined -Wl,-soname=linux-vdso.so.1
-- 
2.20.1



