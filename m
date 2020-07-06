Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586D0215C57
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 18:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbgGFQz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 12:55:57 -0400
Received: from foss.arm.com ([217.140.110.172]:56062 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729495AbgGFQz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 12:55:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AAC41FB;
        Mon,  6 Jul 2020 09:55:56 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.13.106])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2529F3F68F;
        Mon,  6 Jul 2020 09:55:53 -0700 (PDT)
Date:   Mon, 6 Jul 2020 17:55:44 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] arm64: arch_timer: Allow an workaround descriptor
 to disable compat vdso
Message-ID: <20200706165534.GA61340@C02TD0UTHF1T.local>
References: <20200706163802.1836732-1-maz@kernel.org>
 <20200706163802.1836732-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706163802.1836732-3-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 06, 2020 at 05:38:00PM +0100, Marc Zyngier wrote:
> As we are about to disable the vdso for compat tasks in some circumstances,
> let's allow a workaround descriptor to express exactly that.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/include/asm/arch_timer.h  | 1 +
>  drivers/clocksource/arm_arch_timer.c | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index 7ae54d7d333a..9f0ec21d6327 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -58,6 +58,7 @@ struct arch_timer_erratum_workaround {
>  	u64 (*read_cntvct_el0)(void);
>  	int (*set_next_event_phys)(unsigned long, struct clock_event_device *);
>  	int (*set_next_event_virt)(unsigned long, struct clock_event_device *);
> +	bool disable_compat_vdso;
>  };
>  
>  DECLARE_PER_CPU(const struct arch_timer_erratum_workaround *,
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index ecf7b7db2d05..a8e4fb429f52 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -566,6 +566,9 @@ void arch_timer_enable_workaround(const struct arch_timer_erratum_workaround *wa
>  	if (wa->read_cntvct_el0) {
>  		clocksource_counter.vdso_clock_mode = VDSO_CLOCKMODE_NONE;
>  		vdso_default = VDSO_CLOCKMODE_NONE;
> +	} else if (wa->disable_compat_vdso && vdso_default != VDSO_CLOCKMODE_NONE) {
> +		vdso_default = VDSO_CLOCKMODE_ARCHTIMER_NOCOMPAT;
> +		clocksource_counter.vdso_clock_mode = vdso_default;
>  	}
>  }
>  
> -- 
> 2.27.0
> 
