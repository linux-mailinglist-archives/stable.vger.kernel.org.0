Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31ADF147D14
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388573AbgAXJ4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387443AbgAXJ4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:56:48 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2761A20709;
        Fri, 24 Jan 2020 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859807;
        bh=aE+/WAqAvaIwFkmPN5lAVIbMJGoVUx0+tTKeKMzyZyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kehavfmdcv9V3Zi8QdwcGKAYH28Ksi341zuWVfQkTNnJIeTKD9kVzAPCcG47Wvf2t
         wR7sDTx2WNjmXF0yW0dvS5c608o9T2klX3tmRsSncRBsYcR+VfkTzy3yJnIJRjTkxm
         wzyPGHtljfmjCYM6X01rd/WDaIndbDVcx1OrCjTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 187/343] iommu/vt-d: Make kernel parameter igfx_off work with vIOMMU
Date:   Fri, 24 Jan 2020 10:30:05 +0100
Message-Id: <20200124092944.601613484@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 5daab58043ee2bca861068e2595564828f3bc663 ]

The kernel parameter igfx_off is used by users to disable
DMA remapping for the Intel integrated graphic device. It
was designed for bare metal cases where a dedicated IOMMU
is used for graphic. This doesn't apply to virtual IOMMU
case where an include-all IOMMU is used.  This makes the
kernel parameter work with virtual IOMMU as well.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Fixes: c0771df8d5297 ("intel-iommu: Export a flag indicating that the IOMMU is used for iGFX.")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 523d0889c2a4e..4fbd183d973ab 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3361,9 +3361,12 @@ static int __init init_dmars(void)
 		iommu_identity_mapping |= IDENTMAP_ALL;
 
 #ifdef CONFIG_INTEL_IOMMU_BROKEN_GFX_WA
-	iommu_identity_mapping |= IDENTMAP_GFX;
+	dmar_map_gfx = 0;
 #endif
 
+	if (!dmar_map_gfx)
+		iommu_identity_mapping |= IDENTMAP_GFX;
+
 	check_tylersburg_isoch();
 
 	if (iommu_identity_mapping) {
-- 
2.20.1



