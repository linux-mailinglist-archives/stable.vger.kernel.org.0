Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4AE2613C7
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 17:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgIHPtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 11:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbgIHPt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FC5624834;
        Tue,  8 Sep 2020 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579872;
        bh=J9FPxSeDJRQW9rI2ktIJjNLgiwVam06bvp+vY+xw60U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWoL67bnSa818wm0PfMDEsGNqi3fSZc8Bh9xb0iSocv+ClVX9p04QctMG3igncAwx
         1AYbVn38ZLgzXpeUxdwn5Jlx/HlJgsFM1I+AkqB8Gox5FRl7cOXNc+mD568jy5hqju
         fzIHFcwh2K+9a05scU6+LyL9ig2YPGHbPMT1CZL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/129] iommu/vt-d: Serialize IOMMU GCMD register modifications
Date:   Tue,  8 Sep 2020 17:25:08 +0200
Message-Id: <20200908152233.045852216@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 6e4e9ec65078093165463c13d4eb92b3e8d7b2e8 ]

The VT-d spec requires (10.4.4 Global Command Register, GCMD_REG General
Description) that:

If multiple control fields in this register need to be modified, software
must serialize the modifications through multiple writes to this register.

However, in irq_remapping.c, modifications of IRE and CFI are done in one
write. We need to do two separate writes with STS checking after each. It
also checks the status register before writing command register to avoid
unnecessary register write.

Fixes: af8d102f999a4 ("x86/intel/irq_remapping: Clean up x2apic opt-out security warning mess")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Link: https://lore.kernel.org/r/20200828000615.8281-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel_irq_remapping.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 6bfb283e6f287..f697f3a1d46bc 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -507,12 +507,18 @@ static void iommu_enable_irq_remapping(struct intel_iommu *iommu)
 
 	/* Enable interrupt-remapping */
 	iommu->gcmd |= DMA_GCMD_IRE;
-	iommu->gcmd &= ~DMA_GCMD_CFI;  /* Block compatibility-format MSIs */
 	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
-
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_IRES), sts);
 
+	/* Block compatibility-format MSIs */
+	if (sts & DMA_GSTS_CFIS) {
+		iommu->gcmd &= ~DMA_GCMD_CFI;
+		writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
+		IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
+			      readl, !(sts & DMA_GSTS_CFIS), sts);
+	}
+
 	/*
 	 * With CFI clear in the Global Command register, we should be
 	 * protected from dangerous (i.e. compatibility) interrupts
-- 
2.25.1



