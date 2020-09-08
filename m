Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC51D261420
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbgIHQGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731214AbgIHQFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61C2A21D80;
        Tue,  8 Sep 2020 15:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579937;
        bh=zuZmKb8WP9O1Bn85UWwWrQPriHdYTxy/O7xpjBrkROo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9vd4PXsN4Sk+GRABeqtBOr1ySY3ikD02LNMrTLQ0sYfOmUO48arVZWjHxI4pF89X
         AMXrejJoXNPpJXxlK9Uv0FUNEnR0q0hTmN3CO/rVQjwRb0zBTkjJn8xeitm4c8M4gt
         krw9qyNTAuT2a7AStfYTRwzeR2Wd3t1j4XVTUvDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        James Sewart <jamessewart@arista.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 076/129] iommu/vt-d: Handle 36bit addressing for x86-32
Date:   Tue,  8 Sep 2020 17:25:17 +0200
Message-Id: <20200908152233.495213316@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 29aaebbca4abc4cceb38738483051abefafb6950 upstream.

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
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Cc: James Sewart <jamessewart@arista.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: <stable@vger.kernel.org> # v5.3+
Link: https://lore.kernel.org/r/20200822160209.28512-1-chris@chris-wilson.co.uk
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -123,29 +123,29 @@ static inline unsigned int level_to_offs
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


