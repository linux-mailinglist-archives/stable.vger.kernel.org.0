Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504014A44FD
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350817AbiAaLfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376357AbiAaLcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:32:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA37C061A0F;
        Mon, 31 Jan 2022 03:21:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C66C611E3;
        Mon, 31 Jan 2022 11:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3146FC340E8;
        Mon, 31 Jan 2022 11:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628104;
        bh=NdTW5NgfwiFjogl66b/Xf/Y5/M2AILW4jhs+wTa+xZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGiT6bBZu2lpxw/FicC2wYsPmJxgOymCofZLtOpqDk1ePVoJUlS+0Fgjk9NKG9FTR
         P37YSHsClYWTz8mX1tQKeUESCTHCY7QwWXTCcNy9ecxff/kRqrRdWMxBoIRLMyDtv7
         z3yZpK6yBuH4MlZa8Kg7EpWhu4r/r/FlO2dY+nUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 125/200] powerpc64/bpf: Limit ldbrx to processors compliant with ISA v2.06
Date:   Mon, 31 Jan 2022 11:56:28 +0100
Message-Id: <20220131105237.768085761@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 3f5f766d5f7f95a69a630da3544a1a0cee1cdddf ]

Johan reported the below crash with test_bpf on ppc64 e5500:

  test_bpf: #296 ALU_END_FROM_LE 64: 0x0123456789abcdef -> 0x67452301 jited:1
  Oops: Exception in kernel mode, sig: 4 [#1]
  BE PAGE_SIZE=4K SMP NR_CPUS=24 QEMU e500
  Modules linked in: test_bpf(+)
  CPU: 0 PID: 76 Comm: insmod Not tainted 5.14.0-03771-g98c2059e008a-dirty #1
  NIP:  8000000000061c3c LR: 80000000006dea64 CTR: 8000000000061c18
  REGS: c0000000032d3420 TRAP: 0700   Not tainted (5.14.0-03771-g98c2059e008a-dirty)
  MSR:  0000000080089000 <EE,ME>  CR: 88002822  XER: 20000000 IRQMASK: 0
  <...>
  NIP [8000000000061c3c] 0x8000000000061c3c
  LR [80000000006dea64] .__run_one+0x104/0x17c [test_bpf]
  Call Trace:
   .__run_one+0x60/0x17c [test_bpf] (unreliable)
   .test_bpf_init+0x6a8/0xdc8 [test_bpf]
   .do_one_initcall+0x6c/0x28c
   .do_init_module+0x68/0x28c
   .load_module+0x2460/0x2abc
   .__do_sys_init_module+0x120/0x18c
   .system_call_exception+0x110/0x1b8
   system_call_common+0xf0/0x210
  --- interrupt: c00 at 0x101d0acc
  <...>
  ---[ end trace 47b2bf19090bb3d0 ]---

  Illegal instruction

The illegal instruction turned out to be 'ldbrx' emitted for
BPF_FROM_[L|B]E, which was only introduced in ISA v2.06. Guard use of
the same and implement an alternative approach for older processors.

Fixes: 156d0e290e969c ("powerpc/ebpf/jit: Implement JIT compiler for extended BPF")
Reported-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Tested-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Acked-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/d1e51c6fdf572062cf3009a751c3406bda01b832.1641468127.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/ppc-opcode.h |  1 +
 arch/powerpc/net/bpf_jit_comp64.c     | 22 +++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index baea657bc8687..bca31a61e57f8 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -498,6 +498,7 @@
 #define PPC_RAW_LDX(r, base, b)		(0x7c00002a | ___PPC_RT(r) | ___PPC_RA(base) | ___PPC_RB(b))
 #define PPC_RAW_LHZ(r, base, i)		(0xa0000000 | ___PPC_RT(r) | ___PPC_RA(base) | IMM_L(i))
 #define PPC_RAW_LHBRX(r, base, b)	(0x7c00062c | ___PPC_RT(r) | ___PPC_RA(base) | ___PPC_RB(b))
+#define PPC_RAW_LWBRX(r, base, b)	(0x7c00042c | ___PPC_RT(r) | ___PPC_RA(base) | ___PPC_RB(b))
 #define PPC_RAW_LDBRX(r, base, b)	(0x7c000428 | ___PPC_RT(r) | ___PPC_RA(base) | ___PPC_RB(b))
 #define PPC_RAW_STWCX(s, a, b)		(0x7c00012d | ___PPC_RS(s) | ___PPC_RA(a) | ___PPC_RB(b))
 #define PPC_RAW_CMPWI(a, i)		(0x2c000000 | ___PPC_RA(a) | IMM_L(i))
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 6057e900a8790..a26a782e8b78e 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -633,17 +633,21 @@ bpf_alu32_trunc:
 				EMIT(PPC_RAW_MR(dst_reg, b2p[TMP_REG_1]));
 				break;
 			case 64:
-				/*
-				 * Way easier and faster(?) to store the value
-				 * into stack and then use ldbrx
-				 *
-				 * ctx->seen will be reliable in pass2, but
-				 * the instructions generated will remain the
-				 * same across all passes
-				 */
+				/* Store the value to stack and then use byte-reverse loads */
 				PPC_BPF_STL(dst_reg, 1, bpf_jit_stack_local(ctx));
 				EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], 1, bpf_jit_stack_local(ctx)));
-				EMIT(PPC_RAW_LDBRX(dst_reg, 0, b2p[TMP_REG_1]));
+				if (cpu_has_feature(CPU_FTR_ARCH_206)) {
+					EMIT(PPC_RAW_LDBRX(dst_reg, 0, b2p[TMP_REG_1]));
+				} else {
+					EMIT(PPC_RAW_LWBRX(dst_reg, 0, b2p[TMP_REG_1]));
+					if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
+						EMIT(PPC_RAW_SLDI(dst_reg, dst_reg, 32));
+					EMIT(PPC_RAW_LI(b2p[TMP_REG_2], 4));
+					EMIT(PPC_RAW_LWBRX(b2p[TMP_REG_2], b2p[TMP_REG_2], b2p[TMP_REG_1]));
+					if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
+						EMIT(PPC_RAW_SLDI(b2p[TMP_REG_2], b2p[TMP_REG_2], 32));
+					EMIT(PPC_RAW_OR(dst_reg, dst_reg, b2p[TMP_REG_2]));
+				}
 				break;
 			}
 			break;
-- 
2.34.1



