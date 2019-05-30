Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 754162FD66
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 16:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfE3ORk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 10:17:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17630 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbfE3ORk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 10:17:40 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CFF6B529D7ADA0759992;
        Thu, 30 May 2019 22:17:34 +0800 (CST)
Received: from huawei.com (10.67.188.14) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 30 May 2019
 22:17:28 +0800
From:   xiaoqian <xiaoqian9@huawei.com>
To:     <linux@armlinux.org.uk>, <rafael.j.wysocki@intel.com>,
        <ebiederm@xmission.com>, <rppt@linux.ibm.com>, <pmladek@suse.com>,
        <bhelgaas@google.com>, <sakari.ailus@linux.intel.com>
CC:     <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>,
        <xiaoqian9@huawei.com>
Subject: [PATCH] Subject:ARM:fetch pc-instr before local_irq_enable
Date:   Thu, 30 May 2019 22:17:30 +0800
Message-ID: <1559225850-73915-1-git-send-email-xiaoqian9@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.188.14]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the instruction code under PC address is read through
_probe_kernel_read in do_alignment,if the pte page corresponding
to the code segment of PC address is reclaimed exactly at this time,
the address mapping cannot be reconstructed because page fault_disable()
is executed in _probe_kernel_read function,and the failure to obtain
the instruction code of PC finally results in the unsuccessful repair
operation.
Thus we can modify the implementation of reading user-mode PC instruction
before local_irq_enable to avoid the above risk.
At the same time, adjust the sequence of code processing and optimize the
process.

Signed-off-by: xiaoqian <xiaoqian9@huawei.com>
Cc: stable@vger.kernel.org
---
 arch/arm/mm/alignment.c | 81 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index e376883ab35b..4124b9ce3c70 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -76,6 +76,11 @@
 #define IS_T32(hi16) \
 	(((hi16) & 0xe000) == 0xe000 && ((hi16) & 0x1800))
 
+#define INVALID_INSTR_MODE     0
+#define ARM_INSTR_MODE         1
+#define THUMB_INSTR_MODE       2
+#define THUMB2_INSTR_MODE      3
+
 static unsigned long ai_user;
 static unsigned long ai_sys;
 static void *ai_sys_last_pc;
@@ -705,6 +710,48 @@ thumb2arm(u16 tinstr)
 	}
 }
 
+static unsigned int
+fetch_usr_pc_instr(struct pt_regs *regs, unsigned long *pc_instrptr)
+{
+	unsigned int fault;
+	unsigned long instrptr;
+	unsigned long instr_mode = INVALID_INSTR_MODE;
+
+	instrptr = instruction_pointer(regs);
+
+	if (thumb_mode(regs)) {
+		u16 tinstr = 0;
+		u16 *ptr = (u16 *)(instrptr & ~1);
+
+		fault = probe_kernel_address(ptr, tinstr);
+		if (!fault) {
+			tinstr = __mem_to_opcode_thumb16(tinstr);
+			if (cpu_architecture() >= CPU_ARCH_ARMv7 &&
+			    IS_T32(tinstr)) {
+				/* Thumb-2 32-bit */
+				u16 tinstr2 = 0;
+
+				fault = probe_kernel_address(ptr + 1, tinstr2);
+				if (!fault) {
+					tinstr2 = __mem_to_opcode_thumb16(tinstr2);
+					*pc_instrptr = __opcode_thumb32_compose(tinstr, tinstr2);
+					instr_mode = THUMB2_INSTR_MODE;
+				}
+			} else {
+				*pc_instrptr = thumb2arm(tinstr);
+				instr_mode = THUMB_INSTR_MODE;
+			}
+		}
+	} else {
+		fault = probe_kernel_address((void *)instrptr, *pc_instrptr);
+		if (!fault) {
+			*pc_instrptr = __mem_to_opcode_arm(*pc_instrptr);
+			instr_mode = ARM_INSTR_MODE;
+		}
+	}
+	return instr_mode;
+}
+
 /*
  * Convert Thumb-2 32 bit LDM, STM, LDRD, STRD to equivalent instruction
  * handlable by ARM alignment handler, also find the corresponding handler,
@@ -775,42 +822,24 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	unsigned long instr = 0, instrptr;
 	int (*handler)(unsigned long addr, unsigned long instr, struct pt_regs *regs);
 	unsigned int type;
-	unsigned int fault;
 	u16 tinstr = 0;
 	int isize = 4;
 	int thumb2_32b = 0;
+	unsigned long pc_instr_mode;
+
+	pc_instr_mode = fetch_usr_pc_instr(regs, &instr);
 
 	if (interrupts_enabled(regs))
 		local_irq_enable();
 
 	instrptr = instruction_pointer(regs);
-
-	if (thumb_mode(regs)) {
-		u16 *ptr = (u16 *)(instrptr & ~1);
-		fault = probe_kernel_address(ptr, tinstr);
-		tinstr = __mem_to_opcode_thumb16(tinstr);
-		if (!fault) {
-			if (cpu_architecture() >= CPU_ARCH_ARMv7 &&
-			    IS_T32(tinstr)) {
-				/* Thumb-2 32-bit */
-				u16 tinst2 = 0;
-				fault = probe_kernel_address(ptr + 1, tinst2);
-				tinst2 = __mem_to_opcode_thumb16(tinst2);
-				instr = __opcode_thumb32_compose(tinstr, tinst2);
-				thumb2_32b = 1;
-			} else {
-				isize = 2;
-				instr = thumb2arm(tinstr);
-			}
-		}
-	} else {
-		fault = probe_kernel_address((void *)instrptr, instr);
-		instr = __mem_to_opcode_arm(instr);
-	}
-
-	if (fault) {
+	if (pc_instr_mode == INVALID_INSTR_MODE) {
 		type = TYPE_FAULT;
 		goto bad_or_fault;
+	} else if (pc_instr_mode == THUMB_INSTR_MODE) {
+		isize = 2;
+	} else if (pc_instr_mode == THUMB2_INSTR_MODE) {
+		thumb2_32b = 1;
 	}
 
 	if (user_mode(regs))
-- 
2.12.3

