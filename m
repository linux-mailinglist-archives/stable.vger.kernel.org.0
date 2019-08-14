Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409C48DB9D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfHNREc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729235AbfHNREc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20101216F4;
        Wed, 14 Aug 2019 17:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802271;
        bh=EmXnNYRrjXkAFuyAfp9FKE1t/lNadDL0hVpRJKH24Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJB7rlitwAj3iPCfF79wjRWHPFUjCH6NzmUL4Y9YWWPZ0H6nP+UyVB9YmRW5MhLa1
         x7+k3p8xkMpgFWMy6FY26K5qoIlm656koesgzUxEwmOaKDUgibJX9elktKUJG72PF6
         lgqbdlsG3SZqPe07hcHmTnM+lgDUP4wThQFFygtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.2 035/144] x86/purgatory: Use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS
Date:   Wed, 14 Aug 2019 18:59:51 +0200
Message-Id: <20190814165801.293530827@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit b059f801a937d164e03b33c1848bb3dca67c0b04 upstream.

KBUILD_CFLAGS is very carefully built up in the top level Makefile,
particularly when cross compiling or using different build tools.
Resetting KBUILD_CFLAGS via := assignment is an antipattern.

The comment above the reset mentions that -pg is problematic.  Other
Makefiles use `CFLAGS_REMOVE_file.o = $(CC_FLAGS_FTRACE)` when
CONFIG_FUNCTION_TRACER is set. Prefer that pattern to wiping out all of
the important KBUILD_CFLAGS then manually having to re-add them. Seems
also that __stack_chk_fail references are generated when using
CONFIG_STACKPROTECTOR or CONFIG_STACKPROTECTOR_STRONG.

Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190807221539.94583-2-ndesaulniers@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/purgatory/Makefile |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -20,11 +20,34 @@ KCOV_INSTRUMENT := n
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-# sure how to relocate those. Like kexec-tools, use custom flags.
+# sure how to relocate those.
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_sha256.o		+= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_purgatory.o	+= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_string.o		+= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_kexec-purgatory.o	+= $(CC_FLAGS_FTRACE)
+endif
 
-KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
-KBUILD_CFLAGS += -m$(BITS)
-KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
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


