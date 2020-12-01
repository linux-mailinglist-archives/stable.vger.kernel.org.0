Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA522C9B71
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389234AbgLAJI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389224AbgLAJI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E40B920656;
        Tue,  1 Dec 2020 09:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813690;
        bh=U4DM5UEjmLYd3d1w/doEcRmwgiqhXB+Fp4BzzWtfBfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrUsUf/w7Sd9rIsF0yBSAhOBiUICNxnrZ4vvFwzBWuUGbJ6iO19AvzkZx20yspNjr
         D0ajQ9550xonoR/CYsks3vBaTgW1/TfYyU5drrntfUKnMztzhpA4a0Ac22WetQl9A5
         kcJ4wjfAwyRYY3VBworJQ17P0RV2Bnw6kECVnr+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Liu Yi L <yi.l.liu@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.9 026/152] iommu/vt-d: Dont read VCCAP register unless it exists
Date:   Tue,  1 Dec 2020 09:52:21 +0100
Message-Id: <20201201084715.313869297@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit d76b42e92780c3587c1a998a3a943b501c137553 upstream.

My virtual IOMMU implementation is whining that the guest is reading a
register that doesn't exist. Only read the VCCAP_REG if the corresponding
capability is set in ECAP_REG to indicate that it actually exists.

Fixes: 3375303e8287 ("iommu/vt-d: Add custom allocator for IOASID")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Cc: stable@vger.kernel.org # v5.7+
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/de32b150ffaa752e0cff8571b17dfb1213fbe71c.camel@infradead.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel/dmar.c  |    3 ++-
 drivers/iommu/intel/iommu.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -964,7 +964,8 @@ static int map_iommu(struct intel_iommu
 		warn_invalid_dmar(phys_addr, " returns all ones");
 		goto unmap;
 	}
-	iommu->vccap = dmar_readq(iommu->reg + DMAR_VCCAP_REG);
+	if (ecap_vcs(iommu->ecap))
+		iommu->vccap = dmar_readq(iommu->reg + DMAR_VCCAP_REG);
 
 	/* the registers might be more than one page */
 	map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1798,7 +1798,7 @@ static void free_dmar_iommu(struct intel
 		if (ecap_prs(iommu->ecap))
 			intel_svm_finish_prq(iommu);
 	}
-	if (ecap_vcs(iommu->ecap) && vccap_pasid(iommu->vccap))
+	if (vccap_pasid(iommu->vccap))
 		ioasid_unregister_allocator(&iommu->pasid_allocator);
 
 #endif
@@ -3177,7 +3177,7 @@ static void register_pasid_allocator(str
 	 * is active. All vIOMMU allocators will eventually be calling the same
 	 * host allocator.
 	 */
-	if (!ecap_vcs(iommu->ecap) || !vccap_pasid(iommu->vccap))
+	if (!vccap_pasid(iommu->vccap))
 		return;
 
 	pr_info("Register custom PASID allocator\n");


