Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0776A322A
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjBZPYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjBZPYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:24:04 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64F328D14;
        Sun, 26 Feb 2023 07:17:15 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id n2so5302138lfb.12;
        Sun, 26 Feb 2023 07:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mjb1YqsDLTS2qdiYT2rZwNeNUUk92H+uK9H4KlMN7d4=;
        b=UqGnFzGUT4B52Z6de7bV3co9AFBtft9IX+FQgcyCYLkPF5/L/CxpuFahqEpBC4cQlI
         HtUXDnbOKS2hwSyupY9HIp3zlHS9+yDzV3F9Vws2L32p/poly+yLETWJqZgz4RivuFmF
         Oyz3/qHFaEVJCRKTWPFTKZFTP7Dtex/g/jDLH0gaYU1bWxq6kJAQQFReu89rYKLHCZ7n
         f3JKrDu9WB+OaAz/ImVKv0CdcRvaiTp3HKBgWBftfactclQYMH0D+AlX+8G63anp1sJa
         r9e1L01yTD2L8Mt9xWHXWK8vLvb6ZnU48oYEE5FhECbeVyKps4B2TUi6/sfzG6b+8Nff
         PLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mjb1YqsDLTS2qdiYT2rZwNeNUUk92H+uK9H4KlMN7d4=;
        b=hC29xTbgbGKyd/ReqBnmtiFJhq4dVl9OO22dB8K86bGb+9q03+i/GLs0vTkF2k6qNH
         OG1Gv84Eres5oZxPQM+d0nZj62zpf+g/jYVckZRrrCVqSj0ploToZ2msiJBBzz77sXr2
         lNwfVgyxDw766E/A5VnZuetYHN+pTQAORSRS2X38OMFWOnAF9cZEk65LelhvZULEFLHe
         52tYcuAVALJlGUdHsHzNbzw4A2ybDoOFUKPmBux5pBAZ8S6wiLsgnPqmr8tCfz4Nc2sP
         wzjl9yBnHlZc0UOtQnJvXFhKtLX/6eF4gq5Wdsi5YiCx/dooIJCgs0XaOI/BtD9BPWiZ
         LKng==
X-Gm-Message-State: AO0yUKVu/M2229KPKlUqwUvJ2AUhSe3J9Z53IAJ1AliHM03PRxrxPtZp
        OO7OuZqqvWrfS9JZDuh6Rl12X6mHKArcOPlGdLc=
X-Google-Smtp-Source: AK7set8+8r3q+FXjO+JZWpxyQEJ8dKuL+74eP8szhnLyjEsLJVQ8yaU2Y3Xg/qAQejpcCyZyuBw12A==
X-Received: by 2002:a05:6512:244:b0:4d8:5e8e:b138 with SMTP id b4-20020a056512024400b004d85e8eb138mr7193205lfo.14.1677423723351;
        Sun, 26 Feb 2023 07:02:03 -0800 (PST)
Received: from localhost.localdomain ([5.188.167.245])
        by smtp.googlemail.com with ESMTPSA id z7-20020ac25de7000000b004db44dfd888sm580715lfq.30.2023.02.26.07.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 07:02:02 -0800 (PST)
From:   Sergey Matyukevich <geomatsi@gmail.com>
To:     linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Zong Li <zong.li@sifive.com>, Guo Ren <guoren@kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] riscv: asid: Fixup stale TLB entry cause application crash
Date:   Sun, 26 Feb 2023 18:01:37 +0300
Message-Id: <20230226150137.1919750-3-geomatsi@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230226150137.1919750-1-geomatsi@gmail.com>
References: <20230226150137.1919750-1-geomatsi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

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

---
 arch/riscv/mm/context.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index 7acbfbd14557..0f784e3d307b 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -205,12 +205,24 @@ static void set_mm_noasid(struct mm_struct *mm)
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
@@ -317,10 +330,7 @@ void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	 */
 	cpu = smp_processor_id();
 
-	cpumask_clear_cpu(cpu, mm_cpumask(prev));
-	cpumask_set_cpu(cpu, mm_cpumask(next));
-
-	set_mm(next, cpu);
+	set_mm(prev, next, cpu);
 
 	flush_icache_deferred(next, cpu);
 }
-- 
2.39.2

