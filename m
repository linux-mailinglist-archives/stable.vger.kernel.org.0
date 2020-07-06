Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5A0215C60
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 18:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgGFQ5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 12:57:19 -0400
Received: from foss.arm.com ([217.140.110.172]:56196 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729651AbgGFQ5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 12:57:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D43B1FB;
        Mon,  6 Jul 2020 09:57:18 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.13.106])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D41DA3F68F;
        Mon,  6 Jul 2020 09:57:15 -0700 (PDT)
Date:   Mon, 6 Jul 2020 17:57:12 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] arm64: arch_timer: Disable the compat vdso for
 cores affected by ARM64_WORKAROUND_1418040
Message-ID: <20200706165712.GB61340@C02TD0UTHF1T.local>
References: <20200706163802.1836732-1-maz@kernel.org>
 <20200706163802.1836732-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706163802.1836732-4-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 06, 2020 at 05:38:01PM +0100, Marc Zyngier wrote:
> ARM64_WORKAROUND_1418040 requires that AArch32 EL0 accesses to
> the virtual counter register are trapped and emulated by the kernel.
> This makes the vdso pretty pointless, and in some cases livelock
> prone.
> 
> Provide a workaround entry that limits the vdso to 64bit tasks.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  drivers/clocksource/arm_arch_timer.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index a8e4fb429f52..6c3e84180146 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -480,6 +480,14 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
>  		.set_next_event_virt = erratum_set_next_event_tval_virt,
>  	},
>  #endif
> +#ifdef CONFIG_ARM64_ERRATUM_1418040
> +	{
> +		.match_type = ate_match_local_cap_id,
> +		.id = (void *)ARM64_WORKAROUND_1418040,
> +		.desc = "ARM erratum 1418040",
> +		.disable_compat_vdso = true,
> +	},
> +#endif
>  };
>  
>  typedef bool (*ate_match_fn_t)(const struct arch_timer_erratum_workaround *,
> -- 
> 2.27.0
> 
