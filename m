Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDFBE5D72
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfJZNQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbfJZNQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F6921871;
        Sat, 26 Oct 2019 13:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095766;
        bh=utDE9A+XwM99gvrdM1e5/XmBqugeLFVWUk3GsHMGKV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myewyYOlNzUm+GP+1U1V1WAGv89DqC4/rjDIHkfb4xsOabZTeWWsOcE4uWQLws5k4
         l8RcCj3GRuAkzQa/HPhl5JN7iCltBq3H+MVG5NmrgfQ2+uNdgWM3Wvh5agZRaBo+3v
         D/FgXWe37+3U7EuSGFJ9YdlDIrSdFnxL3ZqVc+ZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.3 04/99] iommu/io-pgtable-arm: Support all Mali configurations
Date:   Sat, 26 Oct 2019 09:14:25 -0400
Message-Id: <20191026131600.2507-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 1be08f458d1602275b02f5357ef069957058f3fd ]

In principle, Midgard GPUs supporting smaller VA sizes should only
require 3-level pagetables, since level 0 only resolves bits 48:40 of
the address. However, the kbase driver does not appear to have any
notion of a variable start level, and empirically T720 and T820 rapidly
blow up with translation faults unless given a full 4-level table,
despite only supporting a 33-bit VA size.

The 'real' IAS value is still valuable in terms of validating addresses
on map/unmap, so tweak the allocator to allow smaller values while still
forcing the resultant tables to the full 4 levels. As far as I can test,
this should make all known Midgard variants happy.

Fixes: d08d42de6432 ("iommu: io-pgtable: Add ARM Mali midgard MMU page table format")
Tested-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgtable-arm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 9e35cd991f065..77f41c9dd9be7 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -1022,7 +1022,7 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 	if (cfg->quirks)
 		return NULL;
 
-	if (cfg->ias != 48 || cfg->oas > 40)
+	if (cfg->ias > 48 || cfg->oas > 40)
 		return NULL;
 
 	cfg->pgsize_bitmap &= (SZ_4K | SZ_2M | SZ_1G);
@@ -1031,6 +1031,11 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 	if (!data)
 		return NULL;
 
+	/* Mali seems to need a full 4-level table regardless of IAS */
+	if (data->levels < ARM_LPAE_MAX_LEVELS) {
+		data->levels = ARM_LPAE_MAX_LEVELS;
+		data->pgd_size = sizeof(arm_lpae_iopte);
+	}
 	/*
 	 * MEMATTR: Mali has no actual notion of a non-cacheable type, so the
 	 * best we can do is mimic the out-of-tree driver and hope that the
-- 
2.20.1

