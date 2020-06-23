Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E4D2062F9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393375AbgFWVKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391440AbgFWUdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:33:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA90D2098B;
        Tue, 23 Jun 2020 20:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944419;
        bh=oInHpdmlWN717wx6ubP5AP8bxJAce1oMzk4419RoyAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1fOQqy0S3bhaxwHeiGczTHvfzmnO2HVJyREOU68q7McqU0XZVP7d+ipKAjdE90Zg
         NqDrFibMTZjAA5LPbdmPkPA9RPbXKN2IU3GRheoW2ahyx2/muRUxeZZDeLoVT+LnP4
         yRCGjwKbgOFoAFdM+8X6kj8dyDDe254gLA1va+VA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 267/314] powerpc: Fix kernel crash in show_instructions() w/DEBUG_VIRTUAL
Date:   Tue, 23 Jun 2020 21:57:42 +0200
Message-Id: <20200623195351.711020987@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit a6e2c226c3d51fd93636320e47cabc8a8f0824c5 ]

With CONFIG_DEBUG_VIRTUAL=y, we can hit a BUG() if we take a hard
lockup watchdog interrupt when in OPAL mode.

This happens in show_instructions() if the kernel takes the watchdog
NMI IPI, or any other interrupt, with MSR_IR == 0. show_instructions()
updates the variable pc in the loop and the second iteration will
result in BUG().

We hit the BUG_ON due the below check in  __va()

  #define __va(x)
  ({
  	VIRTUAL_BUG_ON((unsigned long)(x) >= PAGE_OFFSET);
  	(void *)(unsigned long)((phys_addr_t)(x) | PAGE_OFFSET);
  })

Fix it by moving the check out of the loop. Also update nip so that
the nip == pc check still matches.

Fixes: 4dd7554a6456 ("powerpc/64: Add VIRTUAL_BUG_ON checks for __va and __pa addresses")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
[mpe: Use IS_ENABLED(), massage change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200524093822.423487-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/process.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 639ceae7da9d8..bd0c258a1d5dd 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1218,29 +1218,31 @@ struct task_struct *__switch_to(struct task_struct *prev,
 static void show_instructions(struct pt_regs *regs)
 {
 	int i;
+	unsigned long nip = regs->nip;
 	unsigned long pc = regs->nip - (NR_INSN_TO_PRINT * 3 / 4 * sizeof(int));
 
 	printk("Instruction dump:");
 
+	/*
+	 * If we were executing with the MMU off for instructions, adjust pc
+	 * rather than printing XXXXXXXX.
+	 */
+	if (!IS_ENABLED(CONFIG_BOOKE) && !(regs->msr & MSR_IR)) {
+		pc = (unsigned long)phys_to_virt(pc);
+		nip = (unsigned long)phys_to_virt(regs->nip);
+	}
+
 	for (i = 0; i < NR_INSN_TO_PRINT; i++) {
 		int instr;
 
 		if (!(i % 8))
 			pr_cont("\n");
 
-#if !defined(CONFIG_BOOKE)
-		/* If executing with the IMMU off, adjust pc rather
-		 * than print XXXXXXXX.
-		 */
-		if (!(regs->msr & MSR_IR))
-			pc = (unsigned long)phys_to_virt(pc);
-#endif
-
 		if (!__kernel_text_address(pc) ||
 		    probe_kernel_address((const void *)pc, instr)) {
 			pr_cont("XXXXXXXX ");
 		} else {
-			if (regs->nip == pc)
+			if (nip == pc)
 				pr_cont("<%08x> ", instr);
 			else
 				pr_cont("%08x ", instr);
-- 
2.25.1



