Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFB36AEB85
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjCGRpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjCGRpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:45:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86765974AA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:40:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1B2FB819C1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8E9C433EF;
        Tue,  7 Mar 2023 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210849;
        bh=lX1KobrTflvWQnZeQwufnxX7sVZ0XDOpN260eJg/mhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prkv4poEQSslcuZ3EQzJygkodu98uK2GBrCMQwP1Jv+u3CP3XFnlQrFJBYoSPFzRN
         LJ8ycjAo79FWJ/jVbBbKmYFz5a9lI03yxyYMDzap72i0KBmDyi1tQSIUv18shNL34l
         j+0sjueevbspQmRJRaOoLJbYTrdWNFYYDwC0QvoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0674/1001] s390/idle: mark arch_cpu_idle() noinstr
Date:   Tue,  7 Mar 2023 17:57:26 +0100
Message-Id: <20230307170050.849380350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit a9cbc1b471d291c865907542394f1c483b93a811 ]

linux-next commit ("cpuidle: tracing: Warn about !rcu_is_watching()")
adds a new warning which hits on s390's arch_cpu_idle() function:

RCU not on for: arch_cpu_idle+0x0/0x28
WARNING: CPU: 2 PID: 0 at include/linux/trace_recursion.h:162 arch_ftrace_ops_list_func+0x24c/0x258
Modules linked in:
CPU: 2 PID: 0 Comm: swapper/2 Not tainted 6.2.0-rc6-next-20230202 #4
Hardware name: IBM 8561 T01 703 (z/VM 7.3.0)
Krnl PSW : 0404d00180000000 00000000002b55c0 (arch_ftrace_ops_list_func+0x250/0x258)
           R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
Krnl GPRS: c0000000ffffbfff 0000000080000002 0000000000000026 0000000000000000
           0000037ffffe3a28 0000037ffffe3a20 0000000000000000 0000000000000000
           0000000000000000 0000000000f4acf6 00000000001044f0 0000037ffffe3cb0
           0000000000000000 0000000000000000 00000000002b55bc 0000037ffffe3bb8
Krnl Code: 00000000002b55b0: c02000840051        larl    %r2,0000000001335652
           00000000002b55b6: c0e5fff512d1        brasl   %r14,0000000000157b58
          #00000000002b55bc: af000000            mc      0,0
          >00000000002b55c0: a7f4ffe7            brc     15,00000000002b558e
           00000000002b55c4: 0707                bcr     0,%r7
           00000000002b55c6: 0707                bcr     0,%r7
           00000000002b55c8: eb6ff0480024        stmg    %r6,%r15,72(%r15)
           00000000002b55ce: b90400ef            lgr     %r14,%r15
Call Trace:
 [<00000000002b55c0>] arch_ftrace_ops_list_func+0x250/0x258
([<00000000002b55bc>] arch_ftrace_ops_list_func+0x24c/0x258)
 [<0000000000f5f0fc>] ftrace_common+0x1c/0x20
 [<00000000001044f6>] arch_cpu_idle+0x6/0x28
 [<0000000000f4acf6>] default_idle_call+0x76/0x128
 [<00000000001cc374>] do_idle+0xf4/0x1b0
 [<00000000001cc6ce>] cpu_startup_entry+0x36/0x40
 [<0000000000119d00>] smp_start_secondary+0x140/0x150
 [<0000000000f5d2ae>] restart_int_handler+0x6e/0x90

Mark arch_cpu_idle() noinstr like all other architectures with
CONFIG_ARCH_WANTS_NO_INSTR (should) have it to fix this.

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/idle.c b/arch/s390/kernel/idle.c
index 4bf1ee293f2b3..a0da049e73609 100644
--- a/arch/s390/kernel/idle.c
+++ b/arch/s390/kernel/idle.c
@@ -44,7 +44,7 @@ void account_idle_time_irq(void)
 	S390_lowcore.last_update_timer = idle->timer_idle_exit;
 }
 
-void arch_cpu_idle(void)
+void noinstr arch_cpu_idle(void)
 {
 	struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
 	unsigned long idle_time;
-- 
2.39.2



