Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9605A24DD54
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgHURPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727990AbgHUQQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:16:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6F022B40;
        Fri, 21 Aug 2020 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026598;
        bh=RirBJnGWSx+8SfHSLXWiXEKeGrvmh1KYf16yHJ8Ti0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTDnqjpxdJYKYjsYya5niGhwnt7DWj+o7R7oB0b56pcJdiZ+jbEgq02MMZ0uI3djd
         R+sQerjWV7M0lVF11wpyjJKXrpH6mDLO9+WoxTIHw5tJ0miANuei9eTB1f0d0eemqF
         TB8QEVZsGyX9KdrFccVpZqjPDGNg64zwLOyrxM3M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 42/61] gpu: host1x: Put gather's BO on pinning error
Date:   Fri, 21 Aug 2020 12:15:26 -0400
Message-Id: <20200821161545.347622-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit fd323e9ef0a19112c0c85b85afc4848c0518174b ]

This patch fixes gather's BO refcounting on a pinning error. Gather's BO
won't be leaked now if something goes wrong.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/job.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index a10643aa89aa5..2ac5a99406d98 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -102,6 +102,7 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 {
 	struct host1x_client *client = job->client;
 	struct device *dev = client->dev;
+	struct host1x_job_gather *g;
 	struct iommu_domain *domain;
 	unsigned int i;
 	int err;
@@ -184,7 +185,6 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 	}
 
 	for (i = 0; i < job->num_gathers; i++) {
-		struct host1x_job_gather *g = &job->gathers[i];
 		size_t gather_size = 0;
 		struct scatterlist *sg;
 		struct sg_table *sgt;
@@ -194,6 +194,7 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 		dma_addr_t *phys;
 		unsigned int j;
 
+		g = &job->gathers[i];
 		g->bo = host1x_bo_get(g->bo);
 		if (!g->bo) {
 			err = -EINVAL;
@@ -213,7 +214,7 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 		sgt = host1x_bo_pin(host->dev, g->bo, phys);
 		if (IS_ERR(sgt)) {
 			err = PTR_ERR(sgt);
-			goto unpin;
+			goto put;
 		}
 
 		if (!IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL) && host->domain) {
@@ -226,7 +227,7 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 					   host->iova_end >> shift, true);
 			if (!alloc) {
 				err = -ENOMEM;
-				goto unpin;
+				goto put;
 			}
 
 			err = iommu_map_sg(host->domain,
@@ -235,7 +236,7 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 			if (err == 0) {
 				__free_iova(&host->iova, alloc);
 				err = -EINVAL;
-				goto unpin;
+				goto put;
 			}
 
 			job->unpins[job->num_unpins].size = gather_size;
@@ -245,7 +246,7 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 					 DMA_TO_DEVICE);
 			if (!err) {
 				err = -ENOMEM;
-				goto unpin;
+				goto put;
 			}
 
 			job->unpins[job->num_unpins].dir = DMA_TO_DEVICE;
@@ -263,6 +264,8 @@ static unsigned int pin_job(struct host1x *host, struct host1x_job *job)
 
 	return 0;
 
+put:
+	host1x_bo_put(g->bo);
 unpin:
 	host1x_job_unpin(job);
 	return err;
-- 
2.25.1

