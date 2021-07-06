Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F144C3BD16E
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbhGFLj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237035AbhGFLfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A2761CB3;
        Tue,  6 Jul 2021 11:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570713;
        bh=010x7vKbI2pvOTPycUOPxyKTSv6WaO3IorHBzGXHO/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUOjosfeNj8jNJEhDOA25cW7arod7XZzqIc8QXq8d88vgjN0jwGzdFy2Ov1RTznj5
         HH6QvxlXGJFs+1bPK2TEi4ydSIyIXNVkpe2bq/U6lCYJEF+0L0wIZX2NLX7pLjy9bc
         3eQPw1cihdFLso7cZqN6S88e1o5DtJKYxtvC/DfOeAEbX3BpcVItDg/KSA8H3OFqw0
         17ot+DASGcI/PAlpeNMcd1AcnCSOGh5x6pl9AOo+g9wzg+n3FNAQ/wGdDIJJWp6vai
         qXASo7sNpMeXnAahgrTFNXksywHFQQF/FyqeS7tjlQ+QDtoeM1jSlmmEO/es+LVHFU
         Q/tpth8xqag7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bibo Mao <maobibo@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/74] hugetlb: clear huge pte during flush function on mips platform
Date:   Tue,  6 Jul 2021 07:23:56 -0400
Message-Id: <20210706112502.2064236-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 33ae8f801ad8bec48e886d368739feb2816478f2 ]

If multiple threads are accessing the same huge page at the same
time, hugetlb_cow will be called if one thread write the COW huge
page. And function huge_ptep_clear_flush is called to notify other
threads to clear the huge pte tlb entry. The other threads clear
the huge pte tlb entry and reload it from page table, the reload
huge pte entry may be old.

This patch fixes this issue on mips platform, and it clears huge
pte entry before notifying other threads to flush current huge
page entry, it is similar with other architectures.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/hugetlb.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/hugetlb.h b/arch/mips/include/asm/hugetlb.h
index 425bb6fc3bda..bf1bf8c7c332 100644
--- a/arch/mips/include/asm/hugetlb.h
+++ b/arch/mips/include/asm/hugetlb.h
@@ -53,7 +53,13 @@ static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep)
 {
-	flush_tlb_page(vma, addr & huge_page_mask(hstate_vma(vma)));
+	/*
+	 * clear the huge pte entry firstly, so that the other smp threads will
+	 * not get old pte entry after finishing flush_tlb_page and before
+	 * setting new huge pte entry
+	 */
+	huge_ptep_get_and_clear(vma->vm_mm, addr, ptep);
+	flush_tlb_page(vma, addr);
 }
 
 #define __HAVE_ARCH_HUGE_PTE_NONE
-- 
2.30.2

