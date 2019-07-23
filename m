Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9300C7216E
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 23:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392021AbfGWVYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 17:24:38 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:51621 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfGWVYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 17:24:38 -0400
Received: by mail-qt1-f202.google.com with SMTP id m25so39434064qtn.18
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 14:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4zjV4XfUufy/ohN9fql/K25fvrQNe19KfVusxa+S+OU=;
        b=QEi55mfOxuFlP7kIfXPSbx+dxygSE6PsdAiu65v918SBDWisH1ZBMm90Vl7G99tLuN
         J50g5a0gyaMPwnKLu8iWiKON3mpzo14Pgth183t3W8QRPD7YdrkhbHZ2SJO/uSTOEMTK
         aVPQhc6fKnNyXR+nZi6HXg4HIUY1jQMGknaUmpuuoUY/aDaKD9Ywl6SY6HF45XbMwYC9
         YuxBpInkQqH9Q6hCm4VEOMZt51s0SVyjDaMp50h/EoClzSvT8p/iRCTRwL4ssQOWKOnv
         hXO8LpAXeOU2OHvHZNG/xxbn8mgeJhDUzIi/q1BaKDSSeMDgzHuSrk/qXJzWysUXK6YL
         gGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4zjV4XfUufy/ohN9fql/K25fvrQNe19KfVusxa+S+OU=;
        b=AnpDzaCtenXj0J8gBhyT/uEJ3fdnKdM7ic+h52TjG9SxhgqbTq/DwYRoEsGid8b9CZ
         Sa8Kr4VQmtnB4494ggnyg8Y4SX/mJ+FapzzyvqAqKV5OMrKEbvitXB3pIYFcs+mJnq25
         pRQv8w40sbkp07g2XK+oVjR7To9FA4UKc6FAp+IMRIjTbVx0Xk3PGlO6HhA7u/SgXh09
         kkXAwXVH2DyHMVGIRhyOg3fHHa70pljT6zHChKJLgIyE90j9h1wwyv9dcssZKetP2ho8
         rLxGr8a8XTbdnqmc2+L4i5m4cKmSGeM7hMxA9be4vJ8LisJU7zfWTsTZvtJbqWBbXEsu
         r4Pw==
X-Gm-Message-State: APjAAAWlVUy/OBx74Q9OzdRxgrGkx3ozYXnuLMDJ0MywfuZQ3NyccXo2
        XqQYoTtNE8hO1XbzhMyYNYgBy3+157uiL4McYxs=
X-Google-Smtp-Source: APXvYqwEFc5UTGb/nQzWjw3v4tcOhLCiPXWZR7THRGiuou5L5GbAOaQxUqx9H+AvSHqenhot05Wrakvh5MYJrZsGJCM=
X-Received: by 2002:a05:620a:10bc:: with SMTP id h28mr51387214qkk.289.1563917077378;
 Tue, 23 Jul 2019 14:24:37 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:24:11 -0700
In-Reply-To: <20190723212418.36379-1-ndesaulniers@google.com>
Message-Id: <20190723212418.36379-2-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190723212418.36379-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH v3 2/2] x86/purgatory: use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Cc:     peterz@infradead.org, clang-built-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KBUILD_CFLAGS is very carefully built up in the top level Makefile,
particularly when cross compiling or using different build tools.
Resetting KBUILD_CFLAGS via := assignment is an antipattern.

The comment above the reset mentions that -pg is problematic.  Other
Makefiles use `CFLAGS_REMOVE_file.o = $(CC_FLAGS_FTRACE)` when
CONFIG_FUNCTION_TRACER is set. Prefer that pattern to wiping out all of
the important KBUILD_CFLAGS then manually having to re-add them. Seems
also that __stack_chk_fail references are generated when using
CONFIG_STACKPROTECTOR or CONFIG_STACKPROTECTOR_STRONG.

Cc: stable@vger.kernel.org
Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Alternatively, we could put these in all in one variable and remove it
without any conditional checks (I think that's ok to do so with
CFLAGS_REMOVE).

Changes v2 -> v3:
* Prefer $(CC_FLAGS_FTRACE) which is exported to -pg.
* Also check CONFIG_STACKPROTECTOR and CONFIG_STACKPROTECTOR_STRONG.
* Cc stable.
Changes v1 -> v2:
Rather than manually add -mno-sse, -mno-mmx, -mno-sse2, prefer to filter
-pg flags.

 arch/x86/purgatory/Makefile | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 91ef244026d2..6ef0ced59b9c 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -20,11 +20,27 @@ KCOV_INSTRUMENT := n
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-# sure how to relocate those. Like kexec-tools, use custom flags.
-
-KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
-KBUILD_CFLAGS += -m$(BITS)
-KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
+# sure how to relocate those.
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_sha256.o += $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_purgatory.o += $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_string.o += $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_kexec-purgatory.o += $(CC_FLAGS_FTRACE)
+endif
+
+ifdef CONFIG_STACKPROTECTOR
+CFLAGS_REMOVE_sha256.o += -fstack-protector
+CFLAGS_REMOVE_purgatory.o += -fstack-protector
+CFLAGS_REMOVE_string.o += -fstack-protector
+CFLAGS_REMOVE_kexec-purgatory.o += -fstack-protector
+endif
+
+ifdef CONFIG_STACKPROTECTOR_STRONG
+CFLAGS_REMOVE_sha256.o += -fstack-protector-strong
+CFLAGS_REMOVE_purgatory.o += -fstack-protector-strong
+CFLAGS_REMOVE_string.o += -fstack-protector-strong
+CFLAGS_REMOVE_kexec-purgatory.o += -fstack-protector-strong
+endif
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
-- 
2.22.0.709.g102302147b-goog

