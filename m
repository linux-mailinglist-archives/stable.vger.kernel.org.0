Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A961106FA6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfKVLQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbfKVKuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:50:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDDA0205C9;
        Fri, 22 Nov 2019 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419815;
        bh=gZnYs58YiVe5TChW7bml8wRKh6KmwgwD+XgFFTEa1qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cERXZQQhBRWRcpJzPHw2ZTOGvYxQsWGR9MuAWDZCAaUYkWqID0OgfS2r2r4dHeM1E
         K8NpLubHUNudyFc1BpGOAobQTWm5DiK3pDKKKL5iafEdRXXfSGqfN/s3fjNuzcsr5n
         xZVBdLYcxeo8IjV3LzhWGtR4OrkhAw6IiEkDlorM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 019/122] iommu/io-pgtable-arm: Fix race handling in split_blk_unmap()
Date:   Fri, 22 Nov 2019 11:27:52 +0100
Message-Id: <20191122100735.999354490@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e8018a308868e..17a9225283dd1 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -551,13 +551,12 @@ static int arm_lpae_split_blk_unmap(struct arm_lpae_io_pgtable *data,
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
 
 static int __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
-- 
2.20.1



