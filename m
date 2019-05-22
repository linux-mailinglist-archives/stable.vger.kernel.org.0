Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BA426E14
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731733AbfEVT11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732311AbfEVT11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:27:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDAF920879;
        Wed, 22 May 2019 19:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553246;
        bh=n5+gDpMNaq8KcsAJoDm5v6L2gQSBKD7GRoCpfN9jw84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUN2D5lliI3McKeG+eEwevU3x7BJiCT65exHJFD5flyd9M/1jiaw2PyKDpgsHvjR1
         hcBqaTTEiZTxSGjMo0XA8QApoeN1jkUEPIkVEl4Vz6auIAFfL22E4RwmUA+kNG2utK
         /AACs0QkCfRGL3Fl12t3eLHH9tDnp+NxyE+AA3Hk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 032/244] arm64: Fix compiler warning from pte_unmap() with -Wunused-but-set-variable
Date:   Wed, 22 May 2019 15:22:58 -0400
Message-Id: <20190522192630.24917-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 74dd022f9e6260c3b5b8d15901d27ebcc5f21eda ]

When building with -Wunused-but-set-variable, the compiler shouts about
a number of pte_unmap() users, since this expands to an empty macro on
arm64:

  | mm/gup.c: In function 'gup_pte_range':
  | mm/gup.c:1727:16: warning: variable 'ptem' set but not used
  | [-Wunused-but-set-variable]
  | mm/gup.c: At top level:
  | mm/memory.c: In function 'copy_pte_range':
  | mm/memory.c:821:24: warning: variable 'orig_dst_pte' set but not used
  | [-Wunused-but-set-variable]
  | mm/memory.c:821:9: warning: variable 'orig_src_pte' set but not used
  | [-Wunused-but-set-variable]
  | mm/swap_state.c: In function 'swap_ra_info':
  | mm/swap_state.c:641:15: warning: variable 'orig_pte' set but not used
  | [-Wunused-but-set-variable]
  | mm/madvise.c: In function 'madvise_free_pte_range':
  | mm/madvise.c:318:9: warning: variable 'orig_pte' set but not used
  | [-Wunused-but-set-variable]

Rewrite pte_unmap() as a static inline function, which silences the
warnings.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 1bdeca8918a68..ea423db393644 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -444,6 +444,8 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
 	return __pmd_to_phys(pmd);
 }
 
+static inline void pte_unmap(pte_t *pte) { }
+
 /* Find an entry in the third-level page table. */
 #define pte_index(addr)		(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 
@@ -452,7 +454,6 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
 
 #define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
 #define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir), (addr))
-#define pte_unmap(pte)			do { } while (0)
 #define pte_unmap_nested(pte)		do { } while (0)
 
 #define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
-- 
2.20.1

