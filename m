Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756A830CBDA
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbhBBThQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:37:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233167AbhBBN4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99B8964F65;
        Tue,  2 Feb 2021 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273499;
        bh=YxGFlF6SpAQUAlzuQPlGWdwibyY6rby2gQVkguphQJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5js5vSP+gMV1/NSazVCFVCgLkbk3ZWQd3GWSsLihZvs/6IvV21KZ5/XG++NwRG8j
         NkYaVL5/oIWa+ndGrEif4+7dr7ATCUd5w/TRrRoXc1cy7BhfD0VZeUf1XOUVCV8yp1
         5/2fFoHLN5af2Xym4y1xBVp7xrGe4EHktUVYmH/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        Guo Kaijie <Kaijie.Guo@intel.com>
Subject: [PATCH 5.10 129/142] iommu/vt-d: Correctly check addr alignment in qi_flush_dev_iotlb_pasid()
Date:   Tue,  2 Feb 2021 14:38:12 +0100
Message-Id: <20210202133003.020070161@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 494b3688bb11a21af12e92a344a1313486693d47 ]

An incorrect address mask is being used in the qi_flush_dev_iotlb_pasid()
to check the address alignment. This leads to a lot of spurious kernel
warnings:

[  485.837093] DMAR: Invalidate non-aligned address 7f76f47f9000, order 0
[  485.837098] DMAR: Invalidate non-aligned address 7f76f47f9000, order 0
[  492.494145] qi_flush_dev_iotlb_pasid: 5734 callbacks suppressed
[  492.494147] DMAR: Invalidate non-aligned address 7f7728800000, order 11
[  492.508965] DMAR: Invalidate non-aligned address 7f7728800000, order 11

Fix it by checking the alignment in right way.

Fixes: 288d08e780088 ("iommu/vt-d: Handle non-page aligned address")
Reported-and-tested-by: Guo Kaijie <Kaijie.Guo@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Liu Yi L <yi.l.liu@intel.com>
Link: https://lore.kernel.org/r/20210119043500.1539596-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 004feaed3c72c..02e7c10a4224b 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1496,7 +1496,7 @@ void qi_flush_dev_iotlb_pasid(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 	 * Max Invs Pending (MIP) is set to 0 for now until we have DIT in
 	 * ECAP.
 	 */
-	if (addr & GENMASK_ULL(size_order + VTD_PAGE_SHIFT, 0))
+	if (!IS_ALIGNED(addr, VTD_PAGE_SIZE << size_order))
 		pr_warn_ratelimited("Invalidate non-aligned address %llx, order %d\n",
 				    addr, size_order);
 
-- 
2.27.0



