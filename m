Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F11D387D
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 06:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfJKEai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 00:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfJKEai (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 00:30:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 446332089F;
        Fri, 11 Oct 2019 04:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570768236;
        bh=ah1QHqRDMmfVWlvKmhrafxLbI4vaf9pTpDoMwJKs490=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bJZWVqwDvpM+I457dc4b5l1A+kdyV976hXWd7OS0DX/5VJeMRJ17dPrPA8puioz1+
         rzerdOae8CqrMtuioEVYi75HaqjD2wupp3HMdcFC4rg67G7RrhFyhFgAWCtvEeLrg+
         LhPXocKFqnSG8j+/LKXYnTwUes4Xl+/RggYeKa78=
Date:   Fri, 11 Oct 2019 06:30:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Yunqiang Su <ysu@wavecomp.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org
Subject: Re: [PATCH 4.14 17/61] MIPS: Treat Loongson Extensions as ASEs
Message-ID: <20191011043034.GA941864@kroah.com>
References: <20191010083449.500442342@linuxfoundation.org>
 <20191010083459.461605528@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010083459.461605528@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 10:36:42AM +0200, Greg Kroah-Hartman wrote:
> From: Jiaxun Yang <jiaxun.yang@flygoat.com>
> 
> commit d2f965549006acb865c4638f1f030ebcefdc71f6 upstream.
> 
> Recently, binutils had split Loongson-3 Extensions into four ASEs:
> MMI, CAM, EXT, EXT2. This patch do the samething in kernel and expose
> them in cpuinfo so applications can probe supported ASEs at runtime.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Huacai Chen <chenhc@lemote.com>
> Cc: Yunqiang Su <ysu@wavecomp.com>
> Cc: stable@vger.kernel.org # v4.14+
> Signed-off-by: Paul Burton <paul.burton@mips.com>
> Cc: linux-mips@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/mips/include/asm/cpu-features.h |   16 ++++++++++++++++
>  arch/mips/include/asm/cpu.h          |    4 ++++
>  arch/mips/kernel/cpu-probe.c         |    6 ++++++
>  arch/mips/kernel/proc.c              |    4 ++++
>  4 files changed, 30 insertions(+)
> 
> --- a/arch/mips/include/asm/cpu-features.h
> +++ b/arch/mips/include/asm/cpu-features.h
> @@ -348,6 +348,22 @@
>  #define cpu_has_dsp3		(cpu_data[0].ases & MIPS_ASE_DSP3)
>  #endif
>  
> +#ifndef cpu_has_loongson_mmi
> +#define cpu_has_loongson_mmi		__ase(MIPS_ASE_LOONGSON_MMI)
> +#endif
> +
> +#ifndef cpu_has_loongson_cam
> +#define cpu_has_loongson_cam		__ase(MIPS_ASE_LOONGSON_CAM)
> +#endif
> +
> +#ifndef cpu_has_loongson_ext
> +#define cpu_has_loongson_ext		__ase(MIPS_ASE_LOONGSON_EXT)
> +#endif
> +
> +#ifndef cpu_has_loongson_ext2
> +#define cpu_has_loongson_ext2		__ase(MIPS_ASE_LOONGSON_EXT2)
> +#endif
> +
>  #ifndef cpu_has_mipsmt
>  #define cpu_has_mipsmt		(cpu_data[0].ases & MIPS_ASE_MIPSMT)
>  #endif
> --- a/arch/mips/include/asm/cpu.h
> +++ b/arch/mips/include/asm/cpu.h
> @@ -433,5 +433,9 @@ enum cpu_type_enum {
>  #define MIPS_ASE_MSA		0x00000100 /* MIPS SIMD Architecture */
>  #define MIPS_ASE_DSP3		0x00000200 /* Signal Processing ASE Rev 3*/
>  #define MIPS_ASE_MIPS16E2	0x00000400 /* MIPS16e2 */
> +#define MIPS_ASE_LOONGSON_MMI	0x00000800 /* Loongson MultiMedia extensions Instructions */
> +#define MIPS_ASE_LOONGSON_CAM	0x00001000 /* Loongson CAM */
> +#define MIPS_ASE_LOONGSON_EXT	0x00002000 /* Loongson EXTensions */
> +#define MIPS_ASE_LOONGSON_EXT2	0x00004000 /* Loongson EXTensions R2 */
>  
>  #endif /* _ASM_CPU_H */
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -1478,6 +1478,8 @@ static inline void cpu_probe_legacy(stru
>  			__cpu_name[cpu] = "ICT Loongson-3";
>  			set_elf_platform(cpu, "loongson3a");
>  			set_isa(c, MIPS_CPU_ISA_M64R1);
> +			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
> +				MIPS_ASE_LOONGSON_EXT);
>  			break;
>  		case PRID_REV_LOONGSON3B_R1:
>  		case PRID_REV_LOONGSON3B_R2:
> @@ -1485,6 +1487,8 @@ static inline void cpu_probe_legacy(stru
>  			__cpu_name[cpu] = "ICT Loongson-3";
>  			set_elf_platform(cpu, "loongson3b");
>  			set_isa(c, MIPS_CPU_ISA_M64R1);
> +			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
> +				MIPS_ASE_LOONGSON_EXT);
>  			break;
>  		}
>  
> @@ -1845,6 +1849,8 @@ static inline void cpu_probe_loongson(st
>  		decode_configs(c);
>  		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE;
>  		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
> +		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
> +			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
>  		break;
>  	default:
>  		panic("Unknown Loongson Processor ID!");
> --- a/arch/mips/kernel/proc.c
> +++ b/arch/mips/kernel/proc.c
> @@ -124,6 +124,10 @@ static int show_cpuinfo(struct seq_file
>  	if (cpu_has_eva)	seq_printf(m, "%s", " eva");
>  	if (cpu_has_htw)	seq_printf(m, "%s", " htw");
>  	if (cpu_has_xpa)	seq_printf(m, "%s", " xpa");
> +	if (cpu_has_loongson_mmi)	seq_printf(m, "%s", " loongson-mmi");
> +	if (cpu_has_loongson_cam)	seq_printf(m, "%s", " loongson-cam");
> +	if (cpu_has_loongson_ext)	seq_printf(m, "%s", " loongson-ext");
> +	if (cpu_has_loongson_ext2)	seq_printf(m, "%s", " loongson-ext2");
>  	seq_printf(m, "\n");
>  
>  	if (cpu_has_mmips) {
> 
> 

This patch is causing build errors in 4.14, so I am dropping it.  Please
provide a working version if you all want to see it in here.

thanks,

greg k-h
