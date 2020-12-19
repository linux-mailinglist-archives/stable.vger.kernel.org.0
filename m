Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30E32DED0C
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 05:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgLSEeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 23:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgLSEe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 23:34:29 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB3CC0617B0;
        Fri, 18 Dec 2020 20:34:04 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id be12so2492380plb.4;
        Fri, 18 Dec 2020 20:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yoyAynmz1wcAyKdwj7JPb1oUlBRjnh/nNP8b1Gw1a2k=;
        b=sewz8SG1Hhr94jDzCDmMJeN7/3LbxnO32ongCAGDSWXlgEfHRoPdR6ocDAZN0oRe+h
         Pp3W7MMTndo1oCIyfSBC9GuBqgRHPCUHVUA9VLTSydMsUBn0U7HBAa8Sg2fP+X8JIKWc
         6dm6gkAmUkhFhRPGuxvkEH6aGwpnhITUMcvIALGDCBtnAjrf/f9HuLABUzvssBAkSTDZ
         DCTfqdFFdyfKYsH1e1cMbKFsOiQL581rIWaAMWk1szhPHRyj0mfeVBhIEuD6JW6tXxNo
         nIeQquXrTvY+v3VyGd9dZF+6c3nUr+jvCNINxQn3Z98yOtCDs9xfXWORMeGtZP2DD6Y0
         gfPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yoyAynmz1wcAyKdwj7JPb1oUlBRjnh/nNP8b1Gw1a2k=;
        b=Jzgo4QuvQZi87JOAiHq9xii3wpFt3U6Mxq4ZX6HgPx7IlrM/1ZB3OLG1b6Tr8QNIgP
         fahTSCjeYBZj4mo+6jzQhz8kMZvUwxN0h3DmmlbflsYvlvdvzXeXUpo+1gZDZ72sU8E2
         tHu/oMQchxh61ZTrCuVDULCoMNuJmq2qstcNvsqaRvfpYjSRs/MQYgJbiIHCyC7lTbdj
         lDqTNQckklS+ld+xgDN2t/G0z/q2vQcEtjYuzAEeWPwIZwDtFMz+QHuNqDArv92UqE2R
         CZw89DPJ3pt6OYvpXW6PXQ1wlSLm2Zvh8jN+ad6WScsCKOm0Ytbol/QhBzaSeqtRLhh6
         h69w==
X-Gm-Message-State: AOAM5325Fbktji6uahQesWnawS8qhS159FEMeOYfNvYDNmacioTAa9+w
        ihsj3IE5wMFB/2rvIutWLjM=
X-Google-Smtp-Source: ABdhPJxoD5X9iSGSIKKaOutdsLJyUD+JyZV1Irl6iwgjqe8wTKCRGQCBDFPE/PuEI9PvUMhcvUxz4g==
X-Received: by 2002:a17:90a:df0d:: with SMTP id gp13mr7397314pjb.151.1608352443766;
        Fri, 18 Dec 2020 20:34:03 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id f64sm10737029pfb.146.2020.12.18.20.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 20:34:03 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-mm@kvack.org, Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Date:   Fri, 18 Dec 2020 20:30:06 -0800
Message-Id: <20201219043006.2206347-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Userfaultfd self-tests fail occasionally, indicating a memory
corruption.

Analyzing this problem indicates that there is a real bug since
mmap_lock is only taken for read in mwriteprotect_range(). This might
cause the TLBs to be in an inconsistent state due to the deferred
batched TLB flushes.

Consider the following scenario with 3 CPUs (cpu2 is not shown):

cpu0				cpu1
----				----
userfaultfd_writeprotect()
[ write-protecting ]
mwriteprotect_range()
 mmap_read_lock()
 change_protection()
  change_protection_range()
   ...
   change_pte_range()
   [ defer TLB flushes]
				userfaultfd_writeprotect()
				 mmap_read_lock()
				 change_protection()
				 [ write-unprotect ]
				 ...
				  [ unprotect PTE logically ]
				...
				[ page-fault]
				...
				wp_page_copy()
				[ set new writable page in PTE]

At this point no TLB flush took place. cpu2 (not shown) might have a
stale writable PTE, which was cached in the TLB before cpu0 called
userfaultfd_writeprotect(), and this PTE points to a different page.

Therefore, write-protecting of memory, even using userfaultfd, which
does not change the vma, requires to prevent any concurrent reader (#PF
handler) from reading PTEs from the page-tables if any CPU might still
hold in it TLB a PTE with higher permissions for the same address. To
do so mmap_lock needs to be taken for write.

Surprisingly, memory-unprotection using userfaultfd also poses a
problem. Although memory unprotection is logically a promotion of PTE
permissions, and therefore should not require a TLB flush, the current
code might actually cause a demotion of the permission, and therefore
requires a TLB flush.

During unprotection of userfaultfd managed memory region, the PTE is not
really made writable, but instead marked "logically" as writable, and
left for the #PF handler to be handled later. While this is ok, the code
currently also *removes* the write permission, and therefore makes it
necessary to flush the TLBs.

To resolve these problems, acquire mmap_lock for write when
write-protecting userfaultfd region using ioctl's. Keep taking mmap_lock
for read when unprotecting memory, but keep the write-bit set when
resolving userfaultfd write-protection.

Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 mm/mprotect.c    |  3 ++-
 mm/userfaultfd.c | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index ab709023e9aa..c08c4055b051 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -75,7 +75,8 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		oldpte = *pte;
 		if (pte_present(oldpte)) {
 			pte_t ptent;
-			bool preserve_write = prot_numa && pte_write(oldpte);
+			bool preserve_write = (prot_numa || uffd_wp_resolve) &&
+					      pte_write(oldpte);
 
 			/*
 			 * Avoid trapping faults against the zero or KSM
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 9a3d451402d7..7423808640ef 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -652,7 +652,15 @@ int mwriteprotect_range(struct mm_struct *dst_mm, unsigned long start,
 	/* Does the address range wrap, or is the span zero-sized? */
 	BUG_ON(start + len <= start);
 
-	mmap_read_lock(dst_mm);
+	/*
+	 * Although we do not change the VMA, we have to ensure deferred TLB
+	 * flushes are performed before page-faults can be handled. Otherwise
+	 * we can get inconsistent TLB state.
+	 */
+	if (enable_wp)
+		mmap_write_lock(dst_mm);
+	else
+		mmap_read_lock(dst_mm);
 
 	/*
 	 * If memory mappings are changing because of non-cooperative
@@ -686,6 +694,9 @@ int mwriteprotect_range(struct mm_struct *dst_mm, unsigned long start,
 
 	err = 0;
 out_unlock:
-	mmap_read_unlock(dst_mm);
+	if (enable_wp)
+		mmap_write_unlock(dst_mm);
+	else
+		mmap_read_unlock(dst_mm);
 	return err;
 }
-- 
2.25.1

