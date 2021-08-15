Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D3D3ECBB4
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 00:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhHOWzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 18:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhHOWzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 18:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC7B060EB5;
        Sun, 15 Aug 2021 22:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629068084;
        bh=bg7sHPn3XavG4VHjw1wDZ4Saf6f5mojVM5bMo81MVGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qkpk1r5lqodV+9wUpnu1RXibKieJ/uvtUg+2V62LO6isxWonMDzxJSYOpQ1d2/WP0
         zkHSjxeERyY0VBNn3yK4FvkX1hvOwab8g75UuxcQxpUr5ALuE1oZfn3jmKSal3MDAK
         wfCgioPKR9wrDHDVRGdM0wHBERJuxoKoI0xh3ZaMNk2Xq2KK2bxiBNES8ifInZarb0
         HbiFijUv5FKhQu/G6xrl8Vzk4xOOGgW2MjnmCXPu0zYhAGMDSb3XG3Yu/teQR1+x1A
         ZQxkVqp0bKSdssy0tleBIwgit33Tcuo1eVBtoAmePErv4ABr7/WTdGcHV7HfnlLgSr
         vK/uGVTAjugoA==
Date:   Sun, 15 Aug 2021 15:54:39 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     elver@google.com, keescook@chromium.org, maskray@google.com,
        ndesaulniers@google.com, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, sashal@kernel.org
Subject: Re: Patch "vmlinux.lds.h: Handle clang's module.{c,d}tor sections"
 has been added to the 5.13-stable tree
Message-ID: <YRmbLz1ZivIMKgc5@archlinux-ax161>
References: <16290320662366@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ExCZztx91pGMwpEA"
Content-Disposition: inline
In-Reply-To: <16290320662366@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ExCZztx91pGMwpEA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Aug 15, 2021 at 02:54:26PM +0200, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     vmlinux.lds.h: Handle clang's module.{c,d}tor sections
> 
> to the 5.13-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      vmlinux.lds.h-handle-clang-s-module.-c-d-tor-sections.patch
> and it can be found in the queue-5.13 subdirectory.

Attached are backports for 4.4 to 5.10. I am not sure if anyone is
actually using KASAN with clang on 4.4 (ChromeOS maybe?) but it does not
hurt to have it just in case.

I did not get any emails that the patch failed to apply on the older
versions, I assume this is because I did just a "Cc: stable@vger.kernel.org"
without any version or fixes tag. Is there any "official" way to notate
that I want a particular patch applied to all supported kernel versions
aside from adding "# v4.4+" to the Cc tag so that I can provide manual
backports for those versions?

Cheers,
Nathan

--ExCZztx91pGMwpEA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="4.4-4.14-848378812e401.patch"

From fd073a15e9941b70d0db84d28d539cf3535e1b59 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 30 Jul 2021 19:31:08 -0700
Subject: [PATCH 4.4 to 4.14] vmlinux.lds.h: Handle clang's module.{c,d}tor
 sections

commit 848378812e40152abe9b9baf58ce2004f76fb988 upstream.

A recent change in LLVM causes module_{c,d}tor sections to appear when
CONFIG_K{A,C}SAN are enabled, which results in orphan section warnings
because these are not handled anywhere:

ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_ctor) is being placed in '.text.asan.module_ctor'
ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_dtor) is being placed in '.text.asan.module_dtor'
ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.tsan.module_ctor) is being placed in '.text.tsan.module_ctor'

Fangrui explains: "the function asan.module_ctor has the SHF_GNU_RETAIN
flag, so it is in a separate section even with -fno-function-sections
(default)".

Place them in the TEXT_TEXT section so that these technologies continue
to work with the newer compiler versions. All of the KASAN and KCSAN
KUnit tests continue to pass after this change.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1432
Link: https://github.com/llvm/llvm-project/commit/7b789562244ee941b7bf2cefeb3fc08a59a01865
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210731023107.1932981-1-nathan@kernel.org
[nc: Fix conflicts due to lack of cf68fffb66d60 and 266ff2a8f51f0]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c9790b2cdf34..45fe7295051f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -465,6 +465,7 @@
 		*(.text.unknown .text.unknown.*)			\
 		*(.text..refcount)					\
 		*(.ref.text)						\
+		*(.text.asan.* .text.tsan.*)				\
 	MEM_KEEP(init.text)						\
 	MEM_KEEP(exit.text)						\
 

base-commit: 162b95d01320370b80cb2d5724cea4ae538ac740
-- 
2.33.0.rc2


--ExCZztx91pGMwpEA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="4.19-5.10-848378812e401.patch"

From 07154ab1ed7ce98f9418421152753e1bc8029829 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 30 Jul 2021 19:31:08 -0700
Subject: [PATCH 4.19 to 5.10] vmlinux.lds.h: Handle clang's module.{c,d}tor
 sections

commit 848378812e40152abe9b9baf58ce2004f76fb988 upstream.

A recent change in LLVM causes module_{c,d}tor sections to appear when
CONFIG_K{A,C}SAN are enabled, which results in orphan section warnings
because these are not handled anywhere:

ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_ctor) is being placed in '.text.asan.module_ctor'
ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_dtor) is being placed in '.text.asan.module_dtor'
ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.tsan.module_ctor) is being placed in '.text.tsan.module_ctor'

Fangrui explains: "the function asan.module_ctor has the SHF_GNU_RETAIN
flag, so it is in a separate section even with -fno-function-sections
(default)".

Place them in the TEXT_TEXT section so that these technologies continue
to work with the newer compiler versions. All of the KASAN and KCSAN
KUnit tests continue to pass after this change.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1432
Link: https://github.com/llvm/llvm-project/commit/7b789562244ee941b7bf2cefeb3fc08a59a01865
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210731023107.1932981-1-nathan@kernel.org
[nc: Resolve conflict due to lack of cf68fffb66d60]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 18468b46c450..a774361f28d4 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -599,6 +599,7 @@
 		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
+		*(.text.asan.* .text.tsan.*)				\
 	MEM_KEEP(init.text*)						\
 	MEM_KEEP(exit.text*)						\
 

base-commit: 5805e5eec901e830c7741d4916270d0b9cfd6743
-- 
2.33.0.rc2


--ExCZztx91pGMwpEA--
