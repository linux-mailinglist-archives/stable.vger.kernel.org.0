Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0709FA08A
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfKMBuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbfKMBuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58CDF22466;
        Wed, 13 Nov 2019 01:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609850;
        bh=I3ZLCnIDcjBuO+pE/ZPwAvwz5deLJv3WIzNphLQ4FDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmz8FHqA7pWushjdnAS2MizU9JmTDQh8wdOjK1cjo2w+JtbFhAkUKp8ahetnMPqeW
         fqhx8B2bG3OUYn7KAseFhtUaQ2PYEoKtQWKHytslwDSKH27brliV8LBHvlGlPxzFoz
         JU8hmFH10+yvyKJrdHN2YKOJy0XvJWAA3K4Uyhao=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 021/209] iommu/io-pgtable-arm: Fix race handling in split_blk_unmap()
Date:   Tue, 12 Nov 2019 20:47:17 -0500
Message-Id: <20191113015025.9685-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 85c7a0f1ef624ef58173ef52ea77780257bdfe04 ]

In removing the pagetable-wide lock, we gained the possibility of the
vanishingly unlikely case where we have a race between two concurrent
unmappers splitting the same block entry. The logic to handle this is
fairly straightforward - whoever loses the race frees their partial
next-level table and instead dereferences the winner's newly-installed
entry in order to fall back to a regular unmap, which intentionally
echoes the pre-existing case of recursively splitting a 1GB block down
to 4KB pages by installing a full table of 2MB blocks first.

Unfortunately, the chump who implemented that logic failed to update the
condition check for that fallback, meaning that if said race occurs at
the last level (where the loser's unmap_idx is valid) then the unmap
won't actually happen. Fix that to properly account for both the race
and recursive cases.

Fixes: 2c3d273eabe8 ("iommu/io-pgtable-arm: Support lockless operation")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
[will: re-jig control flow to avoid duplicate cmpxchg test]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgtable-arm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 88641b4560bc8..2f79efd16a052 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -574,13 +574,12 @@ static size_t arm_lpae_split_blk_unmap(struct arm_lpae_io_pgtable *data,
 			return 0;
 
 		tablep = iopte_deref(pte, data);
+	} else if (unmap_idx >= 0) {
+		io_pgtable_tlb_add_flush(&data->iop, iova, size, size, true);
+		return size;
 	}
 
-	if (unmap_idx < 0)
-		return __arm_lpae_unmap(data, iova, size, lvl, tablep);
-
-	io_pgtable_tlb_add_flush(&data->iop, iova, size, size, true);
-	return size;
+	return __arm_lpae_unmap(data, iova, size, lvl, tablep);
 }
 
 static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
-- 
2.20.1

