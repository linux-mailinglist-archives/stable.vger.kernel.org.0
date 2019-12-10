Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C288F119907
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfLJVmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729921AbfLJVeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:34:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ACD4207FF;
        Tue, 10 Dec 2019 21:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013644;
        bh=7rf3kIeiTZo/6Pj1Rd6RpMyugMZG5DU5E/725qTpfs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4xW7OipvHRQic33+rDheKQQ/wGe2Ku7czAEJdyP74T3iRkpaQ3TfjpJhpZhUvdmt
         bo2Xp3F8MYQeDAOHqCYeLJc4HSUchVHMCpqax3TgRu0GoMS6W6brbD4U4vou80phAB
         st8I1cUmG1/e5vMaNYFHoFWzKWtcFXVSwZnuOynE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 084/177] gpu: host1x: Allocate gather copy for host1x
Date:   Tue, 10 Dec 2019 16:30:48 -0500
Message-Id: <20191210213221.11921-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit b78e70c04c149299bd210759d7c7af7c86b89ca8 ]

Currently when the gather buffers are copied, they are copied to a
buffer that is allocated for the host1x client that wants to execute the
command streams in the buffers. However, the gather buffers will be read
by the host1x device, which causes SMMU faults if the DMA API is backed
by an IOMMU.

Fix this by allocating the gather buffer copy for the host1x device,
which makes sure that it will be mapped into the host1x's IOVA space if
the DMA API is backed by an IOMMU.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/job.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index 527a1cddb14fd..916b2355e11a6 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -447,7 +447,8 @@ static int validate(struct host1x_firewall *fw, struct host1x_job_gather *g)
 	return err;
 }
 
-static inline int copy_gathers(struct host1x_job *job, struct device *dev)
+static inline int copy_gathers(struct device *host, struct host1x_job *job,
+			       struct device *dev)
 {
 	struct host1x_firewall fw;
 	size_t size = 0;
@@ -470,12 +471,12 @@ static inline int copy_gathers(struct host1x_job *job, struct device *dev)
 	 * Try a non-blocking allocation from a higher priority pools first,
 	 * as awaiting for the allocation here is a major performance hit.
 	 */
-	job->gather_copy_mapped = dma_alloc_wc(dev, size, &job->gather_copy,
+	job->gather_copy_mapped = dma_alloc_wc(host, size, &job->gather_copy,
 					       GFP_NOWAIT);
 
 	/* the higher priority allocation failed, try the generic-blocking */
 	if (!job->gather_copy_mapped)
-		job->gather_copy_mapped = dma_alloc_wc(dev, size,
+		job->gather_copy_mapped = dma_alloc_wc(host, size,
 						       &job->gather_copy,
 						       GFP_KERNEL);
 	if (!job->gather_copy_mapped)
@@ -523,7 +524,7 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 		goto out;
 
 	if (IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL)) {
-		err = copy_gathers(job, dev);
+		err = copy_gathers(host->dev, job, dev);
 		if (err)
 			goto out;
 	}
@@ -584,7 +585,7 @@ void host1x_job_unpin(struct host1x_job *job)
 	job->num_unpins = 0;
 
 	if (job->gather_copy_size)
-		dma_free_wc(job->channel->dev, job->gather_copy_size,
+		dma_free_wc(host->dev, job->gather_copy_size,
 			    job->gather_copy_mapped, job->gather_copy);
 }
 EXPORT_SYMBOL(host1x_job_unpin);
-- 
2.20.1

