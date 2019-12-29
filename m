Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E6C12C6B0
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbfL2Rtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:49:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731377AbfL2Rt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D24206DB;
        Sun, 29 Dec 2019 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641768;
        bh=egxLxLD8kFI5L3pl/QAZrXONHTV+NStU0tx8rn3F93U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igNko/Ecfc4XEKudNb8Agt3B3N37iAmDzm0+BVTFmH0DmKVQ7a6QwoHGYx/9Opbq9
         NBex7DZnrTiUgNYmgoBIRaZlE5S8CtFAJeBmgeyDn0Wl1l8xiUggWLfwfn6BG3jptM
         jWPVUoX+TE7ec3O1dzJ3g4xK8Gb/zfBzjegWOjPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 204/434] gpu: host1x: Allocate gather copy for host1x
Date:   Sun, 29 Dec 2019 18:24:17 +0100
Message-Id: <20191229172715.379195147@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index eaa5c3352c13..22559670faee 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -436,7 +436,8 @@ out:
 	return err;
 }
 
-static inline int copy_gathers(struct host1x_job *job, struct device *dev)
+static inline int copy_gathers(struct device *host, struct host1x_job *job,
+			       struct device *dev)
 {
 	struct host1x_firewall fw;
 	size_t size = 0;
@@ -459,12 +460,12 @@ static inline int copy_gathers(struct host1x_job *job, struct device *dev)
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
@@ -512,7 +513,7 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 		goto out;
 
 	if (IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL)) {
-		err = copy_gathers(job, dev);
+		err = copy_gathers(host->dev, job, dev);
 		if (err)
 			goto out;
 	}
@@ -573,7 +574,7 @@ void host1x_job_unpin(struct host1x_job *job)
 	job->num_unpins = 0;
 
 	if (job->gather_copy_size)
-		dma_free_wc(job->channel->dev, job->gather_copy_size,
+		dma_free_wc(host->dev, job->gather_copy_size,
 			    job->gather_copy_mapped, job->gather_copy);
 }
 EXPORT_SYMBOL(host1x_job_unpin);
-- 
2.20.1



