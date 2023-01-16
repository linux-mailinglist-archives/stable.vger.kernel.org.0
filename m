Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426FF66C4B6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjAPP5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjAPP5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78F2E396
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4740761042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACEBC433EF;
        Mon, 16 Jan 2023 15:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884641;
        bh=CsKm78zPTazvingQ1Le32COlzZJiD4hVMkvcP/fx/1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvxE9nrSPXf7wq/VyVszHduN4TQbiqDxBsSd3eMW2cQOHyfreWt9dbg/0hycspeGJ
         RR52Gow0cL8+a0gmat8sPFpjDsT0D7pDS43pA8ZWneTlgKSqhXkhD99t1Dy4pv9/mr
         FHdhmbVE42pVZwZQoGG8bQri1i1rhtInQHY20fuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 084/183] iommu/arm-smmu-v3: Dont unregister on shutdown
Date:   Mon, 16 Jan 2023 16:50:07 +0100
Message-Id: <20230116154806.980119335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 32ea2c57dc216b6ad8125fa680d31daa5d421c95 upstream.

Similar to SMMUv2, this driver calls iommu_device_unregister() from the
shutdown path, which removes the IOMMU groups with no coordination
whatsoever with their users - shutdown methods are optional in device
drivers. This can lead to NULL pointer dereferences in those drivers'
DMA API calls, or worse.

Instead of calling the full arm_smmu_device_remove() from
arm_smmu_device_shutdown(), let's pick only the relevant function call -
arm_smmu_device_disable() - more or less the reverse of
arm_smmu_device_reset() - and call just that from the shutdown path.

Fixes: 57365a04c921 ("iommu: Move bus setup to IOMMU device registration")
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20221215141251.3688780-2-vladimir.oltean@nxp.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3854,7 +3854,9 @@ static int arm_smmu_device_remove(struct
 
 static void arm_smmu_device_shutdown(struct platform_device *pdev)
 {
-	arm_smmu_device_remove(pdev);
+	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
+
+	arm_smmu_device_disable(smmu);
 }
 
 static const struct of_device_id arm_smmu_of_match[] = {


