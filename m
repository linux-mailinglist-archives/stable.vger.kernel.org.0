Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E0535A16C
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 16:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbhDIOr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 10:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233896AbhDIOrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 10:47:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 895DD610D0;
        Fri,  9 Apr 2021 14:47:41 +0000 (UTC)
Date:   Fri, 9 Apr 2021 15:47:39 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] arm64: mte: Move MTE TCF0 check in entry-common
Message-ID: <20210409144738.GB24031@arm.com>
References: <20210409132419.29965-1-vincenzo.frascino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409132419.29965-1-vincenzo.frascino@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 02:24:19PM +0100, Vincenzo Frascino wrote:
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index b3c70a612c7a..84a942c25870 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -166,14 +166,43 @@ static void set_gcr_el1_excl(u64 excl)
>  	 */
>  }
>  
> -void flush_mte_state(void)
> +void noinstr check_mte_async_tcf0(void)

Nitpick: it looks like naming isn't be entirely consistent with your
kernel async patches:

https://lore.kernel.org/linux-arm-kernel/20210315132019.33202-8-vincenzo.frascino@arm.com/

You could name them mte_check_tfsre0_el1() etc. Also make sure they are
called in similar places in both series.

> +{
> +	u64 tcf0;
> +
> +	if (!system_supports_mte())
> +		return;
> +
> +	/*
> +	 * dsb(ish) is not required before the register read
> +	 * because the TFSRE0_EL1 is automatically synchronized
> +	 * by the hardware on exception entry as SCTLR_EL1.ITFSB
> +	 * is set.
> +	 */
> +	tcf0 = read_sysreg_s(SYS_TFSRE0_EL1);
> +
> +	if (tcf0 & SYS_TFSR_EL1_TF0)
> +		set_thread_flag(TIF_MTE_ASYNC_FAULT);
> +
> +	write_sysreg_s(0, SYS_TFSRE0_EL1);

Please move the write_sysreg() inside the 'if' block. If it was 0,
there's no point in a potentially more expensive write.

That said, we only check TFSRE0_EL1 on entry from EL0. Is there a point
in clearing it before we return to EL0? Uaccess routines may set it
anyway.

> +}
> +
> +void noinstr clear_mte_async_tcf0(void)
>  {
>  	if (!system_supports_mte())
>  		return;
>  
> -	/* clear any pending asynchronous tag fault */
>  	dsb(ish);
>  	write_sysreg_s(0, SYS_TFSRE0_EL1);
> +}

I think Mark suggested on your first version that we should keep these
functions in mte.h so that they can be inlined. They are small and only
called in one or two places.

-- 
Catalin
