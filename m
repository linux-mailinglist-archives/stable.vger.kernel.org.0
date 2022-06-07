Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF4854157F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376489AbiFGUgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377871AbiFGUef (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0E217F83F;
        Tue,  7 Jun 2022 11:36:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5998612EC;
        Tue,  7 Jun 2022 18:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BB3C385A5;
        Tue,  7 Jun 2022 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626981;
        bh=V8zQMeizzlQM2ionAW36kj7IZ1XDcoJOFzKYShixbEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uASMCxqeKtwWRTJzqRbgtgRyFAd/WwL7gOabDQsM55iVUZPOQY/a+K4Gf3z50k5bV
         nG0RbaOWlg09WENvLdb7cIMpskYL6R5SWoj0TDbRDCRoDv+0OXnzwHXue3WutG1a6S
         grqqiBIK7JV42lCt2HcACTGT6ewUaF4p5SpE5O74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 575/772] iommu/arm-smmu-v3-sva: Fix mm use-after-free
Date:   Tue,  7 Jun 2022 19:02:47 +0200
Message-Id: <20220607165005.895912599@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit cbd23144f7662b00bcde32a938c4a4057e476d68 ]

We currently call arm64_mm_context_put() without holding a reference to
the mm, which can result in use-after-free. Call mmgrab()/mmdrop() to
ensure the mm only gets freed after we unpinned the ASID.

Fixes: 32784a9562fb ("iommu/arm-smmu-v3: Implement iommu_sva_bind/unbind()")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Link: https://lore.kernel.org/r/20220426130444.300556-1-jean-philippe@linaro.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index f9e9b4fb78bd..b69161f2e0c0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -6,6 +6,7 @@
 #include <linux/mm.h>
 #include <linux/mmu_context.h>
 #include <linux/mmu_notifier.h>
+#include <linux/sched/mm.h>
 #include <linux/slab.h>
 
 #include "arm-smmu-v3.h"
@@ -96,9 +97,14 @@ static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_ctx_desc *ret = NULL;
 
+	/* Don't free the mm until we release the ASID */
+	mmgrab(mm);
+
 	asid = arm64_mm_context_get(mm);
-	if (!asid)
-		return ERR_PTR(-ESRCH);
+	if (!asid) {
+		err = -ESRCH;
+		goto out_drop_mm;
+	}
 
 	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
 	if (!cd) {
@@ -165,6 +171,8 @@ static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 	kfree(cd);
 out_put_context:
 	arm64_mm_context_put(mm);
+out_drop_mm:
+	mmdrop(mm);
 	return err < 0 ? ERR_PTR(err) : ret;
 }
 
@@ -173,6 +181,7 @@ static void arm_smmu_free_shared_cd(struct arm_smmu_ctx_desc *cd)
 	if (arm_smmu_free_asid(cd)) {
 		/* Unpin ASID */
 		arm64_mm_context_put(cd->mm);
+		mmdrop(cd->mm);
 		kfree(cd);
 	}
 }
-- 
2.35.1



