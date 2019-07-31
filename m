Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1FA7C16D
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 14:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfGaMfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 08:35:39 -0400
Received: from foss.arm.com ([217.140.110.172]:45742 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfGaMfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 08:35:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22F17344;
        Wed, 31 Jul 2019 05:35:39 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFE023F575;
        Wed, 31 Jul 2019 05:35:37 -0700 (PDT)
Date:   Wed, 31 Jul 2019 13:35:33 +0100
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
Subject: Re: [PATCH v4.4 V2 15/43] arm64: Move cpu_die_early to smp.c
Message-ID: <20190731123532.GA39768@lakrids.cambridge.arm.com>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <dd031e0851c01a0cfe275c05dc24935580d2fd78.1562908075.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd031e0851c01a0cfe275c05dc24935580d2fd78.1562908075.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 10:58:03AM +0530, Viresh Kumar wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> commit fce6361fe9b0caeba0c05b7d72ceda406f8780df upstream.
> 
> This patch moves cpu_die_early to smp.c, where it fits better.
> No functional changes, except for adding the necessary checks
> for CONFIG_HOTPLUG_CPU.
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [ Viresh: Resolved rebase conflict ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

> +void cpu_die_early(void)

> +	asm(
> +	"1:	wfe\n"
> +	"	wfi\n"
> +	"	b	1b");
> +}

Rather than open-coding this loop differently from upstream and the
v4.9.y backport, please backport commit:

  c4bc34d20273db69 ("arm64: Add a helper for parking CPUs in a loop")

... as a prerequisite of this patch.

Otherwise, this looks fine to me.

Thanks,
Mark.
