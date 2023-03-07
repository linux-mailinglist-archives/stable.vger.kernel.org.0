Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F006AEB2B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjCGRk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjCGRkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:40:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14F79E663
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:36:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 223DDB8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C012C433EF;
        Tue,  7 Mar 2023 17:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210603;
        bh=5GRxdFP7K4j/5npEL3UGO9QDQLMqVf84ESLvR1yajaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gg/6F3MTc7R2ubZd2docARk7+s1Q0tQQ4MWw/1mgrKr6/4iNOTT4QrHSWg6lTsMVz
         Bsghg1Bz4xuwvKI5+JoS2RxTODgD7/v1oNTruGSEPyKtniUvy+J0Z6C8EKOq0noh+o
         37xr14AuJDfoad3F0eaLUEfyK8CxpSDoV9gNPhmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0563/1001] iommu: Fix error unwind in iommu_group_alloc()
Date:   Tue,  7 Mar 2023 17:55:35 +0100
Message-Id: <20230307170045.913689847@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 4daa861174d56023c2068ddb03de0752f07fa199 ]

If either iommu_group_grate_file() fails then the
iommu_group is leaked.

Destroy it on these error paths.

Found by kselftest/iommu/iommufd_fail_nth

Fixes: bc7d12b91bd3 ("iommu: Implement reserved_regions iommu-group sysfs file")
Fixes: c52c72d3dee8 ("iommu: Add sysfs attribyte for domain type")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/0-v1-8f616bee028d+8b-iommu_group_alloc_leak_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 9ff8cda2de7c6..50d858f36a81b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -774,12 +774,16 @@ struct iommu_group *iommu_group_alloc(void)
 
 	ret = iommu_group_create_file(group,
 				      &iommu_group_attr_reserved_regions);
-	if (ret)
+	if (ret) {
+		kobject_put(group->devices_kobj);
 		return ERR_PTR(ret);
+	}
 
 	ret = iommu_group_create_file(group, &iommu_group_attr_type);
-	if (ret)
+	if (ret) {
+		kobject_put(group->devices_kobj);
 		return ERR_PTR(ret);
+	}
 
 	pr_debug("Allocated group %d\n", group->id);
 
-- 
2.39.2



