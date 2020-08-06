Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C5C23D4CA
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 02:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgHFAnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 20:43:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59468 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgHFAnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 20:43:49 -0400
Subject: Re: [PATCH] MIPS: SGI-IP27: always enable NUMA in Kconfig
To:     Mike Rapoport <rppt@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Paul Burton <paulburton@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Rapoport <rppt@linux.ibm.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
References: <20200805125141.24987-1-rppt@kernel.org>
From:   Joshua Kinard <kumba@gentoo.org>
Openpgp: preference=signencrypt
Message-ID: <11255b1d-5488-9ede-fbca-a176a0572a33@gentoo.org>
Date:   Wed, 5 Aug 2020 20:43:45 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200805125141.24987-1-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/2020 08:51, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> When a configuration has NUMA disabled and SGI_IP27 enabled, the build
> fails:
> 
>   CC      kernel/bounds.s
>   CC      arch/mips/kernel/asm-offsets.s
> In file included from arch/mips/include/asm/topology.h:11,
>                  from include/linux/topology.h:36,
>                  from include/linux/gfp.h:9,
>                  from include/linux/slab.h:15,
>                  from include/linux/crypto.h:19,
>                  from include/crypto/hash.h:11,
>                  from include/linux/uio.h:10,
>                  from include/linux/socket.h:8,
>                  from include/linux/compat.h:15,
>                  from arch/mips/kernel/asm-offsets.c:12:
> include/linux/topology.h: In function 'numa_node_id':
> arch/mips/include/asm/mach-ip27/topology.h:16:27: error: implicit declaration of function 'cputonasid'; did you mean 'cpu_vpe_id'? [-Werror=implicit-function-declaration]
>  #define cpu_to_node(cpu) (cputonasid(cpu))
>                            ^~~~~~~~~~
> include/linux/topology.h:119:9: note: in expansion of macro 'cpu_to_node'
>   return cpu_to_node(raw_smp_processor_id());
>          ^~~~~~~~~~~
> include/linux/topology.h: In function 'cpu_cpu_mask':
> arch/mips/include/asm/mach-ip27/topology.h:19:7: error: implicit declaration of function 'hub_data' [-Werror=implicit-function-declaration]
>       &hub_data(node)->h_cpus)
>        ^~~~~~~~
> include/linux/topology.h:210:9: note: in expansion of macro 'cpumask_of_node'
>   return cpumask_of_node(cpu_to_node(cpu));
>          ^~~~~~~~~~~~~~~
> arch/mips/include/asm/mach-ip27/topology.h:19:21: error: invalid type argument of '->' (have 'int')
>       &hub_data(node)->h_cpus)
>                      ^~
> include/linux/topology.h:210:9: note: in expansion of macro 'cpumask_of_node'
>   return cpumask_of_node(cpu_to_node(cpu));
>          ^~~~~~~~~~~~~~~
> 
> Before switch from discontigmem to sparsemem, there always was
> CONFIG_NEED_MULTIPLE_NODES=y because it was selected by DISCONTIGMEM.
> Without DISCONTIGMEM it is possible to have SPARSEMEM without NUMA for
> SGI_IP27 and as many things there rely on custom node definition, the
> build breaks.
> 
> As Thomas noted "... there are right now too many places in IP27 code,
> which assumes NUMA enabled", the simplest solution would be to always
> enable NUMA for SGI-IP27 builds.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 397dc00e249e ("mips: sgi-ip27: switch from DISCONTIGMEM to SPARSEMEM")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  arch/mips/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 6fee1a133e9d..a7e40bb1e5bc 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -678,6 +678,7 @@ config SGI_IP27
>  	select SYS_SUPPORTS_NUMA
>  	select SYS_SUPPORTS_SMP
>  	select MIPS_L1_CACHE_SHIFT_7
> +	select NUMA
>  	help
>  	  This are the SGI Origin 200, Origin 2000 and Onyx 2 Graphics
>  	  workstations.  To compile a Linux kernel that runs on these, say Y
> 

Reviewed-by: Joshua Kinard <kumba@gentoo.org>
