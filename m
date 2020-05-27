Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D30F1E4CAC
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 20:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388666AbgE0SEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 14:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387706AbgE0SEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 14:04:34 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA31C03E97D
        for <stable@vger.kernel.org>; Wed, 27 May 2020 11:04:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s10so12128779pgm.0
        for <stable@vger.kernel.org>; Wed, 27 May 2020 11:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=30RU4BWAzl0wOn2l0ox/7i0ctRamwhqcNLFYWQjdHwU=;
        b=jq4iDuXHEGkrSKMNUC1NaasBukXAHS1JfA2UuIA606mL4pHJJMIV3DJIaBkMD72NH/
         h9rHOtUPBmXtp/R6z50GLib3r19VmkN15y4Y2+aO0rT/S2UIAG7ATDEMztLRH307UWw2
         DaqONMooU5efxMmemD5WCKyCYX+hZZahJ0XiKOYh8MxYgohN97Ys3ZccX8Z5T+VVGfcv
         cGQSmfK2en3j8h5FgfLDYaEZjWB6xRa4gXvX7d0n7d9gOAPPdR9Fa/ilOYF87IBMGiWb
         4/lPmIqMh3GCGDU7KxIWY+2sOQnCpYIdpr5Pk7Wb2oEktQwngVQjBGCIlZucnG9a/DZd
         UAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=30RU4BWAzl0wOn2l0ox/7i0ctRamwhqcNLFYWQjdHwU=;
        b=joU4dImsRC0EFu0UBzPXFzM7H+1hZF27qUEGd/WMzBmUzuMCPjC2P6seaU1yPt58Qz
         LHi2mEzjAV62R3jHP19Silz11XAGi0ip4FWQNFC3dErWew29mgWUZ+TKJrHjSRJXAHiy
         +d0OBVooAwHvHIlpMui92Uh5CD7OMCgwo5FYFCd+ZuZ5Pjqv/6VC5mmlRLrg5dl2/L7i
         qQGOM0sVkNxTqfJiNidZbTDqvg9znOn8sLBwTjEEmgHwFHt/sf7QauUfuJvHQM2HpluH
         2hR9CIeaCkOvbl9C7T59lhDk8eS94UDA2SfB4pcjN8cBPgSMUhNZoTQqyFyHvwkVbcKc
         lsEA==
X-Gm-Message-State: AOAM533QjyF0pmN1WlbnMuJ8xMpoGoyjDOg25DfHtZyoy3nOC7NKEoTN
        L7H3L69+j9bBvqCgA20hohZTfUoKFyB7xffm7qjejVu727c=
X-Google-Smtp-Source: ABdhPJyCWprooPr5gbGtmhvYEAk/ACWoP1CtoXXUVz1T91quN9BxSnwn+XuxF23ALNxLVdxEpawj2Fi18/D7j4Xk32o=
X-Received: by 2002:aa7:87d6:: with SMTP id i22mr5122213pfo.39.1590602673866;
 Wed, 27 May 2020 11:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200527141553.1768675-1-arnd@arndb.de>
In-Reply-To: <20200527141553.1768675-1-arnd@arndb.de>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 27 May 2020 11:04:22 -0700
Message-ID: <CAKwvOdk8PToaHMWVKV-6Uhhx6CNz15OWLOp_5RCERvdOisLrpA@mail.gmail.com>
Subject: Re: [PATCH] x86: fix clang integrated assembler build
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>,
        Juergen Gross <jgross@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tony Luck <tony.luck@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Bill Wendling <morbo@google.com>, Jian Cai <jiancai@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 7:16 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> clang and gas seem to interpret the symbols in memmove_64.S and
> memset_64.S differently, such that clang does not make them
> 'weak' as expected, which leads to a linker error, with both
> ld.bfd and ld.lld:
>
> ld.lld: error: duplicate symbol: memmove
> >>> defined at common.c
> >>>            kasan/common.o:(memmove) in archive mm/built-in.a
> >>> defined at memmove.o:(__memmove) in archive arch/arm64/lib/lib.a
>
> ld.lld: error: duplicate symbol: memset
> >>> defined at common.c
> >>>            kasan/common.o:(memset) in archive mm/built-in.a
> >>> defined at memset.o:(__memset) in archive arch/arm64/lib/lib.a
>
> Copy the exact way these are written in memcpy_64.S, which does
> not have the same problem.
>
> I don't know why this makes a difference, and it would be good
> to have someone with a better understanding of assembler internals
> review it.
>
> It might be either a bug in the kernel or a bug in the assembler,
> no idea which one. My patch makes it work with all versions of
> clang and gcc, which is probably helpful even if it's a workaround
> for a clang bug.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

+ Bill, Fangrui, Jian
I think we saw this bug or a very similar bug internally around the
ordering of .weak to .global.

> ---
>  arch/x86/lib/memmove_64.S | 4 ++--
>  arch/x86/lib/memset_64.S  | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
> index 7ff00ea64e4f..dcca01434be8 100644
> --- a/arch/x86/lib/memmove_64.S
> +++ b/arch/x86/lib/memmove_64.S
> @@ -26,8 +26,8 @@
>   */
>  .weak memmove
>
> -SYM_FUNC_START_ALIAS(memmove)
> -SYM_FUNC_START(__memmove)
> +SYM_FUNC_START_ALIAS(__memmove)
> +SYM_FUNC_START_LOCAL(memmove)
>
>         mov %rdi, %rax
>
> diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
> index 9ff15ee404a4..a97f2ea4e0b2 100644
> --- a/arch/x86/lib/memset_64.S
> +++ b/arch/x86/lib/memset_64.S
> @@ -19,8 +19,8 @@
>   *
>   * rax   original destination
>   */
> -SYM_FUNC_START_ALIAS(memset)
> -SYM_FUNC_START(__memset)
> +SYM_FUNC_START_ALIAS(__memset)
> +SYM_FUNC_START_LOCAL(memset)
>         /*
>          * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
>          * to use it when possible. If not available, use fast string instructions.
> --
> 2.26.2
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200527141553.1768675-1-arnd%40arndb.de.



-- 
Thanks,
~Nick Desaulniers
