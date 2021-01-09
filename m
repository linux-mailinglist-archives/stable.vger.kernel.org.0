Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41452F034F
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 21:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbhAIUCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 15:02:50 -0500
Received: from [78.8.192.131] ([78.8.192.131]:12716 "EHLO orcam.me.uk"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbhAIUCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 15:02:50 -0500
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jan 2021 15:02:49 EST
Received: from cvs.linux-mips.org (eddie.linux-mips.org [148.251.95.138])
        by orcam.me.uk (Postfix) with ESMTPS id D7E412BE0EC;
        Sat,  9 Jan 2021 19:53:52 +0000 (GMT)
Date:   Sat, 9 Jan 2021 19:53:19 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Aurelien Jarno <aurelien@aurel32.net>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        YunQiang Su <syq@debian.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Support binutils configured with
 --enable-mips-fix-loongson3-llsc=yes
In-Reply-To: <20210109193048.478339-1-aurelien@aurel32.net>
Message-ID: <alpine.LFD.2.21.2101091944330.1637534@eddie.linux-mips.org>
References: <20210109193048.478339-1-aurelien@aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 9 Jan 2021, Aurelien Jarno wrote:

> diff --git a/arch/mips/Makefile b/arch/mips/Makefile
> index cd4343edeb11..5ffdd67093bc 100644
> --- a/arch/mips/Makefile
> +++ b/arch/mips/Makefile
> @@ -136,6 +136,25 @@ cflags-$(CONFIG_SB1XXX_CORELIS)	+= $(call cc-option,-mno-sched-prolog) \
>  #
>  cflags-y += -fno-stack-check
>  
> +# binutils from v2.35 when built with --enable-mips-fix-loongson3-llsc=yes,
> +# supports an -mfix-loongson3-llsc flag which emits a sync prior to each ll
> +# instruction to work around a CPU bug (see __SYNC_loongson3_war in asm/sync.h
> +# for a description).
> +#
> +# We disable this in order to prevent the assembler meddling with the
> +# instruction that labels refer to, ie. if we label an ll instruction:
> +#
> +# 1: ll v0, 0(a0)
> +#
> +# ...then with the assembler fix applied the label may actually point at a sync
> +# instruction inserted by the assembler, and if we were using the label in an
> +# exception table the table would no longer contain the address of the ll
> +# instruction.

 Interesting.  Given that a MIPS assembler is generally free to shuffle 
instructions as it sees fit in its default reorder mode as long as that 
does not change the semantics of the code executed, shouldn't we instead 
place all label/instruction pairs used for exception handling in noreorder 
blocks so as to make sure the label refers to the instruction an exception 
handler expects it to?

 E.g. for the case quoted above:

	.set	push
	.set	noreorder
1:	ll	v0, 0(a0)
	.set	pop

  Maciej

