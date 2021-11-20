Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839D0457AF7
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 04:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhKTEA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 23:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbhKTEA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 23:00:26 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67711C06173E
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 19:57:23 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so8934423wmb.5
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 19:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oxYwFgP8QJkY0fxAaKGmN1e+xFo7sJTuqw6yMPGfDkU=;
        b=IK9SuPgNEEXpXn5eTloZtETIgJUVZCFMm5dY5FECGXFayp2QZE4sItiri8a9E3ZAwO
         w44k+4ShvTftu/4aHhItjEmF4SqykRKGl7KRMBTtE9mW9l3Y29TF2ZLaNrCHFjUuDWTU
         dpVb3ufS2FrPSIusaomI3+nEQX+1quVvFzdW+MswCGStMDsSD9Eg7/+XvdYNPTyvpbkS
         9pXy4UpmC+qIoBsu8dA1LHtUXwJhr49g5SLjtl7ZrEiicgWxM0fIcbAI0bXN42k/vgop
         Pea5vu4B32j+LaYtaFNdhTqwObs8SEMnmGvVceC/Lez4+Nefb/MdW6QRk0G5FXBCldUD
         yc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oxYwFgP8QJkY0fxAaKGmN1e+xFo7sJTuqw6yMPGfDkU=;
        b=pOE/Ae7XYBKFSlhS+qZnPw2SIE78YAREpAV/BkmMxTfLY//YF5spVLwV7rMSI0smQP
         12E2m68hcZn2CPOm8ky3Zv5Xt3YnJkI9zWhYzCOUuSmnxkY4bzy047S6XfSMFVICQyqL
         iP3mQ2MpY9SkxaeP+49+Nn4UuywzlnOo7SYEVRDd/JRbBm59gxFh8UEGMTWzefAwlrDX
         VhsultlwmHJG3AavDIWV8VN77wT9onwaCup7hqzu9hyBU7a7TKv3YqJmeplBTxxNQApX
         5WC4D7tJhS2PYhQywwhrsBLluitzDKKmuVDDhDOdeU5jdaaUKXvbLzubv4OEdI0c7C+w
         /+cA==
X-Gm-Message-State: AOAM5317+esInebihX7O9lf383BLPSl17M3f4m+qwogee/AZH/2/wXb1
        dcUWqhsoRPIF13WAk6pCW8BoT5Ahm+nlEokd2Pgp+A==
X-Google-Smtp-Source: ABdhPJyIb0xxDF6sP8Nm5V4J/JpeG+4+whciNZU5mV9yRjqVSK7mUHZ0qQPwxtG1jTQX1H5BGp23UGzUxdWfTn+fudI=
X-Received: by 2002:a7b:c194:: with SMTP id y20mr6680170wmi.61.1637380641708;
 Fri, 19 Nov 2021 19:57:21 -0800 (PST)
MIME-Version: 1.0
References: <20211119164413.29052-1-palmer@rivosinc.com> <20211119164413.29052-3-palmer@rivosinc.com>
In-Reply-To: <20211119164413.29052-3-palmer@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 20 Nov 2021 09:27:09 +0530
Message-ID: <CAAhSdy1hx3Me_YCKnE=QkTaA9j-qyZjmgJDM8nT-uYCdg7vf=g@mail.gmail.com>
Subject: Re: [PATCH 02/12] RISC-V: MAXPHYSMEM_2GB doesn't depend on CMODEL_MEDLOW
To:     Palmer Dabbelt <palmer@rivosinc.com>
Cc:     linux-riscv <linux-riscv@lists.infradead.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Atish Patra <atish.patra@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Damien Le Moal <damien.lemoal@wdc.com>, axboe@kernel.dk,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 10:14 PM Palmer Dabbelt <palmer@rivosinc.com> wrote:
>
> From: Palmer Dabbelt <palmer@rivosinc.com>
>
> For non-relocatable kernels we need to be able to link the kernel at
> approximately PAGE_OFFSET, thus requiring medany (as medlow requires the
> code to be linked within 2GiB of 0).  The inverse doesn't apply, though:
> since medany code can be linked anywhere it's fine to link it close to
> 0, so we can support the smaller memory config.
>
> Fixes: de5f4b8f634b ("RISC-V: Define MAXPHYSMEM_1GB only for RV32")
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

>
> ---
>
> I found this when going through the savedefconfig diffs for the K210
> defconfigs.  I'm not entirely sure they're doing the right thing here
> (they should probably be setting CMODEL_LOW to take advantage of the
> better code generation), but I don't have any way to test those
> platforms so I don't want to change too much.
> ---
>  arch/riscv/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 821252b65f89..61f64512dcde 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -280,7 +280,7 @@ choice
>                 depends on 32BIT
>                 bool "1GiB"
>         config MAXPHYSMEM_2GB
> -               depends on 64BIT && CMODEL_MEDLOW
> +               depends on 64BIT
>                 bool "2GiB"
>         config MAXPHYSMEM_128GB
>                 depends on 64BIT && CMODEL_MEDANY
> --
> 2.32.0
>
