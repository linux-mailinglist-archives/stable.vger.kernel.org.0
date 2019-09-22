Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E16ABA427
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbfIVSqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389850AbfIVSqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA78B21D7C;
        Sun, 22 Sep 2019 18:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177977;
        bh=dPMBz+h3etmnxoqEa7dwetX9+Br6b4R4IuSCrpEqtQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUQH7Knk++lH2Sz/OPcjYLn3qQKJ4pxspbQYbFWfqjH0a7gD7nWwkpplBXKXYN4TZ
         0QWlQl97gvMqMOkadNNTnaNDd/nJPxSWDheRA7gSAlgnNfyL9QfdDum5YFhYK+SOHG
         HKXjfeFNUBjJ5bVZvCMC2nJacbB7za/hnY5m3X88=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 074/203] arm64/efi: Move variable assignments after SECTIONS
Date:   Sun, 22 Sep 2019 14:41:40 -0400
Message-Id: <20190922184350.30563-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 90776dd1c427cbb4d381aa4b13338f1fb1d20f5e ]

It seems that LLVM's linker does not correctly handle variable assignments
involving section positions that are updated during the SECTIONS
parsing. Commit aa69fb62bea1 ("arm64/efi: Mark __efistub_stext_offset as
an absolute symbol explicitly") ran into this too, but found a different
workaround.

However, this was not enough, as other variables were also miscalculated
which manifested as boot failures under UEFI where __efistub__end was
not taking the correct _end value (they should be the same):

$ ld.lld -EL -maarch64elf --no-undefined -X -shared \
	-Bsymbolic -z notext -z norelro --no-apply-dynamic-relocs \
	-o vmlinux.lld -T poc.lds --whole-archive vmlinux.o && \
  readelf -Ws vmlinux.lld | egrep '\b(__efistub_|)_end\b'
368272: ffff000002218000     0 NOTYPE  LOCAL  HIDDEN    38 __efistub__end
368322: ffff000012318000     0 NOTYPE  GLOBAL DEFAULT   38 _end

$ aarch64-linux-gnu-ld.bfd -EL -maarch64elf --no-undefined -X -shared \
	-Bsymbolic -z notext -z norelro --no-apply-dynamic-relocs \
	-o vmlinux.bfd -T poc.lds --whole-archive vmlinux.o && \
  readelf -Ws vmlinux.bfd | egrep '\b(__efistub_|)_end\b'
338124: ffff000012318000     0 NOTYPE  LOCAL  DEFAULT  ABS __efistub__end
383812: ffff000012318000     0 NOTYPE  GLOBAL DEFAULT 15325 _end

To work around this, all of the __efistub_-prefixed variable assignments
need to be moved after the linker script's SECTIONS entry. As it turns
out, this also solves the problem fixed in commit aa69fb62bea1, so those
changes are reverted here.

Link: https://github.com/ClangBuiltLinux/linux/issues/634
Link: https://bugs.llvm.org/show_bug.cgi?id=42990
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/image-vars.h  | 51 +++++++++++++++++++++++++++++++++
 arch/arm64/kernel/image.h       | 42 ---------------------------
 arch/arm64/kernel/vmlinux.lds.S |  2 ++
 3 files changed, 53 insertions(+), 42 deletions(-)
 create mode 100644 arch/arm64/kernel/image-vars.h

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
new file mode 100644
index 0000000000000..25a2a9b479c2f
--- /dev/null
+++ b/arch/arm64/kernel/image-vars.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Linker script variables to be set after section resolution, as
+ * ld.lld does not like variables assigned before SECTIONS is processed.
+ */
+#ifndef __ARM64_KERNEL_IMAGE_VARS_H
+#define __ARM64_KERNEL_IMAGE_VARS_H
+
+#ifndef LINKER_SCRIPT
+#error This file should only be included in vmlinux.lds.S
+#endif
+
+#ifdef CONFIG_EFI
+
+__efistub_stext_offset = stext - _text;
+
+/*
+ * The EFI stub has its own symbol namespace prefixed by __efistub_, to
+ * isolate it from the kernel proper. The following symbols are legally
+ * accessed by the stub, so provide some aliases to make them accessible.
+ * Only include data symbols here, or text symbols of functions that are
+ * guaranteed to be safe when executed at another offset than they were
+ * linked at. The routines below are all implemented in assembler in a
+ * position independent manner
+ */
+__efistub_memcmp		= __pi_memcmp;
+__efistub_memchr		= __pi_memchr;
+__efistub_memcpy		= __pi_memcpy;
+__efistub_memmove		= __pi_memmove;
+__efistub_memset		= __pi_memset;
+__efistub_strlen		= __pi_strlen;
+__efistub_strnlen		= __pi_strnlen;
+__efistub_strcmp		= __pi_strcmp;
+__efistub_strncmp		= __pi_strncmp;
+__efistub_strrchr		= __pi_strrchr;
+__efistub___flush_dcache_area	= __pi___flush_dcache_area;
+
+#ifdef CONFIG_KASAN
+__efistub___memcpy		= __pi_memcpy;
+__efistub___memmove		= __pi_memmove;
+__efistub___memset		= __pi_memset;
+#endif
+
+__efistub__text			= _text;
+__efistub__end			= _end;
+__efistub__edata		= _edata;
+__efistub_screen_info		= screen_info;
+
+#endif
+
+#endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index 2b85c0d6fa3d1..c7d38c660372c 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -65,46 +65,4 @@
 	DEFINE_IMAGE_LE64(_kernel_offset_le, TEXT_OFFSET);	\
 	DEFINE_IMAGE_LE64(_kernel_flags_le, __HEAD_FLAGS);
 
-#ifdef CONFIG_EFI
-
-/*
- * Use ABSOLUTE() to avoid ld.lld treating this as a relative symbol:
- * https://github.com/ClangBuiltLinux/linux/issues/561
- */
-__efistub_stext_offset = ABSOLUTE(stext - _text);
-
-/*
- * The EFI stub has its own symbol namespace prefixed by __efistub_, to
- * isolate it from the kernel proper. The following symbols are legally
- * accessed by the stub, so provide some aliases to make them accessible.
- * Only include data symbols here, or text symbols of functions that are
- * guaranteed to be safe when executed at another offset than they were
- * linked at. The routines below are all implemented in assembler in a
- * position independent manner
- */
-__efistub_memcmp		= __pi_memcmp;
-__efistub_memchr		= __pi_memchr;
-__efistub_memcpy		= __pi_memcpy;
-__efistub_memmove		= __pi_memmove;
-__efistub_memset		= __pi_memset;
-__efistub_strlen		= __pi_strlen;
-__efistub_strnlen		= __pi_strnlen;
-__efistub_strcmp		= __pi_strcmp;
-__efistub_strncmp		= __pi_strncmp;
-__efistub_strrchr		= __pi_strrchr;
-__efistub___flush_dcache_area	= __pi___flush_dcache_area;
-
-#ifdef CONFIG_KASAN
-__efistub___memcpy		= __pi_memcpy;
-__efistub___memmove		= __pi_memmove;
-__efistub___memset		= __pi_memset;
-#endif
-
-__efistub__text			= _text;
-__efistub__end			= _end;
-__efistub__edata		= _edata;
-__efistub_screen_info		= screen_info;
-
-#endif
-
 #endif /* __ARM64_KERNEL_IMAGE_H */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 7fa0083749078..803b24d2464ae 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -245,6 +245,8 @@ SECTIONS
 	HEAD_SYMBOLS
 }
 
+#include "image-vars.h"
+
 /*
  * The HYP init code and ID map text can't be longer than a page each,
  * and should not cross a page boundary.
-- 
2.20.1

