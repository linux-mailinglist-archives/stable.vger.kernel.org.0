Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB1A24E873
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 18:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgHVQCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 12:02:16 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:64461 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726408AbgHVQCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 12:02:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22208727-1500050 
        for multiple; Sat, 22 Aug 2020 17:02:11 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     iommu@lists.linux-foundation.org
Cc:     intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        James Sewart <jamessewart@arista.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: [PATCH] iommu/intel: Handle 36b addressing for x86-32
Date:   Sat, 22 Aug 2020 17:02:09 +0100
Message-Id: <20200822160209.28512-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Beware that the address size for x86-32 may exceed unsigned long.

[    0.368971] UBSAN: shift-out-of-bounds in drivers/iommu/intel/iommu.c:128:14
[    0.369055] shift exponent 36 is too large for 32-bit type 'long unsigned int'

If we don't handle the wide addresses, the pages are mismapped and the
device read/writes go astray, detected as DMAR faults and leading to
device failure. The behaviour changed (from working to broken) in commit
fa954e683178 ("iommu/vt-d: Delegate the dma domain to upper layer"), but
the error looks older.

Fixes: fa954e683178 ("iommu/vt-d: Delegate the dma domain to upper layer")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: James Sewart <jamessewart@arista.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: <stable@vger.kernel.org> # v5.3+
---
 drivers/iommu/intel/iommu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 2e9c8c3d0da4..ba78a2e854f9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -123,29 +123,29 @@ static inline unsigned int level_to_offset_bits(int level)
 	return (level - 1) * LEVEL_STRIDE;
 }
 
-static inline int pfn_level_offset(unsigned long pfn, int level)
+static inline int pfn_level_offset(u64 pfn, int level)
 {
 	return (pfn >> level_to_offset_bits(level)) & LEVEL_MASK;
 }
 
-static inline unsigned long level_mask(int level)
+static inline u64 level_mask(int level)
 {
-	return -1UL << level_to_offset_bits(level);
+	return -1ULL << level_to_offset_bits(level);
 }
 
-static inline unsigned long level_size(int level)
+static inline u64 level_size(int level)
 {
-	return 1UL << level_to_offset_bits(level);
+	return 1ULL << level_to_offset_bits(level);
 }
 
-static inline unsigned long align_to_level(unsigned long pfn, int level)
+static inline u64 align_to_level(u64 pfn, int level)
 {
 	return (pfn + level_size(level) - 1) & level_mask(level);
 }
 
 static inline unsigned long lvl_to_nr_pages(unsigned int lvl)
 {
-	return  1 << min_t(int, (lvl - 1) * LEVEL_STRIDE, MAX_AGAW_PFN_WIDTH);
+	return 1UL << min_t(int, (lvl - 1) * LEVEL_STRIDE, MAX_AGAW_PFN_WIDTH);
 }
 
 /* VT-d pages must always be _smaller_ than MM pages. Otherwise things
-- 
2.20.1

