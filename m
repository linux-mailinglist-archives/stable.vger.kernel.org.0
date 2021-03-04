Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D726832D831
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 17:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbhCDQ62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 11:58:28 -0500
Received: from mail-oi1-f177.google.com ([209.85.167.177]:36822 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238515AbhCDQ6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 11:58:00 -0500
Received: by mail-oi1-f177.google.com with SMTP id j1so30835969oiw.3;
        Thu, 04 Mar 2021 08:57:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uMbIj2+P93+JeffaIa++scjCnNO8RXrm4bxpZ3J1rGE=;
        b=VYkvwN8Q6E99wNmTuLTwKDa7mP2LZyelhly0ey8+EU/r979ndzzMn/ZGfD1UdJjmgE
         Dq5vgTvd8hv7rqJIE9GsYvf2i3LVKh1J75O70Dat1eTCtTlCo9Q9tu0Q+3EENtBOt37Y
         gHCOdF0ch556iYwtILp7E+ZAoxKhkxTl16wjvOsQPmiz75x+QH9GrKwujcd1L3cI383G
         YJo+aNorPWWACy/9GpsbyE9p5Ob8TEg0iuISEoMFgLtGSfIFUqy/F2g97LJDLUVwsUii
         1WC+u6b9ssnXD8bMgVwvwQg7/udj7mWCINnLY5mJkc2qAKtPR3y5ZopthR2nircA66b0
         sMMg==
X-Gm-Message-State: AOAM532j7MjSEzB32j0n8scsPgj9XfMIRX8L3AQXE1Q9yO3gK+7j3VFG
        06lyEsmyCUAoqbVswJdi688+gkZXGFfiN9UOc0s=
X-Google-Smtp-Source: ABdhPJwJ6+lCPoBdexVxN5OSL3dlQbdDepk+DB0xQPJZyWDJZ6WGl8hT7ChtXvr8IwX5M2btZ0x87P3v2/a4HOB1eOo=
X-Received: by 2002:aca:4ad2:: with SMTP id x201mr64230oia.46.1614877039675;
 Thu, 04 Mar 2021 08:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20210303053342.5920-1-syq@debian.org>
In-Reply-To: <20210303053342.5920-1-syq@debian.org>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Thu, 4 Mar 2021 17:57:08 +0100
Message-ID: <CAAdtpL4XNF_U5KQRf6e-6Agt9VAGOM7WrkOvv_+a5Ym5gYrRDg@mail.gmail.com>
Subject: Re: [PATCH v7] MIPS: force use FR=0 or FRE for FPXX binaries
To:     YunQiang Su <syq@debian.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        YunQiang Su <yunqiang.su@cipunited.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 4, 2021 at 11:06 AM YunQiang Su <syq@debian.org> wrote:
>
> From: YunQiang Su <yunqiang.su@cipunited.com>
>
> The MIPS FPU may have 3 mode:
>   FR=0: MIPS I style, all of the FPR are single.
>   FR=1: all 32 FPR can be double.
>   FRE: redirecting the rw of odd-FPR to the upper 32bit of even-double FPR.
>
> The binary may have 3 mode:
>   FP32: can only work with FR=0 and FRE mode
>   FPXX: can work with all of FR=0/FR=1/FRE mode.
>   FP64: can only work with FR=1 mode
>
> Some binary, for example the output of golang, may be mark as FPXX,
> while in fact they are FP32. It is caused by the bug of design and linker:
>   Object produced by pure Go has no FP annotation while in fact they are FP32;
>   if we link them with the C module which marked as FPXX,
>   the result will be marked as FPXX. If these fake-FPXX binaries is executed
>   in FR=1 mode, some problem will happen.
>
> In Golang, now we add the FP32 annotation, so the future golang programs
> won't have this problem. While for the existing binaries, we need a
> kernel workaround.
>
> Currently, FR=1 mode is used for all FPXX binary, it makes some wrong
> behivour of the binaries. Since FPXX binary can work with both FR=1 and FR=0,
> we force it to use FR=0 or FRE (for R6 CPU).
>
> Reference:
>
> https://web.archive.org/web/20180828210612/https://dmz-portal.mips.com/wiki/MIPS_O32_ABI_-_FR0_and_FR1_Interlinking
>
> https://go-review.googlesource.com/c/go/+/239217
> https://go-review.googlesource.com/c/go/+/237058
>
> Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
> Cc: stable@vger.kernel.org # 4.19+

Here goes the '---' git separator:

---

To remove the following notes when applying, not really useful
in the git history.

>
> v6->v7:
>         Use FRE mode for pre-R6 binaries on R6 CPU.
>
> v5->v6:
>         Rollback to V3, aka remove config option.
>
> v4->v5:
>         Fix CONFIG_MIPS_O32_FPXX_USE_FR0 usage: if -> ifdef
>
> v3->v4:
>         introduce a config option: CONFIG_MIPS_O32_FPXX_USE_FR0
>
> v2->v3:
>         commit message: add Signed-off-by and Cc to stable.
>
> v1->v2:
>         Fix bad commit message: in fact, we are switching to FR=0
> ---
>  arch/mips/kernel/elf.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
> index 7b045d2a0b51..4d4db619544b 100644
> --- a/arch/mips/kernel/elf.c
> +++ b/arch/mips/kernel/elf.c
> @@ -232,11 +232,16 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
>          *   that inherently require the hybrid FP mode.
>          * - If FR1 and FRDEFAULT is true, that means we hit the any-abi or
>          *   fpxx case. This is because, in any-ABI (or no-ABI) we have no FPU
> -        *   instructions so we don't care about the mode. We will simply use
> -        *   the one preferred by the hardware. In fpxx case, that ABI can
> -        *   handle both FR=1 and FR=0, so, again, we simply choose the one
> -        *   preferred by the hardware. Next, if we only use single-precision
> -        *   FPU instructions, and the default ABI FPU mode is not good
> +        *   instructions so we don't care about the mode.
> +        *   In fpxx case, that ABI can handle all of FR=1/FR=0/FRE mode.
> +        *   Here, we need to use FR=0/FRE mode instead of FR=1, because some binaries
> +        *   may be mark as FPXX by mistake due to bugs of design and linker:
> +        *      The object produced by pure Go has no FP annotation,
> +        *      then is treated as any-ABI by linker, although in fact they are FP32;
> +        *      if any-ABI object is linked with FPXX object, the result will be mark as FPXX.
> +        *      Then the problem happens: run FP32 binaries in FR=1 mode.
> +        * - If we only use single-precision FPU instructions,
> +        *   and the default ABI FPU mode is not good
>          *   (ie single + any ABI combination), we set again the FPU mode to the
>          *   one is preferred by the hardware. Next, if we know that the code
>          *   will only use single-precision instructions, shown by single being
> @@ -248,8 +253,9 @@ int arch_check_elf(void *_ehdr, bool has_interpreter, void *_interp_ehdr,
>          */
>         if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1)
>                 state->overall_fp_mode = FP_FRE;
> -       else if ((prog_req.fr1 && prog_req.frdefault) ||
> -                (prog_req.single && !prog_req.frdefault))
> +       else if (prog_req.fr1 && prog_req.frdefault)
> +               state->overall_fp_mode = cpu_has_mips_r6 ? FP_FRE : FP_FR0;
> +       else if (prog_req.single && !prog_req.frdefault)
>                 /* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 */
>                 state->overall_fp_mode = ((raw_current_cpu_data.fpu_id & MIPS_FPIR_F64) &&
>                                           cpu_has_mips_r2_r6) ?
> --
> 2.20.1
>
