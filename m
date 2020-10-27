Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DBE29B50C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793704AbgJ0PHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775351AbgJ0PBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:01:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5A5420714;
        Tue, 27 Oct 2020 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810860;
        bh=bMuu2SKQBLQ0noUW6mEQ9MKF7f84WKR0o3cblm6N2kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WX6GDNzNfPOL5JTyQkmEC8Kt1rjybyflzLomz0g9Us6Wxhb02RNBiI1BkkjWou1nH
         X1tPxI/cj7I2yBeVg0vw0QJ/wmav/g+GDzbLdyF37E0piWSDrJXKVWJ6iaATlVJWFI
         3qqpNW0RQI4ST56/n6i3XxJDqIgf8mN9ZCmG+gz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Yu Kuai <yukuai3@huawei.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 289/633] iommu/qcom: add missing put_device() call in qcom_iommu_of_xlate()
Date:   Tue, 27 Oct 2020 14:50:32 +0100
Message-Id: <20201027135536.227868014@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit e2eae09939a89e0994f7965ba3c676a5eac8b4b0 ]

if of_find_device_by_node() succeed, qcom_iommu_of_xlate() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: 0ae349a0f33f ("iommu/qcom: Add qcom_iommu")
Acked-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20200929014037.2436663-1-yukuai3@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/qcom_iommu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/qcom_iommu.c b/drivers/iommu/qcom_iommu.c
index d176df569af8f..78d813bd0dcc8 100644
--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -578,8 +578,10 @@ static int qcom_iommu_of_xlate(struct device *dev, struct of_phandle_args *args)
 	 * index into qcom_iommu->ctxs:
 	 */
 	if (WARN_ON(asid < 1) ||
-	    WARN_ON(asid > qcom_iommu->num_ctxs))
+	    WARN_ON(asid > qcom_iommu->num_ctxs)) {
+		put_device(&iommu_pdev->dev);
 		return -EINVAL;
+	}
 
 	if (!dev_iommu_priv_get(dev)) {
 		dev_iommu_priv_set(dev, qcom_iommu);
@@ -588,8 +590,10 @@ static int qcom_iommu_of_xlate(struct device *dev, struct of_phandle_args *args)
 		 * multiple different iommu devices.  Multiple context
 		 * banks are ok, but multiple devices are not:
 		 */
-		if (WARN_ON(qcom_iommu != dev_iommu_priv_get(dev)))
+		if (WARN_ON(qcom_iommu != dev_iommu_priv_get(dev))) {
+			put_device(&iommu_pdev->dev);
 			return -EINVAL;
+		}
 	}
 
 	return iommu_fwspec_add_ids(dev, &asid, 1);
-- 
2.25.1



