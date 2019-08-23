Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4919A70B
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 07:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392058AbfHWFYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 01:24:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392037AbfHWFYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 01:24:11 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N5O7RP000660
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 22:24:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=X5cZafEMOtA9egvlal74E4vlPa7kd0hNN9ns5h5N+qo=;
 b=ctGEYVlWD8wU9maXCXQcfvBbT8vpAUm1XXo6OdVD8gyR+f6d4RyRLp8JlPq1Y4gaGCTN
 AOxFtlHkziUfafdHchD7yRhYc/62tmGYzmOCgVDBjsFcnOgSINHtIxET93NPNmUb5TZr
 NG2/qjY7BZSaUUOIAj7mjO0KQfCUyUWzGm0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uj3mhh8hj-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 22:24:09 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 22 Aug 2019 22:23:56 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id AA25B62E2FD5; Thu, 22 Aug 2019 22:23:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>,
        <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH] x86/mm: Do not split_large_page() for set_kernel_text_rw()
Date:   Thu, 22 Aug 2019 22:23:35 -0700
Message-ID: <20190823052335.572133-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230058
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As 4k pages check was removed from cpa [1], set_kernel_text_rw() leads to
split_large_page() for all kernel text pages. This means a single kprobe
will put all kernel text in 4k pages:

  root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
  0xffffffff81000000-0xffffffff82400000     20M  ro    PSE      x  pmd

  root@ ~# echo ONE_KPROBE >> /sys/kernel/debug/tracing/kprobe_events
  root@ ~# echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable

  root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
  0xffffffff81000000-0xffffffff82400000     20M  ro             x  pte

To fix this issue, introduce CPA_FLIP_TEXT_RW to bypass "Text RO" check
in static_protections().

Two helper functions set_text_rw() and set_text_ro() are added to flip
_PAGE_RW bit for kernel text.

[1] commit 585948f4f695 ("x86/mm/cpa: Avoid the 4k pages check completely")

Fixes: 585948f4f695 ("x86/mm/cpa: Avoid the 4k pages check completely")
Cc: stable@vger.kernel.org  # v4.20+
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 arch/x86/mm/init_64.c     |  4 ++--
 arch/x86/mm/mm_internal.h |  4 ++++
 arch/x86/mm/pageattr.c    | 34 +++++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a6b5c653727b..5745fdcc429e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1276,7 +1276,7 @@ void set_kernel_text_rw(void)
 	 * mapping will always be RO. Refer to the comment in
 	 * static_protections() in pageattr.c
 	 */
-	set_memory_rw(start, (end - start) >> PAGE_SHIFT);
+	set_text_rw(start, (end - start) >> PAGE_SHIFT);
 }
 
 void set_kernel_text_ro(void)
@@ -1293,7 +1293,7 @@ void set_kernel_text_ro(void)
 	/*
 	 * Set the kernel identity mapping for text RO.
 	 */
-	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
+	set_text_ro(start, (end - start) >> PAGE_SHIFT);
 }
 
 void mark_rodata_ro(void)
diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index eeae142062ed..65b84b471770 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -24,4 +24,8 @@ void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache);
 
 extern unsigned long tlb_single_page_flush_ceiling;
 
+int set_text_rw(unsigned long addr, int numpages);
+
+int set_text_ro(unsigned long addr, int numpages);
+
 #endif	/* __X86_MM_INTERNAL_H */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 6a9a77a403c9..44a885df776d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -66,6 +66,7 @@ static DEFINE_SPINLOCK(cpa_lock);
 #define CPA_ARRAY 2
 #define CPA_PAGES_ARRAY 4
 #define CPA_NO_CHECK_ALIAS 8 /* Do not search for aliases */
+#define CPA_FLIP_TEXT_RW 0x10 /* allow flip _PAGE_RW for kernel text */
 
 #ifdef CONFIG_PROC_FS
 static unsigned long direct_pages_count[PG_LEVEL_NUM];
@@ -516,7 +517,7 @@ static inline void check_conflict(int warnlvl, pgprot_t prot, pgprotval_t val,
  */
 static inline pgprot_t static_protections(pgprot_t prot, unsigned long start,
 					  unsigned long pfn, unsigned long npg,
-					  int warnlvl)
+					  int warnlvl, unsigned int cpa_flags)
 {
 	pgprotval_t forbidden, res;
 	unsigned long end;
@@ -535,9 +536,11 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long start,
 	check_conflict(warnlvl, prot, res, start, end, pfn, "Text NX");
 	forbidden = res;
 
-	res = protect_kernel_text_ro(start, end);
-	check_conflict(warnlvl, prot, res, start, end, pfn, "Text RO");
-	forbidden |= res;
+	if (!(cpa_flags & CPA_FLIP_TEXT_RW)) {
+		res = protect_kernel_text_ro(start, end);
+		check_conflict(warnlvl, prot, res, start, end, pfn, "Text RO");
+		forbidden |= res;
+	}
 
 	/* Check the PFN directly */
 	res = protect_pci_bios(pfn, pfn + npg - 1);
@@ -819,7 +822,7 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 	 * extra conditional required here.
 	 */
 	chk_prot = static_protections(old_prot, lpaddr, old_pfn, numpages,
-				      CPA_CONFLICT);
+				      CPA_CONFLICT, cpa->flags);
 
 	if (WARN_ON_ONCE(pgprot_val(chk_prot) != pgprot_val(old_prot))) {
 		/*
@@ -855,7 +858,7 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 	 * protection requirement in the large page.
 	 */
 	new_prot = static_protections(req_prot, lpaddr, old_pfn, numpages,
-				      CPA_DETECT);
+				      CPA_DETECT, cpa->flags);
 
 	/*
 	 * If there is a conflict, split the large page.
@@ -906,7 +909,7 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 	if (!cpa->force_static_prot)
 		goto set;
 
-	prot = static_protections(ref_prot, address, pfn, npg, CPA_PROTECT);
+	prot = static_protections(ref_prot, address, pfn, npg, CPA_PROTECT, 0);
 
 	if (pgprot_val(prot) == pgprot_val(ref_prot))
 		goto set;
@@ -1504,7 +1507,7 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 
 		cpa_inc_4k_install();
 		new_prot = static_protections(new_prot, address, pfn, 1,
-					      CPA_PROTECT);
+					      CPA_PROTECT, 0);
 
 		new_prot = pgprot_clear_protnone_bits(new_prot);
 
@@ -1707,7 +1710,7 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
-	if (in_flag & (CPA_ARRAY | CPA_PAGES_ARRAY))
+	if (in_flag & (CPA_ARRAY | CPA_PAGES_ARRAY | CPA_FLIP_TEXT_RW))
 		cpa.flags |= in_flag;
 
 	/* No alias checking for _NX bit modifications */
@@ -1983,11 +1986,24 @@ int set_memory_ro(unsigned long addr, int numpages)
 	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_RW), 0);
 }
 
+int set_text_ro(unsigned long addr, int numpages)
+{
+	return change_page_attr_set_clr(&addr, numpages, __pgprot(0),
+					__pgprot(_PAGE_RW), 0, CPA_FLIP_TEXT_RW,
+					NULL);
+}
+
 int set_memory_rw(unsigned long addr, int numpages)
 {
 	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_RW), 0);
 }
 
+int set_text_rw(unsigned long addr, int numpages)
+{
+	return change_page_attr_set_clr(&addr, numpages, __pgprot(_PAGE_RW),
+					__pgprot(0), 0, CPA_FLIP_TEXT_RW, NULL);
+}
+
 int set_memory_np(unsigned long addr, int numpages)
 {
 	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
-- 
2.17.1

