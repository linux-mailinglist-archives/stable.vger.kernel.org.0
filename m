Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AA129B8A5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799538AbgJ0Pm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800239AbgJ0PfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BD0C22275;
        Tue, 27 Oct 2020 15:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812924;
        bh=c/+nvznaviyWZ/S3V/z59yTOTBOoLOD4EWGH7JCpdFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvXVGJBgRPt2swTliiGbeZREHLaLmq7XocIlN9DwnykurxLAL+v393gA2NQ8TPYfw
         CdTqrna3Bj23ClsJ83+aUORP46Hhog7Il44ncxJPlNA/rbs+KgLaldHLGzNs1xIvHT
         IxIK/4r1ERjZe1oOaiN5S2FmJqw+LveVXyajPPEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Yu Kuai <yukuai3@huawei.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 347/757] iommu/qcom: add missing put_device() call in qcom_iommu_of_xlate()
Date:   Tue, 27 Oct 2020 14:49:57 +0100
Message-Id: <20201027135506.841908370@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index af6bec3ace007..ef3dd32aa6d97 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -584,8 +584,10 @@ static int qcom_iommu_of_xlate(struct device *dev, struct of_phandle_args *args)
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
@@ -594,8 +596,10 @@ static int qcom_iommu_of_xlate(struct device *dev, struct of_phandle_args *args)
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



