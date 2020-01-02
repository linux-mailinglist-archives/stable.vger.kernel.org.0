Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A08912F141
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgABWOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgABWOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDD9721D7D;
        Thu,  2 Jan 2020 22:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003275;
        bh=so39Ko76CscwU0RY7P3cb4mHUdASxpwyjcuzILbe+Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9rB8JOBJFRusT+6HZcPrUSndMhDBwzri2rJggm/fiyeeGAeaZPXx8b5eNlJKmQJ2
         T/PKzqUwn2v7u1Hr4eJjwXBobfkmihbLA5PRcU4zP6+DrNcdirmLvMqKm3vC7w5xgG
         JA4Be+oDdt+em7sFNcNqlJnrGy8iBpwKZGzsBtms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Will Deacon <will@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/191] iommu/arm-smmu-v3: Dont display an error when IRQ lines are missing
Date:   Thu,  2 Jan 2020 23:05:39 +0100
Message-Id: <20200102215836.018899179@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8da93e730d6f..ed90361b84dc 100644
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



