Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1FF10D681
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfK2N7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 08:59:13 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35212 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfK2N7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 08:59:13 -0500
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 64D68292575;
        Fri, 29 Nov 2019 13:59:12 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/8] drm/panfrost: Make panfrost_job_run() return an ERR_PTR() instead of NULL
Date:   Fri, 29 Nov 2019 14:59:01 +0100
Message-Id: <20191129135908.2439529-2-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129135908.2439529-1-boris.brezillon@collabora.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we don't do that, dma_fence_set_error() complains (called from
drm_sched_main()).

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_job.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index 21f34d44aac2..cdd9448fbbdd 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -328,13 +328,13 @@ static struct dma_fence *panfrost_job_run(struct drm_sched_job *sched_job)
 	struct dma_fence *fence = NULL;
 
 	if (unlikely(job->base.s_fence->finished.error))
-		return NULL;
+		return ERR_PTR(job->base.s_fence->finished.error);
 
 	pfdev->jobs[slot] = job;
 
 	fence = panfrost_fence_create(pfdev, slot);
 	if (IS_ERR(fence))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (job->done_fence)
 		dma_fence_put(job->done_fence);
-- 
2.23.0

