Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46656172021
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbgB0Nwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbgB0Nwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:52:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96D620801;
        Thu, 27 Feb 2020 13:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811574;
        bh=h/4mVMWaw2Epkvs+NzKW1PIecgYyuL+JXn5Pv45vFyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwKbOCw4aD2Nz07tPAjMXSmr+r3jkhD979rsV3NqsKdI0HK9sUPQ4zB+UeF6Bw+7r
         ZvWdbxhB16+vASqotjMBROo3s6770awWQcyllWqfAVJ8tDl742MGqYTptO4QTTQUzE
         o4piOtotG0eIady/2Nd4lQKOCZ3CpVHeGmQdFP1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.14 002/237] iommu/qcom: Fix bogus detach logic
Date:   Thu, 27 Feb 2020 14:33:36 +0100
Message-Id: <20200227132255.626960493@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit faf305c51aeabd1ea2d7131e798ef5f55f4a7750 upstream.

Currently, the implementation of qcom_iommu_domain_free() is guaranteed
to do one of two things: WARN() and leak everything, or dereference NULL
and crash. That alone is terrible, but in fact the whole idea of trying
to track the liveness of a domain via the qcom_domain->iommu pointer as
a sanity check is full of fundamentally flawed assumptions. Make things
robust and actually functional by not trying to be quite so clever.

Reported-by: Brian Masney <masneyb@onstation.org>
Tested-by: Brian Masney <masneyb@onstation.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 0ae349a0f33f ("iommu/qcom: Add qcom_iommu")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/qcom_iommu.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -327,21 +327,19 @@ static void qcom_iommu_domain_free(struc
 {
 	struct qcom_iommu_domain *qcom_domain = to_qcom_iommu_domain(domain);
 
-	if (WARN_ON(qcom_domain->iommu))    /* forgot to detach? */
-		return;
-
 	iommu_put_dma_cookie(domain);
 
-	/* NOTE: unmap can be called after client device is powered off,
-	 * for example, with GPUs or anything involving dma-buf.  So we
-	 * cannot rely on the device_link.  Make sure the IOMMU is on to
-	 * avoid unclocked accesses in the TLB inv path:
-	 */
-	pm_runtime_get_sync(qcom_domain->iommu->dev);
-
-	free_io_pgtable_ops(qcom_domain->pgtbl_ops);
-
-	pm_runtime_put_sync(qcom_domain->iommu->dev);
+	if (qcom_domain->iommu) {
+		/*
+		 * NOTE: unmap can be called after client device is powered
+		 * off, for example, with GPUs or anything involving dma-buf.
+		 * So we cannot rely on the device_link.  Make sure the IOMMU
+		 * is on to avoid unclocked accesses in the TLB inv path:
+		 */
+		pm_runtime_get_sync(qcom_domain->iommu->dev);
+		free_io_pgtable_ops(qcom_domain->pgtbl_ops);
+		pm_runtime_put_sync(qcom_domain->iommu->dev);
+	}
 
 	kfree(qcom_domain);
 }
@@ -386,7 +384,7 @@ static void qcom_iommu_detach_dev(struct
 	struct qcom_iommu_domain *qcom_domain = to_qcom_iommu_domain(domain);
 	unsigned i;
 
-	if (!qcom_domain->iommu)
+	if (WARN_ON(!qcom_domain->iommu))
 		return;
 
 	pm_runtime_get_sync(qcom_iommu->dev);
@@ -397,8 +395,6 @@ static void qcom_iommu_detach_dev(struct
 		iommu_writel(ctx, ARM_SMMU_CB_SCTLR, 0);
 	}
 	pm_runtime_put_sync(qcom_iommu->dev);
-
-	qcom_domain->iommu = NULL;
 }
 
 static int qcom_iommu_map(struct iommu_domain *domain, unsigned long iova,


