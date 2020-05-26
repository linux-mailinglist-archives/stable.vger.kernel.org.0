Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF731E2EB2
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389452AbgEZTbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389843AbgEZS7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA9C2084C;
        Tue, 26 May 2020 18:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519563;
        bh=6PeqxmiV1MiN/fs54FhFk/6krLO8JfdqfaCb9/lsmHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8hfWdsHXZbiVl7scwZ6ukY6C5cIh6Scf31RzxDy4sUCoXJX909OyefGZx4Z6QQFs
         n2blSnlOhgV7imGtKLZRiFaZLaPmHF05dLqXoRzHZRO3EdMHAsxTISdfYJwHiWieNV
         itMbE1oWs9roezEfVlwhivMdxsoCodwxja9fcBfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 53/64] ubsan: build ubsan.c more conservatively
Date:   Tue, 26 May 2020 20:53:22 +0200
Message-Id: <20200526183930.759269921@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit af700eaed0564d5d3963a7a51cb0843629d7fe3d upstream.

objtool points out several conditions that it does not like, depending
on the combination with other configuration options and compiler
variants:

stack protector:
  lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0xbf: call to __stack_chk_fail() with UACCESS enabled
  lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0xbe: call to __stack_chk_fail() with UACCESS enabled

stackleak plugin:
  lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x4a: call to stackleak_track_stack() with UACCESS enabled
  lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x4a: call to stackleak_track_stack() with UACCESS enabled

kasan:
  lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x25: call to memcpy() with UACCESS enabled
  lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x25: call to memcpy() with UACCESS enabled

The stackleak and kasan options just need to be disabled for this file
as we do for other files already.  For the stack protector, we already
attempt to disable it, but this fails on clang because the check is
mixed with the gcc specific -fno-conserve-stack option.  According to
Andrey Ryabinin, that option is not even needed, dropping it here fixes
the stackprotector issue.

Link: http://lkml.kernel.org/r/20190722125139.1335385-1-arnd@arndb.de
Link: https://lore.kernel.org/lkml/20190617123109.667090-1-arnd@arndb.de/t/
Link: https://lore.kernel.org/lkml/20190722091050.2188664-1-arnd@arndb.de/t/
Fixes: d08965a27e84 ("x86/uaccess, ubsan: Fix UBSAN vs. SMAP")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/Makefile
+++ b/lib/Makefile
@@ -230,6 +230,7 @@ obj-$(CONFIG_UCS2_STRING) += ucs2_string
 obj-$(CONFIG_UBSAN) += ubsan.o
 
 UBSAN_SANITIZE_ubsan.o := n
-CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
+KASAN_SANITIZE_ubsan.o := n
+CFLAGS_ubsan.o := $(call cc-option, -fno-stack-protector) $(DISABLE_STACKLEAK_PLUGIN)
 
 obj-$(CONFIG_SBITMAP) += sbitmap.o


