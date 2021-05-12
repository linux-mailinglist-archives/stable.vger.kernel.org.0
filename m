Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CEA37CE28
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhELRD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244221AbhELQmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3E7261CAC;
        Wed, 12 May 2021 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835900;
        bh=82GIn4amv/A0EWE6fXs7TcI8A216q1f4D+kq0d9Prrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMecXKxa7WRiWLrUY2zK9gT/SFyOJimuA/KAIiSQt9h15szWlzGPSwVl2pb2SXFsF
         CosGF9/PGm8BPod6Mrt/pN7h76niKfyPVLTdLaeIM/e7EhykjGRtWSopxGTxE1mJcu
         HHQ9xpVjZDcBliTzDbQK60kmp/mNqmC4NnuIiO+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 494/677] iommu/vt-d: Report the right page fault address
Date:   Wed, 12 May 2021 16:49:00 +0200
Message-Id: <20210512144853.797596198@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 547a6cf57057..ecb6314fdd5c 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -862,7 +862,7 @@ intel_svm_prq_report(struct device *dev, struct page_req_dsc *desc)
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



