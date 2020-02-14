Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1406715E8AD
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392547AbgBNQQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:16:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388928AbgBNQQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:16:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB752467D;
        Fri, 14 Feb 2020 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696976;
        bh=Mtlh610rIh1oU57Gn79F/DgIvT7mImV8G06VW8H0y+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pmiucf5EBun4bM6tRB7TLwGXUHQ+jctLX8qpHI9pLHkqrB6pydm36dtjefotSiZRd
         L+TvpwXsgNL+fZAkRGQxtivgJZGKX/JvJze0fwAfVkCGpiM2EPADa6o2z/LRLD7dM4
         6i/m6POySF65cQepOioQsVmXiWjKSnzv3llK+hmw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>, Frank <fgndev@posteo.de>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 214/252] iommu/vt-d: Remove unnecessary WARN_ON_ONCE()
Date:   Fri, 14 Feb 2020 11:11:09 -0500
Message-Id: <20200214161147.15842-214-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 857f081426e5aa38313426c13373730f1345fe95 ]

Address field in device TLB invalidation descriptor is qualified
by the S field. If S field is zero, a single page at page address
specified by address [63:12] is requested to be invalidated. If S
field is set, the least significant bit in the address field with
value 0b (say bit N) indicates the invalidation address range. The
spec doesn't require the address [N - 1, 0] to be cleared, hence
remove the unnecessary WARN_ON_ONCE().

Otherwise, the caller might set "mask = MAX_AGAW_PFN_WIDTH" in order
to invalidating all the cached mappings on an endpoint, and below
overflow error will be triggered.

[...]
UBSAN: Undefined behaviour in drivers/iommu/dmar.c:1354:3
shift exponent 64 is too large for 64-bit type 'long long unsigned int'
[...]

Reported-and-tested-by: Frank <fgndev@posteo.de>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dmar.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 7f9824b0609e7..72994d67bc5b9 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1345,7 +1345,6 @@ void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 	struct qi_desc desc;
 
 	if (mask) {
-		WARN_ON_ONCE(addr & ((1ULL << (VTD_PAGE_SHIFT + mask)) - 1));
 		addr |= (1ULL << (VTD_PAGE_SHIFT + mask - 1)) - 1;
 		desc.high = QI_DEV_IOTLB_ADDR(addr) | QI_DEV_IOTLB_SIZE;
 	} else
-- 
2.20.1

