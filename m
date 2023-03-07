Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3324B6AF499
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbjCGTRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjCGTRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBDCBAEF9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DEB761522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F79AC433EF;
        Tue,  7 Mar 2023 19:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215670;
        bh=OkL6K1NwnSqzOzA/NM+XOhQcwz0sSw4STIKoihQJPeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3S/W7MAK/FFpdpQDszmKC769RgYKyJS6JQuOm+nNBr9/qsPqHJqitptWBCuzEHbS
         RUuDB6WQFsOlRLsSVy8ny9e2t+jYzVQxSk+7CiWIrcDuxRD2PoQeZr1H8aTOGll8lB
         +K5RTugWEK2Ws9UVfkzU85Dv6ki7GoEX0qZ5dG08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/567] iommu/vt-d: Fix error handling in sva enable/disable paths
Date:   Tue,  7 Mar 2023 18:01:13 +0100
Message-Id: <20230307165920.483251439@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 60b1daa3b168fbc648ae2ad28a84759223e49e18 ]

Roll back all previous actions in error paths of intel_iommu_enable_sva()
and intel_iommu_disable_sva().

Fixes: d5b9e4bfe0d8 ("iommu/vt-d: Report prq to io-pgfault framework")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20230208051559.700109-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 751ff91af0ff6..5a4163f71a933 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5405,8 +5405,12 @@ static int intel_iommu_enable_sva(struct device *dev)
 		return -EINVAL;
 
 	ret = iopf_queue_add_device(iommu->iopf_queue, dev);
-	if (!ret)
-		ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
+	if (ret)
+		return ret;
+
+	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
+	if (ret)
+		iopf_queue_remove_device(iommu->iopf_queue, dev);
 
 	return ret;
 }
@@ -5418,8 +5422,12 @@ static int intel_iommu_disable_sva(struct device *dev)
 	int ret;
 
 	ret = iommu_unregister_device_fault_handler(dev);
-	if (!ret)
-		ret = iopf_queue_remove_device(iommu->iopf_queue, dev);
+	if (ret)
+		return ret;
+
+	ret = iopf_queue_remove_device(iommu->iopf_queue, dev);
+	if (ret)
+		iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
 
 	return ret;
 }
-- 
2.39.2



