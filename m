Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1745B23D29D
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgHEUOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgHEQX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:23:26 -0400
Received: from aquarius.haifa.ibm.com (nesher1.haifa.il.ibm.com [195.110.40.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1E932076E;
        Wed,  5 Aug 2020 12:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596631911;
        bh=HOnj3Rf9xvYALWHvNzwxaM2OZCJy8zKF4WAd1JhW220=;
        h=From:To:Cc:Subject:Date:From;
        b=XudrjJsWpfCBAJJ8j5BppShNMFB17hCnJEe1RkAj+b445j2sdQinbuYok0ZAPoY/4
         QEALh8/3vpuplsPnBWfKjuLsf+wRiG9iPh1Qp3Ru0K5F9AoKY2XUEN9lI/mabG57rN
         x+A2+zvpvbvZJrpgCe4722pZ8vEgVOB4+QXqLByg=
From:   Mike Rapoport <rppt@kernel.org>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Paul Burton <paulburton@kernel.org>,
        Joshua Kinard <kumba@gentoo.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Mike Rapoport <rppt@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: [PATCH] MIPS: SGI-IP27: always enable NUMA in Kconfig
Date:   Wed,  5 Aug 2020 15:51:41 +0300
Message-Id: <20200805125141.24987-1-rppt@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

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
---
 arch/mips/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 6fee1a133e9d..a7e40bb1e5bc 100644
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
-- 
2.26.2

