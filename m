Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C317F329028
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbhCAUDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242341AbhCATxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8268465226;
        Mon,  1 Mar 2021 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621186;
        bh=TkggZfF7LSbHhVv8qnNlk1/wH6rq3eNaJMd6iCuWZhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKxv1LgvK/uHrfzJUB+JAPoq1HxPW1+puOkjBdwJTjDF+BQZPHWl3Q9jd+kT/Gw22
         sJRKMwGVIdowSpQO1umUVUkKIBmcVaBCE/U0ekURlA72JBilFvKrfoT/tbp0D1rTMf
         phCEXT1zlz5fQqwJV1n0yFZ7jO+Fug+5Jls6xZZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandipan Das <sandipan@linux.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 424/775] powerpc/sstep: Fix load-store and update emulation
Date:   Mon,  1 Mar 2021 17:09:52 +0100
Message-Id: <20210301161222.525233074@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan@linux.ibm.com>

[ Upstream commit bbda4b6c7d7c7f79da71f95c92a5d76be22c3efd ]

The Power ISA says that the fixed-point load and update instructions
must neither use R0 for the base address (RA) nor have the
destination (RT) and the base address (RA) as the same register.
Similarly, for fixed-point stores and floating-point loads and stores,
the instruction is invalid when R0 is used as the base address (RA).

This is applicable to the following instructions.
  * Load Byte and Zero with Update (lbzu)
  * Load Byte and Zero with Update Indexed (lbzux)
  * Load Halfword and Zero with Update (lhzu)
  * Load Halfword and Zero with Update Indexed (lhzux)
  * Load Halfword Algebraic with Update (lhau)
  * Load Halfword Algebraic with Update Indexed (lhaux)
  * Load Word and Zero with Update (lwzu)
  * Load Word and Zero with Update Indexed (lwzux)
  * Load Word Algebraic with Update Indexed (lwaux)
  * Load Doubleword with Update (ldu)
  * Load Doubleword with Update Indexed (ldux)
  * Load Floating Single with Update (lfsu)
  * Load Floating Single with Update Indexed (lfsux)
  * Load Floating Double with Update (lfdu)
  * Load Floating Double with Update Indexed (lfdux)
  * Store Byte with Update (stbu)
  * Store Byte with Update Indexed (stbux)
  * Store Halfword with Update (sthu)
  * Store Halfword with Update Indexed (sthux)
  * Store Word with Update (stwu)
  * Store Word with Update Indexed (stwux)
  * Store Doubleword with Update (stdu)
  * Store Doubleword with Update Indexed (stdux)
  * Store Floating Single with Update (stfsu)
  * Store Floating Single with Update Indexed (stfsux)
  * Store Floating Double with Update (stfdu)
  * Store Floating Double with Update Indexed (stfdux)

E.g. the following behaviour is observed for an invalid load and
update instruction having RA = RT.

While a userspace program having an instruction word like 0xe9ce0001,
i.e. ldu r14, 0(r14), runs without getting receiving a SIGILL on a
Power system (observed on P8 and P9), the outcome of executing that
instruction word varies and its behaviour can be considered to be
undefined.

Attaching an uprobe at that instruction's address results in emulation
which currently performs the load as well as writes the effective
address back to the base register. This might not match the outcome
from hardware.

To remove any inconsistencies, this adds additional checks for the
aforementioned instructions to make sure that the emulation
infrastructure treats them as unknown. The kernel can then fallback to
executing such instructions on hardware.

Fixes: 0016a4cf5582 ("powerpc: Emulate most Book I instructions in emulate_step()")
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210204080744.135785-1-sandipan@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/sstep.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index 33935869e4976..25cfa9c622c58 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -3019,6 +3019,20 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
 	}
 
+	if (OP_IS_LOAD_STORE(op->type) && (op->type & UPDATE)) {
+		switch (GETTYPE(op->type)) {
+		case LOAD:
+			if (ra == rd)
+				goto unknown_opcode;
+			fallthrough;
+		case STORE:
+		case LOAD_FP:
+		case STORE_FP:
+			if (ra == 0)
+				goto unknown_opcode;
+		}
+	}
+
 #ifdef CONFIG_VSX
 	if ((GETTYPE(op->type) == LOAD_VSX ||
 	     GETTYPE(op->type) == STORE_VSX) &&
-- 
2.27.0



