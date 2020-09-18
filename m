Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2426B2705BD
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 21:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgIRTmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 15:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIRTmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 15:42:23 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D24DC0613CE
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 12:42:23 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d13so4067818pgl.6
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 12:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ZQ5Zsw0qLZ1kzMLFNN+rkmGWWS5R799uwH5up0NkkI=;
        b=rkB3EwTOHI7xML5s4CBXg28dJvyv47Odci6s0ZFhI84yEI9rmRm6j10IivLckwH83r
         sxlkI9lKh5bUb7xKwA1DJIRxOv2WHd9FbIXu4OZBBBQtRZS2+Q0b136Tx3jzrqlaTzBZ
         v1GpCcKvUCVMe3VcGDD9tbA0x2/JLK0XAQ8PztJPwJ99Df3Bs/NC722AmFG67q487H8y
         Levg+24otDr9knw0dCsWYsQjZdpXShfLc0M5jtAU2ZTo5oqDPdpE2dNQDSjPdRRU/UZB
         ibJvPoKpI9Ch8WttkFZO1kb4qXVjbPUrqPTmgWc6Ps1p5RN8qHBNwacoOB6wgX5D30r8
         x4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ZQ5Zsw0qLZ1kzMLFNN+rkmGWWS5R799uwH5up0NkkI=;
        b=RkON8XOtg9hy16RKNIp2qmnRdHia8u3mv21beYuvKWgbfib3TkOL2+oShlcYWrh3y0
         IRut8sGRP2Zmjtr/yfBw3KrMOWIHBIRrvHWYZrKWrv+s09Mn1gK7o/DxfuTgFZP4L8vs
         eZz5Pjqd/1z7RmWTTtOrAHEmhD4/MUhleu3dSTJqKqCboBoZ59ZexFAYs8XzMJI5TrY7
         p2xUvE0cvx6gmf6J1oY43yQLsiKNsUL7GqmAkn4rDOltajFBq4j/ZXXRetxzarPe20ow
         q2zef1hpkhCYEFM+FUkuaFxJAvRBCHmmOt5mkrfH5FnXC6tibiW9aloURNbq0HerwIJU
         WaXw==
X-Gm-Message-State: AOAM532VyLxkcHRjk6vfGJpw0UJ4NelkrPLLVawWzf+cLTKYmUI36EoW
        XO/NiKKb+6y5yY1FZhUIesbx7pHWx9dZSZ6lnQ/UMQ==
X-Google-Smtp-Source: ABdhPJyLNUyjtcDtOhvzSyt8vCxgR8LpxlDA8Q8fhcLkShX7bpeD2SPPXNx5wsrwMjLb5x/3Gg4DNI8FELEY07zmHqg=
X-Received: by 2002:a63:310a:: with SMTP id x10mr6317147pgx.10.1600458142520;
 Fri, 18 Sep 2020 12:42:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200917061948.12403-1-ardb@kernel.org>
In-Reply-To: <20200917061948.12403-1-ardb@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 18 Sep 2020 12:42:11 -0700
Message-ID: <CAKwvOd=15gCywgZtC8=z4+rH29uG-a8Ghw9Aeyn5=LfZXDsASA@mail.gmail.com>
Subject: Re: [PATCH] ARM: vfp: force non-conditional encoding for external
 Thumb2 tail call
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 11:19 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Nick reports that the following error is produced in some cases when
> using GCC+ld.bfd to build the ARM defconfig with Thumb2 enabled:
>
>   arch/arm/vfp/vfphw.o: in function `vfp_support_entry':
>   (.text+0xa): relocation truncated to fit: R_ARM_THM_JUMP19 against
>   symbol `vfp_kmode_exception' defined in .text.unlikely section in
>   arch/arm/vfp/vfpmodule.o
>
>   $ arm-linux-gnueabihf-ld --version
>   GNU ld (GNU Binutils for Debian) 2.34

FWIW this was my compiler version, too:
$ arm-linux-gnueabihf-gcc --version
arm-linux-gnueabihf-gcc (Debian 9.3.0-8) 9.3.0

>
> Generally, the linker should be able to fix up out of range branches by
> emitting veneers, but apparently, it fails to do so in this particular
> case, i.e., a conditional 'tail call' to vfp_kmode_exception(), which
> is not defined in the same object file.
>
> So let's force the use of a non-conditional encoding of the B instruction,
> which has more space for an immediate offset.
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/vfp/vfphw.S | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
> index 4fcff9f59947..f1468702fbc9 100644
> --- a/arch/arm/vfp/vfphw.S
> +++ b/arch/arm/vfp/vfphw.S
> @@ -82,6 +82,7 @@ ENTRY(vfp_support_entry)
>         ldr     r3, [sp, #S_PSR]        @ Neither lazy restore nor FP exceptions
>         and     r3, r3, #MODE_MASK      @ are supported in kernel mode
>         teq     r3, #USR_MODE
> +THUMB( it      ne                      )
>         bne     vfp_kmode_exception     @ Returns through lr
>
>         VFPFMRX r1, FPEXC               @ Is the VFP enabled?
> --
> 2.17.1
>


-- 
Thanks,
~Nick Desaulniers
