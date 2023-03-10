Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B146B43FC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjCJOUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjCJOUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:20:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E456D7DF93
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:18:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F967CE290C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F53EC4339B;
        Fri, 10 Mar 2023 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457914;
        bh=HBsayVx7LdhqXOTj+T1q3RdCZ+qiElCCuyURlX83UuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmFndB8hE2ULM3rMHECJzMnSM0q8pzk/5IPxV/kkbg3qufJl8/2b7ULtsMtXfw1Vp
         sfX8lwlr9noJHXQr9IxmMkA2Sfmoa1D3QpH/jSYvEqiLivG0xXvzR8fUt4bLP8SqTA
         8c3DR/svrvFVAUx+zvRHHI541D1aPjg9qHUlCz3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Jeffery <andrew@aj.id.au>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/252] powerpc/powernv/ioda: Skip unallocated resources when mapping to PE
Date:   Fri, 10 Mar 2023 14:37:52 +0100
Message-Id: <20230310133721.900476910@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Barrat <fbarrat@linux.ibm.com>

[ Upstream commit e64e71056f323a1e178dccf04d4c0f032d84436c ]

pnv_ioda_setup_pe_res() calls opal to map a resource with a PE. However,
the code assumes the resource is allocated and it uses the resource
address to find out the segment(s) which need to be mapped to the
PE. In the unlikely case where the resource hasn't been allocated, the
computation for the segment number is garbage, which can lead to
invalid memory access and potentially a kernel crash, such as:

[ ] pci_bus 0002:02: Configuring PE for bus
[ ] pci 0002:02     : [PE# fc] Secondary bus 0x0000000000000002..0x0000000000000002 associated with PE#fc
[ ] BUG: Kernel NULL pointer dereference on write at 0x00000000
[ ] Faulting instruction address: 0xc00000000005eac4
[ ] Oops: Kernel access of bad area, sig: 7 [#1]
[ ] LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA PowerNV
[ ] Modules linked in:
[ ] CPU: 12 PID: 1 Comm: swapper/20 Not tainted 5.10.50-openpower1 #2
[ ] NIP:  c00000000005eac4 LR: c00000000005ea44 CTR: 0000000030061b9c
[ ] REGS: c000200007383650 TRAP: 0300   Not tainted  (5.10.50-openpower1)
[ ] MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 44000224  XER: 20040000
[ ] CFAR: c00000000005eaa0 DAR: 0000000000000000 DSISR: 02080000 IRQMASK: 0
[ ] GPR00: c00000000005dd98 c0002000073838e0 c00000000185de00 c000200fff018960
[ ] GPR04: 00000000000000fc 0000000000000003 0000000000000000 0000000000000000
[ ] GPR08: 0000000000000000 0000000000000000 0000000000000000 9000000000001033
[ ] GPR12: 0000000031cb0000 c000000ffffe6a80 c000000000010a58 0000000000000000
[ ] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[ ] GPR20: 0000000000000000 0000000000000000 0000000000000000 c00000000711e200
[ ] GPR24: 0000000000000100 c000200009501120 c00020000cee2800 00000000000003ff
[ ] GPR28: c000200fff018960 0000000000000000 c000200ffcb7fd00 0000000000000000
[ ] NIP [c00000000005eac4] pnv_ioda_setup_pe_res+0x94/0x1a0
[ ] LR [c00000000005ea44] pnv_ioda_setup_pe_res+0x14/0x1a0
[ ] Call Trace:
[ ] [c0002000073838e0] [c00000000005eb98] pnv_ioda_setup_pe_res+0x168/0x1a0 (unreliable)
[ ] [c000200007383970] [c00000000005dd98] pnv_pci_ioda_dma_dev_setup+0x43c/0x970
[ ] [c000200007383a60] [c000000000032cdc] pcibios_bus_add_device+0x78/0x18c
[ ] [c000200007383aa0] [c00000000028f2bc] pci_bus_add_device+0x28/0xbc
[ ] [c000200007383b10] [c00000000028f3a0] pci_bus_add_devices+0x50/0x7c
[ ] [c000200007383b50] [c00000000028f3c4] pci_bus_add_devices+0x74/0x7c
[ ] [c000200007383b90] [c00000000028f3c4] pci_bus_add_devices+0x74/0x7c
[ ] [c000200007383bd0] [c00000000069ad0c] pcibios_init+0xf0/0x104
[ ] [c000200007383c50] [c0000000000106d8] do_one_initcall+0x84/0x1c4
[ ] [c000200007383d20] [c0000000006910b8] kernel_init_freeable+0x264/0x268
[ ] [c000200007383dc0] [c000000000010a68] kernel_init+0x18/0x138
[ ] [c000200007383e20] [c00000000000cbfc] ret_from_kernel_thread+0x5c/0x80
[ ] Instruction dump:
[ ] 7f89e840 409d000c 7fbbf840 409c000c 38210090 4848f448 809c002c e95e0120
[ ] 7ba91764 38a00003 57a7043e 38c00000 <7c8a492e> 5484043e e87e0018 4bff23bd

Hitting the problem is not that easy. It was seen with a (semi-bogus)
PCI device with a class code of 0. The generic PCI framework doesn't
allocate resources in such a case.

The patch is simply skipping resources which are still flagged with
IORESOURCE_UNSET.

We don't have the problem with 64-bit mem resources, as the address of
the resource is checked to be within the range of the 64-bit mmio
window. See pnv_ioda_reserve_dev_m64_pe() and pnv_pci_is_m64().

Reported-by: Andrew Jeffery <andrew@aj.id.au>
Fixes: 23e79425fe7c ("powerpc/powernv: Simplify pnv_ioda_setup_pe_seg()")
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230120093215.19496-1-fbarrat@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index ecd211c5f24a5..cd3e5ed7d77c5 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -3123,7 +3123,8 @@ static void pnv_ioda_setup_pe_res(struct pnv_ioda_pe *pe,
 	int index;
 	int64_t rc;
 
-	if (!res || !res->flags || res->start > res->end)
+	if (!res || !res->flags || res->start > res->end ||
+	    res->flags & IORESOURCE_UNSET)
 		return;
 
 	if (res->flags & IORESOURCE_IO) {
-- 
2.39.2



