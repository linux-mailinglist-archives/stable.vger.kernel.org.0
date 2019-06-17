Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AC5493E2
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfFQVYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729954AbfFQVYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FED821019;
        Mon, 17 Jun 2019 21:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806675;
        bh=/OoeYX4BnKXFt36txqAKdXO7B9CybLfnPWdIEhSqQ3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prcKMK3elRc2KsKld1yTl5s6fV0O5p9EmK2ZmtdoeGeDElnl+cVK3nU+6hqEyLu0S
         opaFxA83CIT9vyer1Wf9OWxUEuSlAVzr0w9dAvBFciQS40czfJtwkrK3VkQ7DJTSlt
         nauE05FssOnZ93ft9eql1fWokgatNNoNBmW432TA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno <kholk11@gmail.com>,
        Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 19/75] iommu/arm-smmu: Avoid constant zero in TLBI writes
Date:   Mon, 17 Jun 2019 23:09:30 +0200
Message-Id: <20190617210753.598203710@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 4e4abae311e4b44aaf61f18a826fd7136037f199 upstream.

Apparently, some Qualcomm arm64 platforms which appear to expose their
SMMU global register space are still, in fact, using a hypervisor to
mediate it by trapping and emulating register accesses. Sadly, some
deployed versions of said trapping code have bugs wherein they go
horribly wrong for stores using r31 (i.e. XZR/WZR) as the source
register.

While this can be mitigated for GCC today by tweaking the constraints
for the implementation of writel_relaxed(), to avoid any potential
arms race with future compilers more aggressively optimising register
allocation, the simple way is to just remove all the problematic
constant zeros. For the write-only TLB operations, the actual value is
irrelevant anyway and any old nearby variable will provide a suitable
GPR to encode. The one point at which we really do need a zero to clear
a context bank happens before any of the TLB maintenance where crashes
have been reported, so is apparently not a problem... :/

Reported-by: AngeloGioacchino Del Regno <kholk11@gmail.com>
Tested-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/arm-smmu.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -56,6 +56,15 @@
 #include "io-pgtable.h"
 #include "arm-smmu-regs.h"
 
+/*
+ * Apparently, some Qualcomm arm64 platforms which appear to expose their SMMU
+ * global register space are still, in fact, using a hypervisor to mediate it
+ * by trapping and emulating register accesses. Sadly, some deployed versions
+ * of said trapping code have bugs wherein they go horribly wrong for stores
+ * using r31 (i.e. XZR/WZR) as the source register.
+ */
+#define QCOM_DUMMY_VAL -1
+
 #define ARM_MMU500_ACTLR_CPRE		(1 << 1)
 
 #define ARM_MMU500_ACR_CACHE_LOCK	(1 << 26)
@@ -398,7 +407,7 @@ static void __arm_smmu_tlb_sync(struct a
 {
 	unsigned int spin_cnt, delay;
 
-	writel_relaxed(0, sync);
+	writel_relaxed(QCOM_DUMMY_VAL, sync);
 	for (delay = 1; delay < TLB_LOOP_TIMEOUT; delay *= 2) {
 		for (spin_cnt = TLB_SPIN_COUNT; spin_cnt > 0; spin_cnt--) {
 			if (!(readl_relaxed(status) & sTLBGSTATUS_GSACTIVE))
@@ -1637,8 +1646,8 @@ static void arm_smmu_device_reset(struct
 	}
 
 	/* Invalidate the TLB, just in case */
-	writel_relaxed(0, gr0_base + ARM_SMMU_GR0_TLBIALLH);
-	writel_relaxed(0, gr0_base + ARM_SMMU_GR0_TLBIALLNSNH);
+	writel_relaxed(QCOM_DUMMY_VAL, gr0_base + ARM_SMMU_GR0_TLBIALLH);
+	writel_relaxed(QCOM_DUMMY_VAL, gr0_base + ARM_SMMU_GR0_TLBIALLNSNH);
 
 	reg = readl_relaxed(ARM_SMMU_GR0_NS(smmu) + ARM_SMMU_GR0_sCR0);
 


