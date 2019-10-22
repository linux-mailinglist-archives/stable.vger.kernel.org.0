Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E9BE0421
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 14:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbfJVMqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 08:46:34 -0400
Received: from [217.140.110.172] ([217.140.110.172]:51644 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbfJVMqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Oct 2019 08:46:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3248168F;
        Tue, 22 Oct 2019 05:46:11 -0700 (PDT)
Received: from [10.1.194.37] (e113632-lin.cambridge.arm.com [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 420CA3F71F;
        Tue, 22 Oct 2019 05:46:10 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] sched/topology: Don't try to build empty sched
 domains
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc:     lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, qperret@google.com,
        stable@vger.kernel.org
References: <20191015154250.12951-1-valentin.schneider@arm.com>
 <20191015154250.12951-2-valentin.schneider@arm.com>
 <20dc939f-4102-334e-5fde-a442ee7eaa5e@arm.com>
From:   Valentin Schneider <valentin.schneider@arm.com>
Message-ID: <b38c30cd-f990-dd98-b414-c284f8f32cfd@arm.com>
Date:   Tue, 22 Oct 2019 13:46:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20dc939f-4102-334e-5fde-a442ee7eaa5e@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/10/2019 12:43, Dietmar Eggemann wrote:
> First I thought we can do with a little less drama by only preventing
> arch_scale_cpu_capacity() from consuming >= nr_cpu_ids.
> 
> @@ -1894,6 +1894,9 @@ static struct sched_domain_topology_level
>         struct sched_domain_topology_level *tl, *asym_tl = NULL;
>         unsigned long cap;
> 
> +       if (cpumask_empty(cpu_map))
> +               return NULL;
> +
> 
> Until I tried to hp'ed in CPU4 after CPU4/5 had been hp'ed out (your
> example further below) and I got another:
> 
> [   68.014564] Unable to handle kernel paging request at virtual address
> fffe8009903d8ee0
> ...
> [   68.191293] Call trace:
> [   68.193712]  partition_sched_domains_locked+0x1a4/0x4a0
> [   68.198882]  rebuild_sched_domains_locked+0x4d0/0x7b0
> [   68.203880]  rebuild_sched_domains+0x24/0x40
> [   68.208104]  cpuset_hotplug_workfn+0xe0/0x5f8
> ...
> 
> @@ -2213,6 +2216,11 @@ void partition_sched_domains_locked(int
> ndoms_new, cpumask_var_t doms_new[],
>                                * will be recomputed in function
>                                * update_tasks_root_domain().
>                                */
> +                             if (cpumask_empty(doms_cur[i]))
> +                                    printk("doms_cur[%d] empty\n", i);
> +
>                               rd = cpu_rq(cpumask_any(doms_cur[i]))->rd;
> 
> doms_cur[i] is empty when hp'ing in CPU4 again.
> 
> Your patch fixes this as well.
> 

Thanks for giving it a spin!

> Might be worth noting that this is not only about asym CPU capacity
> handling but missing checks after cpumask operations in case the cpuset
> is empty.

Aye, we end up saving whatever we're given (doms_cur = doms_new at the end
of the rebuild). As you pointed out this is also an issue for the operation
done by

  f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")

but it has been introduced after the asymmetry check, hence why I'm tagging
the latter for stable.
