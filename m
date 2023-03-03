Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0166AA377
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjCCV7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbjCCV6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:58:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C32265C4A;
        Fri,  3 Mar 2023 13:50:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88B48B81A42;
        Fri,  3 Mar 2023 21:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E84C4339E;
        Fri,  3 Mar 2023 21:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880089;
        bh=RQi+ULgVroW/0a+juihRVBiqhQ2ycJLiUsbRMu2BT1I=;
        h=From:To:Cc:Subject:Date:From;
        b=ZmBHzV+Ga/Gm6ma+T/2nFg9BNOeGpfkVl3eLUrowqcZYvQOd8GmqLMsoR/L48Ytvy
         fdevIyyQ/lmXL0p3VJpzIlADlMStFOjTz4psrIaPfKvAa+zBOT77ZiYzYQ7sGjqHNa
         9H73WPfTvRRutkAHy3XjsM6IIBGofu8VYAI3XPoX13g+pjMrUd50EEmqGfsIUI1Cti
         86xNdSj9a0eWWd6RGUm0DW6H6ee8V4y0XVfiNhbRNPnbRLZ0K4X3bUKE1b347TLVaJ
         SwRGJCHCDnTtNNxCtV6PwM1SRT6NjiEvX6OBOa1z7UFkVSo0xwziOTy1fJQemAOuXo
         PTatP0gu0vOrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasant Hegde <vasant.hegde@amd.com>,
        Matt Fagnani <matt.fagnani@bell.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, joro@8bytes.org,
        will@kernel.org, iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 5.4 01/20] iommu/amd: Fix error handling for pdev_pri_ats_enable()
Date:   Fri,  3 Mar 2023 16:47:47 -0500
Message-Id: <20230303214806.1453287-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 080920e52148b4fbbf9360d5345fdcd7846e4841 ]

Current code throws kernel warning if it fails to enable pasid/pri [1].
Do not call pci_disable_[pasid/pri] if pci_enable_[pasid/pri] failed.

[1] https://lore.kernel.org/linux-iommu/15d0f9ff-2a56-b3e9-5b45-e6b23300ae3b@leemhuis.info/

Reported-by: Matt Fagnani <matt.fagnani@bell.net>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20230111121503.5931-1-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b79309928d786..a51e78caa9c8e 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2120,17 +2120,17 @@ static int pdev_iommuv2_enable(struct pci_dev *pdev)
 	/* Only allow access to user-accessible pages */
 	ret = pci_enable_pasid(pdev, 0);
 	if (ret)
-		goto out_err;
+		return ret;
 
 	/* First reset the PRI state of the device */
 	ret = pci_reset_pri(pdev);
 	if (ret)
-		goto out_err;
+		goto out_err_pasid;
 
 	/* Enable PRI */
 	ret = pci_enable_pri(pdev, reqs);
 	if (ret)
-		goto out_err;
+		goto out_err_pasid;
 
 	if (reset_enable) {
 		ret = pri_reset_while_enabled(pdev);
@@ -2140,12 +2140,14 @@ static int pdev_iommuv2_enable(struct pci_dev *pdev)
 
 	ret = pci_enable_ats(pdev, PAGE_SHIFT);
 	if (ret)
-		goto out_err;
+		goto out_err_pri;
 
 	return 0;
 
-out_err:
+out_err_pri:
 	pci_disable_pri(pdev);
+
+out_err_pasid:
 	pci_disable_pasid(pdev);
 
 	return ret;
-- 
2.39.2

