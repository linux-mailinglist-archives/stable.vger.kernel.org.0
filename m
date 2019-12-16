Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8371204A2
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 13:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLPMA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 07:00:56 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40363 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727435AbfLPMA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 07:00:56 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 36CCF220A7;
        Mon, 16 Dec 2019 07:00:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 16 Dec 2019 07:00:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=R+dyOD
        f6aSTJYHnGa3/CBnhQDqfQDrdXNB4hDTzx5ek=; b=lKRSuE9A9eFWGSK6uEWNrY
        g9nIb1I6CPvdGK30VIA37vYNtoPde3cRRcoRoZ7oudNYlS3PxbVaT+1CfUAYuupr
        RGabJ1YYSwadQi7lMok8fUMZVoN0Mk6NpmJTNe0gDv2pBja2sKAMEFrHIBKaOgbR
        EiRR0PoVQJCriY4vmMvms6Ln6BL5s8IkGGVPuFQI1J1luaeGn1YiSosGd/SAxhYu
        7Cx9u49Eef7IF8Rf1GoF1PUgKD7q0g8weDbEntkre3eG7+XSeAEXUVUEWPgQNhyv
        gKQQ7A6e79m0M0KByceQrTdWvGqad2OCLmT39I8u0eWh/YQAl7jZIh9l6WHxk1Mg
        ==
X-ME-Sender: <xms:93H3XX-S9uU24IJSbMxUh4v4m-gdS_SehNoNqoFgX3LH-X5mLcqclg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddthedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:93H3XYZhPQ8l7-eaXgJYJZ6dPIgVGHFxluWukfU3TrrkBHCFfwo6vw>
    <xmx:93H3Xc7MufmKr739R7N5ExfVGmX4zlSOET8-aN9Z_JbaCldBhc8wsw>
    <xmx:93H3XXN0uOb6SyxiEehXAR48lHeoKFZrxLz9EvwmFcuFMS74PKpLlA>
    <xmx:93H3XSPp3FDTnqqEkppxvmDwHk8IpwTm5bY-eOLYwPFF75gG1ZC3qA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8ECA80065;
        Mon, 16 Dec 2019 07:00:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm/memory.c: fix a huge pud insertion race during faulting" failed to apply to 4.14-stable tree
To:     thellstrom@vmware.com, akpm@linux-foundation.org, arnd@arndb.de,
        kirill.shutemov@linux.intel.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Dec 2019 13:00:45 +0100
Message-ID: <1576497645138250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 625110b5e9dae9074d8a7e67dd07f821a053eed7 Mon Sep 17 00:00:00 2001
From: Thomas Hellstrom <thellstrom@vmware.com>
Date: Sat, 30 Nov 2019 17:51:32 -0800
Subject: [PATCH] mm/memory.c: fix a huge pud insertion race during faulting

A huge pud page can theoretically be faulted in racing with pmd_alloc()
in __handle_mm_fault().  That will lead to pmd_alloc() returning an
invalid pmd pointer.

Fix this by adding a pud_trans_unstable() function similar to
pmd_trans_unstable() and check whether the pud is really stable before
using the pmd pointer.

Race:
  Thread 1:             Thread 2:                 Comment
  create_huge_pud()                               Fallback - not taken.
                        create_huge_pud()         Taken.
  pmd_alloc()                                     Returns an invalid pointer.

This will result in user-visible huge page data corruption.

Note that this was caught during a code audit rather than a real
experienced problem.  It looks to me like the only implementation that
currently creates huge pud pagetable entries is dev_dax_huge_fault()
which doesn't appear to care much about private (COW) mappings or
write-tracking which is, I believe, a prerequisite for create_huge_pud()
falling back on thread 1, but not in thread 2.

Link: http://lkml.kernel.org/r/20191115115808.21181-2-thomas_os@shipmail.org
Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 3127f9028f54..798ea36a0549 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -938,6 +938,31 @@ static inline int pud_trans_huge(pud_t pud)
 }
 #endif
 
+/* See pmd_none_or_trans_huge_or_clear_bad for discussion. */
+static inline int pud_none_or_trans_huge_or_dev_or_clear_bad(pud_t *pud)
+{
+	pud_t pudval = READ_ONCE(*pud);
+
+	if (pud_none(pudval) || pud_trans_huge(pudval) || pud_devmap(pudval))
+		return 1;
+	if (unlikely(pud_bad(pudval))) {
+		pud_clear_bad(pud);
+		return 1;
+	}
+	return 0;
+}
+
+/* See pmd_trans_unstable for discussion. */
+static inline int pud_trans_unstable(pud_t *pud)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	return pud_none_or_trans_huge_or_dev_or_clear_bad(pud);
+#else
+	return 0;
+#endif
+}
+
 #ifndef pmd_read_atomic
 static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 62b5cce653f6..c3902201989f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4010,6 +4010,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	vmf.pud = pud_alloc(mm, p4d, address);
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
+retry_pud:
 	if (pud_none(*vmf.pud) && __transparent_hugepage_enabled(vma)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
@@ -4036,6 +4037,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	vmf.pmd = pmd_alloc(mm, vmf.pud, address);
 	if (!vmf.pmd)
 		return VM_FAULT_OOM;
+
+	/* Huge pud page fault raced with pmd_alloc? */
+	if (pud_trans_unstable(vmf.pud))
+		goto retry_pud;
+
 	if (pmd_none(*vmf.pmd) && __transparent_hugepage_enabled(vma)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))

