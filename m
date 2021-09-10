Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AA94062B7
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241951AbhIJAqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233905AbhIJAWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1C3F611AF;
        Fri, 10 Sep 2021 00:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233256;
        bh=O/gg5zFLjVoQtTTZxlWgpQw4T0yXAHEHAMRe3ZrnNIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmNeB98HNqtiLQ6m+dQsge5k5a2a9mFuecEVvHGz3KIQVkHUHs0qIhz5Z1XWuYKgH
         cRIBZ7JF2BfLW8MM4Twqi1UiNrdUrqziLfQCIJvY4A7XTD6/13YoCR26xEelmlbPYh
         qNz8lx1gXkE3Q/w5Gbp9HhYtaDalIJmh4myeyDAfePKR1yBBIyPCIwqvfDGlgnbTHa
         7KzBLS4xzDDynR/WSDKoGmioqJAEfahBTdv/TstK56J0lr8Uxd+x5O/0epfcPXVI6Q
         UObqkcuYn7vv7Gzh3OvAtKzpgMlYxKhsPjY2Z1xVUbualXE4xHtMvqNAJcJ2M5vO0E
         hkxLgIe4RXtkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ashish Mhetre <amhetre@nvidia.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 20/53] iommu: Fix race condition during default domain allocation
Date:   Thu,  9 Sep 2021 20:19:55 -0400
Message-Id: <20210910002028.175174-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
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
index bcf060b5cf85..a103a503a4db 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -262,7 +262,9 @@ int iommu_probe_device(struct device *dev)
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

