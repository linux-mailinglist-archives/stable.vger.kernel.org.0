Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15867417405
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345748AbhIXNBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345873AbhIXM7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E49C2613B3;
        Fri, 24 Sep 2021 12:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488013;
        bh=FOmoSz92b510kDvBvOC+BOpveMVp2GSYEVGd4Z96iAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Im6SZrsQXmuOh2mRYN+iPaSiTkxCPkbz8N0X07X+HiAO6y4BKamrG0gAetTWBEQEG
         8cN9qBo5lh8xcqSN9K/BMRucNPoLRnl//pDaiWpglsWiNFwb/SJk9T0GbdOCj/xC92
         qsQUjfb5Aa5rT14L/9CFEAzYQX09bMx7CxNjWPnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 050/100] arm64: mm: limit linear region to 51 bits for KVM in nVHE mode
Date:   Fri, 24 Sep 2021 14:43:59 +0200
Message-Id: <20210924124343.119361789@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 88053ec8cb1b91df566353cd3116470193797e00 ]

KVM in nVHE mode divides up its VA space into two equal halves, and
picks the half that does not conflict with the HYP ID map to map its
linear region. This worked fine when the kernel's linear map itself was
guaranteed to cover precisely as many bits of VA space, but this was
changed by commit f4693c2716b35d08 ("arm64: mm: extend linear region for
52-bit VA configurations").

The result is that, depending on the placement of the ID map, kernel-VA
to hyp-VA translations may produce addresses that either conflict with
other HYP mappings (including the ID map itself) or generate addresses
outside of the 52-bit addressable range, neither of which is likely to
lead to anything useful.

Given that 52-bit capable cores are guaranteed to implement VHE, this
only affects configurations such as pKVM where we opt into non-VHE mode
even if the hardware is VHE capable. So just for these configurations,
let's limit the kernel linear map to 51 bits and work around the
problem.

Fixes: f4693c2716b3 ("arm64: mm: extend linear region for 52-bit VA configurations")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20210826165613.60774-1-ardb@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/init.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 1fdb7bb7c198..0ad4afc9359b 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -319,7 +319,21 @@ static void __init fdt_enforce_memory_region(void)
 
 void __init arm64_memblock_init(void)
 {
-	const s64 linear_region_size = PAGE_END - _PAGE_OFFSET(vabits_actual);
+	s64 linear_region_size = PAGE_END - _PAGE_OFFSET(vabits_actual);
+
+	/*
+	 * Corner case: 52-bit VA capable systems running KVM in nVHE mode may
+	 * be limited in their ability to support a linear map that exceeds 51
+	 * bits of VA space, depending on the placement of the ID map. Given
+	 * that the placement of the ID map may be randomized, let's simply
+	 * limit the kernel's linear map to 51 bits as well if we detect this
+	 * configuration.
+	 */
+	if (IS_ENABLED(CONFIG_KVM) && vabits_actual == 52 &&
+	    is_hyp_mode_available() && !is_kernel_in_hyp_mode()) {
+		pr_info("Capping linear region to 51 bits for KVM in nVHE mode on LVA capable hardware.\n");
+		linear_region_size = min_t(u64, linear_region_size, BIT(51));
+	}
 
 	/* Handle linux,usable-memory-range property */
 	fdt_enforce_memory_region();
-- 
2.33.0



