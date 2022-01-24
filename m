Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021EF4993A7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386073AbiAXUfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35668 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384307AbiAXU33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:29:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D90C6B81229;
        Mon, 24 Jan 2022 20:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA7DC340E5;
        Mon, 24 Jan 2022 20:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056164;
        bh=uthVye0iwSuswlGwFuQRe9N7bDcMWWKiC6t7peSk9s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AW9v4rJFwdAP2DRFnxKzJFy/IwPd5M2HCFBXq4iGYBWDX4v0wpC0LSzxKVpjMgxeL
         xi+b6lMTWGD4UPU+8Vh34awYXm7vub4WPzOUJfklD2SeueYTe1foARrS4Udd+8qoKD
         bL8xwuh3TX98zsc9dHkPvnLqNrLYAg+9Imk8EWGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/846] powerpc/modules: Dont WARN on first module allocation attempt
Date:   Mon, 24 Jan 2022 19:38:28 +0100
Message-Id: <20220124184114.427101963@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit f1797e4de1146009c888bcf8b6bb6648d55394f1 ]

module_alloc() first tries to allocate module text within 24 bits direct
jump from kernel text, and tries a wider allocation if first one fails.

When first allocation fails the following is observed in kernel logs:

  vmap allocation for size 2400256 failed: use vmalloc=<size> to increase size
  systemd-udevd: vmalloc error: size 2395133, vm_struct allocation failed, mode:0xcc0(GFP_KERNEL), nodemask=(null)
  CPU: 0 PID: 127 Comm: systemd-udevd Tainted: G        W         5.15.5-gentoo-PowerMacG4 #9
  Call Trace:
  [e2a53a50] [c0ba0048] dump_stack_lvl+0x80/0xb0 (unreliable)
  [e2a53a70] [c0540128] warn_alloc+0x11c/0x2b4
  [e2a53b50] [c0531be8] __vmalloc_node_range+0xd8/0x64c
  [e2a53c10] [c00338c0] module_alloc+0xa0/0xac
  [e2a53c40] [c027a368] load_module+0x2ae0/0x8148
  [e2a53e30] [c027fc78] sys_finit_module+0xfc/0x130
  [e2a53f30] [c0035098] ret_from_syscall+0x0/0x28
  ...

Add __GFP_NOWARN flag to first allocation so that no warning appears
when it fails.

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Fixes: 2ec13df16704 ("powerpc/modules: Load modules closer to kernel text")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/93c9b84d6ec76aaf7b4f03468e22433a6d308674.1638267035.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/module.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.c
index ed04a3ba66fe8..40a583e9d3c70 100644
--- a/arch/powerpc/kernel/module.c
+++ b/arch/powerpc/kernel/module.c
@@ -90,16 +90,17 @@ int module_finalize(const Elf_Ehdr *hdr,
 }
 
 static __always_inline void *
-__module_alloc(unsigned long size, unsigned long start, unsigned long end)
+__module_alloc(unsigned long size, unsigned long start, unsigned long end, bool nowarn)
 {
 	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
+	gfp_t gfp = GFP_KERNEL | (nowarn ? __GFP_NOWARN : 0);
 
 	/*
 	 * Don't do huge page allocations for modules yet until more testing
 	 * is done. STRICT_MODULE_RWX may require extra work to support this
 	 * too.
 	 */
-	return __vmalloc_node_range(size, 1, start, end, GFP_KERNEL, prot,
+	return __vmalloc_node_range(size, 1, start, end, gfp, prot,
 				    VM_FLUSH_RESET_PERMS | VM_NO_HUGE_VMAP,
 				    NUMA_NO_NODE, __builtin_return_address(0));
 }
@@ -114,13 +115,13 @@ void *module_alloc(unsigned long size)
 
 	/* First try within 32M limit from _etext to avoid branch trampolines */
 	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit)
-		ptr = __module_alloc(size, limit, MODULES_END);
+		ptr = __module_alloc(size, limit, MODULES_END, true);
 
 	if (!ptr)
-		ptr = __module_alloc(size, MODULES_VADDR, MODULES_END);
+		ptr = __module_alloc(size, MODULES_VADDR, MODULES_END, false);
 
 	return ptr;
 #else
-	return __module_alloc(size, VMALLOC_START, VMALLOC_END);
+	return __module_alloc(size, VMALLOC_START, VMALLOC_END, false);
 #endif
 }
-- 
2.34.1



