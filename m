Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BCE1EFC4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbfEOLf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:35:59 -0400
Received: from 5.mo173.mail-out.ovh.net ([46.105.40.148]:50792 "EHLO
        5.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfEOLdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 07:33:04 -0400
X-Greylist: delayed 4198 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 May 2019 07:33:03 EDT
Received: from player761.ha.ovh.net (unknown [10.109.143.209])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 658ED10813E
        for <stable@vger.kernel.org>; Wed, 15 May 2019 12:13:35 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player761.ha.ovh.net (Postfix) with ESMTPSA id 2F9C65CA0640;
        Wed, 15 May 2019 10:13:26 +0000 (UTC)
Subject: Re: [PATCH] powerpc/pseries: Fix xive=off command line
To:     Greg Kurz <groug@kaod.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, pavrampu@in.ibm.com
References: <155791470178.432724.8008395673479905061.stgit@bahia.lan>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <f627ac6d-1237-a980-b6a3-13f571d6d9c3@kaod.org>
Date:   Wed, 15 May 2019 12:13:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <155791470178.432724.8008395673479905061.stgit@bahia.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 16595201680402844598
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrleekgddvjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 12:05 PM, Greg Kurz wrote:
> On POWER9, if the hypervisor supports XIVE exploitation mode, the guest OS
> will unconditionally requests for the XIVE interrupt mode even if XIVE was
> deactivated with the kernel command line xive=off. Later on, when the spapr
> XIVE init code handles xive=off, it disables XIVE and tries to fall back on
> the legacy mode XICS.
> 
> This discrepency causes a kernel panic because the hypervisor is configured
> to provide the XIVE interrupt mode to the guest :
> 
> [    0.008837] kernel BUG at arch/powerpc/sysdev/xics/xics-common.c:135!
> [    0.008877] Oops: Exception in kernel mode, sig: 5 [#1]
> [    0.008908] LE SMP NR_CPUS=1024 NUMA pSeries
> [    0.008939] Modules linked in:
> [    0.008964] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.0.13-200.fc29.ppc64le #1
> [    0.009018] NIP:  c000000001029ab8 LR: c000000001029aac CTR: c0000000018e0000
> [    0.009065] REGS: c0000007f96d7900 TRAP: 0700   Tainted: G        W          (5.0.13-200.fc29.ppc64le)
> [    0.009119] MSR:  8000000002029033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 28000222  XER: 20040000
> [    0.009168] CFAR: c0000000001b1e28 IRQMASK: 0
> [    0.009168] GPR00: c000000001029aac c0000007f96d7b90 c0000000015e8600 0000000000000000
> [    0.009168] GPR04: 0000000000000001 0000000000000000 0000000000000061 646f6d61696e0d0a
> [    0.009168] GPR08: 00000007fd8f0000 0000000000000001 c0000000014c44c0 c0000007f96d76cf
> [    0.009168] GPR12: 0000000000000000 c0000000018e0000 0000000000000001 0000000000000000
> [    0.009168] GPR16: 0000000000000000 0000000000000001 c0000007f96d7c08 c0000000016903d0
> [    0.009168] GPR20: c0000007fffe04e8 ffffffffffffffea c000000001620164 c00000000161fe58
> [    0.009168] GPR24: c000000000ea6c88 c0000000011151a8 00000000006000c0 c0000007f96d7c34
> [    0.009168] GPR28: 0000000000000000 c0000000014b286c c000000001115180 c00000000161dc70
> [    0.009558] NIP [c000000001029ab8] xics_smp_probe+0x38/0x98
> [    0.009590] LR [c000000001029aac] xics_smp_probe+0x2c/0x98
> [    0.009622] Call Trace:
> [    0.009639] [c0000007f96d7b90] [c000000001029aac] xics_smp_probe+0x2c/0x98 (unreliable)
> [    0.009687] [c0000007f96d7bb0] [c000000001033404] pSeries_smp_probe+0x40/0xa0
> [    0.009734] [c0000007f96d7bd0] [c0000000010212a4] smp_prepare_cpus+0x62c/0x6ec
> [    0.009782] [c0000007f96d7cf0] [c0000000010141b8] kernel_init_freeable+0x148/0x448
> [    0.009829] [c0000007f96d7db0] [c000000000010ba4] kernel_init+0x2c/0x148
> [    0.009870] [c0000007f96d7e20] [c00000000000bdd4] ret_from_kernel_thread+0x5c/0x68
> [    0.009916] Instruction dump:
> [    0.009940] 7c0802a6 60000000 7c0802a6 38800002 f8010010 f821ffe1 3c62001c e863b9a0
> [    0.009988] 4b1882d1 60000000 7c690034 5529d97e <0b090000> 3d22001c e929b998 3ce2ff8f
> 
> Look for xive=off during prom_init and don't ask for XIVE in this case. One
> exception though: if the host only supports XIVE, we still want to boot so
> we ignore xive=off.
> 
> Similarly, have the spapr XIVE init code to looking at the interrupt mode
> negociated during CAS, and ignore xive=off if the hypervisor only supports
> XIVE.
> 
> Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
> Cc: stable@vger.kernel.org # v4.20
> Reported-by: Pavithra R. Prakash <pavrampu@in.ibm.com>
> Signed-off-by: Greg Kurz <groug@kaod.org>


Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

> ---
> eac1e731b59e is a v4.16 commit actually but this patch only applies
> cleanly to v4.20 and newer. If needed I can send a backport for
> older versions.
> ---
>  arch/powerpc/kernel/prom_init.c  |   16 +++++++++++-
>  arch/powerpc/sysdev/xive/spapr.c |   52 +++++++++++++++++++++++++++++++++++++-
>  2 files changed, 66 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
> index 523bb99d7676..c8f7eb845927 100644
> --- a/arch/powerpc/kernel/prom_init.c
> +++ b/arch/powerpc/kernel/prom_init.c
> @@ -172,6 +172,7 @@ static unsigned long __prombss prom_tce_alloc_end;
>  
>  #ifdef CONFIG_PPC_PSERIES
>  static bool __prombss prom_radix_disable;
> +static bool __prombss prom_xive_disable;
>  #endif
>  
>  struct platform_support {
> @@ -808,6 +809,12 @@ static void __init early_cmdline_parse(void)
>  	}
>  	if (prom_radix_disable)
>  		prom_debug("Radix disabled from cmdline\n");
> +
> +	opt = prom_strstr(prom_cmd_line, "xive=off");
> +	if (opt) {
> +		prom_xive_disable = true;
> +		prom_debug("XIVE disabled from cmdline\n");
> +	}
>  #endif /* CONFIG_PPC_PSERIES */
>  }
>  
> @@ -1216,10 +1223,17 @@ static void __init prom_parse_xive_model(u8 val,
>  	switch (val) {
>  	case OV5_FEAT(OV5_XIVE_EITHER): /* Either Available */
>  		prom_debug("XIVE - either mode supported\n");
> -		support->xive = true;
> +		support->xive = !prom_xive_disable;
>  		break;
>  	case OV5_FEAT(OV5_XIVE_EXPLOIT): /* Only Exploitation mode */
>  		prom_debug("XIVE - exploitation mode supported\n");
> +		if (prom_xive_disable) {
> +			/*
> +			 * If we __have__ to do XIVE, we're better off ignoring
> +			 * the command line rather than not booting.
> +			 */
> +			prom_printf("WARNING: Ignoring cmdline option xive=off\n");
> +		}
>  		support->xive = true;
>  		break;
>  	case OV5_FEAT(OV5_XIVE_LEGACY): /* Only Legacy mode */
> diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
> index 575db3b06a6b..2e2d1b8f810f 100644
> --- a/arch/powerpc/sysdev/xive/spapr.c
> +++ b/arch/powerpc/sysdev/xive/spapr.c
> @@ -20,6 +20,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/mm.h>
>  #include <linux/delay.h>
> +#include <linux/libfdt.h>
>  
>  #include <asm/prom.h>
>  #include <asm/io.h>
> @@ -663,6 +664,55 @@ static bool xive_get_max_prio(u8 *max_prio)
>  	return true;
>  }
>  
> +static const u8 *get_vec5_feature(unsigned int index)
> +{
> +	unsigned long root, chosen;
> +	int size;
> +	const u8 *vec5;
> +
> +	root = of_get_flat_dt_root();
> +	chosen = of_get_flat_dt_subnode_by_name(root, "chosen");
> +	if (chosen == -FDT_ERR_NOTFOUND)
> +		return NULL;
> +
> +	vec5 = of_get_flat_dt_prop(chosen, "ibm,architecture-vec-5", &size);
> +	if (!vec5)
> +		return NULL;
> +
> +	if (size <= index)
> +		return NULL;
> +
> +	return vec5 + index;
> +}
> +
> +static bool xive_spapr_disabled(void)
> +{
> +	const u8 *vec5_xive;
> +
> +	vec5_xive = get_vec5_feature(OV5_INDX(OV5_XIVE_SUPPORT));
> +	if (vec5_xive) {
> +		u8 val;
> +
> +		val = *vec5_xive & OV5_FEAT(OV5_XIVE_SUPPORT);
> +		switch (val) {
> +		case OV5_FEAT(OV5_XIVE_EITHER):
> +		case OV5_FEAT(OV5_XIVE_LEGACY):
> +			break;
> +		case OV5_FEAT(OV5_XIVE_EXPLOIT):
> +			/* Hypervisor only supports XIVE */
> +			if (xive_cmdline_disabled)
> +				pr_warn("WARNING: Ignoring cmdline option xive=off\n");
> +			return false;
> +		default:
> +			pr_warn("%s: Unknown xive support option: 0x%x\n",
> +				__func__, val);
> +			break;
> +		}
> +	}
> +
> +	return xive_cmdline_disabled;
> +}
> +
>  bool __init xive_spapr_init(void)
>  {
>  	struct device_node *np;
> @@ -675,7 +725,7 @@ bool __init xive_spapr_init(void)
>  	const __be32 *reg;
>  	int i;
>  
> -	if (xive_cmdline_disabled)
> +	if (xive_spapr_disabled())
>  		return false;
>  
>  	pr_devel("%s()\n", __func__);
> 

