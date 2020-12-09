Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9A42D471D
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 17:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgLIQse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 11:48:34 -0500
Received: from foss.arm.com ([217.140.110.172]:37504 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgLIQse (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 11:48:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32E961FB;
        Wed,  9 Dec 2020 08:47:48 -0800 (PST)
Received: from [192.168.2.21] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBBB63F68F;
        Wed,  9 Dec 2020 08:47:45 -0800 (PST)
Subject: Re: [PATCH 1/3] x86/resctrl: Move setting task's active CPU in a mask
 into helpers
To:     Reinette Chatre <reinette.chatre@intel.com>, fenghua.yu@intel.com
Cc:     tglx@linutronix.de, bp@alien8.de, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <77973e75a10bf7ef9b33c664544667deee9e1a8e.1607036601.git.reinette.chatre@intel.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <a782d2f3-d2f6-795f-f4b1-9462205fd581@arm.com>
Date:   Wed, 9 Dec 2020 16:47:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <77973e75a10bf7ef9b33c664544667deee9e1a8e.1607036601.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Reinette, Fenghua,

On 03/12/2020 23:25, Reinette Chatre wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> The code of setting the CPU on which a task is running in a CPU mask is
> moved into a couple of helpers. The new helper task_on_cpu() will be
> reused shortly.

> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 6f4ca4bea625..68db7d2dec8f 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -525,6 +525,38 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)

> +#ifdef CONFIG_SMP

(using IS_ENABLED(CONFIG_SMP) lets the compiler check all the code in one go, then
dead-code-remove the stuff that will never happen... its also easier on the eye!)


> +/* Get the CPU if the task is on it. */
> +static bool task_on_cpu(struct task_struct *t, int *cpu)
> +{
> +	/*
> +	 * This is safe on x86 w/o barriers as the ordering of writing to
> +	 * task_cpu() and t->on_cpu is reverse to the reading here. The
> +	 * detection is inaccurate as tasks might move or schedule before
> +	 * the smp function call takes place. In such a case the function
> +	 * call is pointless, but there is no other side effect.
> +	 */

> +	if (t->on_cpu) {

kernel/sched/core.c calls out that there can be two tasks on one CPU with this set.
(grep astute)
I think that means this series will falsely match the old task for a CPU while the
scheduler is running, and IPI it unnecessarily.

task_curr() is the helper that knows not to do this.


> +		*cpu = task_cpu(t);
> +
> +		return true;
> +	}
> +
> +	return false;
> +}


Thanks,

James
