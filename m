Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83075E673F
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfJ0VTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731435AbfJ0VTP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:15 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51D7621726;
        Sun, 27 Oct 2019 21:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211154;
        bh=naMNGdMiQ4KmdVDxjycCfK0/ec7A2qbg2aucw2kQ98M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrrnfQRDvxI41E1mrYhxZJr4QDeGAXov94OunhybJYAAEo65q+WY8drjVLWIXvTRy
         5/WAeCTaoHRshVizsGDi+2EigDcU/cUdAevlMTHxwGMYhPgTDmua6nIgH8LPHOibOW
         IZU1d8vAoAKP+82Gu9y+I4SSfC0M19X3LczgOQBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 052/197] s390/mm: fix -Wunused-but-set-variable warnings
Date:   Sun, 27 Oct 2019 21:59:30 +0100
Message-Id: <20191027203354.492549644@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 51ce02216d4ad4e8f6a58de81d6e803cf04c418e ]

Convert two functions to static inline to get ride of W=1 GCC warnings
like,

mm/gup.c: In function 'gup_pte_range':
mm/gup.c:1816:16: warning: variable 'ptem' set but not used
[-Wunused-but-set-variable]
  pte_t *ptep, *ptem;
                ^~~~

mm/mmap.c: In function 'acct_stack_growth':
mm/mmap.c:2322:16: warning: variable 'new_start' set but not used
[-Wunused-but-set-variable]
  unsigned long new_start;
                ^~~~~~~~~

Signed-off-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/lkml/1570138596-11913-1-git-send-email-cai@lca.pw/
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/hugetlb.h | 9 +++++++--
 arch/s390/include/asm/pgtable.h | 3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/hugetlb.h b/arch/s390/include/asm/hugetlb.h
index bb59dd9645909..de8f0bf5f238c 100644
--- a/arch/s390/include/asm/hugetlb.h
+++ b/arch/s390/include/asm/hugetlb.h
@@ -12,8 +12,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
-
-#define is_hugepage_only_range(mm, addr, len)	0
 #define hugetlb_free_pgd_range			free_pgd_range
 #define hugepages_supported()			(MACHINE_HAS_EDAT1)
 
@@ -23,6 +21,13 @@ pte_t huge_ptep_get(pte_t *ptep);
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 			      unsigned long addr, pte_t *ptep);
 
+static inline bool is_hugepage_only_range(struct mm_struct *mm,
+					  unsigned long addr,
+					  unsigned long len)
+{
+	return false;
+}
+
 /*
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 9b274fcaacb68..70ac23e50cae9 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1268,7 +1268,8 @@ static inline pte_t *pte_offset(pmd_t *pmd, unsigned long address)
 
 #define pte_offset_kernel(pmd, address) pte_offset(pmd, address)
 #define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_unmap(pte) do { } while (0)
+
+static inline void pte_unmap(pte_t *pte) { }
 
 static inline bool gup_fast_permitted(unsigned long start, unsigned long end)
 {
-- 
2.20.1



