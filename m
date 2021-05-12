Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED2037C9BA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhELQUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239927AbhELQQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29EB661D63;
        Wed, 12 May 2021 15:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834175;
        bh=KBawGH7cOPdiNXLwMIdd2SmB5YDFAtaR1s+kD1CEdtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCWjpBgFOns5nm0p0Xt23eR1s8UeMh43+/zfhxKl7AC/y4M7pmib2ovqFFK4UiVHX
         uhiOzzMeUWxxzSp7sTMWh/UhfGPxZUYCL/SXl05XRNGRpdXldfUfDgF+nyjMM5G/DZ
         0vP/ZHxXuVkI253SbW7fvKgcyBKPxr0It/f7slQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        Will Deacon <will@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 437/601] iommu: Fix a boundary issue to avoid performance drop
Date:   Wed, 12 May 2021 16:48:34 +0200
Message-Id: <20210512144842.229299788@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index d63d3e9cc7b6..3e82f0dce3cc 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -546,7 +546,7 @@ static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
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



