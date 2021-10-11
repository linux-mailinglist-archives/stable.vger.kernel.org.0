Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142F242959D
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 19:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhJKRbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 13:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhJKRbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 13:31:36 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE065C06161C
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 10:29:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g10so69901378edj.1
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 10:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qA3YuL7fYmv4Y8Yvw8BDi0DK+UWHyslqyhO8rDvQoNY=;
        b=d+BRza8HiCfXT1IwFtf5HXAvgHtq59Wg3QEi22ubyhxfWeM5jg8fYggLDauZf4D62E
         ussN8dvte5J0e2s0xVWV9KtiXwsJSNs1IEkau5yacd6kSEHgXjuutTXkH0JRQyqwpy8I
         gI9QJ7P0fOQf07zjlkUMcCik5oB+GpKIezcjH7/MuAwRafmk1NrQuPvLsllqRXLEgiRr
         PM7wr+Zmcj+wrj9W/eet2X4fKldR9TiUJ9ssP0pQYWnPUPT76NawLB92sH0R+nWcNnPI
         7I9YK+HLgZozd3wSV2SLDu/8mYkroFiAW+mrwMrXg/lihmOyENJX0bxvqlT9ZkpwqgBg
         XM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qA3YuL7fYmv4Y8Yvw8BDi0DK+UWHyslqyhO8rDvQoNY=;
        b=HIa65wMSKbTLSS0c+v43YvxKO+L4ALgZDjFBioLAHgYU0ue9BGwIVW7ZXVWZzz4aoX
         4cDAoRM+UVmFX64nUnVN1DNq1pQtqZS0OqblfjI2ObVAwmxGvWiJFZqKwN6JDQKeRQ6T
         rIiGaCfT8xA8q3c/Ykn5YanDj9huPNQio/ZsrRPvMvMqc+/R4220Frw2ERflbUdHbCWZ
         6QtXQ9/06lOjk/xPZtC0uQY/N3Uv6jCJRg2RF4xnTOWJtnZefIODmIkWi8AEwDdgSnVC
         RqRbHlv5fTOCZnqwzcmRCXKrrEfDcxZ9+EP6WA6Mti4aPY+AVA/FHbTQEz2mK1ej4jLA
         8HDg==
X-Gm-Message-State: AOAM532dCkVh/7gdKTDPzry2VmSEOOhoQhrpA5562QeUfO/1FhUH9FIg
        OgYKmloBPTvso//8pVhkWnQIDc9hnFf4/ttFkRvQGg==
X-Google-Smtp-Source: ABdhPJwNEv9b5UFK5ZJWQ4MEFZdqdPTSJb8KzPRNG7wtiK2VDmIq0TGi9Nsj9oe4DWFRz0C7k6Y3sFNbjCBJLkLqzBs=
X-Received: by 2002:a05:6402:3587:: with SMTP id y7mr43089286edc.182.1633973374304;
 Mon, 11 Oct 2021 10:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211011134508.362906295@linuxfoundation.org> <20211011134510.897297770@linuxfoundation.org>
In-Reply-To: <20211011134510.897297770@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 11 Oct 2021 22:59:23 +0530
Message-ID: <CA+G9fYshyzMVBbO9ySSYtK+oucZ4k0e4M2JcVfQ8-U26cV+7=Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 73/83] powerpc/bpf: Fix BPF_MOD when imm == 1
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc 5.4 build failed due this patch.
 - powerpc gcc-10-defconfig - FAILED
 - powerpc gcc-11-defconfig - FAILED
 - powerpc gcc-8-defconfig - FAILED
 - powerpc gcc-9-defconfig - FAILED

On Mon, 11 Oct 2021 at 19:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>
> [ Upstream commit 8bbc9d822421d9ac8ff9ed26a3713c9afc69d6c8 ]
>
> Only ignore the operation if dividing by 1.
>
> Fixes: 156d0e290e969c ("powerpc/ebpf/jit: Implement JIT compiler for extended BPF")
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Tested-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Acked-by: Song Liu <songliubraving@fb.com>
> Acked-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/c674ca18c3046885602caebb326213731c675d06.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/powerpc/net/bpf_jit_comp64.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
> index 658ca2bab13c..e79f9eae2bc0 100644
> --- a/arch/powerpc/net/bpf_jit_comp64.c
> +++ b/arch/powerpc/net/bpf_jit_comp64.c
> @@ -408,8 +408,14 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
>                 case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /= imm */
>                         if (imm == 0)
>                                 return -EINVAL;
> -                       else if (imm == 1)
> -                               goto bpf_alu32_trunc;
> +                       if (imm == 1) {
> +                               if (BPF_OP(code) == BPF_DIV) {
> +                                       goto bpf_alu32_trunc;
> +                               } else {
> +                                       EMIT(PPC_RAW_LI(dst_reg, 0));

In file included from arch/powerpc/net/bpf_jit64.h:11,
                 from arch/powerpc/net/bpf_jit_comp64.c:19:
arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
arch/powerpc/net/bpf_jit_comp64.c:415:46: error: implicit declaration
of function 'PPC_RAW_LI'; did you mean 'PPC_RLWIMI'?
[-Werror=implicit-function-declaration]
  415 |                                         EMIT(PPC_RAW_LI(dst_reg, 0));
      |                                              ^~~~~~~~~~
arch/powerpc/net/bpf_jit.h:32:34: note: in definition of macro 'PLANT_INSTR'
   32 |         do { if (d) { (d)[idx] = instr; } idx++; } while (0)
      |                                  ^~~~~
arch/powerpc/net/bpf_jit_comp64.c:415:41: note: in expansion of macro 'EMIT'
  415 |                                         EMIT(PPC_RAW_LI(dst_reg, 0));
      |                                         ^~~~
cc1: all warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

-- 
Linaro LKFT
https://lkft.linaro.org
