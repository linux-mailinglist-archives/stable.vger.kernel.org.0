Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D270D446E2E
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 14:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhKFNsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 09:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhKFNsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 09:48:19 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A5DC061570
        for <stable@vger.kernel.org>; Sat,  6 Nov 2021 06:45:38 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d5so18259222wrc.1
        for <stable@vger.kernel.org>; Sat, 06 Nov 2021 06:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f31WRtxRAaJ1ReHamccwuYw+KLj+c2LCAREJ/bMMV3c=;
        b=wVf6Mdvfbfy0yyKVtJHy/4iYqp5dIVOo2qoWCmcFQtgMiH/3/R11fcbR8fVyHf9ULK
         LFjkHWCwbH+UjVtZOB7ILZc7NSGCobw0HEnrp7pRXRpkoQYhSQ6bnNat6e5m1ZZUrBxM
         Fay/r9bYykJC/OpZGjwlX8XieYgZ2Jd2/8YDf8X3nT4r0Ht8HqQAGJwW+8AzrcqLtcNc
         7Efc7T9cO52SWaYRHpk9VoZKUVd+dTz2Xhx3XtLYKe9c9olJZd75ycov8kISJkaOy5Pd
         nEua5M0ov4f4KVG9S7P8N0LISg5CCt/YXD4ockptHfcDQaLjzPWS01MhpsPVHD01mD1A
         o6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f31WRtxRAaJ1ReHamccwuYw+KLj+c2LCAREJ/bMMV3c=;
        b=AH5pVz67AQHwNAzXKtAzY3CyecJcUvA3AIjYkLtRnNY9WQoO9lhZQDCAHEP8U2Hxc4
         0GLO0Cltwb6WexidjctyHENWc+9iNiItpjoScXRgN+ek3hPAnOcMS+HBhzvxS+MpMDGc
         fICx/v99mY/9Ml6eXXkdEyPZti2tIY7G+FpWkjZLggNPJOuNazznntIV17KTkuQMypW8
         5rz+BmF/vKD3TyDKs6p30G1g3xBF9MIOGS+PL4sCmxHRzmLs+7Jqu6DZK4pAN7sM+40i
         W+VWVlF5sIHTjqPs10n3u9+XH4VuAS/cu9t7/VE0WIsKBCspo5qXPdevUmbaVmgtTlis
         Z3gQ==
X-Gm-Message-State: AOAM532C7zAJ2j2KvmLYTIhG85VGjLDDY5QtDlMBC4aiLNo/H8kmVVaU
        I7+mE9V3RpjCM8AW2qzbfJzen1HBdnptlQYRa/ddZSZgZnQ=
X-Google-Smtp-Source: ABdhPJwj0bSJpCKsFAQNW7l21NJ6PZn1RoeYyJeAZJHt0df9t5osbpRnqm83k2dhkDYTZTvXrYYXbxl/6UtX2NUWa/k=
X-Received: by 2002:a5d:4846:: with SMTP id n6mr36037840wrs.249.1636206336953;
 Sat, 06 Nov 2021 06:45:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211105094748.3894453-1-guoren@kernel.org>
In-Reply-To: <20211105094748.3894453-1-guoren@kernel.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 6 Nov 2021 19:15:25 +0530
Message-ID: <CAAhSdy1vyCQdv_gNaNSzU79PC4giCAig6hzgD9JXSXs6+gfFPA@mail.gmail.com>
Subject: Re: [PATCH V7] irqchip/sifive-plic: Fixup EOI failed when masked
To:     Guo Ren <guoren@kernel.org>
Cc:     Atish Patra <atish.patra@wdc.com>, Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Guo Ren <guoren@linux.alibaba.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 5, 2021 at 3:18 PM <guoren@kernel.org> wrote:
>
> From: Guo Ren <guoren@linux.alibaba.com>
>
> When using "devm_request_threaded_irq(,,,,IRQF_ONESHOT,,)" in the driver,
> only the first interrupt could be handled, and continue irq is blocked by
> hw. Because the riscv plic couldn't complete masked irq source which has
> been disabled in enable register. The bug was firstly reported in [1].
>
> Here is the description of Interrupt Completion in PLIC spec [2]:
>
> The PLIC signals it has completed executing an interrupt handler by
> writing the interrupt ID it received from the claim to the claim/complete
> register. The PLIC does not check whether the completion ID is the same
> as the last claim ID for that target. If the completion ID does not match
> an interrupt source that is currently enabled for the target, the
>                          ^^ ^^^^^^^^^ ^^^^^^^
> completion is silently ignored.
>
> [1] http://lists.infradead.org/pipermail/linux-riscv/2021-July/007441.html
> [2] https://github.com/riscv/riscv-plic-spec/blob/8bc15a35d07c9edf7b5d23fec9728302595ffc4d/riscv-plic.adoc
>
> Fixes: bb0fed1c60cc ("irqchip/sifive-plic: Switch to fasteoi flow")
> Reported-by: Vincent Pelletier <plr.vincent@gmail.com>
> Tested-by: Nikita Shubin <nikita.shubin@maquefel.me>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> Cc: stable@vger.kernel.org
> Cc: Anup Patel <anup@brainfault.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Atish Patra <atish.patra@wdc.com>
> Cc: Nikita Shubin <nikita.shubin@maquefel.me>
> Cc: incent Pelletier <plr.vincent@gmail.com>
>
> ---
>
> Changes since V7:
>  - Add Fixes tag
>  - Add Tested-by
>  - Add Cc stable
>
> Changes since V6:
>  - Propagate to plic_irq_eoi for all riscv,plic by Nikita Shubin
>  - Remove thead related codes
>
> Changes since V5:
>  - Move back to mask/unmask
>  - Fixup the problem in eoi callback
>  - Remove allwinner,sun20i-d1 IRQCHIP_DECLARE
>  - Rewrite comment log
>
> Changes since V4:
>  - Update comment by Anup
>
> Changes since V3:
>  - Rename "c9xx" to "c900"
>  - Add sifive_plic_chip and thead_plic_chip for difference
>
> Changes since V2:
>  - Add a separate compatible string "thead,c9xx-plic"
>  - set irq_mask/unmask of "plic_chip" to NULL and point
>    irq_enable/disable of "plic_chip" to plic_irq_mask/unmask
>  - Add a detailed comment block in plic_init() about the
>    differences in Claim/Completion process of RISC-V PLIC and C9xx
>    PLIC.
> ---
>  drivers/irqchip/irq-sifive-plic.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
> index cf74cfa82045..259065d271ef 100644
> --- a/drivers/irqchip/irq-sifive-plic.c
> +++ b/drivers/irqchip/irq-sifive-plic.c
> @@ -163,7 +163,13 @@ static void plic_irq_eoi(struct irq_data *d)
>  {
>         struct plic_handler *handler = this_cpu_ptr(&plic_handlers);
>
> -       writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
> +       if (irqd_irq_masked(d)) {
> +               plic_irq_unmask(d);
> +               writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
> +               plic_irq_mask(d);
> +       } else {
> +               writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
> +       }
>  }
>
>  static struct irq_chip plic_chip = {
> --
> 2.25.1
>
