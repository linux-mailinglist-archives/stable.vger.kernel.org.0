Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4577F33E49E
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhCQBAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231686AbhCQA6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF8E64FAE;
        Wed, 17 Mar 2021 00:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942712;
        bh=tJppkkQxH6U1OjcQEgVnWQ7WGA+4wOLEyT5G0NsQy78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obikidQUdeF3SGbeE07+FsuV/Tpd5FVEltxdKNwGEPCieYFrkit9n4nTisxkfsWPQ
         SUwoYGZYHHPqPqxPR9JHMpDshtQSXGb2nJ0d/3laI18Lvf1ECUokXfd8mN/pwU0sxR
         M7JZFKRCMRb9ZRZKT3oUtIqz1vJUkyoF2Gvfe8gHhJZvCaviZIoWZa0VDr6EmZjiPl
         HUp8B0qZ6yLpn+gFq/76OapCSrES9GpuyQ6GYaEN5Rsyb26Tz0nhBHuadT68rGLPXz
         NQPhTt8tFGooDL4Q+cViOYHls4XXnii/JrbPMRGKyP/bWvCylSQ1CsEK7dmH6bZfMi
         HVMY5KPlSMlbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Gardner <rob.gardner@oracle.com>,
        Anatoly Pugachev <matorola@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/37] sparc64: Fix opcode filtering in handling of no fault loads
Date:   Tue, 16 Mar 2021 20:57:49 -0400
Message-Id: <20210317005802.725825-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Gardner <rob.gardner@oracle.com>

[ Upstream commit e5e8b80d352ec999d2bba3ea584f541c83f4ca3f ]

is_no_fault_exception() has two bugs which were discovered via random
opcode testing with stress-ng. Both are caused by improper filtering
of opcodes.

The first bug can be triggered by a floating point store with a no-fault
ASI, for instance "sta %f0, [%g0] #ASI_PNF", opcode C1A01040.

The code first tests op3[5] (0x1000000), which denotes a floating
point instruction, and then tests op3[2] (0x200000), which denotes a
store instruction. But these bits are not mutually exclusive, and the
above mentioned opcode has both bits set. The intent is to filter out
stores, so the test for stores must be done first in order to have
any effect.

The second bug can be triggered by a floating point load with one of
the invalid ASI values 0x8e or 0x8f, which pass this check in
is_no_fault_exception():
     if ((asi & 0xf2) == ASI_PNF)

An example instruction is "ldqa [%l7 + %o7] #ASI 0x8f, %f38",
opcode CF95D1EF. Asi values greater than 0x8b (ASI_SNFL) are fatal
in handle_ldf_stq(), and is_no_fault_exception() must not allow these
invalid asi values to make it that far.

In both of these cases, handle_ldf_stq() reacts by calling
sun4v_data_access_exception() or spitfire_data_access_exception(),
which call is_no_fault_exception() and results in an infinite
recursion.

Signed-off-by: Rob Gardner <rob.gardner@oracle.com>
Tested-by: Anatoly Pugachev <matorola@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/traps_64.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 27778b65a965..f2b22c496fb9 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -275,14 +275,13 @@ bool is_no_fault_exception(struct pt_regs *regs)
 			asi = (regs->tstate >> 24); /* saved %asi       */
 		else
 			asi = (insn >> 5);	    /* immediate asi    */
-		if ((asi & 0xf2) == ASI_PNF) {
-			if (insn & 0x1000000) {     /* op3[5:4]=3       */
-				handle_ldf_stq(insn, regs);
-				return true;
-			} else if (insn & 0x200000) { /* op3[2], stores */
+		if ((asi & 0xf6) == ASI_PNF) {
+			if (insn & 0x200000)        /* op3[2], stores   */
 				return false;
-			}
-			handle_ld_nf(insn, regs);
+			if (insn & 0x1000000)       /* op3[5:4]=3 (fp)  */
+				handle_ldf_stq(insn, regs);
+			else
+				handle_ld_nf(insn, regs);
 			return true;
 		}
 	}
-- 
2.30.1

