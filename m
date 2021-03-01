Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C44328572
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhCAQxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235522AbhCAQtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:49:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CC0164EEA;
        Mon,  1 Mar 2021 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616335;
        bh=BqQMahe/bwDLRNaiE6tIqAxHG8KX+ksm1uE7n0ZYgIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjXWpr5WjRQ1mxN5VEfEkis3Nn+zPSZPJ4mzNLPxV2WoKwL0Qr5aDZs2i1mE97BpT
         FQTtaYycDN2tWu5duWCvqQ9ARNXfSRcq9pXP6hzjigdd0CFftcQVOhumSP3+GT85AB
         GNAAY/UjrCdjmopBFcgTejvuKCoN/99zVEjgYnyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongxiang Lou <louhongxiang@huawei.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 115/176] mm/memory.c: fix potential pte_unmap_unlock pte error
Date:   Mon,  1 Mar 2021 17:13:08 +0100
Message-Id: <20210301161026.691834356@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 90a3e375d324b2255b83e3dd29e99e2b05d82aaf ]

Since commit 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged
high MMIO PROT_NONE mappings"), when the first pfn modify is not allowed,
we would break the loop with pte unchanged.  Then the wrong pte - 1 would
be passed to pte_unmap_unlock.

Andi said:

 "While the fix is correct, I'm not sure if it actually is a real bug.
  Is there any architecture that would do something else than unlocking
  the underlying page? If it's just the underlying page then it should
  be always the same page, so no bug"

Link: https://lkml.kernel.org/r/20210109080118.20885-1-linmiaohe@huawei.com
Fixes: 42e4089c789 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index caefa5526b20c..5c2511831723e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1984,11 +1984,11 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
 			unsigned long addr, unsigned long end,
 			unsigned long pfn, pgprot_t prot)
 {
-	pte_t *pte;
+	pte_t *pte, *mapped_pte;
 	spinlock_t *ptl;
 	int err = 0;
 
-	pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
+	mapped_pte = pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
 	if (!pte)
 		return -ENOMEM;
 	arch_enter_lazy_mmu_mode();
@@ -2002,7 +2002,7 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
 		pfn++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap_unlock(mapped_pte, ptl);
 	return err;
 }
 
-- 
2.27.0



