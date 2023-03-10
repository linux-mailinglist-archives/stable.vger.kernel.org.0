Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D416B4370
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjCJOOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjCJOOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:14:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF392212E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:13:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EE11B822B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E67C4339C;
        Fri, 10 Mar 2023 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457541;
        bh=NqyLywQdr+GjqxAN5/Ok/tyfg5uViJIHxKLt5nmQYBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boCwXBHrprpq9ZfXSQi3R/3MAScFHBQ5eKnfPbzKTr8xbEfXp9md9tWs7KTQrwA6L
         RFS8vHDuD3UKB/O6yylWL/bYhS8U8bL/KpiSdI6OlFdaEqJMI+H8O3/cwBEAEYF++Y
         0S0U4P5B9Cg3hq5+SVlG0f7pRj/7y7T41uUShxoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
        Matt Fagnani <matt.fagnani@bell.net>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/200] iommu: Attach device group to old domain in error path
Date:   Fri, 10 Mar 2023 14:39:40 +0100
Message-Id: <20230310133722.414436375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 2cc73c5712f97de98c38c2fafc1f288354a9f3c3 ]

iommu_attach_group() attaches all devices in a group to domain and then
sets group domain (group->domain). Current code (__iommu_attach_group())
does not handle error path. This creates problem as devices to domain
attachment is in inconsistent state.

Flow:
  - During boot iommu attach devices to default domain
  - Later some device driver (like amd/iommu_v2 or vfio) tries to attach
    device to new domain.
  - In iommu_attach_group() path we detach device from current domain.
    Then it tries to attach devices to new domain.
  - If it fails to attach device to new domain then device to domain link
    is broken.
  - iommu_attach_group() returns error.
  - At this stage iommu_attach_group() caller thinks, attaching device to
    new domain failed and devices are still attached to old domain.
  - But in reality device to old domain link is broken. It will result
    in all sort of failures (like IO page fault) later.

To recover from this situation, we need to attach all devices back to the
old domain. Also log warning if it fails attach device back to old domain.

Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Reported-by: Matt Fagnani <matt.fagnani@bell.net>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Matt Fagnani <matt.fagnani@bell.net>
Link: https://lore.kernel.org/r/20230215052642.6016-1-vasant.hegde@amd.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216865
Link: https://lore.kernel.org/lkml/15d0f9ff-2a56-b3e9-5b45-e6b23300ae3b@leemhuis.info/
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fd8c8aeb3c504..bfb2f163c6914 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2089,8 +2089,22 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 
 	ret = __iommu_group_for_each_dev(group, domain,
 					 iommu_group_do_attach_device);
-	if (ret == 0)
+	if (ret == 0) {
 		group->domain = domain;
+	} else {
+		/*
+		 * To recover from the case when certain device within the
+		 * group fails to attach to the new domain, we need force
+		 * attaching all devices back to the old domain. The old
+		 * domain is compatible for all devices in the group,
+		 * hence the iommu driver should always return success.
+		 */
+		struct iommu_domain *old_domain = group->domain;
+
+		group->domain = NULL;
+		WARN(__iommu_group_set_domain(group, old_domain),
+		     "iommu driver failed to attach a compatible domain");
+	}
 
 	return ret;
 }
-- 
2.39.2



