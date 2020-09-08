Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC6C26189C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732208AbgIHR6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731565AbgIHQMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7822A24890;
        Tue,  8 Sep 2020 15:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580338;
        bh=woD0s/c+KQ9dldAxsGjx8OIeX9K9as3mRw1U7kI2VXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaXhWCk5J4dT+eWh8eFnmKdzz7vaA935Bh51aqu4Zr0BGdUcN2dfbfoBquDeY73j0
         NL6Zo+n3KTaXyyNnUlVDCIis9xiAJq7SYZfganIZSY+m8FtpXJlrS21t21lv6pGQtV
         YsB3+pwVWwjB7rI56BYp+6ENrtug2pfu3NtNH6wI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/65] iommu/vt-d: Serialize IOMMU GCMD register modifications
Date:   Tue,  8 Sep 2020 17:26:20 +0200
Message-Id: <20200908152218.853442226@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
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
index 7cc5b04e30b7a..09c6b17aaf80e 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -479,12 +479,18 @@ static void iommu_enable_irq_remapping(struct intel_iommu *iommu)
 
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



