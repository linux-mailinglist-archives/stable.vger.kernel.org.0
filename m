Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908B880470
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 06:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfHCEtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 00:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfHCEtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 00:49:01 -0400
Received: from X1 (unknown [76.191.170.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6FE121726;
        Sat,  3 Aug 2019 04:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564807739;
        bh=diRa3/aj/2YHdw0FL1osj2u7iLHlHNttrP4kSyOc6+g=;
        h=Date:From:To:Subject:From;
        b=C13z1QJlJh10Uak6x4ZCLJAm8gy3a+GOW0TJA/jg6fhaYxO1uK4ygPr65cockMzIK
         YSPfiYEiMiKd/whLJN/2pelKwbFH3R8fJVsDk4IXOgqr/0iPm+Nuva59bVTdx9L5QQ
         XkmziAGD08owOJYhazyt2Y9aD8adUnj34N9P1yCg=
Date:   Fri, 02 Aug 2019 21:48:58 -0700
From:   akpm@linux-foundation.org
To:     willy@infradead.org, tglx@linutronix.de, stable@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org, keescook@chromium.org,
        jpoimboe@redhat.com, dvyukov@google.com, bp@alien8.de,
        aryabinin@virtuozzo.com, ard.biesheuvel@linaro.org,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/17] ubsan: build ubsan.c more conservatively
Message-ID: <20190803044858.fw_-j%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: ubsan: build ubsan.c more conservatively

objtool points out several conditions that it does not like, depending on
the combination with other configuration options and compiler variants:

stack protector:
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0xbf: call to __stack_chk_fail() with UACCESS enabled
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0xbe: call to __stack_chk_fail() with UACCESS enabled

stackleak plugin:
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x4a: call to stackleak_track_stack() with UACCESS enabled
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x4a: call to stackleak_track_stack() with UACCESS enabled

kasan:
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x25: call to memcpy() with UACCESS enabled
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x25: call to memcpy() with UACCESS enabled

The stackleak and kasan options just need to be disabled for this file as
we do for other files already.  For the stack protector, we already
attempt to disable it, but this fails on clang because the check is mixed
with the gcc specific -fno-conserve-stack option.  According to Andrey
Ryabinin, that option is not even needed, dropping it here fixes the
stackprotector issue.

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
---

 lib/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/Makefile~ubsan-build-ubsanc-more-conservatively
+++ a/lib/Makefile
@@ -279,7 +279,8 @@ obj-$(CONFIG_UCS2_STRING) += ucs2_string
 obj-$(CONFIG_UBSAN) += ubsan.o
 
 UBSAN_SANITIZE_ubsan.o := n
-CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
+KASAN_SANITIZE_ubsan.o := n
+CFLAGS_ubsan.o := $(call cc-option, -fno-stack-protector) $(DISABLE_STACKLEAK_PLUGIN)
 
 obj-$(CONFIG_SBITMAP) += sbitmap.o
 
_
