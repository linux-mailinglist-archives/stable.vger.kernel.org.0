Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B244A516DA0
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 11:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384279AbiEBJqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 05:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384387AbiEBJqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 05:46:37 -0400
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F240210FC3
        for <stable@vger.kernel.org>; Mon,  2 May 2022 02:42:52 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5A9B65E5; Mon,  2 May 2022 11:42:51 +0200 (CEST)
Date:   Mon, 2 May 2022 11:42:50 +0200
From:   JoergRoedel <joro@8bytes.org>
To:     =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        vasant.hedge@amd.com, WillDeacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: Re: Linux 5.17.5
Message-ID: <Ym+nmt/aZoq1SUjV@8bytes.org>
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jörg,

can you please try the attached patch? It should get rid of the WARNING
on your system.

Suravee, Vasant, can you please test review the patch and report whether
the GA log functionality is still working?

Thanks,

	Joerg

From 4fee768d5c23715eae31fed3b41cdf045e099aef Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Mon, 2 May 2022 11:37:43 +0200
Subject: [PATCH] iommu/amd: Do not poll GA_LOG_RUNNING mask at boot

On some hardware it takes more than a second for the hardware to get
the GA log into running state. This is too long to poll for in the AMD
IOMMU driver code.

Instead, check whehter initialization was successful before polling
the log for the first time.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd/amd_iommu_types.h |  3 +++
 drivers/iommu/amd/init.c            | 13 ++-----------
 drivers/iommu/amd/iommu.c           | 25 ++++++++++++++++++++++++-
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 47108ed44fbb..080eafa11327 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -579,6 +579,9 @@ struct amd_iommu {
 	/* pci domain of this IOMMU */
 	u16 pci_seg;
 
+	/* Whether to poll MMIO to check if ga_log is running */
+	bool ga_log_running;
+
 	/* start of exclusion range of that IOMMU */
 	u64 exclusion_start;
 	/* length of exclusion range of that IOMMU */
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 7bfe37e52e21..b5e8246f82cc 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -816,7 +816,7 @@ static void free_ga_log(struct amd_iommu *iommu)
 static int iommu_ga_log_enable(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
-	u32 status, i;
+	u32 status;
 	u64 entry;
 
 	if (!iommu->ga_log)
@@ -840,17 +840,8 @@ static int iommu_ga_log_enable(struct amd_iommu *iommu)
 
 	iommu_feature_enable(iommu, CONTROL_GAINT_EN);
 	iommu_feature_enable(iommu, CONTROL_GALOG_EN);
-
-	for (i = 0; i < LOOP_TIMEOUT; ++i) {
-		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
-		if (status & (MMIO_STATUS_GALOG_RUN_MASK))
-			break;
-		udelay(10);
-	}
-
-	if (WARN_ON(i >= LOOP_TIMEOUT))
-		return -EINVAL;
 #endif /* CONFIG_IRQ_REMAP */
+
 	return 0;
 }
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a18b549951bb..eab9ffe0cb0c 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -705,6 +705,18 @@ int amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
 }
 EXPORT_SYMBOL(amd_iommu_register_ga_log_notifier);
 
+static bool iommu_ga_log_running(struct amd_iommu *iommu)
+{
+	if (!iommu->ga_log_running) {
+		u32 status;
+
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		iommu->ga_log_running = !!(status & (MMIO_STATUS_GALOG_RUN_MASK));
+	}
+
+	return iommu->ga_log_running;
+}
+
 static void iommu_poll_ga_log(struct amd_iommu *iommu)
 {
 	u32 head, tail, cnt = 0;
@@ -792,7 +804,18 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data)
 #ifdef CONFIG_IRQ_REMAP
 		if (status & MMIO_STATUS_GALOG_INT_MASK) {
 			pr_devel("Processing IOMMU GA Log\n");
-			iommu_poll_ga_log(iommu);
+
+			/*
+			 * The hardware needs a lot of time (sometimes > 1s) to
+			 * get the GA log into running state. So it is
+			 * inefficient to poll for that at initialization time.
+			 * Instead the check is made here before the log is
+			 * polled for the first time.
+			 */
+			if (iommu_ga_log_running(iommu))
+				iommu_poll_ga_log(iommu);
+			else
+				WARN_ON_ONCE(1);
 		}
 #endif
 
-- 
2.36.0

