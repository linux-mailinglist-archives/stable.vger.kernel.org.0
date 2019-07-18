Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBEB86C3BB
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 02:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfGRACx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 20:02:53 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:37498 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfGRACx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 20:02:53 -0400
Received: by mail-pl1-f201.google.com with SMTP id n4so12408935plp.4
        for <stable@vger.kernel.org>; Wed, 17 Jul 2019 17:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=L/78IskbmRc+SAnYRdHcj67j75qZnnMK6y2VOBnfvrk=;
        b=S8Yba5KmalqdPks1VNH9Uyedt6+Y0i8sR5GaZllNlSzySnf0g7KcoIn18+QvPtf/WD
         MM5Mg0oIBJuvXHnYUYYmRhp8YmbmiRc8jWCfu+WjoGaWtBjA7HVQcBvT9p8RTOVA2CHA
         TrQMZkRmwvtTgWXBQP9clKU1DLLCKnxp8Wdb6CGLX+c9GN0KFiEX6dM5dDTUEfh1PhY/
         mcJpXHhxb0jFOlv4MFKCbUnDNhzPhM9oqsPzNzcAwZX4aGB5Xz3Vym6xL34fBePCXP1e
         6/Z0Ppls3PoFbzBk1QA6O924jzTypnc7pko3pScKOISaEdoQ1VhUb3HR6nqMZQ0/TikG
         g/EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=L/78IskbmRc+SAnYRdHcj67j75qZnnMK6y2VOBnfvrk=;
        b=rkMVD82PfeBQ10Xu7dBDjzWWKBq8hEOInHFEH64AAsSdQqc8Ayerbnyo5ShdetVr9c
         4GqCBoIsjttl0MT9TUBj0WWlQ01uHwwX2EqUQhcjslc/htHT/7OB8X25nwDgJSnd/OEl
         EWDJhuS7Bg2SKSpAzdAq8QrFGkvH1ZJp+cfVp56Urc043ry736RdRp6qu9xK0imXPWan
         B0eWaG+BoEy95SolAaqSywdY5ff4LXLJ2VDUm+yD/DCIocq1Lx0OWVWxhixu02L4Pxqb
         QIEF4XGZTLCPasifhfzzDLNhUADJBxjBZQmNcwYomtDXeq5cz6DuvwpRaZkjp+0QZ52z
         LjJQ==
X-Gm-Message-State: APjAAAWIS2CbKqIF9iyCKrKRdVfN+Px6iR84tvW0cCo3dW5uXr5HFevK
        izvERuCm+RNAny6g0Jux74BripxdgGEBQ9K94RPXrg==
X-Google-Smtp-Source: APXvYqwVE0HkM/l3O7QFSf8aW9eANsYMwJv8OSxTZYlAHNH9xFe7SxqEaIpQv935uuZ5aOz9IdAbsGGTjA1FKAfLQdzgfQ==
X-Received: by 2002:a63:714a:: with SMTP id b10mr9682287pgn.25.1563408172263;
 Wed, 17 Jul 2019 17:02:52 -0700 (PDT)
Date:   Wed, 17 Jul 2019 17:02:06 -0700
In-Reply-To: <20190718000206.121392-1-vaibhavrustagi@google.com>
Message-Id: <20190718000206.121392-3-vaibhavrustagi@google.com>
Mime-Version: 1.0
References: <20190718000206.121392-1-vaibhavrustagi@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
Subject: [PATCH 2/2] x86/purgatory: do not use __builtin_memcpy and __builtin_memset.
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Manoj Gupta <manojgupta@google.com>,
        Alistair Delva <adelva@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

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
if we define warn as a symbol.

Link: https://bugs.chromium.org/p/chromium/issues/detail?id=984056
Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Debugged-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Debugged-by: Manoj Gupta <manojgupta@google.com>
Suggested-by: Alistair Delva <adelva@google.com>
Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/x86/purgatory/Makefile    |  3 +++
 arch/x86/purgatory/purgatory.c |  6 ++++++
 arch/x86/purgatory/string.c    | 23 -----------------------
 3 files changed, 9 insertions(+), 23 deletions(-)
 delete mode 100644 arch/x86/purgatory/string.c

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 3589ec4a28c7..84b8314ddb2d 100644
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
2.22.0.510.g264f2c817a-goog

