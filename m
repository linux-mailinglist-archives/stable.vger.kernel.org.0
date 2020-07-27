Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC92022F054
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbgG0OXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732106AbgG0OXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236642075A;
        Mon, 27 Jul 2020 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859818;
        bh=FUp0VNab1O9xEaaJWh2nIEeHUfPjHwqXSlJBT8VPvsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3caCyfGYa9YlP2j5Q4UutqfK/GvxSzmo4mpfJa6Z38fn9zyZ7+jH0s0lnE1eHuGr
         FrdWTn2kLXdxqc0FJ5KkHx7t0bO/1SeeTEiJlGF83h9Mtd50Cfg9q/PgRnZFn2FQ05
         +QMita0PiwpM/+ORlnHk2dUuliyfzA40tKrwEkNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 087/179] iommu/qcom: Use domain rather than dev as tlb cookie
Date:   Mon, 27 Jul 2020 16:04:22 +0200
Message-Id: <20200727134936.918578591@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 1014a2f8d76b05e0f228dd097ac1a249c5934232 ]

The device may be torn down, but the domain should still be valid.  Lets
use that as the tlb flush ops cookie.

Fixes a problem reported in [1]

[1] https://lkml.org/lkml/2020/7/20/104

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 09b5dfff9ad6 ("iommu/qcom: Use accessor functions for iommu private data")
Link: https://lore.kernel.org/r/20200720155217.274994-1-robdclark@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/qcom_iommu.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/qcom_iommu.c b/drivers/iommu/qcom_iommu.c
index 5b3b270972f80..c6277d7398f30 100644
--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -65,6 +65,7 @@ struct qcom_iommu_domain {
 	struct mutex		 init_mutex; /* Protects iommu pointer */
 	struct iommu_domain	 domain;
 	struct qcom_iommu_dev	*iommu;
+	struct iommu_fwspec	*fwspec;
 };
 
 static struct qcom_iommu_domain *to_qcom_iommu_domain(struct iommu_domain *dom)
@@ -84,9 +85,9 @@ static struct qcom_iommu_dev * to_iommu(struct device *dev)
 	return dev_iommu_priv_get(dev);
 }
 
-static struct qcom_iommu_ctx * to_ctx(struct device *dev, unsigned asid)
+static struct qcom_iommu_ctx * to_ctx(struct qcom_iommu_domain *d, unsigned asid)
 {
-	struct qcom_iommu_dev *qcom_iommu = to_iommu(dev);
+	struct qcom_iommu_dev *qcom_iommu = d->iommu;
 	if (!qcom_iommu)
 		return NULL;
 	return qcom_iommu->ctxs[asid - 1];
@@ -118,14 +119,12 @@ iommu_readq(struct qcom_iommu_ctx *ctx, unsigned reg)
 
 static void qcom_iommu_tlb_sync(void *cookie)
 {
-	struct iommu_fwspec *fwspec;
-	struct device *dev = cookie;
+	struct qcom_iommu_domain *qcom_domain = cookie;
+	struct iommu_fwspec *fwspec = qcom_domain->fwspec;
 	unsigned i;
 
-	fwspec = dev_iommu_fwspec_get(dev);
-
 	for (i = 0; i < fwspec->num_ids; i++) {
-		struct qcom_iommu_ctx *ctx = to_ctx(dev, fwspec->ids[i]);
+		struct qcom_iommu_ctx *ctx = to_ctx(qcom_domain, fwspec->ids[i]);
 		unsigned int val, ret;
 
 		iommu_writel(ctx, ARM_SMMU_CB_TLBSYNC, 0);
@@ -139,14 +138,12 @@ static void qcom_iommu_tlb_sync(void *cookie)
 
 static void qcom_iommu_tlb_inv_context(void *cookie)
 {
-	struct device *dev = cookie;
-	struct iommu_fwspec *fwspec;
+	struct qcom_iommu_domain *qcom_domain = cookie;
+	struct iommu_fwspec *fwspec = qcom_domain->fwspec;
 	unsigned i;
 
-	fwspec = dev_iommu_fwspec_get(dev);
-
 	for (i = 0; i < fwspec->num_ids; i++) {
-		struct qcom_iommu_ctx *ctx = to_ctx(dev, fwspec->ids[i]);
+		struct qcom_iommu_ctx *ctx = to_ctx(qcom_domain, fwspec->ids[i]);
 		iommu_writel(ctx, ARM_SMMU_CB_S1_TLBIASID, ctx->asid);
 	}
 
@@ -156,16 +153,14 @@ static void qcom_iommu_tlb_inv_context(void *cookie)
 static void qcom_iommu_tlb_inv_range_nosync(unsigned long iova, size_t size,
 					    size_t granule, bool leaf, void *cookie)
 {
-	struct device *dev = cookie;
-	struct iommu_fwspec *fwspec;
+	struct qcom_iommu_domain *qcom_domain = cookie;
+	struct iommu_fwspec *fwspec = qcom_domain->fwspec;
 	unsigned i, reg;
 
 	reg = leaf ? ARM_SMMU_CB_S1_TLBIVAL : ARM_SMMU_CB_S1_TLBIVA;
 
-	fwspec = dev_iommu_fwspec_get(dev);
-
 	for (i = 0; i < fwspec->num_ids; i++) {
-		struct qcom_iommu_ctx *ctx = to_ctx(dev, fwspec->ids[i]);
+		struct qcom_iommu_ctx *ctx = to_ctx(qcom_domain, fwspec->ids[i]);
 		size_t s = size;
 
 		iova = (iova >> 12) << 12;
@@ -256,7 +251,9 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
 	};
 
 	qcom_domain->iommu = qcom_iommu;
-	pgtbl_ops = alloc_io_pgtable_ops(ARM_32_LPAE_S1, &pgtbl_cfg, dev);
+	qcom_domain->fwspec = fwspec;
+
+	pgtbl_ops = alloc_io_pgtable_ops(ARM_32_LPAE_S1, &pgtbl_cfg, qcom_domain);
 	if (!pgtbl_ops) {
 		dev_err(qcom_iommu->dev, "failed to allocate pagetable ops\n");
 		ret = -ENOMEM;
@@ -269,7 +266,7 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
 	domain->geometry.force_aperture = true;
 
 	for (i = 0; i < fwspec->num_ids; i++) {
-		struct qcom_iommu_ctx *ctx = to_ctx(dev, fwspec->ids[i]);
+		struct qcom_iommu_ctx *ctx = to_ctx(qcom_domain, fwspec->ids[i]);
 
 		if (!ctx->secure_init) {
 			ret = qcom_scm_restore_sec_cfg(qcom_iommu->sec_id, ctx->asid);
@@ -419,7 +416,7 @@ static void qcom_iommu_detach_dev(struct iommu_domain *domain, struct device *de
 
 	pm_runtime_get_sync(qcom_iommu->dev);
 	for (i = 0; i < fwspec->num_ids; i++) {
-		struct qcom_iommu_ctx *ctx = to_ctx(dev, fwspec->ids[i]);
+		struct qcom_iommu_ctx *ctx = to_ctx(qcom_domain, fwspec->ids[i]);
 
 		/* Disable the context bank: */
 		iommu_writel(ctx, ARM_SMMU_CB_SCTLR, 0);
-- 
2.25.1



