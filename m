Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E62D55E695
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347945AbiF1PoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 11:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347967AbiF1PoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 11:44:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B8A3630E;
        Tue, 28 Jun 2022 08:43:57 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SFhCCs008015;
        Tue, 28 Jun 2022 15:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=eGOAAX/MzK0GnpKpJPxVK06tkihlGybYABV69N5IrRo=;
 b=BX9mMf3S8xiZdVhn7kyjiR0qa2eeBqd6G4jHS/42gavEWaJ63mNDO4tBGK6nwo/jbJpk
 rrF0YBng8C6b5xnjARlonP+gpdGmg3eSSi70ekke2iLgybOZt0D5t2uo8OMlYsxAUKxO
 YQvwcdvuXHMtwj0hlLstVGdA2/Razg8u3qO4HSZg8+ECEIgI2H2vfKoviM7Uspr1cCZc
 w8rZw7GJPsf01GElRpDRhbpcnJOudQXui1KnJPP/PjTfcvgsJkM6pY/GBJQgLCib+zh4
 BFCnPCNH7MPNN0g1eea1K+3xnyTjgo7VjKB21fsNV452c9oMGaoasUfPo2WLhQuKXVHy 9w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h04hh00gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 15:43:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SFaeuV020210;
        Tue, 28 Jun 2022 15:43:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3gwt08w3gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 15:43:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SFhije23200104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 15:43:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 297995204E;
        Tue, 28 Jun 2022 15:43:44 +0000 (GMT)
Received: from li-NotSettable.ibm.com.com (unknown [9.43.54.243])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EA78752050;
        Tue, 28 Jun 2022 15:43:41 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
Cc:     <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        kexec@lists.infradead.org, Michael Ellerman <mpe@ellerman.id.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4.9] kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]
Date:   Tue, 28 Jun 2022 21:12:48 +0530
Message-Id: <20220628154249.204911-3-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Nt3itEkV3yye9lE6mGJaPGpcuPKHR-R9
X-Proofpoint-GUID: Nt3itEkV3yye9lE6mGJaPGpcuPKHR-R9
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0
 phishscore=0 mlxlogscore=910 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3e35142ef99fe6b4fe5d834ad43ee13cca10a2dc upstream.

Since commit d1bcae833b32f1 ("ELF: Don't generate unused section
symbols") [1], binutils (v2.36+) started dropping section symbols that
it thought were unused.  This isn't an issue in general, but with
kexec_file.c, gcc is placing kexec_arch_apply_relocations[_add] into a
separate .text.unlikely section and the section symbol ".text.unlikely"
is being dropped. Due to this, recordmcount is unable to find a non-weak
symbol in .text.unlikely to generate a relocation record against.

Address this by dropping the weak attribute from these functions.
Instead, follow the existing pattern of having architectures #define the
name of the function they want to override in their headers.

[1] https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=d1bcae833b32f1

[akpm@linux-foundation.org: arch/s390/include/asm/kexec.h needs linux/module.h]
Link: https://lkml.kernel.org/r/20220519091237.676736-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/include/asm/kexec.h |  7 +++++++
 include/linux/kexec.h        | 26 ++++++++++++++++++++++----
 kernel/kexec_file.c          | 18 ------------------
 3 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 1624a7ffa95d89..3f1f58c1a9ce63 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -20,6 +20,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/string.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -206,6 +207,12 @@ struct kexec_entry64_regs {
 	uint64_t r15;
 	uint64_t rip;
 };
+
+#ifdef CONFIG_KEXEC_FILE
+int arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr,
+				     Elf_Shdr *sechdrs, unsigned int relsec);
+#define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+#endif
 #endif
 
 typedef void crash_vmclear_fn(void);
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 406c33dcae137a..565be657098b0b 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -148,6 +148,28 @@ struct kexec_file_ops {
 	kexec_verify_sig_t *verify_sig;
 #endif
 };
+
+#ifndef arch_kexec_apply_relocations_add
+/* Apply relocations of type RELA */
+static inline int
+arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr,
+				 Elf_Shdr *sechdrs, unsigned int relsec)
+{
+	pr_err("RELA relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
+
+#ifndef arch_kexec_apply_relocations
+/* Apply relocations of type REL */
+static inline int
+arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+			     unsigned int relsec)
+{
+	pr_err("REL relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
 #endif
 
 struct kimage {
@@ -320,10 +342,6 @@ void * __weak arch_kexec_kernel_image_load(struct kimage *image);
 int __weak arch_kimage_file_post_load_cleanup(struct kimage *image);
 int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 					unsigned long buf_len);
-int __weak arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr,
-					Elf_Shdr *sechdrs, unsigned int relsec);
-int __weak arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-					unsigned int relsec);
 void arch_kexec_protect_crashkres(void);
 void arch_kexec_unprotect_crashkres(void);
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 2edaed6803ff79..eb775e699836ad 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -59,24 +59,6 @@ int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 }
 #endif
 
-/* Apply relocations of type RELA */
-int __weak
-arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-				 unsigned int relsec)
-{
-	pr_err("RELA relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
-/* Apply relocations of type REL */
-int __weak
-arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-			     unsigned int relsec)
-{
-	pr_err("REL relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
 /*
  * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have

base-commit: 4ffa4be5a14beeb008bd2b4fbc681222bfec90c7
-- 
2.36.1

