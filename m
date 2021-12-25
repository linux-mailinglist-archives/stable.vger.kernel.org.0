Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981FF47F361
	for <lists+stable@lfdr.de>; Sat, 25 Dec 2021 15:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhLYOXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 09:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhLYOXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 09:23:12 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB80C061401
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 06:23:12 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id l5so8739015edj.13
        for <stable@vger.kernel.org>; Sat, 25 Dec 2021 06:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ntqyWM2S7YaEuV2O8n2An/RW6EflrGlyakvKWLGzjA=;
        b=2xuW6H5MX+uBIfOawDuYqqlxygkNPQ9AV5DnSzvDbxDkmqr/fPSR2QEF8iaCzU1csC
         BFQdXZdlUoFQ2SFiQyBZViPLhkO63TNgiivwnfpUhXxSuPBdk3M8XDlNtA0JPTCnXJo9
         wOpTzRQt4CjFYyCFQk1LPYBgUo3an9Qg0TeZrCEl+cFY47y+0L2BCcViLXpCrCTK/Onb
         qrS2TD892zf8ALnaUJd5O6I/anC8Smu6jpAbEMXkK+4JPN345dcrbmlEqZL4/bX1Fm8/
         GYyZN/CThWHRaKrZRWAS4L0bRslchsikvFrnUZSuTDG+3SmG2o87rqA7GgWQat9LZHq5
         uX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ntqyWM2S7YaEuV2O8n2An/RW6EflrGlyakvKWLGzjA=;
        b=1QSurTfdtyijnnBa59ZDL19/78MK5ixC39negSTkCPruKuyPIQH8vB4Q9uGG2Uk/VO
         eA0Vf0axKHnixBD7opaSKQsDGp6uVBFbooH8zEfn+QVdI4EHW2PkeFY3hKxDlLiCSAtP
         CIzMOO0uniZmNHutoJ4oxoh6pHbS37kb1YbRyzEpvHUehtfzu0R+ip2ALQiUybRxKuEL
         1VPxiWfQOPKYe3dXPghwFwNeP/aKCxt9W7ma+I8R+V2TverIc2tbSl+0nlXqJkbf2B78
         z7N5NWUMshUPTl8V8Cq9SQ2hbGdwpCinE6wDxAo3Ca2PJfZuwLU/bsyR1ykOEmrNfrTO
         NyTw==
X-Gm-Message-State: AOAM532tWC8JcQsr99tm4rnI7Hxw2fIFY1gq0x+6ChqHvXZY/837U6y3
        0Nv6Gwa08Xh9/DRdnNwYulIIbGBT/wvY2b8sy8l1xQ==
X-Google-Smtp-Source: ABdhPJzs4YggNuaWHNrpc2KkpzxkfPL3CfrW/VOmf6j55jO3wme+Hh9GgWHPn7tVJy1h7qKPy0zxlvozF3v7adPN7Qs=
X-Received: by 2002:a17:906:249a:: with SMTP id e26mr8165381ejb.492.1640442190849;
 Sat, 25 Dec 2021 06:23:10 -0800 (PST)
MIME-Version: 1.0
References: <20211223222141.1253092-1-nathan@kernel.org>
In-Reply-To: <20211223222141.1253092-1-nathan@kernel.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Sat, 25 Dec 2021 15:23:00 +0100
Message-ID: <CAMRc=MfdkefAS2ZiPYp3976y3fECYvRXTf1j-OMnLsq6NGtUgw@mail.gmail.com>
Subject: Re: [PATCH] ARM: davinci: da850-evm: Avoid NULL pointer dereference
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sekhar Nori <nsekhar@ti.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 11:22 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> With newer versions of GCC, there is a panic in da850_evm_config_emac()
> when booting multi_v5_defconfig in QEMU under the palmetto-bmc machine:
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000020
> pgd = (ptrval)
> [00000020] *pgd=00000000
> Internal error: Oops: 5 [#1] PREEMPT ARM
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper Not tainted 5.15.0 #1
> Hardware name: Generic DT based system
> PC is at da850_evm_config_emac+0x1c/0x120
> LR is at do_one_initcall+0x50/0x1e0
>
> The emac_pdata pointer in soc_info is NULL because davinci_soc_info only
> gets populated on davinci machines but da850_evm_config_emac() is called
> on all machines via device_initcall().
>
> Move the rmii_en assignment below the machine check so that it is only
> dereferenced when running on a supported SoC.
>
> Cc: stable@vger.kernel.org
> Fixes: bae105879f2f ("davinci: DA850/OMAP-L138 EVM: implement autodetect of RMII PHY")
> Link: https://lore.kernel.org/r/YcS4xVWs6bQlQSPC@archlinux-ax161/
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 428012687a80..7f7f6bae21c2 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -1101,11 +1101,13 @@ static int __init da850_evm_config_emac(void)
>         int ret;
>         u32 val;
>         struct davinci_soc_info *soc_info = &davinci_soc_info;
> -       u8 rmii_en = soc_info->emac_pdata->rmii_en;
> +       u8 rmii_en;
>
>         if (!machine_is_davinci_da850_evm())
>                 return 0;
>
> +       rmii_en = soc_info->emac_pdata->rmii_en;
> +
>         cfg_chip3_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG);
>
>         val = __raw_readl(cfg_chip3_base);
>
> base-commit: a7904a538933c525096ca2ccde1e60d0ee62c08e
> --
> 2.34.1
>

Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
