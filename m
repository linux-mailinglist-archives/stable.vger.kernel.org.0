Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E851147D47
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgAXJ6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgAXJ6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:58:54 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E86120718;
        Fri, 24 Jan 2020 09:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859933;
        bh=S0DcZUB/dj1Ci2RayirlwC/ePHnKNOhILSazWcVMolU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4ByzmZTl/vfStVr0BNdJymTUsO29KdBD7zyCnp6q56nkZIooS6kGghvjF4LBUx4R
         gmbLRqzjngo3lGpguuLXHta7NPoJyjLID9WtdjQmfeS4CUMdoyjSquDe4+zo1QXeu/
         wj2cIdiFSaAAxzEab6OE8M0DmVko3xKlGFPgDbek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 224/343] iommu: Use right function to get group for device
Date:   Fri, 24 Jan 2020 10:30:42 +0100
Message-Id: <20200124092949.600552033@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 57274ea25736496ee019a5c40479855b21888839 ]

The iommu_group_get_for_dev() will allocate a group for a
device if it isn't in any group. This isn't the use case
in iommu_request_dm_for_dev(). Let's use iommu_group_get()
instead.

Fixes: d290f1e70d85a ("iommu: Introduce iommu_request_dm_for_dev()")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 4b761678a18bb..2c48a9d6d91e9 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1856,9 +1856,9 @@ int iommu_request_dm_for_dev(struct device *dev)
 	int ret;
 
 	/* Device must already be in a group before calling this function */
-	group = iommu_group_get_for_dev(dev);
-	if (IS_ERR(group))
-		return PTR_ERR(group);
+	group = iommu_group_get(dev);
+	if (!group)
+		return -EINVAL;
 
 	mutex_lock(&group->mutex);
 
-- 
2.20.1



