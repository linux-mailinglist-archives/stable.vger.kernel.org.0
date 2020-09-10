Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D170264353
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 12:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgIJKKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 06:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730380AbgIJKKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 06:10:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 598B220BED;
        Thu, 10 Sep 2020 10:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599732604;
        bh=6NsRRIZOYZGI15PFFB2tX8VoaM4wqNIrphKoqkih9IM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XnQQoV9xR8khV2sGFbRjeYw6C5wlG0pj81fyFFbQy+6FFuVPzbleUgLWqJMPd1NiH
         cQz9f2ayKrk0u+mc2bIu4g7HaXhTLY/RnRy7IYN23vfhSCS2HtOpHn/TNmKphZNqrh
         rpSYCuFaiZjkwIUN3VaFgHGRob0Rom6V6CTdZbsQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kGJWk-00Ae6D-Av; Thu, 10 Sep 2020 11:10:02 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Sep 2020 11:10:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] MIPS: Loongson64: Increase NR_IRQS to 320
In-Reply-To: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <894f35a7883451c4c2bf91b6181376fb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: chenhc@lemote.com, tsbogend@alpha.franken.de, tglx@linutronix.de, jason@lakedaemon.net, linux-mips@vger.kernel.org, zhangfx@lemote.com, chenhuacai@gmail.com, jiaxun.yang@flygoat.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-09 05:09, Huacai Chen wrote:
> Modernized Loongson64 uses a hierarchical organization for interrupt
> controllers (INTCs), all INTC nodes (not only leaf nodes) need some IRQ
> numbers. This means 280 (i.e., NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> is not enough to represent all interrupts, so let's increase NR_IRQS to
> 320.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/include/asm/mach-loongson64/irq.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/asm/mach-loongson64/irq.h
> b/arch/mips/include/asm/mach-loongson64/irq.h
> index f5e362f7..0da3017 100644
> --- a/arch/mips/include/asm/mach-loongson64/irq.h
> +++ b/arch/mips/include/asm/mach-loongson64/irq.h
> @@ -7,7 +7,7 @@
>  /* cpu core interrupt numbers */
>  #define NR_IRQS_LEGACY		16
>  #define NR_MIPS_CPU_IRQS	8
> -#define NR_IRQS			(NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> +#define NR_IRQS			320
> 
>  #define MIPS_CPU_IRQ_BASE 	NR_IRQS_LEGACY

Why are you hardcoding a random value instead of bumping the constant
in NR_IRQS?

         M.
-- 
Jazz is not dead. It just smells funny...
