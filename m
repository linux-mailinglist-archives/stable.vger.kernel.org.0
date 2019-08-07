Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B12285598
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 00:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbfHGWP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 18:15:59 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:52929 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfHGWP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 18:15:59 -0400
Received: by mail-vs1-f73.google.com with SMTP id g189so23488787vsc.19
        for <stable@vger.kernel.org>; Wed, 07 Aug 2019 15:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=O7ZtR6QD4RFJAye0JbMOqjbvPAFE8alBTupXCiubdkM=;
        b=L0jfbkWlYSycFtmRuN6qqndAzaKahqkihHir07QALKvEDvcBYpFwYQSrhKZF1rmog8
         hqDPJkgxiKgXnd7P9tk4+s2/SaCu+ymqgypyS/OMVD+v7Qj1at0KMqLXX6bYeOpsb2pu
         WXGnll0nWDJfzQT1g4H12gJN5XXq44d37mydS2UejLL8/8IkdiWTMq4GSIhE8whGACEJ
         37DXPbWLXeLpJLrlJFao6oGjEkYqBPDxHs+1B0kuUGgHTLKvTjNVhT8PZKqDc3gnazmG
         3apGES28G+ZT8B6h6W7lT6F+RzBmcDj5JZS7NseQJJMdGsjjwWd4X6iFSEVizyQszSQo
         eqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=O7ZtR6QD4RFJAye0JbMOqjbvPAFE8alBTupXCiubdkM=;
        b=b3AaoJyOoU/JR7rAEKhNWHryM4MHCZ+btE13aQ06VL8CE/aRmDrw8Rfd0OjJFQh8TQ
         KiZeDKXML2EFmrZiKZ1Ipeqs/E9h/ABe4WmsXAgFswEWG99jmTynoHgjMOyPAYff/qui
         C/i1wXdKfj/Esy5KiEM5Vm7YWLmMSZPCffXp2yXWuTo1cldhtpJoHuN2HmHVvL4wtXxJ
         0O0KfL87cBB6qMxJNbo+9JlMl/yvBYDd0xPvy+QwiGBf1HIaw0F/QLjyFGPdFe8zs6Ad
         yx2WRx+gcWXHC5buJAACDjczNQ4x7TCemMJ0DFj3CEFxu31BQL1z1hs4j9DKHlV1rc0q
         CSKQ==
X-Gm-Message-State: APjAAAV9LAN+eEor9IrRJNVDj1/oztQ+0bA4qlMDJuumuQi8Eq9O3Giy
        jqZQW7G9F/w4y3SsQxeDriJwLRD40XIRl6hDox0=
X-Google-Smtp-Source: APXvYqywDFMQACwNummna2W5lngZ8TWSRZDP3DgeAn65iG+ZLQ7yHCnE3p5vk5Q0g/0U4hA+d0Wwo/Rjg7vD1U6fkCU=
X-Received: by 2002:a1f:5945:: with SMTP id n66mr4514236vkb.58.1565216157744;
 Wed, 07 Aug 2019 15:15:57 -0700 (PDT)
Date:   Wed,  7 Aug 2019 15:15:32 -0700
Message-Id: <20190807221539.94583-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH v5 1/2] x86/purgatory: do not use __builtin_memcpy and __builtin_memset
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
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
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
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
---
Changes v4 -> v5:
* None
Changes v3 -> v4:
* (style) open brace on newline
* drop Vaibhav's SOB tag that was accidentally copy+pasta'd from v1.
* Carry Vaibhav's tested by tag from v3 since v4 is strictly stylistic
  change from v3.
* Drop cc'ing stable. Sasha's bot reports v1 doesn't cherry pick cleanly
  5.1, so this series will require manual backports.
Changes v2 -> v3:
* Add bcmp implementation.
* Drop tested-by tag (Vaibhav will help retest).
* Cc stable
Changes v1 -> v2:
* Add Fixes tag.
* Move this patch to first in the series.

 arch/x86/boot/string.c         |  8 ++++++++
 arch/x86/purgatory/Makefile    |  3 +++
 arch/x86/purgatory/purgatory.c |  6 ++++++
 arch/x86/purgatory/string.c    | 23 -----------------------
 4 files changed, 17 insertions(+), 23 deletions(-)
 delete mode 100644 arch/x86/purgatory/string.c

diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index 401e30ca0a75..8272a4492844 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -37,6 +37,14 @@ int memcmp(const void *s1, const void *s2, size_t len)
 	return diff;
 }
 
+/*
+ * Clang may lower `memcmp == 0` to `bcmp == 0`.
+ */
+int bcmp(const void *s1, const void *s2, size_t len)
+{
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
2.22.0.770.g0f2c4a37fd-goog

