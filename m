Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAFC2C9C4C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388834AbgLAJRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389015AbgLAJMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 879D6206CA;
        Tue,  1 Dec 2020 09:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813917;
        bh=yzmrYridZZHC56CRIQEOUhTE+VoFsyBBdUhnkMxaCBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNenS8X6RSuy8UwjUm/iUqiZaUxaJKQBSjbv/DM3KyI9e/2vGcbXAqpT+c/HtZXls
         U6rTR34GV8kSjAScffEGdOQ3G9sMud0NADRNR2vXizT+tCJ833s7420nbaQD8m1tjN
         xXY0UGf1I57qNoCBjXO4p/s6qIlR2dKoxTY9VhhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 103/152] iommu: Check return of __iommu_attach_device()
Date:   Tue,  1 Dec 2020 09:53:38 +0100
Message-Id: <20201201084725.342977874@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

[ Upstream commit 77c38c8cf52ef715bfc5cab3d14222d4f3e776e2 ]

Currently iommu_create_device_direct_mappings() is called
without checking the return of __iommu_attach_device(). This
may result in failures in iommu driver if dev attach returns
error.

Fixes: ce574c27ae27 ("iommu: Move iommu_group_create_direct_mappings() out of iommu_group_add_device()")
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Link: https://lore.kernel.org/r/20201119165846.34180-1-shameerali.kolothum.thodi@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 609bd25bf154b..6a0a79e3f5641 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -264,16 +264,18 @@ int iommu_probe_device(struct device *dev)
 	 */
 	iommu_alloc_default_domain(group, dev);
 
-	if (group->default_domain)
+	if (group->default_domain) {
 		ret = __iommu_attach_device(group->default_domain, dev);
+		if (ret) {
+			iommu_group_put(group);
+			goto err_release;
+		}
+	}
 
 	iommu_create_device_direct_mappings(group, dev);
 
 	iommu_group_put(group);
 
-	if (ret)
-		goto err_release;
-
 	if (ops->probe_finalize)
 		ops->probe_finalize(dev);
 
-- 
2.27.0



