Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F42A2D1889
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 19:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgLGS35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 13:29:57 -0500
Received: from mail.skyhub.de ([5.9.137.197]:43648 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgLGS35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 13:29:57 -0500
Received: from zn.tnic (p200300ec2f0a380064629ff712875f88.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:3800:6462:9ff7:1287:5f88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 37ACB1EC0266;
        Mon,  7 Dec 2020 19:29:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1607365756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UcgJt3nxSKpwchL/iP2ux1Mxz2gg4VyE+PHYmJH7Ers=;
        b=TINAG4raZW9HXC9+zvnMHq3Hd/A/VIdV6GeOubaoSo9HZGEjZT4pf1/XZlQ5kEWK8sGRp1
        W69ROu759QdWgoz3ZQDlVyYh/YF2ePApgEt9vm5MZbMIzXFFWkcDLVlDWDWgLlEAupu2kj
        oyMgjaAzIj8YfJkU9ubfRco9h4ieyXs=
Date:   Mon, 7 Dec 2020 19:29:12 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        james.morse@arm.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/resctrl: Move setting task's active CPU in a
 mask into helpers
Message-ID: <20201207182912.GF20489@zn.tnic>
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <77973e75a10bf7ef9b33c664544667deee9e1a8e.1607036601.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <77973e75a10bf7ef9b33c664544667deee9e1a8e.1607036601.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 03:25:48PM -0800, Reinette Chatre wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> The code of setting the CPU on which a task is running in a CPU mask is
> moved into a couple of helpers.

Pls read section "2) Describe your changes" in
Documentation/process/submitting-patches.rst for more details.

More specifically:

"Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
to do frotz", as if you are giving orders to the codebase to change
its behaviour."

> The new helper task_on_cpu() will be reused shortly.

"reused shortly"? I don't think so.

> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Cc: stable@vger.kernel.org

Fixes?

I guess the same commit from the other two:

Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")

?

> ---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 47 +++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 6f4ca4bea625..68db7d2dec8f 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -525,6 +525,38 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)
>  	kfree(rdtgrp);
>  }
>  
> +#ifdef CONFIG_SMP
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
> +		*cpu = task_cpu(t);

Why have an I/O parameter when you can make it simply:

static int task_on_cpu(struct task_struct *t)
{
	if (t->on_cpu)
		return task_cpu(t);

	return -1;
}

> +
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static void set_task_cpumask(struct task_struct *t, struct cpumask *mask)
> +{
> +	int cpu;
> +
> +	if (mask && task_on_cpu(t, &cpu))
> +		cpumask_set_cpu(cpu, mask);

And that you can turn into:

	if (!mask)
		return;

	cpu = task_on_cpu(t);
	if (cpu < 0)
		return;

	cpumask_set_cpu(cpu, mask);

Readable and simple.

Hmm?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
