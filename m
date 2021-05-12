Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D6837C9BD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhELQVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239976AbhELQQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FA2061D64;
        Wed, 12 May 2021 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834180;
        bh=dB/NnrlTJp2ohdNhdlVc3Z2YiSmthIDPHKH8GTisx94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TASAYMzyHnLHWHYQjXUfqub4JOa42Sf5AJKkJjNdzlUAGI6TuWeEo8Tb2Lce6owY
         xcZ8vbvS3StHLVHFuts8fyuzzxJKSaT06Ynapyx5Ht9x91HWcOekyA64qjZSVLc3Ek
         THQywwKixjCaGObnsKvJqM4BQWi2knRDK4AZEaq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 439/601] iommu/vt-d: Report the right page fault address
Date:   Wed, 12 May 2021 16:48:36 +0200
Message-Id: <20210512144842.298512566@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 03d205094af45bca4f8e0498c461a893aa3ec6d9 ]

The Address field of the Page Request Descriptor only keeps bit [63:12]
of the offending address. Convert it to a full address before reporting
it to device drivers.

Fixes: eb8d93ea3c1d3 ("iommu/vt-d: Report page request faults for guest SVA")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210320025415.641201-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index ac86509a0a73..4260bb089b2c 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -899,7 +899,7 @@ intel_svm_prq_report(struct device *dev, struct page_req_dsc *desc)
 	/* Fill in event data for device specific processing */
 	memset(&event, 0, sizeof(struct iommu_fault_event));
 	event.fault.type = IOMMU_FAULT_PAGE_REQ;
-	event.fault.prm.addr = desc->addr;
+	event.fault.prm.addr = (u64)desc->addr << VTD_PAGE_SHIFT;
 	event.fault.prm.pasid = desc->pasid;
 	event.fault.prm.grpid = desc->prg_index;
 	event.fault.prm.perm = prq_to_iommu_prot(desc);
-- 
2.30.2



