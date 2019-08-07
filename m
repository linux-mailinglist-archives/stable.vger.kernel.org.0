Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48E985599
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 00:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfHGWQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 18:16:06 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:39370 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729624AbfHGWQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 18:16:06 -0400
Received: by mail-vk1-f202.google.com with SMTP id d14so39715317vka.6
        for <stable@vger.kernel.org>; Wed, 07 Aug 2019 15:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BTH9OU52XeEKf7Mqa2TrpR96t0HPiKB7u1PceO9qGi4=;
        b=vy0xZl3mSShgz3JGBMwxgQuVZpsaYyR6IY25deU1dTWEhTr7xjVmDBky+8ZfdL1zHI
         J/+GO6boE6x0DYVbMS2zqMybhMsbHYwaUxA8FubywXajSke0u1fgmAZvZbC5P4HTbeDY
         dSJV4YQw8E9tuoI46QW0tjEqsxgVNo6Ok1UUnoVjs0SYceuXPHA6iAFviVXk8pugb177
         rpqVQz5TFKjDYEAAlRBQNkPLuAiwNzvLpEWsaRwt5xTuf4qoGFX2nZNfhhiy5DI1OSC3
         Il4Ys0t9SFbefq2GMTBlVnTdDevukPSA/8pmO2+MJT2EuwrQvY0nhe+hw7OZtdLIikj1
         +PmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BTH9OU52XeEKf7Mqa2TrpR96t0HPiKB7u1PceO9qGi4=;
        b=b9agXvt84erWsRGbE41JfWjS8HTenO2Q2qYMSkCXg1FS6aTZj40HYpqL1hPRLFgpr9
         r28gqeMKTm9tPKWSTabhAi71pPkFbEhzTXulwdxhp1AjrW1WD0/HEh+rhUlYSj3FxI/V
         tQehkcZeFQf4gM8rf4VCtLQEXvT0yBnM3q6y5Dne2bgZNwSv/0rZz4jkQd6Lu3cicqJT
         cD0vIgPebHcTlEleb3dG3yh/fjOahDu8G5EKi4lNkN+Q+bQESxgamrFdxmp4jw9CCNUU
         1KTZLvkZXYdMPCRBiCieDI04IJGjfXyzK50MrePaR5b8cHkITfAlRQ68u4eqgNpXxqsK
         jqUA==
X-Gm-Message-State: APjAAAUtPEy9uSumVTiIiJ3g1G4lN7KFhaqUyvB6zBX3VPjgRqO/RPWQ
        GIf/4DnN7DIZjSnWvYr3URXeGugWtwVHc8GiYCc=
X-Google-Smtp-Source: APXvYqzR8z+KGqg+WRpDl4EWzaLU33WHQIU38qoIdy22PA0lnaDsouGaMrm9eulxgGOpGqR3j1T1vLb0M3RYV5VFW7I=
X-Received: by 2002:ac5:c2d2:: with SMTP id i18mr4433043vkk.36.1565216164900;
 Wed, 07 Aug 2019 15:16:04 -0700 (PDT)
Date:   Wed,  7 Aug 2019 15:15:33 -0700
In-Reply-To: <20190807221539.94583-1-ndesaulniers@google.com>
Message-Id: <20190807221539.94583-2-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190807221539.94583-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH v5 2/2] x86/purgatory: use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS
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
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
---
Changes v4 -> v5:
* Add RETPOLINE_CFLAGS when CONFIG_RETPOLINE=y as per tglx.
* Add tglx's Suggested-by tag.
Changes v3 -> v4:
* Use tabs to align flags (stylistic change only).
* Drop stable tag, patch 01/02 doesn't apply earlier than 5.1.
* Add tglx's suggested by tag for the tabs.
* Carry Vaibhav's tested by tag from v3 since v4 is simply stylistic.
Changes v2 -> v3:
* Prefer $(CC_FLAGS_FTRACE) which is exported to -pg.
* Also check CONFIG_STACKPROTECTOR and CONFIG_STACKPROTECTOR_STRONG.
* Cc stable.
Changes v1 -> v2:
Rather than manually add -mno-sse, -mno-mmx, -mno-sse2, prefer to filter
-pg flags.

 arch/x86/purgatory/Makefile | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)
 arch/x86/purgatory/Makefile | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 91ef244026d2..8901a1f89cf5 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -20,11 +20,34 @@ KCOV_INSTRUMENT := n
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-# sure how to relocate those. Like kexec-tools, use custom flags.
-
-KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
-KBUILD_CFLAGS += -m$(BITS)
-KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
+# sure how to relocate those.
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_sha256.o		+= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_purgatory.o	+= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_string.o		+= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_kexec-purgatory.o	+= $(CC_FLAGS_FTRACE)
+endif
+
+ifdef CONFIG_STACKPROTECTOR
+CFLAGS_REMOVE_sha256.o		+= -fstack-protector
+CFLAGS_REMOVE_purgatory.o	+= -fstack-protector
+CFLAGS_REMOVE_string.o		+= -fstack-protector
+CFLAGS_REMOVE_kexec-purgatory.o	+= -fstack-protector
+endif
+
+ifdef CONFIG_STACKPROTECTOR_STRONG
+CFLAGS_REMOVE_sha256.o		+= -fstack-protector-strong
+CFLAGS_REMOVE_purgatory.o	+= -fstack-protector-strong
+CFLAGS_REMOVE_string.o		+= -fstack-protector-strong
+CFLAGS_REMOVE_kexec-purgatory.o	+= -fstack-protector-strong
+endif
+
+ifdef CONFIG_RETPOLINE
+CFLAGS_REMOVE_sha256.o		+= $(RETPOLINE_CFLAGS)
+CFLAGS_REMOVE_purgatory.o	+= $(RETPOLINE_CFLAGS)
+CFLAGS_REMOVE_string.o		+= $(RETPOLINE_CFLAGS)
+CFLAGS_REMOVE_kexec-purgatory.o	+= $(RETPOLINE_CFLAGS)
+endif
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
-- 
2.22.0.770.g0f2c4a37fd-goog

