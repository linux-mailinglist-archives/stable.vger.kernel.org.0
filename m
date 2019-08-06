Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1334A83A07
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 22:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfHFUHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 16:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfHFUHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 16:07:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF50F216F4;
        Tue,  6 Aug 2019 20:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565122049;
        bh=sy+cMgHPkc2RH0vGYwWv3/9L5clHN0NjHOn8WXyiA+A=;
        h=Date:From:To:Subject:From;
        b=XqbUDqssiNj5zKPlnIv1QEz3A/lYslE5bXdMsQKV4aX+URNMUL3G3MPKYJq1atjLi
         Po9jOPfK2VXM2yP4k64LftN+8bRBYxks7JPIugujX+I/X3uveyW2D4riqX8LAGxz3Q
         Ny+7K6xkXIN5Ei+zo82Zb2cW+3YXrBNzEFx+noHw=
Date:   Tue, 06 Aug 2019 13:07:28 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ard.biesheuvel@linaro.org,
        arnd@arndb.de, aryabinin@virtuozzo.com, bp@alien8.de,
        dvyukov@google.com, jpoimboe@redhat.com, keescook@chromium.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org,
        stable@vger.kernel.org, tglx@linutronix.de, willy@infradead.org
Subject:  [merged] ubsan-build-ubsanc-more-conservatively.patch
 removed from -mm tree
Message-ID: <20190806200728.2EVPsVmkC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ubsan: build ubsan.c more conservatively
has been removed from the -mm tree.  Its filename was
     ubsan-build-ubsanc-more-conservatively.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from arnd@arndb.de are

mm-sparse-fix-memory-leak-of-sparsemap_buf-in-aliged-memory-fix.patch

