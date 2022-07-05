Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0D7566D0A
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbiGEMUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbiGEMRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7C31902E;
        Tue,  5 Jul 2022 05:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71979B817CE;
        Tue,  5 Jul 2022 12:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A5AC341C7;
        Tue,  5 Jul 2022 12:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023125;
        bh=w8/GIHaK5lt0ow3tkT2iLdxX6zkIiYVhDF4tLqjmHFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecsQb7soXRoHEbKGdzrZC6Qyl0DGO6/BDYy7gNfSah80kUDo9gwzUvRQJ7KqVLHph
         KDlG0jKlgxebLc2eFHJEx8RdCy1GOBIJ64NduQcE44htLsIDscxmTXm5BT5g2ynyNP
         qIccS0TAoLDTqnTxxoiM5O4OtDM8seLX2N9IAJew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 47/98] powerpc/memhotplug: Add add_pages override for PPC
Date:   Tue,  5 Jul 2022 13:58:05 +0200
Message-Id: <20220705115618.922242082@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit ac790d09885d36143076e7e02825c541e8eee899 upstream.

With commit ffa0b64e3be5 ("powerpc: Fix virt_addr_valid() for 64-bit Book3E & 32-bit")
the kernel now validate the addr against high_memory value. This results
in the below BUG_ON with dax pfns.

[  635.798741][T26531] kernel BUG at mm/page_alloc.c:5521!
1:mon> e
cpu 0x1: Vector: 700 (Program Check) at [c000000007287630]
    pc: c00000000055ed48: free_pages.part.0+0x48/0x110
    lr: c00000000053ca70: tlb_finish_mmu+0x80/0xd0
    sp: c0000000072878d0
   msr: 800000000282b033
  current = 0xc00000000afabe00
  paca    = 0xc00000037ffff300   irqmask: 0x03   irq_happened: 0x05
    pid   = 26531, comm = 50-landscape-sy
kernel BUG at :5521!
Linux version 5.19.0-rc3-14659-g4ec05be7c2e1 (kvaneesh@ltc-boston8) (gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #625 SMP Thu Jun 23 00:35:43 CDT 2022
1:mon> t
[link register   ] c00000000053ca70 tlb_finish_mmu+0x80/0xd0
[c0000000072878d0] c00000000053ca54 tlb_finish_mmu+0x64/0xd0 (unreliable)
[c000000007287900] c000000000539424 exit_mmap+0xe4/0x2a0
[c0000000072879e0] c00000000019fc1c mmput+0xcc/0x210
[c000000007287a20] c000000000629230 begin_new_exec+0x5e0/0xf40
[c000000007287ae0] c00000000070b3cc load_elf_binary+0x3ac/0x1e00
[c000000007287c10] c000000000627af0 bprm_execve+0x3b0/0xaf0
[c000000007287cd0] c000000000628414 do_execveat_common.isra.0+0x1e4/0x310
[c000000007287d80] c00000000062858c sys_execve+0x4c/0x60
[c000000007287db0] c00000000002c1b0 system_call_exception+0x160/0x2c0
[c000000007287e10] c00000000000c53c system_call_common+0xec/0x250

The fix is to make sure we update high_memory on memory hotplug.
This is similar to what x86 does in commit 3072e413e305 ("mm/memory_hotplug: introduce add_pages")

Fixes: ffa0b64e3be5 ("powerpc: Fix virt_addr_valid() for 64-bit Book3E & 32-bit")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220629050925.31447-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Kconfig  |    4 ++++
 arch/powerpc/mm/mem.c |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -353,6 +353,10 @@ config ARCH_SUSPEND_NONZERO_CPU
 	def_bool y
 	depends on PPC_POWERNV || PPC_PSERIES
 
+config ARCH_HAS_ADD_PAGES
+	def_bool y
+	depends on ARCH_ENABLE_MEMORY_HOTPLUG
+
 config PPC_DCR_NATIVE
 	bool
 
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -104,6 +104,37 @@ void __ref arch_remove_linear_mapping(u6
 	vm_unmap_aliases();
 }
 
+/*
+ * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
+ * updating.
+ */
+static void update_end_of_memory_vars(u64 start, u64 size)
+{
+	unsigned long end_pfn = PFN_UP(start + size);
+
+	if (end_pfn > max_pfn) {
+		max_pfn = end_pfn;
+		max_low_pfn = end_pfn;
+		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+	}
+}
+
+int __ref add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
+		    struct mhp_params *params)
+{
+	int ret;
+
+	ret = __add_pages(nid, start_pfn, nr_pages, params);
+	if (ret)
+		return ret;
+
+	/* update max_pfn, max_low_pfn and high_memory */
+	update_end_of_memory_vars(start_pfn << PAGE_SHIFT,
+				  nr_pages << PAGE_SHIFT);
+
+	return ret;
+}
+
 int __ref arch_add_memory(int nid, u64 start, u64 size,
 			  struct mhp_params *params)
 {
@@ -114,7 +145,7 @@ int __ref arch_add_memory(int nid, u64 s
 	rc = arch_create_linear_mapping(nid, start, size, params);
 	if (rc)
 		return rc;
-	rc = __add_pages(nid, start_pfn, nr_pages, params);
+	rc = add_pages(nid, start_pfn, nr_pages, params);
 	if (rc)
 		arch_remove_linear_mapping(start, size);
 	return rc;


