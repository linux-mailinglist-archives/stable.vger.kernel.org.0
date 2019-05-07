Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF2815B11
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbfEGFjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728955AbfEGFjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:39:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E365C20675;
        Tue,  7 May 2019 05:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207592;
        bh=vKWZ4BWnbyXlrZc2cSKReqfH0T75dQxJ0StJrorzd2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKw/35PxTMlp7PORDasrUhGGCvWyGfqOsQGR6YlTSySwsLocBizbr/r4qBazLPTS6
         NFfMfDDwlaRGQJGR1zIXGeCBb6y+gXBrRrCLG9TEsWsb1IT7TBvqqeRu1k9Doer1w4
         kq0YtvbSesdA1plu5QT+WSDd5Z9LCBnwvoDfk5n8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Punit Agrawal <punit.agrawal@arm.com>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 4.14 42/95] KVM: arm/arm64: Ensure only THP is candidate for adjustment
Date:   Tue,  7 May 2019 01:37:31 -0400
Message-Id: <20190507053826.31622-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Punit Agrawal <punit.agrawal@arm.com>

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
index 225dc671ae31..1f4cac53b923 100644
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

