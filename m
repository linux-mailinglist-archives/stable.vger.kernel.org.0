Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7246D11AF5C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731253AbfLKPMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731247AbfLKPMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D03924681;
        Wed, 11 Dec 2019 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077172;
        bh=ziHd0qwLt1CVoQnQwHS/GZeFprg96768/sHE5CZAjPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOgHLnETcOln1S0IoBPv1WoItLd07F0aM2ASat8ap5pBuW4TZC93Y5l7PSUSZ1akM
         3dH2VsEk3ia9oDbNeO/hAyf1XoyWQZhDlJmkCfst8vGUW7pVMDylX2p1Ln+A+C4DwM
         HC7U0FEpsVPFucZdzaQpRI9AgZOXZ9LEsaQp7yHo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Will Deacon <will@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 057/134] iommu/arm-smmu-v3: Don't display an error when IRQ lines are missing
Date:   Wed, 11 Dec 2019 10:10:33 -0500
Message-Id: <20191211151150.19073-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit f7aff1a93f52047739af31072de0ad8d149641f3 ]

Since commit 7723f4c5ecdb ("driver core: platform: Add an error message
to platform_get_irq*()"), platform_get_irq_byname() displays an error
when the IRQ isn't found. Since the SMMUv3 driver uses that function to
query which interrupt method is available, the message is now displayed
during boot for any SMMUv3 that doesn't implement the combined
interrupt, or that implements MSIs.

[   20.700337] arm-smmu-v3 arm-smmu-v3.7.auto: IRQ combined not found
[   20.706508] arm-smmu-v3 arm-smmu-v3.7.auto: IRQ eventq not found
[   20.712503] arm-smmu-v3 arm-smmu-v3.7.auto: IRQ priq not found
[   20.718325] arm-smmu-v3 arm-smmu-v3.7.auto: IRQ gerror not found

Use platform_get_irq_byname_optional() to avoid displaying a spurious
error.

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm-smmu-v3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 8da93e730d6fd..ed90361b84dc7 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3611,19 +3611,19 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 
 	/* Interrupt lines */
 
-	irq = platform_get_irq_byname(pdev, "combined");
+	irq = platform_get_irq_byname_optional(pdev, "combined");
 	if (irq > 0)
 		smmu->combined_irq = irq;
 	else {
-		irq = platform_get_irq_byname(pdev, "eventq");
+		irq = platform_get_irq_byname_optional(pdev, "eventq");
 		if (irq > 0)
 			smmu->evtq.q.irq = irq;
 
-		irq = platform_get_irq_byname(pdev, "priq");
+		irq = platform_get_irq_byname_optional(pdev, "priq");
 		if (irq > 0)
 			smmu->priq.q.irq = irq;
 
-		irq = platform_get_irq_byname(pdev, "gerror");
+		irq = platform_get_irq_byname_optional(pdev, "gerror");
 		if (irq > 0)
 			smmu->gerr_irq = irq;
 	}
-- 
2.20.1

