Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AC234425C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhCVMky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232003AbhCVMje (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFBEB619A2;
        Mon, 22 Mar 2021 12:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416696;
        bh=QuGiOYuzq0ntzJUrAlRofhELOhughI7VSrqqNFaZxfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6M7n6iRSSSMdtYZN4pwMhhFa/0uYKJuEtIu8DNTgs0SsGZV+xIswsOB95D51iA4d
         9VlSmjao2ZdsXaj12899vXhaghME2eI3HmxjCdYx8/3KgkKrm0VhzWqZoDnmMLTgi1
         y5Bpiusxd8Fw4Uf1trx1qwZzQSUrUEpOPDer6kEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandipan Das <sandipan@linux.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/157] powerpc/sstep: Fix load-store and update emulation
Date:   Mon, 22 Mar 2021 13:27:23 +0100
Message-Id: <20210322121936.515547204@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
index 242bdd8281e0..0f228ee11ca4 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -2909,6 +2909,20 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 
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
2.30.1



