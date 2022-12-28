Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBA065819E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbiL1QaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiL1Q3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:29:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267BD1AF18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:26:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B81AD61578
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA9EC433D2;
        Wed, 28 Dec 2022 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244759;
        bh=JfW3wOTCX+swmeAf6RGK+HFaTDza7VvIR6GBU/NEFIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6qaLvL1b0DkHhpQUJvH4kCzhKr98yt1tnwlHArwAB2vNuOGw8SlcNSfdhcez5+Ah
         BTnZ+aDzKQLs7B1o3jSbjqb0iu90SXr+FBrw/VlBphev/q/E/wjEBoofSEoXn/Q9GL
         uCbsSrQYOVQ5m1MLg36dOHRrOVGFOkbvDmGE6IYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0769/1073] iommu/sun50i: Consider all fault sources for reset
Date:   Wed, 28 Dec 2022 15:39:17 +0100
Message-Id: <20221228144348.900308369@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit cef20703e2b2276aaa402ec5a65ec9a09963b83e ]

We have to reset masters for all faults - permissions, L1 fault or L2
fault. Currently it's done only for permissions. If other type of fault
happens, master is in locked up state. Fix that by really considering
all fault sources.

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221025165415.307591-3-jernej.skrabec@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sun50i-iommu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index c777882d0ec2..38d1069cf383 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -869,8 +869,8 @@ static phys_addr_t sun50i_iommu_handle_perm_irq(struct sun50i_iommu *iommu)
 
 static irqreturn_t sun50i_iommu_irq(int irq, void *dev_id)
 {
+	u32 status, l1_status, l2_status, resets;
 	struct sun50i_iommu *iommu = dev_id;
-	u32 status;
 
 	spin_lock(&iommu->iommu_lock);
 
@@ -880,6 +880,9 @@ static irqreturn_t sun50i_iommu_irq(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 
+	l1_status = iommu_read(iommu, IOMMU_L1PG_INT_REG);
+	l2_status = iommu_read(iommu, IOMMU_L2PG_INT_REG);
+
 	if (status & IOMMU_INT_INVALID_L2PG)
 		sun50i_iommu_handle_pt_irq(iommu,
 					    IOMMU_INT_ERR_ADDR_L2_REG,
@@ -893,7 +896,8 @@ static irqreturn_t sun50i_iommu_irq(int irq, void *dev_id)
 
 	iommu_write(iommu, IOMMU_INT_CLR_REG, status);
 
-	iommu_write(iommu, IOMMU_RESET_REG, ~status);
+	resets = (status | l1_status | l2_status) & IOMMU_INT_MASTER_MASK;
+	iommu_write(iommu, IOMMU_RESET_REG, ~resets);
 	iommu_write(iommu, IOMMU_RESET_REG, IOMMU_RESET_RELEASE_ALL);
 
 	spin_unlock(&iommu->iommu_lock);
-- 
2.35.1



