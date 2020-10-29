Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD07529E9ED
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbgJ2LDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727294AbgJ2LDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 07:03:40 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4F4620754;
        Thu, 29 Oct 2020 11:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603969420;
        bh=acyncxg5wDmK6CNLmKA7z6UGUav7uI03MNVXwSyOnEI=;
        h=From:To:Cc:Subject:Date:From;
        b=2l7+bdLsxiEoowdZcFK8fSCWL8dc6VEbigghYpsfmRdAG96y63rpRU+TOb4VC3eRm
         SxGFfM/H8Drmgt7S9KEKWjfrVU10S2BXpHQh5zohudS/m+W2oBmOOmjJKratdUW6M/
         ALKaey2MrK+zqmua8tZQZrtZMrdwYB5eoZK6f67Q=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linus.walleij@linaro.org, linux@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] ARM: highmem: avoid clobbering non-page aligned memory reservations
Date:   Thu, 29 Oct 2020 12:03:34 +0100
Message-Id: <20201029110334.4118-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

free_highpages() iterates over the free memblock regions in high
memory, and marks each page as available for the memory management
system. However, as it rounds the end of each region downwards, we
may end up freeing a page that is memblock_reserve()d, resulting
in memory corruption. So align the end of the range to the next
page instead.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index a391804c7ce3..d41781cb5496 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -354,7 +354,7 @@ static void __init free_highpages(void)
 	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
 				&range_start, &range_end, NULL) {
 		unsigned long start = PHYS_PFN(range_start);
-		unsigned long end = PHYS_PFN(range_end);
+		unsigned long end = PHYS_PFN(PAGE_ALIGN(range_end));
 
 		/* Ignore complete lowmem entries */
 		if (end <= max_low)
-- 
2.17.1

