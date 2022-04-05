Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0BE4F3351
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350162AbiDEJzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243214AbiDEJIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1439F3A6;
        Tue,  5 Apr 2022 01:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F918B81C77;
        Tue,  5 Apr 2022 08:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B032EC385A0;
        Tue,  5 Apr 2022 08:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149065;
        bh=dDEgLEE+d+dNNd5zKLzfFJYE/4qo9BE4nxHk/OiZzKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clVY+BKzFrPu44LwKPepLRd1ri9lTo0B4d2+//DTOExn54i0N3scq/uKfE//aPG0c
         cvRasiJGpTGnuOJwVJfdsbyFnX7OxoRrl1gD1IC+OoZzXZg1NXC/arPHenJ1+HAMwV
         FnEL5Gt/CNQWPozfHcqPfCjRIZA+/rSubG1ukkBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nageswara R Sastry <rnsastry@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0580/1017] powerpc/64s: Dont use DSISR for SLB faults
Date:   Tue,  5 Apr 2022 09:24:53 +0200
Message-Id: <20220405070411.496151286@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit d4679ac8ea2e5078704aa1c026db36580cc1bf9a ]

Since commit 46ddcb3950a2 ("powerpc/mm: Show if a bad page fault on data
is read or write.") we use page_fault_is_write(regs->dsisr) in
__bad_page_fault() to determine if the fault is for a read or write, and
change the message printed accordingly.

But SLB faults, aka Data Segment Interrupts, don't set DSISR (Data
Storage Interrupt Status Register) to a useful value. All ISA versions
from v2.03 through v3.1 specify that the Data Segment Interrupt sets
DSISR "to an undefined value". As far as I can see there's no mention of
SLB faults setting DSISR in any BookIV content either.

This manifests as accesses that should be a read being incorrectly
reported as writes, for example, using the xmon "dump" command:

  0:mon> d 0x5deadbeef0000000
  5deadbeef0000000
  [359526.415354][    C6] BUG: Unable to handle kernel data access on write at 0x5deadbeef0000000
  [359526.415611][    C6] Faulting instruction address: 0xc00000000010a300
  cpu 0x6: Vector: 380 (Data SLB Access) at [c00000000ffbf400]
      pc: c00000000010a300: mread+0x90/0x190

If we disassemble the PC, we see a load instruction:

  0:mon> di c00000000010a300
  c00000000010a300 89490000      lbz     r10,0(r9)

We can also see in exceptions-64s.S that the data_access_slb block
doesn't set IDSISR=1, which means it doesn't load DSISR into pt_regs. So
the value we're using to determine if the fault is a read/write is some
stale value in pt_regs from a previous page fault.

Rework the printing logic to separate the SLB fault case out, and only
print read/write in the cases where we can determine it.

The result looks like eg:

  0:mon> d 0x5deadbeef0000000
  5deadbeef0000000
  [  721.779525][    C6] BUG: Unable to handle kernel data access at 0x5deadbeef0000000
  [  721.779697][    C6] Faulting instruction address: 0xc00000000014cbe0
  cpu 0x6: Vector: 380 (Data SLB Access) at [c00000000ffbf390]

  0:mon> d 0
  0000000000000000
  [  742.793242][    C6] BUG: Kernel NULL pointer dereference at 0x00000000
  [  742.793316][    C6] Faulting instruction address: 0xc00000000014cbe0
  cpu 0x6: Vector: 380 (Data SLB Access) at [c00000000ffbf390]

Fixes: 46ddcb3950a2 ("powerpc/mm: Show if a bad page fault on data is read or write.")
Reported-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Link: https://lore.kernel.org/r/20220222113449.319193-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/fault.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index a8d0ce85d39a..4a15172dfef2 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -568,18 +568,24 @@ NOKPROBE_SYMBOL(hash__do_page_fault);
 static void __bad_page_fault(struct pt_regs *regs, int sig)
 {
 	int is_write = page_fault_is_write(regs->dsisr);
+	const char *msg;
 
 	/* kernel has accessed a bad area */
 
+	if (regs->dar < PAGE_SIZE)
+		msg = "Kernel NULL pointer dereference";
+	else
+		msg = "Unable to handle kernel data access";
+
 	switch (TRAP(regs)) {
 	case INTERRUPT_DATA_STORAGE:
-	case INTERRUPT_DATA_SEGMENT:
 	case INTERRUPT_H_DATA_STORAGE:
-		pr_alert("BUG: %s on %s at 0x%08lx\n",
-			 regs->dar < PAGE_SIZE ? "Kernel NULL pointer dereference" :
-			 "Unable to handle kernel data access",
+		pr_alert("BUG: %s on %s at 0x%08lx\n", msg,
 			 is_write ? "write" : "read", regs->dar);
 		break;
+	case INTERRUPT_DATA_SEGMENT:
+		pr_alert("BUG: %s at 0x%08lx\n", msg, regs->dar);
+		break;
 	case INTERRUPT_INST_STORAGE:
 	case INTERRUPT_INST_SEGMENT:
 		pr_alert("BUG: Unable to handle kernel instruction fetch%s",
-- 
2.34.1



