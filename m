Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58F8592506
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243010AbiHNQhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242940AbiHNQgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62161088;
        Sun, 14 Aug 2022 09:28:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3735B60FC1;
        Sun, 14 Aug 2022 16:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEABC433C1;
        Sun, 14 Aug 2022 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494479;
        bh=1HZL6Ii0eYbpxdGWodcz3JnCT22+06EimcngsnMDASM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jycde2CoHIPMWxe870XnKJzM+rASJtlz/BedpahpQ8JKhSoW0K5l/wXlDaOj1mlk3
         Y56hFG7Qx0C3gVqcxmrU60wpfm+393tGFrzRul7SJgPvioP2mezj5+2QPQe9cP/ffK
         QDO4q2DlKaWjqLMll0jhyg6K8/sbwOoqLCR2VLBXn67EJsYQ5uzAkGtWiKq6EaLUNO
         1DqCx7/sFdMt4mjt3M+RM9RYuRp1/DUPo/tdnC0tOvfHfDyuXa6/4EmjyzAPzBllrB
         XSGy9Zde+9dSSxGKeXV8znrfv5uibqbdwYrWAdbexE/rxOcjEO9qdpM6GcyquWnamj
         OEUVIsrLx2G9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu,
        akpm@linux-foundation.org, philipp.tomsich@vrull.eu,
        wangkefeng.wang@huawei.com, heiko@sntech.de, ebiederm@xmission.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 08/19] RISC-V: Add fast call path of crash_kexec()
Date:   Sun, 14 Aug 2022 12:27:27 -0400
Message-Id: <20220814162739.2398217-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162739.2398217-1-sashal@kernel.org>
References: <20220814162739.2398217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 3f1901110a89b0e2e13adb2ac8d1a7102879ea98 ]

Currently, almost all archs (x86, arm64, mips...) support fast call
of crash_kexec() when "regs && kexec_should_crash()" is true. But
RISC-V not, it can only enter crash system via panic(). However panic()
doesn't pass the regs of the real accident scene to crash_kexec(),
it caused we can't get accurate backtrace via gdb,
	$ riscv64-linux-gnu-gdb vmlinux vmcore
	Reading symbols from vmlinux...
	[New LWP 95]
	#0  console_unlock () at kernel/printk/printk.c:2557
	2557                    if (do_cond_resched)
	(gdb) bt
	#0  console_unlock () at kernel/printk/printk.c:2557
	#1  0x0000000000000000 in ?? ()

With the patch we can get the accurate backtrace,
	$ riscv64-linux-gnu-gdb vmlinux vmcore
	Reading symbols from vmlinux...
	[New LWP 95]
	#0  0xffffffe00063a4e0 in test_thread (data=<optimized out>) at drivers/test_crash.c:81
	81             *(int *)p = 0xdead;
	(gdb)
	(gdb) bt
	#0  0xffffffe00064d5c0 in test_thread (data=<optimized out>) at drivers/test_crash.c:81
	#1  0x0000000000000000 in ?? ()

Test code to produce NULL address dereference in test_crash.c,
	void *p = NULL;
	*(int *)p = 0xdead;

Reviewed-by: Guo Ren <guoren@kernel.org>
Tested-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220606082308.2883458-1-xianting.tian@linux.alibaba.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index ad14f4466d92..c1a13011fb8e 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/irq.h>
+#include <linux/kexec.h>
 
 #include <asm/processor.h>
 #include <asm/ptrace.h>
@@ -43,6 +44,9 @@ void die(struct pt_regs *regs, const char *str)
 
 	ret = notify_die(DIE_OOPS, str, regs, 0, regs->cause, SIGSEGV);
 
+	if (regs && kexec_should_crash(current))
+		crash_kexec(regs);
+
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irq(&die_lock);
-- 
2.35.1

