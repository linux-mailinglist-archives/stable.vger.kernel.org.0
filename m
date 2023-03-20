Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9126C1940
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbjCTPcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjCTPbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406F612F3A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:24:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83FC5B80EAB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD84C433EF;
        Mon, 20 Mar 2023 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325863;
        bh=7JEzRy99DMpt5DMVhxNFw+mt7bxl/o1gZtqO59tZJ8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ge+PIZMdvDCM5tIN8vCZhfOICyUAIwDibZRsM4NRk1gtJcEG+CWbIqjPtAQdPtL1u
         6i+LTTlPI1cHIilcwafuuqejW5zXFh50fy+JXwDQF9PfBXayg+GKM7loHDsWNEQx1W
         hRImuJEPzy0knq+fzVHViv3VjFEmSD8YjISnprQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Zong Li <zong.li@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH 6.1 154/198] riscv: asid: Fixup stale TLB entry cause application crash
Date:   Mon, 20 Mar 2023 15:54:52 +0100
Message-Id: <20230320145513.985230399@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit 82dd33fde0268cc622d3d1ac64971f3f61634142 upstream.

After use_asid_allocator is enabled, the userspace application will
crash by stale TLB entries. Because only using cpumask_clear_cpu without
local_flush_tlb_all couldn't guarantee CPU's TLB entries were fresh.
Then set_mm_asid would cause the user space application to get a stale
value by stale TLB entry, but set_mm_noasid is okay.

Here is the symptom of the bug:
unhandled signal 11 code 0x1 (coredump)
   0x0000003fd6d22524 <+4>:     auipc   s0,0x70
   0x0000003fd6d22528 <+8>:     ld      s0,-148(s0) # 0x3fd6d92490
=> 0x0000003fd6d2252c <+12>:    ld      a5,0(s0)
(gdb) i r s0
s0          0x8082ed1cc3198b21       0x8082ed1cc3198b21
(gdb) x /2x 0x3fd6d92490
0x3fd6d92490:   0xd80ac8a8      0x0000003f
The core dump file shows that register s0 is wrong, but the value in
memory is correct. Because 'ld s0, -148(s0)' used a stale mapping entry
in TLB and got a wrong result from an incorrect physical address.

When the task ran on CPU0, which loaded/speculative-loaded the value of
address(0x3fd6d92490), then the first version of the mapping entry was
PTWed into CPU0's TLB.
When the task switched from CPU0 to CPU1 (No local_tlb_flush_all here by
asid), it happened to write a value on the address (0x3fd6d92490). It
caused do_page_fault -> wp_page_copy -> ptep_clear_flush ->
ptep_get_and_clear & flush_tlb_page.
The flush_tlb_page used mm_cpumask(mm) to determine which CPUs need TLB
flush, but CPU0 had cleared the CPU0's mm_cpumask in the previous
switch_mm. So we only flushed the CPU1 TLB and set the second version
mapping of the PTE. When the task switched from CPU1 to CPU0 again, CPU0
still used a stale TLB mapping entry which contained a wrong target
physical address. It raised a bug when the task happened to read that
value.

   CPU0                               CPU1
   - switch 'task' in
   - read addr (Fill stale mapping
     entry into TLB)
   - switch 'task' out (no tlb_flush)
                                      - switch 'task' in (no tlb_flush)
                                      - write addr cause pagefault
                                        do_page_fault() (change to
                                        new addr mapping)
                                          wp_page_copy()
                                            ptep_clear_flush()
                                              ptep_get_and_clear()
                                              & flush_tlb_page()
                                        write new value into addr
                                      - switch 'task' out (no tlb_flush)
   - switch 'task' in (no tlb_flush)
   - read addr again (Use stale
     mapping entry in TLB)
     get wrong value from old phyical
     addr, BUG!

The solution is to keep all CPUs' footmarks of cpumask(mm) in switch_mm,
which could guarantee to invalidate all stale TLB entries during TLB
flush.

Fixes: 65d4b9c53017 ("RISC-V: Implement ASID allocator")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Tested-by: Zong Li <zong.li@sifive.com>
Tested-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Cc: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20230226150137.1919750-3-geomatsi@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/context.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -205,12 +205,24 @@ static void set_mm_noasid(struct mm_stru
 	local_flush_tlb_all();
 }
 
-static inline void set_mm(struct mm_struct *mm, unsigned int cpu)
+static inline void set_mm(struct mm_struct *prev,
+			  struct mm_struct *next, unsigned int cpu)
 {
-	if (static_branch_unlikely(&use_asid_allocator))
-		set_mm_asid(mm, cpu);
-	else
-		set_mm_noasid(mm);
+	/*
+	 * The mm_cpumask indicates which harts' TLBs contain the virtual
+	 * address mapping of the mm. Compared to noasid, using asid
+	 * can't guarantee that stale TLB entries are invalidated because
+	 * the asid mechanism wouldn't flush TLB for every switch_mm for
+	 * performance. So when using asid, keep all CPUs footmarks in
+	 * cpumask() until mm reset.
+	 */
+	cpumask_set_cpu(cpu, mm_cpumask(next));
+	if (static_branch_unlikely(&use_asid_allocator)) {
+		set_mm_asid(next, cpu);
+	} else {
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
+		set_mm_noasid(next);
+	}
 }
 
 static int __init asids_init(void)
@@ -264,7 +276,8 @@ static int __init asids_init(void)
 }
 early_initcall(asids_init);
 #else
-static inline void set_mm(struct mm_struct *mm, unsigned int cpu)
+static inline void set_mm(struct mm_struct *prev,
+			  struct mm_struct *next, unsigned int cpu)
 {
 	/* Nothing to do here when there is no MMU */
 }
@@ -317,10 +330,7 @@ void switch_mm(struct mm_struct *prev, s
 	 */
 	cpu = smp_processor_id();
 
-	cpumask_clear_cpu(cpu, mm_cpumask(prev));
-	cpumask_set_cpu(cpu, mm_cpumask(next));
-
-	set_mm(next, cpu);
+	set_mm(prev, next, cpu);
 
 	flush_icache_deferred(next, cpu);
 }


