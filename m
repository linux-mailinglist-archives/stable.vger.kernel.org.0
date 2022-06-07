Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D01540D6F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353747AbiFGSrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353693AbiFGSp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:45:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9858188E93;
        Tue,  7 Jun 2022 10:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A079C618D3;
        Tue,  7 Jun 2022 17:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F014AC36B03;
        Tue,  7 Jun 2022 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624761;
        bh=3B2X66Nmpe6wB09aSth1g6OhRMxH2VcusbbHSLbMnlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpyAqRpvKALSp0rsmb1GK7OHldfQY9aFbP2KH4DdTXo3Cw8mERk54g/ZBdX/U6OdT
         eyvqjOQh0MuPwlaOZJXWphi+CDI05XJsClb95xz9knZ5AwcVlENmxadER8ojHQ1293
         /+KNee8jfW6z64NRhmxchRS4dv1Lzm91zUMmia/Axx/fzvnkCic5O/98bZJIciCWhr
         lZVt4IgnnQDbBCQgHKdYsSYnmfDACUXccL/2qVv0GCdApTXJi1zJX/LAjQaStsxFGV
         m19LKrFWRzXxL9EwA0yPWFk1A6gEzAQXnXwUcYkEm/Zl1UJla0X0wzjJ1VFLD3Gfxq
         j35Je9PCJiShw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 13/38] sysrq: do not omit current cpu when showing backtrace of all active CPUs
Date:   Tue,  7 Jun 2022 13:58:08 -0400
Message-Id: <20220607175835.480735-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175835.480735-1-sashal@kernel.org>
References: <20220607175835.480735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

[ Upstream commit 5390e7f46b9d5546d45a83e6463bc656678b1d0e ]

The backtrace of current CPU also should be printed as it is active. This
change add stack trace for current CPU and print a hint for idle CPU for
the generic workqueue based printing. (x86 already does this)

Now it looks like below:
[  279.401567] sysrq: Show backtrace of all active CPUs
[  279.407234] sysrq: CPU5:
[  279.407505] Call Trace:
[  279.408789] [<ffffffff8000606c>] dump_backtrace+0x2c/0x3a
[  279.411698] [<ffffffff800060ac>] show_stack+0x32/0x3e
[  279.411809] [<ffffffff80542258>] sysrq_handle_showallcpus+0x4c/0xc6
[  279.411929] [<ffffffff80542f16>] __handle_sysrq+0x106/0x26c
[  279.412034] [<ffffffff805436a8>] write_sysrq_trigger+0x64/0x74
[  279.412139] [<ffffffff8029cd48>] proc_reg_write+0x8e/0xe2
[  279.412252] [<ffffffff8021a8f8>] vfs_write+0x90/0x2be
[  279.412362] [<ffffffff8021acd2>] ksys_write+0xa6/0xce
[  279.412467] [<ffffffff8021ad24>] sys_write+0x2a/0x38
[  279.412689] [<ffffffff80003ff8>] ret_from_syscall+0x0/0x2
[  279.417173] sysrq: CPU6: backtrace skipped as idling
[  279.417185] sysrq: CPU4: backtrace skipped as idling
[  279.417187] sysrq: CPU0: backtrace skipped as idling
[  279.417181] sysrq: CPU7: backtrace skipped as idling
[  279.417190] sysrq: CPU1: backtrace skipped as idling
[  279.417193] sysrq: CPU3: backtrace skipped as idling
[  279.417219] sysrq: CPU2:
[  279.419179] Call Trace:
[  279.419440] [<ffffffff8000606c>] dump_backtrace+0x2c/0x3a
[  279.419782] [<ffffffff800060ac>] show_stack+0x32/0x3e
[  279.420015] [<ffffffff80542b30>] showacpu+0x5c/0x96
[  279.420317] [<ffffffff800ba71c>] flush_smp_call_function_queue+0xd6/0x218
[  279.420569] [<ffffffff800bb438>] generic_smp_call_function_single_interrupt+0x14/0x1c
[  279.420798] [<ffffffff800079ae>] handle_IPI+0xaa/0x13a
[  279.421024] [<ffffffff804dcb92>] riscv_intc_irq+0x56/0x70
[  279.421274] [<ffffffff80a05b70>] generic_handle_arch_irq+0x6a/0xfa
[  279.421518] [<ffffffff80004006>] ret_from_exception+0x0/0x10
[  279.421750] [<ffffffff80096492>] rcu_idle_enter+0x16/0x1e

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Link: https://lore.kernel.org/r/20220117154300.2808-1-changbin.du@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/sysrq.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 959f9e121cc6..7ca209d4e088 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -231,8 +231,10 @@ static void showacpu(void *dummy)
 	unsigned long flags;
 
 	/* Idle CPUs have no interesting backtrace. */
-	if (idle_cpu(smp_processor_id()))
+	if (idle_cpu(smp_processor_id())) {
+		pr_info("CPU%d: backtrace skipped as idling\n", smp_processor_id());
 		return;
+	}
 
 	raw_spin_lock_irqsave(&show_lock, flags);
 	pr_info("CPU%d:\n", smp_processor_id());
@@ -259,10 +261,13 @@ static void sysrq_handle_showallcpus(int key)
 
 		if (in_irq())
 			regs = get_irq_regs();
-		if (regs) {
-			pr_info("CPU%d:\n", smp_processor_id());
+
+		pr_info("CPU%d:\n", smp_processor_id());
+		if (regs)
 			show_regs(regs);
-		}
+		else
+			show_stack(NULL, NULL, KERN_INFO);
+
 		schedule_work(&sysrq_showallcpus);
 	}
 }
-- 
2.35.1

