Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CF624BFA6
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgHTNuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbgHTJ04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:26:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0507322D2A;
        Thu, 20 Aug 2020 09:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915612;
        bh=xoF6oG+fF8czt3XFOicaePjWcPHnJQveCnY/OPDHI6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AR9yTQHBWBzisYHt6wTHyvbEoJTLMepIbaOfOhB6OAeZU0gJosI3ouf3+2OVlalTg
         +ZoZu/g6WvnfN0CYNSQ7kSmvL+Ssrk2rNmLW1FRIS6iuWLgU7goLVcJkVI/433Wkbk
         utLgkMKPkjuaedfSqDwcezJeMi7mzSbK9lW/OPh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.8 075/232] MIPS: SGI-IP27: always enable NUMA in Kconfig
Date:   Thu, 20 Aug 2020 11:18:46 +0200
Message-Id: <20200820091616.442618574@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 6c86a3029ce3b44597526909f2e39a77a497f640 upstream.

When a configuration has NUMA disabled and SGI_IP27 enabled, the build
fails:

  CC      kernel/bounds.s
  CC      arch/mips/kernel/asm-offsets.s
In file included from arch/mips/include/asm/topology.h:11,
                 from include/linux/topology.h:36,
                 from include/linux/gfp.h:9,
                 from include/linux/slab.h:15,
                 from include/linux/crypto.h:19,
                 from include/crypto/hash.h:11,
                 from include/linux/uio.h:10,
                 from include/linux/socket.h:8,
                 from include/linux/compat.h:15,
                 from arch/mips/kernel/asm-offsets.c:12:
include/linux/topology.h: In function 'numa_node_id':
arch/mips/include/asm/mach-ip27/topology.h:16:27: error: implicit declaration of function 'cputonasid'; did you mean 'cpu_vpe_id'? [-Werror=implicit-function-declaration]
 #define cpu_to_node(cpu) (cputonasid(cpu))
                           ^~~~~~~~~~
include/linux/topology.h:119:9: note: in expansion of macro 'cpu_to_node'
  return cpu_to_node(raw_smp_processor_id());
         ^~~~~~~~~~~
include/linux/topology.h: In function 'cpu_cpu_mask':
arch/mips/include/asm/mach-ip27/topology.h:19:7: error: implicit declaration of function 'hub_data' [-Werror=implicit-function-declaration]
      &hub_data(node)->h_cpus)
       ^~~~~~~~
include/linux/topology.h:210:9: note: in expansion of macro 'cpumask_of_node'
  return cpumask_of_node(cpu_to_node(cpu));
         ^~~~~~~~~~~~~~~
arch/mips/include/asm/mach-ip27/topology.h:19:21: error: invalid type argument of '->' (have 'int')
      &hub_data(node)->h_cpus)
                     ^~
include/linux/topology.h:210:9: note: in expansion of macro 'cpumask_of_node'
  return cpumask_of_node(cpu_to_node(cpu));
         ^~~~~~~~~~~~~~~

Before switch from discontigmem to sparsemem, there always was
CONFIG_NEED_MULTIPLE_NODES=y because it was selected by DISCONTIGMEM.
Without DISCONTIGMEM it is possible to have SPARSEMEM without NUMA for
SGI_IP27 and as many things there rely on custom node definition, the
build breaks.

As Thomas noted "... there are right now too many places in IP27 code,
which assumes NUMA enabled", the simplest solution would be to always
enable NUMA for SGI-IP27 builds.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 397dc00e249e ("mips: sgi-ip27: switch from DISCONTIGMEM to SPARSEMEM")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -678,6 +678,7 @@ config SGI_IP27
 	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SMP
 	select MIPS_L1_CACHE_SHIFT_7
+	select NUMA
 	help
 	  This are the SGI Origin 200, Origin 2000 and Onyx 2 Graphics
 	  workstations.  To compile a Linux kernel that runs on these, say Y


