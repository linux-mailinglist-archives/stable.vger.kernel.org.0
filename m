Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A2E1F1B8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfEOLRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbfEOLRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:17:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2229420644;
        Wed, 15 May 2019 11:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919053;
        bh=sIEpzBP2Z3Ii8F5JVqfFpnSZmjXPVZuB9OmYUgD8Ixs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Apj9tmJstBbLy3gCeHWlh7VH6/AU4hYw5yYW5937SaDiPoAF/uyXS5HZrXTpEWVO
         c0buf0yfpLJ+44fF3NLTRaQr16oEJPqhC96Xg+hpwq2EK57k3Apgs2xZDgmz4V6awS
         h8F8fqLSU/gS1++4Pd/9AzibiGUIarUAqm0bhqu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 047/115] KVM: arm/arm64: Ensure only THP is candidate for adjustment
Date:   Wed, 15 May 2019 12:55:27 +0200
Message-Id: <20190515090703.009777947@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fd2ef358282c849c193aa36dadbf4f07f7dcd29b ]

PageTransCompoundMap() returns true for hugetlbfs and THP
hugepages. This behaviour incorrectly leads to stage 2 faults for
unsupported hugepage sizes (e.g., 64K hugepage with 4K pages) to be
treated as THP faults.

Tighten the check to filter out hugetlbfs pages. This also leads to
consistently mapping all unsupported hugepage sizes as PTE level
entries at stage 2.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: stable@vger.kernel.org # v4.13+
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 virt/kvm/arm/mmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 225dc671ae31b..1f4cac53b9234 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1068,8 +1068,14 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *ipap >> PAGE_SHIFT;
+	struct page *page = pfn_to_page(pfn);
 
-	if (PageTransCompoundMap(pfn_to_page(pfn))) {
+	/*
+	 * PageTransCompoungMap() returns true for THP and
+	 * hugetlbfs. Make sure the adjustment is done only for THP
+	 * pages.
+	 */
+	if (!PageHuge(page) && PageTransCompoundMap(page)) {
 		unsigned long mask;
 		/*
 		 * The address we faulted on is backed by a transparent huge
-- 
2.20.1



