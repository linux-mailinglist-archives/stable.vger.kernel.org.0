Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A60514851F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 13:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731460AbgAXMZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 07:25:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730673AbgAXMZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 07:25:41 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00OCD4qF071179
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 07:25:40 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xqmjtcyy4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 07:25:40 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <svens@linux.ibm.com>;
        Fri, 24 Jan 2020 12:25:38 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 24 Jan 2020 12:25:36 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00OCPZ0E29687910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 12:25:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2693A4C050;
        Fri, 24 Jan 2020 12:25:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F6404C058;
        Fri, 24 Jan 2020 12:25:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 24 Jan 2020 12:25:35 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55390)
        id 9CE62E0379; Fri, 24 Jan 2020 13:25:34 +0100 (CET)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     linux390-list@tuxmaker.boeblingen.de.ibm.com
Cc:     Sven Schnelle <svens@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v2] s390: prevent leaking kernel address in BEAR
Date:   Fri, 24 Jan 2020 13:25:15 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20012412-0020-0000-0000-000003A39A74
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012412-0021-0000-0000-000021FB37CC
Message-Id: <20200124122515.80348-1-svens@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_03:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=953
 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1011
 mlxscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 suspectscore=1 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001240102
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When userspace executes a syscall or gets interrupted,
BEAR contains a kernel address when returning to userspace.
This make it pretty easy to figure out where the kernel is
mapped even with KASLR enabled. To fix this, add lpswe to
lowcore and always execute it there, so userspace sees only
the lowcore address of lpswe. For this we have to extend
both critical_cleanup and the SWITCH_ASYNC macro to also check
for lpswe addresses in lowcore.

Fixes: b2d24b97b2a9 ("s390/kernel: add support for kernel address space layout randomization (KASLR)")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
---

Changes in v2:
 - use cghi instead of clgfi in address compare
 - use b mnemonic instead of bc 15,x
 - Add Fixes: and Cc: stable

 arch/s390/include/asm/lowcore.h |  4 +++-
 arch/s390/include/asm/setup.h   |  7 +++++++
 arch/s390/kernel/asm-offsets.c  |  2 ++
 arch/s390/kernel/entry.S        | 30 ++++++++++++++++++------------
 arch/s390/kernel/setup.c        |  3 +++
 arch/s390/kernel/smp.c          |  2 ++
 arch/s390/mm/vmem.c             |  4 ++++
 7 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
index 237ee0c4169f..612ed3c6d581 100644
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -141,7 +141,9 @@ struct lowcore {
 
 	/* br %r1 trampoline */
 	__u16	br_r1_trampoline;		/* 0x0400 */
-	__u8	pad_0x0402[0x0e00-0x0402];	/* 0x0402 */
+	__u32	return_lpswe;			/* 0x0402 */
+	__u32	return_mcck_lpswe;		/* 0x0406 */
+	__u8	pad_0x040a[0x0e00-0x040a];	/* 0x040a */
 
 	/*
 	 * 0xe00 contains the address of the IPL Parameter Information
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index 69289e99cabd..5017499601a3 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -8,6 +8,7 @@
 
 #include <linux/bits.h>
 #include <uapi/asm/setup.h>
+#include <linux/build_bug.h>
 
 #define EP_OFFSET		0x10008
 #define EP_STRING		"S390EP"
@@ -155,6 +156,12 @@ static inline unsigned long kaslr_offset(void)
 	return __kaslr_offset;
 }
 
+static inline u32 gen_lpswe(unsigned long addr)
+{
+	BUILD_BUG_ON(addr > 0xfff);
+	return 0xb2b20000 | addr;
+}
+
 #else /* __ASSEMBLY__ */
 
 #define IPL_DEVICE	(IPL_DEVICE_OFFSET)
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index ce33406cfe83..e80f0e6f5972 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -124,6 +124,8 @@ int main(void)
 	OFFSET(__LC_EXT_DAMAGE_CODE, lowcore, external_damage_code);
 	OFFSET(__LC_MCCK_FAIL_STOR_ADDR, lowcore, failing_storage_address);
 	OFFSET(__LC_LAST_BREAK, lowcore, breaking_event_addr);
+	OFFSET(__LC_RETURN_LPSWE, lowcore, return_lpswe);
+	OFFSET(__LC_RETURN_MCCK_LPSWE, lowcore, return_mcck_lpswe);
 	OFFSET(__LC_RST_OLD_PSW, lowcore, restart_old_psw);
 	OFFSET(__LC_EXT_OLD_PSW, lowcore, external_old_psw);
 	OFFSET(__LC_SVC_OLD_PSW, lowcore, svc_old_psw);
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 270d1d145761..ead5efa07b0b 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -115,26 +115,29 @@ _LPP_OFFSET	= __LC_LPP
 
 	.macro	SWITCH_ASYNC savearea,timer
 	tmhh	%r8,0x0001		# interrupting from user ?
-	jnz	1f
+	jnz	2f
 	lgr	%r14,%r9
+	cghi	%r14,__LC_RETURN_LPSWE
+	je	0f
 	slg	%r14,BASED(.Lcritical_start)
 	clg	%r14,BASED(.Lcritical_length)
-	jhe	0f
+	jhe	1f
+0:
 	lghi	%r11,\savearea		# inside critical section, do cleanup
 	brasl	%r14,cleanup_critical
 	tmhh	%r8,0x0001		# retest problem state after cleanup
-	jnz	1f
-0:	lg	%r14,__LC_ASYNC_STACK	# are we already on the target stack?
+	jnz	2f
+1:	lg	%r14,__LC_ASYNC_STACK	# are we already on the target stack?
 	slgr	%r14,%r15
 	srag	%r14,%r14,STACK_SHIFT
-	jnz	2f
+	jnz	3f
 	CHECK_STACK \savearea
 	aghi	%r15,-(STACK_FRAME_OVERHEAD + __PT_SIZE)
-	j	3f
-1:	UPDATE_VTIME %r14,%r15,\timer
+	j	4f
+2:	UPDATE_VTIME %r14,%r15,\timer
 	BPENTER __TI_flags(%r12),_TIF_ISOLATE_BP
-2:	lg	%r15,__LC_ASYNC_STACK	# load async stack
-3:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
+3:	lg	%r15,__LC_ASYNC_STACK	# load async stack
+4:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	.endm
 
 	.macro UPDATE_VTIME w1,w2,enter_timer
@@ -401,7 +404,7 @@ ENTRY(system_call)
 	stpt	__LC_EXIT_TIMER
 	mvc	__VDSO_ECTG_BASE(16,%r14),__LC_EXIT_TIMER
 	lmg	%r11,%r15,__PT_R11(%r11)
-	lpswe	__LC_RETURN_PSW
+	b	__LC_RETURN_LPSWE(%r0)
 .Lsysc_done:
 
 #
@@ -775,7 +778,7 @@ ENTRY(io_int_handler)
 	mvc	__VDSO_ECTG_BASE(16,%r14),__LC_EXIT_TIMER
 .Lio_exit_kernel:
 	lmg	%r11,%r15,__PT_R11(%r11)
-	lpswe	__LC_RETURN_PSW
+	b	__LC_RETURN_LPSWE(%r0)
 .Lio_done:
 
 #
@@ -1214,7 +1217,7 @@ ENTRY(mcck_int_handler)
 	stpt	__LC_EXIT_TIMER
 	mvc	__VDSO_ECTG_BASE(16,%r14),__LC_EXIT_TIMER
 0:	lmg	%r11,%r15,__PT_R11(%r11)
-	lpswe	__LC_RETURN_MCCK_PSW
+	b	__LC_RETURN_MCCK_LPSWE
 
 .Lmcck_panic:
 	lg	%r15,__LC_NODAT_STACK
@@ -1271,6 +1274,8 @@ ENDPROC(stack_overflow)
 #endif
 
 ENTRY(cleanup_critical)
+	cghi	%r9,__LC_RETURN_LPSWE
+	je	.Lcleanup_lpswe
 #if IS_ENABLED(CONFIG_KVM)
 	clg	%r9,BASED(.Lcleanup_table_sie)	# .Lsie_gmap
 	jl	0f
@@ -1424,6 +1429,7 @@ ENDPROC(cleanup_critical)
 	mvc	__LC_RETURN_PSW(16),__PT_PSW(%r9)
 	mvc	0(64,%r11),__PT_R8(%r9)
 	lmg	%r0,%r7,__PT_R0(%r9)
+.Lcleanup_lpswe:
 1:	lmg	%r8,%r9,__LC_RETURN_PSW
 	BR_EX	%r14,%r11
 .Lcleanup_sysc_restore_insn:
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index d5fbd754f41a..c3890c05f71f 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -73,6 +73,7 @@
 #include <asm/nospec-branch.h>
 #include <asm/mem_detect.h>
 #include <asm/uv.h>
+#include <asm/asm-offsets.h>
 #include "entry.h"
 
 /*
@@ -450,6 +451,8 @@ static void __init setup_lowcore_dat_off(void)
 	lc->spinlock_index = 0;
 	arch_spin_lock_setup(0);
 	lc->br_r1_trampoline = 0x07f1;	/* br %r1 */
+	lc->return_lpswe = gen_lpswe(__LC_RETURN_PSW);
+	lc->return_mcck_lpswe = gen_lpswe(__LC_RETURN_MCCK_PSW);
 
 	set_prefix((u32)(unsigned long) lc);
 	lowcore_ptr[0] = lc;
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index a08bd2522dd9..f87d4e14269c 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -212,6 +212,8 @@ static int pcpu_alloc_lowcore(struct pcpu *pcpu, int cpu)
 	lc->spinlock_lockval = arch_spin_lockval(cpu);
 	lc->spinlock_index = 0;
 	lc->br_r1_trampoline = 0x07f1;	/* br %r1 */
+	lc->return_lpswe = gen_lpswe(__LC_RETURN_PSW);
+	lc->return_mcck_lpswe = gen_lpswe(__LC_RETURN_MCCK_PSW);
 	if (nmi_alloc_per_cpu(lc))
 		goto out_async;
 	if (vdso_alloc_per_cpu(lc))
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index b403fa14847d..f810930aff42 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -415,6 +415,10 @@ void __init vmem_map_init(void)
 		     SET_MEMORY_RO | SET_MEMORY_X);
 	__set_memory(__stext_dma, (__etext_dma - __stext_dma) >> PAGE_SHIFT,
 		     SET_MEMORY_RO | SET_MEMORY_X);
+
+	/* we need lowcore executable for our LPSWE instructions */
+	set_memory_x(0, 1);
+
 	pr_info("Write protected kernel read-only data: %luk\n",
 		(unsigned long)(__end_rodata - _stext) >> 10);
 }
-- 
2.17.1

