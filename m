Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261C0406155
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhIJAmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230434AbhIJASV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0FBF61208;
        Fri, 10 Sep 2021 00:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233015;
        bh=RNf9vEr2uufGpxXa4wgnVK85ccOPTtxswSIhBYi6TL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGEfuDDFD1woLTNlTMd9HuJZCEv2cEHDtmoHWSNeNgTvNcO+CneKyr9iYoTrXYDKu
         uTMIKbTVPieY/UW8tC68CyHVtVvFFPGyvflR36NRcyNJ5p0hPNGWUR05Ih10yAIj0D
         hcha768wtoJ9egEhnJO+YnlXwT1fyWZ/5g+1yHxi2fWTA+bAXWdX0KPXclZDAMQxZW
         3dRjqzBajWZ9huOimjpUZ9UK1eJFIJhYA9/BjOBufGhj1Hoooz852Hcwx+0bvB2iIY
         5y6Z2+9pcWK6mqthF5r2MqeZO7kRKTDQrpkP3Okrq8msW/tZZuQ8Iy9FOmDCMtftlh
         13+lt7v78uquA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ashish Mhetre <amhetre@nvidia.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.14 41/99] iommu: Fix race condition during default domain allocation
Date:   Thu,  9 Sep 2021 20:15:00 -0400
Message-Id: <20210910001558.173296-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashish Mhetre <amhetre@nvidia.com>

[ Upstream commit 211ff31b3d33b56aa12937e898c9280d07daf0d9 ]

When two devices with same SID are getting probed concurrently through
iommu_probe_device(), the iommu_domain sometimes is getting allocated more
than once as call to iommu_alloc_default_domain() is not protected for
concurrency. Furthermore, it leads to each device holding a different
iommu_domain pointer, separate IOVA space and only one of the devices'
domain is used for translations from IOMMU. This causes accesses from other
device to fault or see incorrect translations.
Fix this by protecting iommu_alloc_default_domain() call with group->mutex
and let all devices with same SID share same iommu_domain.

Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
Link: https://lore.kernel.org/r/1628570641-9127-2-git-send-email-amhetre@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 63f0af10c403..3050cc4b02bc 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -273,7 +273,9 @@ int iommu_probe_device(struct device *dev)
 	 * support default domains, so the return value is not yet
 	 * checked.
 	 */
+	mutex_lock(&group->mutex);
 	iommu_alloc_default_domain(group, dev);
+	mutex_unlock(&group->mutex);
 
 	if (group->default_domain) {
 		ret = __iommu_attach_device(group->default_domain, dev);
-- 
2.30.2

