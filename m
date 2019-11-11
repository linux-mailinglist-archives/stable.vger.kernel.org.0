Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E74F7C6F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbfKKSqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbfKKSqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:46:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8761E20659;
        Mon, 11 Nov 2019 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497970;
        bh=E1CbWjVkJG8PYQL/0BKtViHj53nuYKi+UegmnxcQ47g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqefyO1N02Fx9MLCfr2CgIzhGftC/mJr8tizsvSLg5ULIEsMqMvJFj8AEd2pr+0qU
         +sorQbUdYDPXGSa4/9uA+Y9FFrfARhNSC+xkObvcGhH9OlGEmKD8T+oQDBJytCGc0Q
         sS+BSqVyEql70C4CBxwdggMo7JycuObFsbM/NlKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/125] drm/amdgpu: If amdgpu_ib_schedule fails return back the error.
Date:   Mon, 11 Nov 2019 19:29:09 +0100
Message-Id: <20191111181454.505362132@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit 57c0f58e9f562089de5f0b60da103677d232374c ]

Use ERR_PTR to return back the error happened during amdgpu_ib_schedule.

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index f823d4baf044d..cf582cc46d53e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -203,7 +203,7 @@ static struct dma_fence *amdgpu_job_run(struct drm_sched_job *sched_job)
 	struct amdgpu_ring *ring = to_amdgpu_ring(sched_job->sched);
 	struct dma_fence *fence = NULL, *finished;
 	struct amdgpu_job *job;
-	int r;
+	int r = 0;
 
 	job = to_amdgpu_job(sched_job);
 	finished = &job->base.s_fence->finished;
@@ -228,6 +228,8 @@ static struct dma_fence *amdgpu_job_run(struct drm_sched_job *sched_job)
 	job->fence = dma_fence_get(fence);
 
 	amdgpu_job_free_resources(job);
+
+	fence = r ? ERR_PTR(r) : fence;
 	return fence;
 }
 
-- 
2.20.1



