Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F0C4EF316
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349777AbiDAO55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352581AbiDAOu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9657F2B3D76;
        Fri,  1 Apr 2022 07:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EC2260E9A;
        Fri,  1 Apr 2022 14:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E99C2BBE4;
        Fri,  1 Apr 2022 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824073;
        bh=ShkihJZgBChBcLK7ZusFfmiNcC/8t/sR6Qm3v8kQG+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xl+b7lYHm90bhFaf8aVNmszKjpx9nnHfV73Z9HZBra/JefRki7hL4Gadddzpb4IE/
         dUs6taZR1IVrZ5HBuAqis5ECwQeFRwwhNlnMokKymtXjnmtr0e/L8478TMO556e4El
         pZbKc5FMSq0aQwfZ3R0iFQz9ZLKPchTTFjVe6MsOnk3+fB5YXzZBB6trEqirPTBEMW
         04f2/0nuS6miCvwvxmGJGIgqzNGVxpHm9mOoo/vdqll0ka8Kdxb9SZtBQVSsuI+FUr
         p4IAhstQoLqRcSnEjFqCJ/uv1kc7K1NSZuw77eQWASERRU2NwmfBPHT+GbTW24rL/D
         bCiQVqzWKO7Sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 75/98] powerpc/code-patching: Pre-map patch area
Date:   Fri,  1 Apr 2022 10:37:19 -0400
Message-Id: <20220401143742.1952163-75-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 591b4b268435f00d2f0b81f786c2c7bd5ef66416 ]

Paul reported a warning with DEBUG_ATOMIC_SLEEP=y:

  BUG: sleeping function called from invalid context at include/linux/sched/mm.h:256
  in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 0, expected: 0
  ...
  Call Trace:
    dump_stack_lvl+0xa0/0xec (unreliable)
    __might_resched+0x2f4/0x310
    kmem_cache_alloc+0x220/0x4b0
    __pud_alloc+0x74/0x1d0
    hash__map_kernel_page+0x2cc/0x390
    do_patch_instruction+0x134/0x4a0
    arch_jump_label_transform+0x64/0x78
    __jump_label_update+0x148/0x180
    static_key_enable_cpuslocked+0xd0/0x120
    static_key_enable+0x30/0x50
    check_kvm_guest+0x60/0x88
    pSeries_smp_probe+0x54/0xb0
    smp_prepare_cpus+0x3e0/0x430
    kernel_init_freeable+0x20c/0x43c
    kernel_init+0x30/0x1a0
    ret_from_kernel_thread+0x5c/0x64

Peter pointed out that this is because do_patch_instruction() has
disabled interrupts, but then map_patch_area() calls map_kernel_page()
then hash__map_kernel_page() which does a sleeping memory allocation.

We only see the warning in KVM guests with SMT enabled, which is not
particularly common, or on other platforms if CONFIG_KPROBES is
disabled, also not common. The reason we don't see it in most
configurations is that another path that happens to have interrupts
enabled has allocated the required page tables for us, eg. there's a
path in kprobes init that does that. That's just pure luck though.

As Christophe suggested, the simplest solution is to do a dummy
map/unmap when we initialise the patching, so that any required page
table levels are pre-allocated before the first call to
do_patch_instruction(). This works because the unmap doesn't free any
page tables that were allocated by the map, it just clears the PTE,
leaving the page table levels there for the next map.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Debugged-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220223015821.473097-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/code-patching.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index c5ed98823835..b76b31196be1 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -47,9 +47,14 @@ int raw_patch_instruction(u32 *addr, struct ppc_inst instr)
 #ifdef CONFIG_STRICT_KERNEL_RWX
 static DEFINE_PER_CPU(struct vm_struct *, text_poke_area);
 
+static int map_patch_area(void *addr, unsigned long text_poke_addr);
+static void unmap_patch_area(unsigned long addr);
+
 static int text_area_cpu_up(unsigned int cpu)
 {
 	struct vm_struct *area;
+	unsigned long addr;
+	int err;
 
 	area = get_vm_area(PAGE_SIZE, VM_ALLOC);
 	if (!area) {
@@ -57,6 +62,15 @@ static int text_area_cpu_up(unsigned int cpu)
 			cpu);
 		return -1;
 	}
+
+	// Map/unmap the area to ensure all page tables are pre-allocated
+	addr = (unsigned long)area->addr;
+	err = map_patch_area(empty_zero_page, addr);
+	if (err)
+		return err;
+
+	unmap_patch_area(addr);
+
 	this_cpu_write(text_poke_area, area);
 
 	return 0;
-- 
2.34.1

