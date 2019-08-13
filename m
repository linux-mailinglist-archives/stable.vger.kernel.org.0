Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6948C37E
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 23:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfHMVTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 17:19:42 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:46653 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfHMVTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 17:19:42 -0400
Received: by mail-vk1-f202.google.com with SMTP id j63so46068410vkc.13
        for <stable@vger.kernel.org>; Tue, 13 Aug 2019 14:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9ER49LkAApjAQ4CherwlnIMF0QHNLtrlUhDOwjnAQF4=;
        b=mA2bsJDIFA50wpeXtmasu3xbrZRfayHFzjPbpzQeVObMANrD3wsvvfgtmDi8hFDLqQ
         pDbcspSZyEIoCQ5gPpJsExfoq7NKl40/h0FvshvhZpPQyFXZJcUKD8UgBk8GtTt9DqsW
         hKOA0ZZ387zvJm1Qd5T3EcCg6H7gaexYmg3kyr+VWmv1vHif5k9Ha/UNiSLaWEF0If3Q
         Qx7ojbuDOGlRKVVOxZaUGCXSFxpFp5V9Biltc810bV5KaUQLomIuOUhDl0y6E89RhFko
         RAJBRPHI/h0V2RrcVfZYzHhHi1cJvpm7PEDMrzecFS6S2DIIrQshIX9lEvDTxVJ/shJH
         YhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9ER49LkAApjAQ4CherwlnIMF0QHNLtrlUhDOwjnAQF4=;
        b=JHuEbYPmhNbBW5Hwx7GEX7pmcSf0J0OPh37gYTzzk6nC/S2T5Muun1/6boPEf0tAyV
         0IiJeyoGAFjD2JavXtM7eOyxQfIh/ulOmNByFdW3Du8NAA1Qe5lqMc9dDPPxWENSda9j
         daQLyF5XPkNShM5ix5pPgLgpV/uyZtX5iwa9vmtX172w3jpe9VwI6Ak5xSD/4SmhxFuC
         vqTJmaN94d0jNqdlOK4g26NfMYpwUz/Pnet6RBazfWL6Ww3Bryv5ZSDEZjCfRuzi1/Oa
         doSPnUVqYtitcgSzib84549Sa0nIQc3ABM0jAFbcPz/0lPBSxwMnUBnV9SDuqi75mOxl
         ymLw==
X-Gm-Message-State: APjAAAXZS0qC0U2nsTDWoXFd1CXlvKjO7boHcotxOf9WKB0XcId/0pOg
        ctrFzATQqf3C5ZTYWbKJsMidL+MtWOFhCnFfw6s=
X-Google-Smtp-Source: APXvYqxYV43UWQcQhtPv2cyHZ1lpIF5yjC2CFCs01mn0xNb/TFXk3CQiXujFWpv9ekLzR/y26sAsJ1j8Gn1Lt+aQF3s=
X-Received: by 2002:a1f:9915:: with SMTP id b21mr10493141vke.69.1565731180599;
 Tue, 13 Aug 2019 14:19:40 -0700 (PDT)
Date:   Tue, 13 Aug 2019 14:19:30 -0700
In-Reply-To: <1565721608151140@kroah.com>
Message-Id: <20190813211930.42094-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <1565721608151140@kroah.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [4.19 PATCH] x86/purgatory: Do not use __builtin_memcpy and __builtin_memset
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     gregkh@linuxfoundation.org
Cc:     adelva@google.com, manojgupta@google.com, tglx@linutronix.de,
        vaibhavrustagi@google.com, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4ce97317f41d38584fb93578e922fcd19e535f5b upstream.

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

Instead, reuse an implementation from arch/x86/boot/compressed/string.c.
This requires to implement a stub function for warn(). Also, Clang may
lower memcmp's that compare against 0 to bcmp's, so add a small definition,
too. See also: commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")

Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Debugged-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Debugged-by: Manoj Gupta <manojgupta@google.com>
Suggested-by: Alistair Delva <adelva@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc: stable@vger.kernel.org
Link: https://bugs.chromium.org/p/chromium/issues/detail?id=984056
Link: https://lkml.kernel.org/r/20190807221539.94583-1-ndesaulniers@google.com
---
This failed to cherry-pick back cleanly due to the SPDX license
identifier not existing in arch/x86/purgatory/string.c in 4.19. `git rm`
it anyway.


 arch/x86/boot/string.c         |  8 ++++++++
 arch/x86/purgatory/Makefile    |  3 +++
 arch/x86/purgatory/purgatory.c |  6 ++++++
 arch/x86/purgatory/string.c    | 25 -------------------------
 4 files changed, 17 insertions(+), 25 deletions(-)
 delete mode 100644 arch/x86/purgatory/string.c

diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index c4428a176973..2622c0742c92 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -34,6 +34,14 @@ int memcmp(const void *s1, const void *s2, size_t len)
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
index 025c34ac0d84..7971f7a8af59 100644
--- a/arch/x86/purgatory/purgatory.c
+++ b/arch/x86/purgatory/purgatory.c
@@ -70,3 +70,9 @@ void purgatory(void)
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
index 795ca4f2cb3c..000000000000
--- a/arch/x86/purgatory/string.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Simple string functions.
- *
- * Copyright (C) 2014 Red Hat Inc.
- *
- * Author:
- *       Vivek Goyal <vgoyal@redhat.com>
- *
- * This source code is licensed under the GNU General Public License,
- * Version 2.  See the file COPYING for more details.
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
2.23.0.rc1.153.gdeed80330f-goog

