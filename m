Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA6055C603
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbiF0RkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 13:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236313AbiF0RkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 13:40:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B5A11828
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 10:40:08 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RHJiNA028219;
        Mon, 27 Jun 2022 17:40:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=JNUGPCruFKdZCUCFVbVCf/FrTWxRNz6Yzv3LN4X2W0A=;
 b=ioRdbm583BWwsSh01VjdJLFQmJD3Tekf1DG0dPEwqauZxofgml2ZM0ozWQkI4XqGCvHH
 PYwn4pVAUoD4SQBAMGqlrRB9kFhLB0OtgJOy84MM9WmxOyMluy6l0VxoJ9p4LTlF84Dr
 A2xTPOgHqjxrZoeaVRtiSU86MP6Ye5OSG0ttzoI6g1fjbyalpiPLDazLKO7fkM4YV4Vm
 fM1OjfgJlAW90Sk8VW2+9a+iwzxkE2dIJR5+EsnCkjbdhNwLiPvyrf6gBM9qGWiM3+ht
 Uavnn0T/fzuuJcnb9m6Tp6OjzvhSqieZ3srNiwwFuIYGm9ejJlB3D1NGfho6lq+GIxCq 0w== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gygur8j1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 17:40:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RHZ5ul003345;
        Mon, 27 Jun 2022 17:40:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj3ae3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 17:40:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RHdwBh25100704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 17:39:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24CE94C040;
        Mon, 27 Jun 2022 17:39:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2C8D4C044;
        Mon, 27 Jun 2022 17:39:56 +0000 (GMT)
Received: from li-NotSettable.ibm.com.com (unknown [9.43.62.161])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 17:39:56 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v5.4] powerpc/ftrace: Remove ftrace init tramp once kernel init is complete
Date:   Mon, 27 Jun 2022 23:09:30 +0530
Message-Id: <20220627173930.133620-4-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220627173930.133620-1-naveen.n.rao@linux.vnet.ibm.com>
References: <20220627173930.133620-1-naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cpCWhQVBQTB_7lhR4nZH4kFpM6-fsMAA
X-Proofpoint-ORIG-GUID: cpCWhQVBQTB_7lhR4nZH4kFpM6-fsMAA
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206270071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 84ade0a6655bee803d176525ef457175cbf4df22 upstream.

Stop using the ftrace trampoline for init section once kernel init is
complete.

Fixes: 67361cf8071286 ("powerpc/ftrace: Handle large kernel configs")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220516071422.463738-1-naveen.n.rao@linux.vnet.ibm.com
---
 arch/powerpc/include/asm/ftrace.h  |  5 ++++-
 arch/powerpc/kernel/trace/ftrace.c | 15 ++++++++++++---
 arch/powerpc/mm/mem.c              |  2 ++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index f54a08a2cd7092..017336f2b0864a 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -96,7 +96,7 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 #endif /* PPC64_ELF_ABI_v1 */
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
-#ifdef CONFIG_PPC64
+#if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)
 #include <asm/paca.h>
 
 static inline void this_cpu_disable_ftrace(void)
@@ -108,9 +108,12 @@ static inline void this_cpu_enable_ftrace(void)
 {
 	get_paca()->ftrace_enabled = 1;
 }
+
+void ftrace_free_init_tramp(void);
 #else /* CONFIG_PPC64 */
 static inline void this_cpu_disable_ftrace(void) { }
 static inline void this_cpu_enable_ftrace(void) { }
+static inline void ftrace_free_init_tramp(void) { }
 #endif /* CONFIG_PPC64 */
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/powerpc/kernel/trace/ftrace.c b/arch/powerpc/kernel/trace/ftrace.c
index 7ea0ca044b6500..d816e714f2f489 100644
--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -328,9 +328,7 @@ static int setup_mcount_compiler_tramp(unsigned long tramp)
 
 	/* Is this a known long jump tramp? */
 	for (i = 0; i < NUM_FTRACE_TRAMPS; i++)
-		if (!ftrace_tramps[i])
-			break;
-		else if (ftrace_tramps[i] == tramp)
+		if (ftrace_tramps[i] == tramp)
 			return 0;
 
 	/* Is this a known plt tramp? */
@@ -868,6 +866,17 @@ void arch_ftrace_update_code(int command)
 
 extern unsigned int ftrace_tramp_text[], ftrace_tramp_init[];
 
+void ftrace_free_init_tramp(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_FTRACE_TRAMPS && ftrace_tramps[i]; i++)
+		if (ftrace_tramps[i] == (unsigned long)ftrace_tramp_init) {
+			ftrace_tramps[i] = 0;
+			return;
+		}
+}
+
 int __init ftrace_dyn_arch_init(void)
 {
 	int i;
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index c48705c726ac6d..d427f70556eab5 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -48,6 +48,7 @@
 #include <asm/fixmap.h>
 #include <asm/swiotlb.h>
 #include <asm/rtas.h>
+#include <asm/ftrace.h>
 
 #include <mm/mmu_decl.h>
 
@@ -346,6 +347,7 @@ void free_initmem(void)
 	mark_initmem_nx();
 	init_mem_is_free = true;
 	free_initmem_default(POISON_FREE_INITMEM);
+	ftrace_free_init_tramp();
 }
 
 /**

base-commit: 23db944f754e99abf814a79a2273b0191d35e4ff
-- 
2.36.1

