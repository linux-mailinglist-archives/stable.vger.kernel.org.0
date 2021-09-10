Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1434640620D
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbhIJAog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233569AbhIJAUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6258C610A3;
        Fri, 10 Sep 2021 00:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233151;
        bh=2Rb8pAo61id0/qvD1+/iwJWQ3LQzfOrKbsYuJ0pBJL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRotO7Vbqz79bKIn31GHnbRXvJcTnxGiT2KIeviOYS5OMIqk0a/eBhjnV3xjmoIW1
         dWsRF9FHWlwMquspD0NzT9iSB8E3eiXf+3MVr5mo8ddeZ6VgFL8YK7zG/bDeNBWkYS
         uS/1w3slxsUbj8or6DX4dqeo2hBOzeQbf6cFWFECk1pU+SOosLALklTtdiSCyguUq/
         vvCrdYIN0n6cluHak9dfkBss9OYS1e9bI9Ns5633hYX7D5aWAqXK0/Eb8npBbl+EN7
         3RUxSYZWccDF0WyEHdkuctj2L296i66x6Uovr6vH1WPWx6gYdvj1pmrbkC/JbYu49b
         91e7e22lQ/WXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ashish Mhetre <amhetre@nvidia.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.13 35/88] iommu: Fix race condition during default domain allocation
Date:   Thu,  9 Sep 2021 20:17:27 -0400
Message-Id: <20210910001820.174272-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index db966a7841fe..f4d0bab6be10 100644
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

