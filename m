Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D417216D
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 23:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392014AbfGWVY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 17:24:29 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:38196 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731951AbfGWVY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 17:24:29 -0400
Received: by mail-pg1-f202.google.com with SMTP id w5so26787693pgs.5
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 14:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Hpr0yuvpw6CUvnD+l1IHEq2uOMPPyrhe5BbCI8J3Zt4=;
        b=VT0Ofx24XZsOi/DWgdLf2x1p5ZVFNWYNnm62NavnjPOiJD05DZXcapm7QaSZE1TDlA
         trA+JJpYbnyIZO0I4IHApXrgNEmDUOiHtIROcvVBasPHwY9XhEoVZddSoCAQrJANDWAI
         /Zh1uh5Xkf6oL/rKjoj8nX9ZY/M8JYQnwsLN6fnzrhyxsXO1O0KpK2qJKsF4MTey0Mlf
         7/vQXADbjEYoT78sc9OMqSHlbcbSbqRlzVtVlAKpjKoBFd7uObCMP2o9GP6zKrFXC+Mb
         vY1TDxrcTgp8liTP5ylCHq5DlNxNCSBHrSRtQmTf2i3awU26ece+iICLO5iG42bTqwc2
         3Bkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Hpr0yuvpw6CUvnD+l1IHEq2uOMPPyrhe5BbCI8J3Zt4=;
        b=LBdqPNPhcH1UshE1tN6wmvwDJCjWcSS0IJlQx+DTGgWNk1wN2uRafKNVJtEDehShmp
         YQGZ9hMqAeRCw2wejQ9rZiAOVgr+fjgyh0EVWFMpBjume4mreUOuU33Slr/6gcsZh4SP
         qUNrUu/JoL7+21N/obLb8Xr0WPTu5gl/ywwH4LuTdexT0ViVe8xi1KiG5uRldg948fPT
         71jlcZUs55v6xyIkhnI82oQVXnjGp8/zqwfNkd7Nvw9H5Zs70SoTqZ7ye7j9qlRI0DZj
         85u6Y1tLlzU7RgpkrV2QuEUczT1TLSu66D6xLl3VScN54g7Bf8meOEDWUTTBV0UaEkOr
         o6tA==
X-Gm-Message-State: APjAAAV2ZIv1hZ5e0We3tfNgJDTjPn1hC9BehjivXyRlBMFCFssTpjbE
        uapjfhZJ9RTqlYbwM8SwsLXDgKFHzrI5oKyPQOc=
X-Google-Smtp-Source: APXvYqyieEw9mowf+3MX9BvaqVP7ku8d1VUCoxL8b8DXNybC34xxPpP+mjS8/n9tY/oRuOQEJ+9nf4mpgSdvOXL3C9E=
X-Received: by 2002:a63:2026:: with SMTP id g38mr72977845pgg.172.1563917068137;
 Tue, 23 Jul 2019 14:24:28 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:24:10 -0700
Message-Id: <20190723212418.36379-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH v3 1/2] x86/purgatory: do not use __builtin_memcpy and __builtin_memset
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Cc:     peterz@infradead.org, clang-built-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Alistair Delva <adelva@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        Uros Bizjak <ubizjak@gmail.com>,
        Chao Fan <fanc.fnst@cn.fujitsu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Implementing memcpy and memset in terms of __builtin_memcpy and
__builtin_memset is problematic.

GCC at -O2 will replace calls to the builtins with calls to memcpy and
memset (but will generate an inline implementation at -Os).  Clang will
replace the builtins with these calls regardless of optimization level.
$ llvm-objdump -dr arch/x86/purgatory/string.o | tail

0000000000000339 memcpy:
     339: 48 b8 00 00 00 00 00 00 00 00 movabsq $0, %rax
                000000000000033b:  R_X86_64_64  memcpy
     343: ff e0                         jmpq    *%rax

0000000000000345 memset:
     345: 48 b8 00 00 00 00 00 00 00 00 movabsq $0, %rax
                0000000000000347:  R_X86_64_64  memset
     34f: ff e0

Such code results in infinite recursion at runtime. This is observed
when doing kexec.

Instead, reuse an implementation from arch/x86/boot/compressed/string.c
if we define warn as a symbol. Also, Clang may lower memcmp's that
compare against 0 to bcmp's, so add a small definition, too. See also:
commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")

Cc: stable@vger.kernel.org
Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
Link: https://bugs.chromium.org/p/chromium/issues/detail?id=984056
Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Debugged-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Debugged-by: Manoj Gupta <manojgupta@google.com>
Suggested-by: Alistair Delva <adelva@google.com>
Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes v2 -> v3:
* Add bcmp implementation.
* Drop tested-by tag (Vaibhav will help retest).
* Cc stable
Changes v1 -> v2:
* Add Fixes tag.
* Move this patch to first in the series.

 arch/x86/boot/string.c         |  7 +++++++
 arch/x86/purgatory/Makefile    |  3 +++
 arch/x86/purgatory/purgatory.c |  6 ++++++
 arch/x86/purgatory/string.c    | 23 -----------------------
 4 files changed, 16 insertions(+), 23 deletions(-)
 delete mode 100644 arch/x86/purgatory/string.c

diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index 401e30ca0a75..4c364cf63432 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -37,6 +37,13 @@ int memcmp(const void *s1, const void *s2, size_t len)
 	return diff;
 }
 
+/*
+ * Clang may lower `memcmp == 0` to `bcmp == 0`.
+ */
+int bcmp(const void *s1, const void *s2, size_t len) {
+	return memcmp(s1, s2, len);
+}
+
 int strcmp(const char *str1, const char *str2)
 {
 	const unsigned char *s1 = (const unsigned char *)str1;
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 3cf302b26332..91ef244026d2 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -6,6 +6,9 @@ purgatory-y := purgatory.o stack.o setup-x86_$(BITS).o sha256.o entry64.o string
 targets += $(purgatory-y)
 PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
 
+$(obj)/string.o: $(srctree)/arch/x86/boot/compressed/string.c FORCE
+	$(call if_changed_rule,cc_o_c)
+
 $(obj)/sha256.o: $(srctree)/lib/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
diff --git a/arch/x86/purgatory/purgatory.c b/arch/x86/purgatory/purgatory.c
index 6d8d5a34c377..b607bda786f6 100644
--- a/arch/x86/purgatory/purgatory.c
+++ b/arch/x86/purgatory/purgatory.c
@@ -68,3 +68,9 @@ void purgatory(void)
 	}
 	copy_backup_region();
 }
+
+/*
+ * Defined in order to reuse memcpy() and memset() from
+ * arch/x86/boot/compressed/string.c
+ */
+void warn(const char *msg) {}
diff --git a/arch/x86/purgatory/string.c b/arch/x86/purgatory/string.c
deleted file mode 100644
index 01ad43873ad9..000000000000
--- a/arch/x86/purgatory/string.c
+++ /dev/null
@@ -1,23 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Simple string functions.
- *
- * Copyright (C) 2014 Red Hat Inc.
- *
- * Author:
- *       Vivek Goyal <vgoyal@redhat.com>
- */
-
-#include <linux/types.h>
-
-#include "../boot/string.c"
-
-void *memcpy(void *dst, const void *src, size_t len)
-{
-	return __builtin_memcpy(dst, src, len);
-}
-
-void *memset(void *dst, int c, size_t len)
-{
-	return __builtin_memset(dst, c, len);
-}
-- 
2.22.0.709.g102302147b-goog

