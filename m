Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFF0154372
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgBFLte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgBFLte (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 06:49:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6880921741;
        Thu,  6 Feb 2020 11:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580989773;
        bh=92I49pV9+CFZtlXx3hqZUSrtiPGQqm5WyKohR25KhyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mcSkBO1jrQ4O8gWRSrnqgP6aTucu2CtcURfdn4qZt5p8hsLiOON030sNDusMMNLnR
         sXRirfJdba/AjPMOgtOg9xIIxgyOKybyGIdODwueyknW2H3LG+eSPd+hfDvRhIoRMb
         4s//PyB+EB4cYEXIy6hMcOpOFZC1uBhNHUrBomB0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1izff1-003J3b-NW; Thu, 06 Feb 2020 11:49:31 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Feb 2020 11:49:31 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        kernel-team@android.com, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>
Subject: Re: [PATCH] arm64: ssbs: Fix context-switch when SSBS instructions
 are present
In-Reply-To: <20200206113410.18301-1-will@kernel.org>
References: <20200206113410.18301-1-will@kernel.org>
Message-ID: <10b7b4b0bcc443db7028efbdee789549@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, kernel-team@android.com, stable@vger.kernel.org, catalin.marinas@arm.com, sramana@codeaurora.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-02-06 11:34, Will Deacon wrote:
> When all CPUs in the system implement the SSBS instructions, we
> advertise this via an HWCAP and allow EL0 to toggle the SSBS field
> in PSTATE directly. Consequently, the state of the mitigation is not
> accurately tracked by the TIF_SSBD thread flag and the PSTATE value
> is authoritative.
> 
> Avoid forcing the SSBS field in context-switch on such a system, and
> simply rely on the PSTATE register instead.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Srinivas Ramana <sramana@codeaurora.org>
> Fixes: cbdf8a189a66 ("arm64: Force SSBS on context switch")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kernel/process.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index d54586d5b031..45e867f40a7a 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -466,6 +466,13 @@ static void ssbs_thread_switch(struct task_struct 
> *next)
>  	if (unlikely(next->flags & PF_KTHREAD))
>  		return;
> 
> +	/*
> +	 * If all CPUs implement the SSBS instructions, then we just
> +	 * need to context-switch the PSTATE field.
> +	 */
> +	if (cpu_have_feature(cpu_feature(SSBS)))
> +		return;
> +
>  	/* If the mitigation is enabled, then we leave SSBS clear. */
>  	if ((arm64_get_ssbd_state() == ARM64_SSBD_FORCE_ENABLE) ||
>  	    test_tsk_thread_flag(next, TIF_SSBD))

Looks goot to me.

Reviewed-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...
