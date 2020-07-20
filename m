Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69194227013
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 22:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgGTUyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 16:54:20 -0400
Received: from mail.baikalelectronics.com ([87.245.175.226]:51598 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgGTUyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 16:54:19 -0400
Received: from localhost (unknown [127.0.0.1])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 261A78030867;
        Mon, 20 Jul 2020 20:54:13 +0000 (UTC)
X-Virus-Scanned: amavisd-new at baikalelectronics.ru
Received: from mail.baikalelectronics.ru ([127.0.0.1])
        by localhost (mail.baikalelectronics.ru [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pC6jqx2WqjEa; Mon, 20 Jul 2020 23:54:12 +0300 (MSK)
Date:   Mon, 20 Jul 2020 23:54:10 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Huacai Chen <chenhc@lemote.com>
CC:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        <linux-mips@vger.kernel.org>, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "Stable # 4 . 4/4 . 9/4 . 14/4 . 19" <stable@vger.kernel.org>
Subject: Re: [PATCH -stable] MIPS: Fix build for LTS kernel caused by
 backporting lpj adjustment
Message-ID: <20200720205410.qicgkpbyikenagbx@mobilestation>
References: <1594892369-28060-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1594892369-28060-1-git-send-email-chenhc@lemote.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Huacai,

Thanks for the fix. The patch looks good to me except a small cleanup
comment.

On Thu, Jul 16, 2020 at 05:39:29PM +0800, Huacai Chen wrote:
> Commit ed26aacfb5f71eecb20a ("mips: Add udelay lpj numbers adjustment")
> has backported to 4.4~5.4, but the "struct cpufreq_freqs" (and also the
> cpufreq notifier machanism) of 4.4~4.19 are different from the upstream
> kernel. These differences cause build errors, and this patch can fix the
> build.
> 
> Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Cc: Stable <stable@vger.kernel.org> # 4.4/4.9/4.14/4.19
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/kernel/time.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
> index b7f7e08..b15ee12 100644
> --- a/arch/mips/kernel/time.c
> +++ b/arch/mips/kernel/time.c
> @@ -40,10 +40,8 @@ static unsigned long glb_lpj_ref_freq;
>  static int cpufreq_callback(struct notifier_block *nb,
>  			    unsigned long val, void *data)
>  {
> -	struct cpufreq_freqs *freq = data;
> -	struct cpumask *cpus = freq->policy->cpus;
> -	unsigned long lpj;
>  	int cpu;
> +	struct cpufreq_freqs *freq = data;

Why do you want to rearrange the cpu and freq variables declarations?
IMO the order should be left as before since the change doesn't really
make the code looking or working any better. If so the change is unneeded.
Moreover reverse xmas tree-like variables declaration looks neater than any
other.

After fixing that feel free to add

Reviewed-by: Serge Semin <fancer.lancer@gmail.com>

-Sergey

>  
>  	/*
>  	 * Skip lpj numbers adjustment if the CPU-freq transition is safe for
> @@ -64,6 +62,7 @@ static int cpufreq_callback(struct notifier_block *nb,
>  		}
>  	}
>  
> +	cpu = freq->cpu;
>  	/*
>  	 * Adjust global lpj variable and per-CPU udelay_val number in
>  	 * accordance with the new CPU frequency.
> @@ -74,12 +73,8 @@ static int cpufreq_callback(struct notifier_block *nb,
>  						glb_lpj_ref_freq,
>  						freq->new);
>  
> -		for_each_cpu(cpu, cpus) {
> -			lpj = cpufreq_scale(per_cpu(pcp_lpj_ref, cpu),
> -					    per_cpu(pcp_lpj_ref_freq, cpu),
> -					    freq->new);
> -			cpu_data[cpu].udelay_val = (unsigned int)lpj;
> -		}
> +		cpu_data[cpu].udelay_val = cpufreq_scale(per_cpu(pcp_lpj_ref, cpu),
> +					   per_cpu(pcp_lpj_ref_freq, cpu), freq->new);
>  	}
>  
>  	return NOTIFY_OK;
> -- 
> 2.7.0
> 
