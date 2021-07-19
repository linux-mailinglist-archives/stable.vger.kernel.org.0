Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40193CDDCE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245556AbhGSPAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343839AbhGSO7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EF20611F2;
        Mon, 19 Jul 2021 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709044;
        bh=Nj0Udr4R71nGxE+aMr8O49t+TEjcRM2tKiepHUjqTXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xit3BPZtniQ8KarQ3ofcApd3PRd3k7VqwcIeI3aPqs1AOMC/VHmsawKl92FKaa15I
         gFj4ZRZ1mwvHJXleYHRfXGzoSDtuNnA3y0V6zZVp5XyOwFR+9vQrKtnJZNgnVthsv0
         2yOlfNFF+Ic63yR4+TNUMviuq+Q2Nn6YQ+lOG6Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 232/421] hugetlb: clear huge pte during flush function on mips platform
Date:   Mon, 19 Jul 2021 16:50:43 +0200
Message-Id: <20210719144954.462802772@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 982bc0685330..4747a4694669 100644
--- a/arch/mips/include/asm/hugetlb.h
+++ b/arch/mips/include/asm/hugetlb.h
@@ -67,7 +67,13 @@ static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
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
 
 static inline int huge_pte_none(pte_t pte)
-- 
2.30.2



