Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31EE446E12
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 14:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhKFNi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 09:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbhKFNi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 09:38:59 -0400
X-Greylist: delayed 473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 06 Nov 2021 06:36:17 PDT
Received: from forward501p.mail.yandex.net (forward501p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B431BC061570;
        Sat,  6 Nov 2021 06:36:17 -0700 (PDT)
Received: from vla5-836e2f83e8f0.qloud-c.yandex.net (vla5-836e2f83e8f0.qloud-c.yandex.net [IPv6:2a02:6b8:c18:348b:0:640:836e:2f83])
        by forward501p.mail.yandex.net (Yandex) with ESMTP id E2EEF6212528;
        Sat,  6 Nov 2021 16:28:21 +0300 (MSK)
Received: from vla3-3dd1bd6927b2.qloud-c.yandex.net (vla3-3dd1bd6927b2.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:3dd1:bd69])
        by vla5-836e2f83e8f0.qloud-c.yandex.net (mxback/Yandex) with ESMTP id sAB0i1kmQw-SLCmM15q;
        Sat, 06 Nov 2021 16:28:21 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1636205301;
        bh=Z5QVA2pkOETIbu65nWlqH2zmDSY3CFNfPgpINclXmq4=;
        h=In-Reply-To:Subject:To:From:References:Date:Message-ID:Cc;
        b=YtUF/mdFBa6g6fv+lbJ8VQ9C5O/dBseTC3Di04q2cdwtFUZ2ikapk302vQY/kS1wa
         5Ra7DhqcwwdWTezjReGGzU7GZa4Ex2Gg2h+txmt7TaxtNoZldfTFFvKelTTDVqjiny
         31egxeuo2hX8ph0RvMTtVKmkZAJoargdcybyXAS0=
Authentication-Results: vla5-836e2f83e8f0.qloud-c.yandex.net; dkim=pass header.i=@maquefel.me
Received: by vla3-3dd1bd6927b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPS id SI9GU8Pu6X-SKLmORfB;
        Sat, 06 Nov 2021 16:28:20 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Date:   Sat, 6 Nov 2021 16:28:19 +0300
From:   Nikita Shubin <nikita.shubin@maquefel.me>
To:     Aurelien Jarno <aurelien@aurel32.net>
Cc:     guoren@kernel.org, anup@brainfault.org, atish.patra@wdc.com,
        maz@kernel.org, tglx@linutronix.de, palmer@dabbelt.com,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH V7] irqchip/sifive-plic: Fixup EOI failed when masked
Message-ID: <20211106162819.1f5c08ed@redslave.neermore.group>
In-Reply-To: <YYZxB0LN2iYhj+nz@aurel32.net>
References: <20211105094748.3894453-1-guoren@kernel.org>
        <YYZxB0LN2iYhj+nz@aurel32.net>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, Aurelien!

On Sat, 6 Nov 2021 13:11:51 +0100
Aurelien Jarno <aurelien@aurel32.net> wrote:

> On 2021-11-05 17:47, guoren@kernel.org wrote:
> > From: Guo Ren <guoren@linux.alibaba.com>
> > 
> > When using "devm_request_threaded_irq(,,,,IRQF_ONESHOT,,)" in the
> > driver, only the first interrupt could be handled, and continue irq
> > is blocked by hw. Because the riscv plic couldn't complete masked
> > irq source which has been disabled in enable register. The bug was
> > firstly reported in [1].
> > 
> > Here is the description of Interrupt Completion in PLIC spec [2]:
> > 
> > The PLIC signals it has completed executing an interrupt handler by
> > writing the interrupt ID it received from the claim to the
> > claim/complete register. The PLIC does not check whether the
> > completion ID is the same as the last claim ID for that target. If
> > the completion ID does not match an interrupt source that is
> > currently enabled for the target, the ^^ ^^^^^^^^^ ^^^^^^^
> > completion is silently ignored.
> > 
> > [1]
> > http://lists.infradead.org/pipermail/linux-riscv/2021-July/007441.html
> > [2]
> > https://github.com/riscv/riscv-plic-spec/blob/8bc15a35d07c9edf7b5d23fec9728302595ffc4d/riscv-plic.adoc
> > 
> > Fixes: bb0fed1c60cc ("irqchip/sifive-plic: Switch to fasteoi flow")
> > Reported-by: Vincent Pelletier <plr.vincent@gmail.com>
> > Tested-by: Nikita Shubin <nikita.shubin@maquefel.me>
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Cc: stable@vger.kernel.org
> > Cc: Anup Patel <anup@brainfault.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Palmer Dabbelt <palmer@dabbelt.com>
> > Cc: Atish Patra <atish.patra@wdc.com>
> > Cc: Nikita Shubin <nikita.shubin@maquefel.me>
> > Cc: incent Pelletier <plr.vincent@gmail.com>  
> 
> Thanks for this patch. From what I understand, it fixes among other
> things the possibility to read the DA9063 RTC more than once.

Well RTC works definitely, through you need some patch to use it as a
wakeup source:

https://lkml.org/lkml/2021/11/1/800

and, AFAIK currently SiFive Unmatched lack's PM.

I still haven't tested the Watchdog and Onkey.

> 
> Does it means that we could now enable it in the device tree? I mean
> something like the following patch that unfortunately I can't test
> now:

Adding RTC is really useful and adding Watchdog along with Onkey
shouldn't make any harm.

> 
> diff --git a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
> b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts index
> 2e4ea84f27e7..c357b48582f7 100644 ---
> a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts +++
> b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts @@ -70,6 +70,10
> @@ pmic@58 { interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
>  		interrupt-controller;
>  
> +		onkey {
> +			compatible = "dlg,da9063-onkey";
> +		};
> +
>  		regulators {
>  			vdd_bcore1: bcore1 {
>  				regulator-min-microvolt = <900000>;
> @@ -205,6 +209,14 @@ vdd_ldo11: ldo11 {
>  				regulator-always-on;
>  			};
>  		};
> +
> +		rtc {
> +			compatible = "dlg,da9063-rtc";
> +		};
> +
> +		wdt {
> +			compatible = "dlg,da9063-watchdog";
> +		};
>  	};
>  };
> 

