Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E27B0507
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 22:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbfIKU4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 16:56:04 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42896 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729685AbfIKU4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 16:56:04 -0400
Received: by mail-pl1-f193.google.com with SMTP id g6so80818plj.9
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 13:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hECyZnP2/Wb3+Wh7idFWgoa4zJGDS5Ymb1IJNhVMGsM=;
        b=O4HLFzuLvgRtaOYD+41+U97SXnxP09FStmC8vuSWi1/3Md/asn73q1z3atC6YBnIp0
         U0GJtUwMWu0aPVl70WI9gq1j3E3MWR/ca+WwxESdzEEcx2PiOYkgMHz8y/ZMfAikCgYc
         NdfD+1ztePAqXEIyFab7iXjCt7OUz+sJebpixEcD32vSZmCidk3dPa5OBoORsYy1Rsus
         +OTzjB8hgDGuPSUh3FEFQT+GonA4RRpOgCc1rNYQXkj/DXE8DKCEJwwpkJd2KwDcgxqY
         6kneExfgwdKVtAseOKzKSZFla1DbA8hUPPIRE78vmXEyVY+R8RD29XvNewSBrVrvf5b5
         MEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hECyZnP2/Wb3+Wh7idFWgoa4zJGDS5Ymb1IJNhVMGsM=;
        b=kKVYIXBcb/5SJcrATBnvNuPtPjarHluQwmiycZWZ5c6KodMhSldGH3ZBnDUsKNmp3i
         9AfF9amMsjDZq2P2l7RwVV/hAGWVHszQfxNKNLt03deNmlBIwS5UexhCKKdrpUoF13Qy
         nuqRDWF0aWg7EANi4sVix3NO1WfI4SE4hNPZw2Dkf3HIZQf6E87MgxLVtVEZA8qDBVct
         bENboyDPp50B/GKUMPsg71pxtEu127xLuyZ2NjG9y4UcQelnYXZDOY98lPB4I2cy0J0f
         54cbNxOBxJybaoKEpujmJEkJADhDeIYoAhqyKBk+glqBRwau9NVHezxbIs7nkqjwAt88
         RnbQ==
X-Gm-Message-State: APjAAAWWEzmmreNiiqwNg7zaFTLQrHf/5IY0Ac6mmNuYRMObuRi98ll0
        uZwrILTQF1fQeui0+GR7ibhpnpaAIrhpxxHtQIa4sQ==
X-Google-Smtp-Source: APXvYqygXwwB3HrJAYGIzgZFaTxeGs7BobXjt9YTik0bsJO7DbpauDgLEBayH/87rd+PF6LMKAqF7jHu/7L1+MMzZfc=
X-Received: by 2002:a17:902:7296:: with SMTP id d22mr39066409pll.179.1568235363028;
 Wed, 11 Sep 2019 13:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190911182049.77853-1-natechancellor@gmail.com> <20190911182049.77853-3-natechancellor@gmail.com>
In-Reply-To: <20190911182049.77853-3-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 11 Sep 2019 13:55:52 -0700
Message-ID: <CAKwvOdn2vz0XGDQrbBiGFAp6vvBzmOgUH3GLkgGY4UAWLhhZUQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] powerpc: Avoid clang warnings around setjmp and longjmp
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Segher Boessenkool <segher@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 11:21 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
> setjmp is used") disabled -Wbuiltin-requires-header because of a warning
> about the setjmp and longjmp declarations.
>
> r367387 in clang added another diagnostic around this, complaining that
> there is no jmp_buf declaration.
>
> In file included from ../arch/powerpc/xmon/xmon.c:47:
> ../arch/powerpc/include/asm/setjmp.h:10:13: error: declaration of
> built-in function 'setjmp' requires the declaration of the 'jmp_buf'
> type, commonly provided in the header <setjmp.h>.
> [-Werror,-Wincomplete-setjmp-declaration]
> extern long setjmp(long *);
>             ^
> ../arch/powerpc/include/asm/setjmp.h:11:13: error: declaration of
> built-in function 'longjmp' requires the declaration of the 'jmp_buf'
> type, commonly provided in the header <setjmp.h>.
> [-Werror,-Wincomplete-setjmp-declaration]
> extern void longjmp(long *, long);
>             ^
> 2 errors generated.
>
> We are not using the standard library's longjmp/setjmp implementations
> for obvious reasons; make this clear to clang by using -ffreestanding
> on these files.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
https://godbolt.org/z/B2oQnl

>
> Cc: stable@vger.kernel.org # 4.14+
> Link: https://github.com/ClangBuiltLinux/linux/issues/625
> Link: https://github.com/llvm/llvm-project/commit/3be25e79477db2d31ac46493d97eca8c20592b07
> Suggested-by: Segher Boessenkool <segher@kernel.crashing.org>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> v1 -> v3:
>
> * Use -ffreestanding instead of outright disabling the warning because
>   it is legitimate.
>
> I skipped v2 because the first patch in the series already had a v2.
>
>  arch/powerpc/kernel/Makefile | 4 ++--
>  arch/powerpc/xmon/Makefile   | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index c9cc4b689e60..19f19c8c874b 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -5,8 +5,8 @@
>
>  CFLAGS_ptrace.o                += -DUTS_MACHINE='"$(UTS_MACHINE)"'
>
> -# Disable clang warning for using setjmp without setjmp.h header
> -CFLAGS_crash.o         += $(call cc-disable-warning, builtin-requires-header)
> +# Avoid clang warnings around longjmp/setjmp declarations
> +CFLAGS_crash.o         += -ffreestanding
>
>  ifdef CONFIG_PPC64
>  CFLAGS_prom_init.o     += $(NO_MINIMAL_TOC)
> diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
> index f142570ad860..c3842dbeb1b7 100644
> --- a/arch/powerpc/xmon/Makefile
> +++ b/arch/powerpc/xmon/Makefile
> @@ -1,8 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for xmon
>
> -# Disable clang warning for using setjmp without setjmp.h header
> -subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header)
> +# Avoid clang warnings around longjmp/setjmp declarations
> +subdir-ccflags-y := -ffreestanding
>
>  GCOV_PROFILE := n
>  KCOV_INSTRUMENT := n
> --
> 2.23.0
>


-- 
Thanks,
~Nick Desaulniers
