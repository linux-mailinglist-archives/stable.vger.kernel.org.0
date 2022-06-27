Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CE955C49F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbiF0RkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 13:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbiF0RkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 13:40:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B6A12744
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 10:40:07 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RGrDB2017903;
        Mon, 27 Jun 2022 17:39:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=dUs6zqEF+eqyL+/GIvf6gAgAlmBWrSgJy5fYQjW5g5Y=;
 b=tCkeeohbyBax/5NmAO2JSKYArVBRszXAetRVgSKY0XJIs8QpTC7H/o1EJT0jXe6AwdQE
 IaxApLLzz8+hA6lvixT77kFlsoKhuWe68N7zlVrtm4aWHL2dLPX0q/Zi86wVKoot2wHv
 mpzVOLvGpC2Dj9GLbfc1LJ4tCXIZKPzqP7ZCjluC6NnLwk9WP8Uy1ztkiy3a66W4SSKA
 HpWZWtyZl6pIn9HIkJzWtFIxs62lqyxlj90b0/J7oSneFe7dBpHh8EcQo0AVRUJh/7j+
 r0rDs+MST/UCmKUbhnHNIGrnMa6KsgWb8Qsa7dgOqf/mAvByJl/OUFmLUoOktAL2rM0f 1g== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gygfe1g76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 17:39:56 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RHb5Kl024142;
        Mon, 27 Jun 2022 17:39:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gwsmhthaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 17:39:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RHdxnh33358130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 17:39:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9A8C4C044;
        Mon, 27 Jun 2022 17:39:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55BFB4C040;
        Mon, 27 Jun 2022 17:39:51 +0000 (GMT)
Received: from li-NotSettable.ibm.com.com (unknown [9.43.62.161])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 17:39:51 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v5.10] powerpc/ftrace: Remove ftrace init tramp once kernel init is complete
Date:   Mon, 27 Jun 2022 23:09:27 +0530
Message-Id: <20220627173930.133620-1-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RxTlVo7P3HwOjzT79PWrXpoPWJLY7yuU
X-Proofpoint-GUID: RxTlVo7P3HwOjzT79PWrXpoPWJLY7yuU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0
 spamscore=0 clxscore=1011 suspectscore=0 priorityscore=1501 adultscore=0
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
 arch/powerpc/include/asm/ftrace.h  |  4 +++-
 arch/powerpc/kernel/trace/ftrace.c | 15 ++++++++++++---
 arch/powerpc/mm/mem.c              |  2 ++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index bc76970b6ee532..e647dfcb319171 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -96,7 +96,7 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 #endif /* PPC64_ELF_ABI_v1 */
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
-#ifdef CONFIG_PPC64
+#if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)
 #include <asm/paca.h>
 
 static inline void this_cpu_disable_ftrace(void)
@@ -120,11 +120,13 @@ static inline u8 this_cpu_get_ftrace_enabled(void)
 	return get_paca()->ftrace_enabled;
 }
 
+void ftrace_free_init_tramp(void);
 #else /* CONFIG_PPC64 */
 static inline void this_cpu_disable_ftrace(void) { }
 static inline void this_cpu_enable_ftrace(void) { }
 static inline void this_cpu_set_ftrace_enabled(u8 ftrace_enabled) { }
 static inline u8 this_cpu_get_ftrace_enabled(void) { return 1; }
+static inline void ftrace_free_init_tramp(void) { }
 #endif /* CONFIG_PPC64 */
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/powerpc/kernel/trace/ftrace.c b/arch/powerpc/kernel/trace/ftrace.c
index 42761ebec9f755..d24aea4fed7a35 100644
--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -336,9 +336,7 @@ static int setup_mcount_compiler_tramp(unsigned long tramp)
 
 	/* Is this a known long jump tramp? */
 	for (i = 0; i < NUM_FTRACE_TRAMPS; i++)
-		if (!ftrace_tramps[i])
-			break;
-		else if (ftrace_tramps[i] == tramp)
+		if (ftrace_tramps[i] == tramp)
 			return 0;
 
 	/* Is this a known plt tramp? */
@@ -882,6 +880,17 @@ void arch_ftrace_update_code(int command)
 
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
index 22eb1c718e6224..1ed276d2305fab 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -51,6 +51,7 @@
 #include <asm/kasan.h>
 #include <asm/svm.h>
 #include <asm/mmzone.h>
+#include <asm/ftrace.h>
 
 #include <mm/mmu_decl.h>
 
@@ -347,6 +348,7 @@ void free_initmem(void)
 	mark_initmem_nx();
 	init_mem_is_free = true;
 	free_initmem_default(POISON_FREE_INITMEM);
+	ftrace_free_init_tramp();
 }
 
 /**

base-commit: 9cae50bdfafa0ce87eb2693401efeae2cd30b417
-- 
2.36.1

