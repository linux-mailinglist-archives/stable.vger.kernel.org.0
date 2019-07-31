Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E95B7C914
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 18:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfGaQqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 12:46:00 -0400
Received: from foss.arm.com ([217.140.110.172]:51498 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfGaQqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 12:46:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6337337;
        Wed, 31 Jul 2019 09:45:59 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 814443F71F;
        Wed, 31 Jul 2019 09:45:58 -0700 (PDT)
Date:   Wed, 31 Jul 2019 17:45:56 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 V2 24/43] arm64: Add skeleton to harden the branch
 predictor against aliasing attacks
Message-ID: <20190731164556.GI39768@lakrids.cambridge.arm.com>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <4349161f0ed572bbc6bff64bad94aa96d07b27ff.1562908075.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4349161f0ed572bbc6bff64bad94aa96d07b27ff.1562908075.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 10:58:12AM +0530, Viresh Kumar wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> commit 0f15adbb2861ce6f75ccfc5a92b19eae0ef327d0 upstream.
> 
> Aliasing attacks against CPU branch predictors can allow an attacker to
> redirect speculative control flow on some CPUs and potentially divulge
> information from one context to another.
> 
> This patch adds initial skeleton code behind a new Kconfig option to
> enable implementation-specific mitigations against these attacks for
> CPUs that are affected.
> 
> Co-developed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [ v4.4: Changes made according to 4.4 codebase ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

[...]

>  /* id_aa64pfr0 */
> +#define ID_AA64PFR0_CSV2_SHIFT		56

Note: CSV3 is bits 63-60, 

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 474b34243521..040a42d79990 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -83,7 +83,8 @@ static struct arm64_ftr_bits ftr_id_aa64isar0[] = {
>  };
>  
>  static struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
> -	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 32, 32, 0),
> +	ARM64_FTR_BITS(FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 32, 28, 0),

This line should be:

	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 32, 24, 0),

... as it was in the v4.9 backbort, making it cover bits 55:32. As in
this patch, it covers 59:32, overlapping with CSV2.

We also need to cater for bits 63:60. In the v4.9 backport, the meltdown
bits were applied first, so nothing special was necessary.

What's the plan w.r.t. meltdown mitigations and v4.4?

Thanks,
Mark.
