Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403138DB01
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbfHNRJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730273AbfHNRJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2628A2084D;
        Wed, 14 Aug 2019 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802546;
        bh=667TcVdpDhNaEjohdrqBizGLS8ipZ7Vkf9Lqs08EpV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icz3PmbBtiESRc4TuO4TBVG+MRvlO42h9DvR1pnQnhSExArciciRf+/d03EC2vsNO
         8Bb/55QRHAG/8zPGUn6v36npv1GaKMDHQSOVaT/h7EOJnNUXOdm8WcAz+NtcmFc2b/
         IGCbevT+K1ux2ZBi63XPscXCU/s+njNOUfoE58jQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 23/91] x86/purgatory: Use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS
Date:   Wed, 14 Aug 2019 19:00:46 +0200
Message-Id: <20190814165750.700710357@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
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
@@ -17,11 +17,34 @@ KCOV_INSTRUMENT := n
 
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


