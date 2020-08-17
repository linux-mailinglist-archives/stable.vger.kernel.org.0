Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE352475E4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388394AbgHQT3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730278AbgHQPcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307B520709;
        Mon, 17 Aug 2020 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678321;
        bh=Oa7Ez3rHLkW4BGy0tuai6tw2vu2xI3kKAl26GFf0WA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCmtJ/PBT4dlLH4pwoE+L47YMBUnK9wYAvWM7z4UpuoxrKJhee7EmMwvHWWJ45pzV
         UE61evSlocEV1D762vfkcw6UmcUNN1+StYt3vTrb7lEmvoZmIn0+lZn2Qw+i/RuSvE
         vfuDeWEHvqNRv0AvxkoTddahqQlFXv/l1cLPNRAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pedro Miraglia Franco de Carvalho <pedromfc@br.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 294/464] powerpc/watchpoint: Fix DAWR exception constraint
Date:   Mon, 17 Aug 2020 17:14:07 +0200
Message-Id: <20200817143847.841030507@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit f6780ce619f8daa285760302d56e95892087bd1f ]

Pedro Miraglia Franco de Carvalho noticed that on p8/p9, DAR value is
inconsistent with different type of load/store. Like for byte,word
etc. load/stores, DAR is set to the address of the first byte of
overlap between watch range and real access. But for quadword load/
store it's sometime set to the address of the first byte of real
access whereas sometime set to the address of the first byte of
overlap. This issue has been fixed in p10. In p10(ISA 3.1), DAR is
always set to the address of the first byte of overlap. Commit 27985b2a640e
("powerpc/watchpoint: Don't ignore extraneous exceptions blindly")
wrongly assumes that DAR is set to the address of the first byte of
overlap for all load/stores on p8/p9 as well. Fix that. With the fix,
we now rely on 'ea' provided by analyse_instr(). If analyse_instr()
fails, generate event unconditionally on p8/p9, and on p10 generate
event only if DAR is within a DAWR range.

Note: 8xx is not affected.

Fixes: 27985b2a640e ("powerpc/watchpoint: Don't ignore extraneous exceptions blindly")
Fixes: 74c6881019b7 ("powerpc/watchpoint: Prepare handler to handle more than one watchpoint")
Reported-by: Pedro Miraglia Franco de Carvalho <pedromfc@br.ibm.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200723090813.303838-3-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint.c | 72 ++++++++++++++++-------------
 1 file changed, 41 insertions(+), 31 deletions(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 031e6defc08e6..a971e22aea819 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -498,11 +498,11 @@ static bool dar_in_user_range(unsigned long dar, struct arch_hw_breakpoint *info
 	return ((info->address <= dar) && (dar - info->address < info->len));
 }
 
-static bool dar_user_range_overlaps(unsigned long dar, int size,
-				    struct arch_hw_breakpoint *info)
+static bool ea_user_range_overlaps(unsigned long ea, int size,
+				   struct arch_hw_breakpoint *info)
 {
-	return ((dar < info->address + info->len) &&
-		(dar + size > info->address));
+	return ((ea < info->address + info->len) &&
+		(ea + size > info->address));
 }
 
 static bool dar_in_hw_range(unsigned long dar, struct arch_hw_breakpoint *info)
@@ -515,20 +515,22 @@ static bool dar_in_hw_range(unsigned long dar, struct arch_hw_breakpoint *info)
 	return ((hw_start_addr <= dar) && (hw_end_addr > dar));
 }
 
-static bool dar_hw_range_overlaps(unsigned long dar, int size,
-				  struct arch_hw_breakpoint *info)
+static bool ea_hw_range_overlaps(unsigned long ea, int size,
+				 struct arch_hw_breakpoint *info)
 {
 	unsigned long hw_start_addr, hw_end_addr;
 
 	hw_start_addr = ALIGN_DOWN(info->address, HW_BREAKPOINT_SIZE);
 	hw_end_addr = ALIGN(info->address + info->len, HW_BREAKPOINT_SIZE);
 
-	return ((dar < hw_end_addr) && (dar + size > hw_start_addr));
+	return ((ea < hw_end_addr) && (ea + size > hw_start_addr));
 }
 
 /*
  * If hw has multiple DAWR registers, we also need to check all
  * dawrx constraint bits to confirm this is _really_ a valid event.
+ * If type is UNKNOWN, but privilege level matches, consider it as
+ * a positive match.
  */
 static bool check_dawrx_constraints(struct pt_regs *regs, int type,
 				    struct arch_hw_breakpoint *info)
@@ -553,7 +555,8 @@ static bool check_dawrx_constraints(struct pt_regs *regs, int type,
  * including extraneous exception. Otherwise return false.
  */
 static bool check_constraints(struct pt_regs *regs, struct ppc_inst instr,
-			      int type, int size, struct arch_hw_breakpoint *info)
+			      unsigned long ea, int type, int size,
+			      struct arch_hw_breakpoint *info)
 {
 	bool in_user_range = dar_in_user_range(regs->dar, info);
 	bool dawrx_constraints;
@@ -569,22 +572,27 @@ static bool check_constraints(struct pt_regs *regs, struct ppc_inst instr,
 	}
 
 	if (unlikely(ppc_inst_equal(instr, ppc_inst(0)))) {
-		if (in_user_range)
-			return true;
+		if (cpu_has_feature(CPU_FTR_ARCH_31) &&
+		    !dar_in_hw_range(regs->dar, info))
+			return false;
 
-		if (dar_in_hw_range(regs->dar, info)) {
-			info->type |= HW_BRK_TYPE_EXTRANEOUS_IRQ;
-			return true;
-		}
-		return false;
+		return true;
 	}
 
 	dawrx_constraints = check_dawrx_constraints(regs, type, info);
 
-	if (dar_user_range_overlaps(regs->dar, size, info))
+	if (type == UNKNOWN) {
+		if (cpu_has_feature(CPU_FTR_ARCH_31) &&
+		    !dar_in_hw_range(regs->dar, info))
+			return false;
+
 		return dawrx_constraints;
+	}
 
-	if (dar_hw_range_overlaps(regs->dar, size, info)) {
+	if (ea_user_range_overlaps(ea, size, info))
+		return dawrx_constraints;
+
+	if (ea_hw_range_overlaps(ea, size, info)) {
 		if (dawrx_constraints) {
 			info->type |= HW_BRK_TYPE_EXTRANEOUS_IRQ;
 			return true;
@@ -594,7 +602,7 @@ static bool check_constraints(struct pt_regs *regs, struct ppc_inst instr,
 }
 
 static void get_instr_detail(struct pt_regs *regs, struct ppc_inst *instr,
-			     int *type, int *size, bool *larx_stcx)
+			     int *type, int *size, unsigned long *ea)
 {
 	struct instruction_op op;
 
@@ -602,16 +610,18 @@ static void get_instr_detail(struct pt_regs *regs, struct ppc_inst *instr,
 		return;
 
 	analyse_instr(&op, regs, *instr);
-
-	/*
-	 * Set size = 8 if analyse_instr() fails. If it's a userspace
-	 * watchpoint(valid or extraneous), we can notify user about it.
-	 * If it's a kernel watchpoint, instruction  emulation will fail
-	 * in stepping_handler() and watchpoint will be disabled.
-	 */
 	*type = GETTYPE(op.type);
-	*size = !(*type == UNKNOWN) ? GETSIZE(op.type) : 8;
-	*larx_stcx = (*type == LARX || *type == STCX);
+	*ea = op.ea;
+#ifdef __powerpc64__
+	if (!(regs->msr & MSR_64BIT))
+		*ea &= 0xffffffffUL;
+#endif
+	*size = GETSIZE(op.type);
+}
+
+static bool is_larx_stcx_instr(int type)
+{
+	return type == LARX || type == STCX;
 }
 
 /*
@@ -678,7 +688,7 @@ int hw_breakpoint_handler(struct die_args *args)
 	struct ppc_inst instr = ppc_inst(0);
 	int type = 0;
 	int size = 0;
-	bool larx_stcx = false;
+	unsigned long ea;
 
 	/* Disable breakpoints during exception handling */
 	hw_breakpoint_disable();
@@ -692,7 +702,7 @@ int hw_breakpoint_handler(struct die_args *args)
 	rcu_read_lock();
 
 	if (!IS_ENABLED(CONFIG_PPC_8xx))
-		get_instr_detail(regs, &instr, &type, &size, &larx_stcx);
+		get_instr_detail(regs, &instr, &type, &size, &ea);
 
 	for (i = 0; i < nr_wp_slots(); i++) {
 		bp[i] = __this_cpu_read(bp_per_reg[i]);
@@ -702,7 +712,7 @@ int hw_breakpoint_handler(struct die_args *args)
 		info[i] = counter_arch_bp(bp[i]);
 		info[i]->type &= ~HW_BRK_TYPE_EXTRANEOUS_IRQ;
 
-		if (check_constraints(regs, instr, type, size, info[i])) {
+		if (check_constraints(regs, instr, ea, type, size, info[i])) {
 			if (!IS_ENABLED(CONFIG_PPC_8xx) &&
 			    ppc_inst_equal(instr, ppc_inst(0))) {
 				handler_error(bp[i], info[i]);
@@ -744,7 +754,7 @@ int hw_breakpoint_handler(struct die_args *args)
 	}
 
 	if (!IS_ENABLED(CONFIG_PPC_8xx)) {
-		if (larx_stcx) {
+		if (is_larx_stcx_instr(type)) {
 			for (i = 0; i < nr_wp_slots(); i++) {
 				if (!hit[i])
 					continue;
-- 
2.25.1



