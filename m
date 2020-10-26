Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5005B2986E3
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 07:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770461AbgJZGhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 02:37:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:24792 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390463AbgJZGhY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 02:37:24 -0400
IronPort-SDR: Tw2/HQqoZqI+8tqBnfifgYHi6I/YBFKC2AB5kaG47m67Vt7NHTZvFVjLbuxGx3tQx0Qn+QSad3
 swtbq2CBk/UQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9785"; a="229517714"
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="229517714"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2020 23:37:16 -0700
IronPort-SDR: SW9PSpgPrR3cfwI9V9M3hmjSSYsReY583gF9oKzRSJl5lHUHtDDnf1ZzfEfmKPlvb5nB2QesdY
 JTztsEr6wmxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="350001157"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 25 Oct 2020 23:37:12 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] iommu: Fix deferred domain attachment in iommu_probe_device()
Date:   Mon, 26 Oct 2020 14:30:08 +0800
Message-Id: <20201026063008.24849-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The IOMMU core has support for deferring the attachment of default domain
to device. Fix a missed deferred attaching check in iommu_probe_device().

Fixes: cf193888bfbd3 ("iommu: Move new probe_device path to separate function")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 6d847027d35e..690abf60239d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -93,6 +93,8 @@ static void __iommu_detach_group(struct iommu_domain *domain,
 static int iommu_create_device_direct_mappings(struct iommu_group *group,
 					       struct device *dev);
 static struct iommu_group *iommu_group_get_for_dev(struct device *dev);
+static bool iommu_is_attach_deferred(struct iommu_domain *domain,
+				     struct device *dev);
 
 #define IOMMU_GROUP_ATTR(_name, _mode, _show, _store)		\
 struct iommu_group_attribute iommu_group_attr_##_name =		\
@@ -264,7 +266,8 @@ int iommu_probe_device(struct device *dev)
 	 */
 	iommu_alloc_default_domain(group, dev);
 
-	if (group->default_domain)
+	if (group->default_domain &&
+	    !iommu_is_attach_deferred(group->default_domain, dev))
 		ret = __iommu_attach_device(group->default_domain, dev);
 
 	iommu_create_device_direct_mappings(group, dev);
-- 
2.17.1

