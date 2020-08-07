Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E682723F327
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 21:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgHGTlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 15:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGTlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 15:41:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F191C061757
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 12:41:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a5so4015958ybh.3
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 12:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5n0w4AsANVZZcp3jIgW7OYwnXyM3bWVVuSXkfYvbUl4=;
        b=WoKT11jR5jq/vQb3JNLV25H6iflkXWudcxfP6rTqgMokNc8wuvhdV871BhnFNvsvhq
         qcUCcS3CyBMPMYSk00SqeMIFCim9HusgHp5n9bI/UVP4PKlenKWo5Ow+d98zN6ESLN1f
         ptGrXZMrKbm7sc+l+aI760IdJO+JrbC+N6J3qHbTqNd2vv/Erj9AoVGphW45V7pA0bYC
         ROFWsOCvNbBWZ5KmrSJK005wiXxh4RRVcqE1W6A7RN4OanMO/fF5ZnNW3fUOKEd0ZrPw
         db/osdd+sp9woxBRA+k9CuwBske9+y1Hbj7J0mB2Le4sNL5evawsrlaGNWRZQtsx6JVp
         r1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5n0w4AsANVZZcp3jIgW7OYwnXyM3bWVVuSXkfYvbUl4=;
        b=jQZ4fPw/Ap9HuGdzAvJHRh+1eQH3NgvXwmlVHGMw3boySzb8CyglsWRt0ZPzroihfb
         Az8ePihjompwLOgTP093CP2xu2ty5MGfCsTs64g/H3sfvfbX/aLwFtZSbywMkeuaq7D4
         e3Z+iTImBo0lwwuRB3v8U8/zm0gtvUYqT0hGoo+KVxxMLkP5Z6hCtLhzVZZxPu8qZe7A
         oGta5PkWaaSQPrl5huCVrvJttJZjTjC8EzwVl7vBPdaWOXXSuUTqKLwiyVJMA/dTtyly
         B75cjVvAfU3aVSp9msj3aGK+6j8bHvmmv2Y9GdICj3DyS1kHhVuVBwN/7vXVzm3oq4Pn
         W+Yg==
X-Gm-Message-State: AOAM530R5lg2uVsx7I0Pma0bGeO/7MIw+YLDxRmVt6z8G7tDr3AIt1/V
        ZJf/blZTJwCni5xGtTFzA/hNp+ww5cGYzLJz2vo=
X-Google-Smtp-Source: ABdhPJzHB9j8QRSntH63NyIOH3Co/ruEv4R6/7xZwQZKx/N+UI6YkVvblAovxmcitH8ymcMlGDm584LWnU0RrQFQP18=
X-Received: by 2002:a25:d8c3:: with SMTP id p186mr24793342ybg.50.1596829273517;
 Fri, 07 Aug 2020 12:41:13 -0700 (PDT)
Date:   Fri,  7 Aug 2020 12:41:00 -0700
Message-Id: <20200807194100.3570838-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH] x86/boot: avoid relaxable symbols with Clang
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     Fangrui Song <maskray@google.com>,
        clang-built-linux@googlegroups.com, e5ten.arch@gmail.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dmitry Golovin <dima@golovin.in>,
        Marco Elver <elver@google.com>, Nick Terrell <terrelln@fb.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent change to a default value of configuration variable
(ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
relocations. LLD will relax instructions with these relocations based on
whether the image is being linked as position independent or not.  When
not, then LLD will relax these instructions to use absolute addressing
mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with Clang
and linked with LLD to fail to boot.

Also, the LLVM commit notes that these relocation types aren't supported
until binutils 2.26. Since we support binutils 2.23+, avoid the
relocations regardless of linker.

The proper solution is to build the compressed boot image as position
independent.  There's a series working its way through code review
currently that does that, but it's unlikely to be backported to stable,
due to its size.  For now, cut a smaller patch that's more likely to be
easily picked up into stable, so that we can get our kernels booting
again.

Cc: stable@vger.kernel.org # 4.14.y
Link: https://github.com/ClangBuiltLinux/linux/issues/1121
Link: https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
Link: https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/builds/178868465
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
https://lore.kernel.org/lkml/20200731230820.1742553-7-keescook@chromium.org/
is the patch I'm hopeful for building the compressed image as -pie, but
I don't think the series will be backported. Regardless, we probably
want this for older binutils support.

 arch/x86/boot/compressed/Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 3962f592633d..ab0f7e7dabf9 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -44,6 +44,13 @@ KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS += -D__DISABLE_EXPORTS
 
+# Until we can build arch/x86/boot/compressed/vmlinux as -Wl,-pie, don't emit
+# R_X86_64_GOTPCRELX or R_X86_64_REX_GOTPCRELX relocations that LLD will relax
+# into absolute addressed operands, and that BFD didn't support until 2.26.
+ifdef CONFIG_CC_IS_CLANG
+KBUILD_CFLAGS += -Wa,-mrelax-relocations=no
+endif
+
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
 UBSAN_SANITIZE :=n
-- 
2.28.0.236.gb10cc79966-goog

