Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6D755E8A7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbiF1PNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348014AbiF1PNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 11:13:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904A91D331
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 08:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3999AB81E3D
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 15:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8247DC3411D;
        Tue, 28 Jun 2022 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656429190;
        bh=FPWKhxksykPqrm5K5pUo6WtVBcbCDsVOuIp4w6S2pFs=;
        h=From:To:Cc:Subject:Date:From;
        b=glzWtcHWlQOlR3r8Fj2rNX60tqwrOq+LHGSQ0Ksv6c+l/Whstqzi/QG1TKIR9Vdp5
         IiIvjwAp3hNz5IoK8lIi0xK+U9H8ody+7vy2SEq6PCTTYho4nLWEq2HCG9zRrDgtQY
         pMZ45uwt/strnDD9TDZJNg6NMQwD7xbrUd1rMnnZDeaKNav+dcxrJ4c96PaebR4Qkk
         hTHIAcRBz/6Abc/50p9iC90Sq3vi2sPeHZEdDP8Zy6N1BwMgQpk/6CVzQzUVxb7r7Y
         vHdfRpX5heSzcVAQQYdgAZ2jruDZeluiYBtiZ30xcMfIfonwcuYL6hq3aleYOdtRXv
         KMdB8IDb5IqxA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux@armlinux.org.uk
Cc:     linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@linaro.org, Ard Biesheuvel <ardb@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: alignment: advance IT state after emulating Thumb instruction
Date:   Tue, 28 Jun 2022 17:12:58 +0200
Message-Id: <20220628151258.2582737-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3641; h=from:subject; bh=FPWKhxksykPqrm5K5pUo6WtVBcbCDsVOuIp4w6S2pFs=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiuxp2W3SFe6l7FbglahXmCUO4T5/GZimwb6Lt+Veu x956liCJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYrsadgAKCRDDTyI5ktmPJHThC/ 4ysWl5fJkI7CBELsQ4ELK47sYlgdaG8TGnqhtqn+BBXoBP3r0KQLTK9I+qyeCTv33K/HoN68aOxpIf oL6swrbIUCRD9BbQobA8Eg/mocrE8yAb5+qCuj8fMmD/P1Jkid8ONdsuTux9JXY6jooEv5rDPQmSTm pVmfPAWOJZOO36D4jvNlWLIN0S8+yyk2hR0Pqnbw5aJWfqrGHvAQqY1Iw46pIp5/wj0uNs3/sK3O7z 6oY26LzGvr5VnkRJLcIlLv4QSco3qh2IvuWWF4D11g7ynEgQPweBfiGB0J4R+yYxk7KKRbFC2T9Ttp ri8//xYJ+z3sga5QXH7UNMoLrkT9iTkhr1iokjqq/uaDbDwSAesZm4aYAf1M2I5J/P1rpEOJ7u5Rr2 AlCaI8V3t4RUNnH3YDU9ftq/HTbHregDDR0bmmH/sOTD0NNQdLuDPeo/3fL1UVxdK6Y9sIdvot5+ix W6b2qJAskoq9cImjqa/0jCWLWdQ1UH1bFYB1VKx+B0SbI=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After emulating a misaligned load or store issued in Thumb mode, we have
to advance the IT state by hand, or it will get out of sync with the
actual instruction stream, which means we'll end up applying the wrong
condition code to subsequent instructions. This might corrupt the
program state rather catastrophically.

So borrow the it_advance() helper from the probing code, and use it on
CPSR if the emulated instruction is Thumb.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/ptrace.h | 26 ++++++++++++++++++++++++++
 arch/arm/mm/alignment.c       |  3 +++
 arch/arm/probes/decode.h      | 26 +-------------------------
 3 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 93051e2f402c..1408a6a15d0e 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -163,5 +163,31 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 		((current_stack_pointer | (THREAD_SIZE - 1)) - 7) - 1;	\
 })
 
+
+/*
+ * Update ITSTATE after normal execution of an IT block instruction.
+ *
+ * The 8 IT state bits are split into two parts in CPSR:
+ *	ITSTATE<1:0> are in CPSR<26:25>
+ *	ITSTATE<7:2> are in CPSR<15:10>
+ */
+static inline unsigned long it_advance(unsigned long cpsr)
+{
+	if ((cpsr & 0x06000400) == 0) {
+		/* ITSTATE<2:0> == 0 means end of IT block, so clear IT state */
+		cpsr &= ~PSR_IT_MASK;
+	} else {
+		/* We need to shift left ITSTATE<4:0> */
+		const unsigned long mask = 0x06001c00;  /* Mask ITSTATE<4:0> */
+		unsigned long it = cpsr & mask;
+		it <<= 1;
+		it |= it >> (27 - 10);  /* Carry ITSTATE<2> to correct place */
+		it &= mask;
+		cpsr &= ~mask;
+		cpsr |= it;
+	}
+	return cpsr;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 6f499559d193..f8dd0b3cc8e0 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -935,6 +935,9 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (type == TYPE_LDST)
 		do_alignment_finish_ldst(addr, instr, regs, offset);
 
+	if (thumb_mode(regs))
+		regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
+
 	return 0;
 
  bad_or_fault:
diff --git a/arch/arm/probes/decode.h b/arch/arm/probes/decode.h
index 973173598992..facc889d05ee 100644
--- a/arch/arm/probes/decode.h
+++ b/arch/arm/probes/decode.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <asm/probes.h>
+#include <asm/ptrace.h>
 #include <asm/kprobes.h>
 
 void __init arm_probes_decode_init(void);
@@ -35,31 +36,6 @@ void __init find_str_pc_offset(void);
 #endif
 
 
-/*
- * Update ITSTATE after normal execution of an IT block instruction.
- *
- * The 8 IT state bits are split into two parts in CPSR:
- *	ITSTATE<1:0> are in CPSR<26:25>
- *	ITSTATE<7:2> are in CPSR<15:10>
- */
-static inline unsigned long it_advance(unsigned long cpsr)
-	{
-	if ((cpsr & 0x06000400) == 0) {
-		/* ITSTATE<2:0> == 0 means end of IT block, so clear IT state */
-		cpsr &= ~PSR_IT_MASK;
-	} else {
-		/* We need to shift left ITSTATE<4:0> */
-		const unsigned long mask = 0x06001c00;  /* Mask ITSTATE<4:0> */
-		unsigned long it = cpsr & mask;
-		it <<= 1;
-		it |= it >> (27 - 10);  /* Carry ITSTATE<2> to correct place */
-		it &= mask;
-		cpsr &= ~mask;
-		cpsr |= it;
-	}
-	return cpsr;
-}
-
 static inline void __kprobes bx_write_pc(long pcv, struct pt_regs *regs)
 {
 	long cpsr = regs->ARM_cpsr;
-- 
2.35.1

