Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7B523D7D1
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 10:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgHFIIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 04:08:16 -0400
Received: from elvis.franken.de ([193.175.24.41]:36293 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgHFIEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 04:04:14 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1k3arg-0000uJ-00; Thu, 06 Aug 2020 10:03:04 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 42BD9C0C56; Thu,  6 Aug 2020 09:41:41 +0200 (CEST)
Date:   Thu, 6 Aug 2020 09:41:41 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Paul Burton <paulburton@kernel.org>,
        Joshua Kinard <kumba@gentoo.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Rapoport <rppt@linux.ibm.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: SGI-IP27: always enable NUMA in Kconfig
Message-ID: <20200806074141.GA5148@alpha.franken.de>
References: <20200805125141.24987-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805125141.24987-1-rppt@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 03:51:41PM +0300, Mike Rapoport wrote:
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

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
