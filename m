Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6565499B4A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575022AbiAXVuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458141AbiAXVmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1316C07A953;
        Mon, 24 Jan 2022 12:30:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8288B61383;
        Mon, 24 Jan 2022 20:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5BCC340E5;
        Mon, 24 Jan 2022 20:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056244;
        bh=lHp066GqEuWHuPWqIDH4N1W547qnHtwjWomtPz60+2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6y2vvacceplFWuIxh5IRUeUNeTDzhC4LfmpY4FzifwCsvSogPnQ3BLfMKxv4VZ83
         n2zsw44Tq7DVbVgAGQ/DC8+X9wnNI8iUfuztlyhqVE1mVnBF0s5htSRENGub5s2dnz
         uhxEsiooxjySBoEZqNZQ+k+3aBjn7MJilQAeKANw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 419/846] iommu/amd: Restore GA log/tail pointer on host resume
Date:   Mon, 24 Jan 2022 19:38:56 +0100
Message-Id: <20220124184115.426600618@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit a8d4a37d1bb93608501d0d0545f902061152669a ]

This will give IOMMU GA log a chance to work after resume
from s3/s4.

Fixes: 8bda0cfbdc1a6 ("iommu/amd: Detect and initialize guest vAPIC log")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20211123161038.48009-2-mlevitsk@redhat.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 2a822b229bd05..9b12a2f7548ac 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -804,16 +804,27 @@ static int iommu_ga_log_enable(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
 	u32 status, i;
+	u64 entry;
 
 	if (!iommu->ga_log)
 		return -EINVAL;
 
-	status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
-
 	/* Check if already running */
-	if (status & (MMIO_STATUS_GALOG_RUN_MASK))
+	status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+	if (WARN_ON(status & (MMIO_STATUS_GALOG_RUN_MASK)))
 		return 0;
 
+	entry = iommu_virt_to_phys(iommu->ga_log) | GA_LOG_SIZE_512;
+	memcpy_toio(iommu->mmio_base + MMIO_GA_LOG_BASE_OFFSET,
+		    &entry, sizeof(entry));
+	entry = (iommu_virt_to_phys(iommu->ga_log_tail) &
+		 (BIT_ULL(52)-1)) & ~7ULL;
+	memcpy_toio(iommu->mmio_base + MMIO_GA_LOG_TAIL_OFFSET,
+		    &entry, sizeof(entry));
+	writel(0x00, iommu->mmio_base + MMIO_GA_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_GA_TAIL_OFFSET);
+
+
 	iommu_feature_enable(iommu, CONTROL_GAINT_EN);
 	iommu_feature_enable(iommu, CONTROL_GALOG_EN);
 
@@ -823,7 +834,7 @@ static int iommu_ga_log_enable(struct amd_iommu *iommu)
 			break;
 	}
 
-	if (i >= LOOP_TIMEOUT)
+	if (WARN_ON(i >= LOOP_TIMEOUT))
 		return -EINVAL;
 #endif /* CONFIG_IRQ_REMAP */
 	return 0;
@@ -832,8 +843,6 @@ static int iommu_ga_log_enable(struct amd_iommu *iommu)
 static int iommu_init_ga_log(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
-	u64 entry;
-
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
 		return 0;
 
@@ -847,16 +856,6 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 	if (!iommu->ga_log_tail)
 		goto err_out;
 
-	entry = iommu_virt_to_phys(iommu->ga_log) | GA_LOG_SIZE_512;
-	memcpy_toio(iommu->mmio_base + MMIO_GA_LOG_BASE_OFFSET,
-		    &entry, sizeof(entry));
-	entry = (iommu_virt_to_phys(iommu->ga_log_tail) &
-		 (BIT_ULL(52)-1)) & ~7ULL;
-	memcpy_toio(iommu->mmio_base + MMIO_GA_LOG_TAIL_OFFSET,
-		    &entry, sizeof(entry));
-	writel(0x00, iommu->mmio_base + MMIO_GA_HEAD_OFFSET);
-	writel(0x00, iommu->mmio_base + MMIO_GA_TAIL_OFFSET);
-
 	return 0;
 err_out:
 	free_ga_log(iommu);
-- 
2.34.1



