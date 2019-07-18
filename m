Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F746D6AF
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 23:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfGRV5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 17:57:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34083 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfGRV5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 17:57:08 -0400
Received: by mail-pl1-f194.google.com with SMTP id i2so14565826plt.1
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 14:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9NQWIYIb3zofiCzg+GVgOIJ0wwu6tmW9/oeA0AthTQA=;
        b=Jdap8+4mcc3eFAOhQHwxZ5WXvdobqWzQDiAYdXC9xE+6DY8wMTmtxIYIX6PMcDexwI
         SckVNHUILX5YBmoNozTcGrdglFtkAzj2NaxaTF8EJ2v3j6Kmuf8m8th7RhZoRpy4fNnQ
         ApbPJGMUBCS/HP7I+h9Ej7t86Q21bE3HXLrCkT4Tc4pPM/I3BtJ86xldJhRFKuPvywni
         rAFQFF2ShNJpwiQGr5LbDLhuuxtj+KFhBgqWEJfoF6PUh8oPJV7G9FFu7bivZQ5k3Znz
         sRKlm6KMd214c66wXV5wC/O13P2SsRcNv/67UxN5P0i0U/0htoSkZtm9zoC1NoV3eMad
         SC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9NQWIYIb3zofiCzg+GVgOIJ0wwu6tmW9/oeA0AthTQA=;
        b=AzQdi5gaPyrW21RrAhiRJtIyUv0UV8top2aa9TVMrmAIkYUX7ZOHYeoohcjgTHk6C3
         bEI3DHwLRUdRV6ebvTDkkCwCiRmZV+GyKSfSzCWFbk2mQtq4ugcT33Y9PaGwiw+9WZhV
         yYD0IUHIbptBEAwygf4SHUGbo4hMzFX+3JCHSqd29c1OdlBqBVMfBttNxm6Suiif8u2z
         kSwsKKjDVvIECEmn8ZtCz3GDbx5FxF9qYnK6lUqe0xGgT6yp3fCB+1yIUSwQxXOjPyhp
         7QWRUCvdgxfbLbYuc6Pwsc3jnQeo6XNwSnUZcTuNGh7j2tFc0YPeKQE6POaHzxgC+NYU
         GXQQ==
X-Gm-Message-State: APjAAAXF+fm/kGGHypiSARbODS7KNX7oZynDIqqZFVsnpIHgrpq+iUHV
        hVitaEdRJRSvqnEea9zIl77B1Gns/99PSCH/OpE44Q==
X-Google-Smtp-Source: APXvYqxVHFZG25s8tacIiBWnDZc7GkdNevsOnib9tFOEtpBkY+1WZIp27vsk69ZC5f4fXIQLmVA1Y8RwmOZ3IluUxtk=
X-Received: by 2002:a17:902:4aa3:: with SMTP id x32mr50488531pld.119.1563487027518;
 Thu, 18 Jul 2019 14:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190718000206.121392-1-vaibhavrustagi@google.com> <20190718000206.121392-3-vaibhavrustagi@google.com>
In-Reply-To: <20190718000206.121392-3-vaibhavrustagi@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 18 Jul 2019 14:56:56 -0700
Message-ID: <CAKwvOd=wrN_MhO57ft6ER=z9PB7or7UKUo=Shd=8bn1rDQNgiA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86/purgatory: do not use __builtin_memcpy and __builtin_memset.
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Manoj Gupta <manojgupta@google.com>,
        Alistair Delva <adelva@google.com>,
        Hans Boehm <hboehm@google.com>,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 5:02 PM Vaibhav Rustagi
<vaibhavrustagi@google.com> wrote:
>
> From: Nick Desaulniers <ndesaulniers@google.com>
>
> Implementing memcpy and memset in terms of __builtin_memcpy and
> __builtin_memset is problematic.
>
> GCC at -O2 will replace calls to the builtins with calls to memcpy and
> memset (but will generate an inline implementation at -Os).  Clang will
> replace the builtins with these calls regardless of optimization level.
>
> $ llvm-objdump -dr arch/x86/purgatory/string.o | tail
>
> 0000000000000339 memcpy:
>      339: 48 b8 00 00 00 00 00 00 00 00 movabsq $0, %rax
>                 000000000000033b:  R_X86_64_64  memcpy
>      343: ff e0                         jmpq    *%rax
>
> 0000000000000345 memset:
>      345: 48 b8 00 00 00 00 00 00 00 00 movabsq $0, %rax
>                 0000000000000347:  R_X86_64_64  memset
>      34f: ff e0
>
> Such code results in infinite recursion at runtime. This is observed
> when doing kexec.

Just so it's crystal clear to other reviewers, consider this codegen
between compilers and optimization levels:
https://godbolt.org/z/jcfKsw
So I'd imagine the commit that introduced these implementations very
much relied on being compiled at -Os to work.

>
> Instead, reuse an implementation from arch/x86/boot/compressed/string.c
> if we define warn as a symbol.

Alternatively, I was getting fancy trying to match what GCC lowers
__builtin_memcpy/__builtin_memset to:
diff --git a/arch/x86/purgatory/string.c b/arch/x86/purgatory/string.c
index 795ca4f..e055f65 100644
--- a/arch/x86/purgatory/string.c
+++ b/arch/x86/purgatory/string.c
@@ -16,10 +16,23 @@

 void *memcpy(void *dst, const void *src, size_t len)
 {
- return __builtin_memcpy(dst, src, len);
+ asm(
+ "movq %0, %%rax\n\t"
+ "movq %2, %%rcx\n\t"
+ "rep movsb\n\t"
+ : "=r"(dst) : "r"(src), "ri"(len) : "rax", "rcx");
+ return dst;
 }

 void *memset(void *dst, int c, size_t len)
 {
- return __builtin_memset(dst, c, len);
+ void* ret;
+ asm(
+ "movq %1, %%r8\n\t"
+ "movl %2, %%eax\n\t"
+ "movq %3, %%rcx\n\t"
+ "rep stosb\n\t"
+ "movq %%r8, %0"
+ : "=r"(ret) : "r"(dst), "ri"(c), "ri"(len) : "r8", "eax", "rcx");
+ return ret;
 }

but then Alistair pointed out that we have a proliferation of
memcpy+memest definitions in the kernel, and we should probably just
reuse an existing one rather than add to the arms race.

>
> Link: https://bugs.chromium.org/p/chromium/issues/detail?id=984056
> Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Debugged-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Debugged-by: Manoj Gupta <manojgupta@google.com>
> Suggested-by: Alistair Delva <adelva@google.com>
> Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  arch/x86/purgatory/Makefile    |  3 +++
>  arch/x86/purgatory/purgatory.c |  6 ++++++
>  arch/x86/purgatory/string.c    | 23 -----------------------
>  3 files changed, 9 insertions(+), 23 deletions(-)
>  delete mode 100644 arch/x86/purgatory/string.c
>
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 3589ec4a28c7..84b8314ddb2d 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -6,6 +6,9 @@ purgatory-y := purgatory.o stack.o setup-x86_$(BITS).o sha256.o entry64.o string
>  targets += $(purgatory-y)
>  PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
>
> +$(obj)/string.o: $(srctree)/arch/x86/boot/compressed/string.c FORCE
> +       $(call if_changed_rule,cc_o_c)
> +
>  $(obj)/sha256.o: $(srctree)/lib/sha256.c FORCE
>         $(call if_changed_rule,cc_o_c)
>
> diff --git a/arch/x86/purgatory/purgatory.c b/arch/x86/purgatory/purgatory.c
> index 6d8d5a34c377..b607bda786f6 100644
> --- a/arch/x86/purgatory/purgatory.c
> +++ b/arch/x86/purgatory/purgatory.c
> @@ -68,3 +68,9 @@ void purgatory(void)
>         }
>         copy_backup_region();
>  }
> +
> +/*
> + * Defined in order to reuse memcpy() and memset() from
> + * arch/x86/boot/compressed/string.c
> + */
> +void warn(const char *msg) {}

This is the one part I feel bad about; memcpy() in
arch/x86/boot/compressed/string.c calls warn() which would result in
an undefined symbol in purgatory.ro. Maybe there's a preferred
solution, or this is ok for purgatory/kexec?  There's other x86
memsets+memcpys, but IMO this is the smallest incision without playing
the satisfy-the-symbol-dependencies game.

If the maintainers are ok with this, then the series looks ready to go
to me. Thanks for debugging/sending Vaibhav.

Orthogonally, I showed Hans Boehm the pointer comparisons+subtraction
in arch/x86/boot/compressed/string.c's memcpy asking about pointer
provenance issues
(https://wiki.sei.cmu.edu/confluence/display/c/ARR36-C.+Do+not+subtract+or+compare+two+pointers+that+do+not+refer+to+the+same+array,
http://www.open-std.org/jtc1/sc22/wg14/www/docs/n2090.htm) introduced
in commit 00ec2c37031e ("x86/boot: Warn on future overlapping memcpy()
use") and he started cursing in Spanish (I don't think he speaks
Spanish) and performed the sign of the cross.  Y'all need
<strikethrough>Jesus</strikethrough>[u]intptr_t.

> diff --git a/arch/x86/purgatory/string.c b/arch/x86/purgatory/string.c
> deleted file mode 100644
> index 01ad43873ad9..000000000000
> --- a/arch/x86/purgatory/string.c
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-only
> -/*
> - * Simple string functions.
> - *
> - * Copyright (C) 2014 Red Hat Inc.
> - *
> - * Author:
> - *       Vivek Goyal <vgoyal@redhat.com>
> - */
> -
> -#include <linux/types.h>
> -
> -#include "../boot/string.c"
> -
> -void *memcpy(void *dst, const void *src, size_t len)
> -{
> -       return __builtin_memcpy(dst, src, len);
> -}
> -
> -void *memset(void *dst, int c, size_t len)
> -{
> -       return __builtin_memset(dst, c, len);
> -}
> --
> 2.22.0.510.g264f2c817a-goog
>


-- 
Thanks,
~Nick Desaulniers
