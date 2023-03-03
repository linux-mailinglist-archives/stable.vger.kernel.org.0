Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FBB6AA2B5
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbjCCVtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbjCCVtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:49:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB3F67030;
        Fri,  3 Mar 2023 13:45:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 921B4B81A01;
        Fri,  3 Mar 2023 21:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DFEC433AA;
        Fri,  3 Mar 2023 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879924;
        bh=1l9CNJ8eRwES9R0cfICK1umvf0eZ1DCpbyE1HqEnb2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9mKLc97uRYL8z+ZbaEVsHPTlVaN/Jdn5zz/DBeVElnOvsIPFsVqUnVFhkZjYji9O
         BJPCj3TQ6XLpr/F05dd1CzGzIeBHSt3N7bXA0+qJDtLq4HoAwDH20Vt2GbFDyr6zS/
         3q9LC3BTQhKxzw4qQGLLqG9BTgp9DK7uvfv4WO7XSD0YlrgsrEIyKjqBLmgiJ3fTXA
         eyRcc+zWyuyym0cvDHgEIhAVBkODFSJfTtX5rnAncWW/IEG1NfNKhfGlSMkeGYlJl1
         0Szz6E8FpTYNQka4CmqmW3nlwsBWKHDDQG9cbDhWCSbjZwS3vnzdHdMMTn50yguX1o
         3D+9fl7z/j9Fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasant Hegde <vasant.hegde@amd.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Matt Fagnani <matt.fagnani@bell.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, joro@8bytes.org,
        will@kernel.org, iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 58/60] iommu: Attach device group to old domain in error path
Date:   Fri,  3 Mar 2023 16:43:12 -0500
Message-Id: <20230303214315.1447666-58-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 959d895fc1dff..f9eb1a4bb5bb0 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2085,8 +2085,22 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 
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

