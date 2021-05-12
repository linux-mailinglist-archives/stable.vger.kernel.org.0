Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E7E37C590
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbhELPl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236119AbhELPhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1E6561C45;
        Wed, 12 May 2021 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832705;
        bh=RLXRX7p9QBkk0qs1xA+Qk3UvYSFo6PoIGCtRjJsDlI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMLHSPXQQmCFrzjeekOIcsLc07pd2KJSDn+9SIfupVCnBwdu285liIfUNqFPdEvr/
         XOktMb9zOjHbcmwcVRYUNJx/IHixW2yjxbXrGPIOWj9KDyZBcp2MIbRCgHjQNys3yC
         Wry9Ld08Ozl6sxuZOXyj96pUM5dfUbji0UUctTEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        Will Deacon <will@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 389/530] iommu: Fix a boundary issue to avoid performance drop
Date:   Wed, 12 May 2021 16:48:19 +0200
Message-Id: <20210512144832.561371977@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 3431c3f660a39f6ced954548a59dba6541ce3eb1 ]

After the change of patch ("iommu: Switch gather->end to the
inclusive end"), the performace drops from 1600+K IOPS to 1200K in our
kunpeng ARM64 platform.
We find that the range [start1, end1) actually is joint from the range
[end1, end2), but it is considered as disjoint after the change,
so it needs more times of TLB sync, and spends more time on it.
So fix the boundary issue to avoid performance drop.

Fixes: 862c3715de8f ("iommu: Switch gather->end to the inclusive end")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/1616643504-120688-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iommu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f11f5072af5d..e90c267e7f3e 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -544,7 +544,7 @@ static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
 	 * structure can be rewritten.
 	 */
 	if (gather->pgsize != size ||
-	    end < gather->start || start > gather->end) {
+	    end + 1 < gather->start || start > gather->end + 1) {
 		if (gather->pgsize)
 			iommu_iotlb_sync(domain, gather);
 		gather->pgsize = size;
-- 
2.30.2



