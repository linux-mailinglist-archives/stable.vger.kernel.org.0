Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956C422F108
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732257AbgG0O26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732183AbgG0OX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B544D21D95;
        Mon, 27 Jul 2020 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859837;
        bh=0EJWnODGD4TNz5brZBkLw/E00QZ4S2pmfWX1+6zrt28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ge2B4eU90kbtnj3jOzAv4ISvjwbun1d3AXkQUHDQUDjUT5L58WdehQBssvaDfMvT8
         JDIPwmdSEsx0WM8zcMuvgHd0+oD8o9ueX7MFSsaA2bpEGN5Q+lmxGCALHdVV2G41Pq
         FG9YJeKQ9wJ/VId5jk4K5GsSf5HO+VOxrhX8EaKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Xiao <Jack.Xiao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 125/179] drm/amdgpu/gfx10: fix race condition for kiq
Date:   Mon, 27 Jul 2020 16:05:00 +0200
Message-Id: <20200727134938.739260444@linuxfoundation.org>
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

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit 7d65a577bb58d4f27a3398a4c0cb0b00ab7d0511 ]

During preemption test for gfx10, it uses kiq to trigger
gfx preemption, which would result in race condition
with flushing TLB for kiq.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 0e0daf0021b60..ff94f756978d5 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4746,12 +4746,17 @@ static int gfx_v10_0_ring_preempt_ib(struct amdgpu_ring *ring)
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_kiq *kiq = &adev->gfx.kiq;
 	struct amdgpu_ring *kiq_ring = &kiq->ring;
+	unsigned long flags;
 
 	if (!kiq->pmf || !kiq->pmf->kiq_unmap_queues)
 		return -EINVAL;
 
-	if (amdgpu_ring_alloc(kiq_ring, kiq->pmf->unmap_queues_size))
+	spin_lock_irqsave(&kiq->ring_lock, flags);
+
+	if (amdgpu_ring_alloc(kiq_ring, kiq->pmf->unmap_queues_size)) {
+		spin_unlock_irqrestore(&kiq->ring_lock, flags);
 		return -ENOMEM;
+	}
 
 	/* assert preemption condition */
 	amdgpu_ring_set_preempt_cond_exec(ring, false);
@@ -4762,6 +4767,8 @@ static int gfx_v10_0_ring_preempt_ib(struct amdgpu_ring *ring)
 				   ++ring->trail_seq);
 	amdgpu_ring_commit(kiq_ring);
 
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
+
 	/* poll the trailing fence */
 	for (i = 0; i < adev->usec_timeout; i++) {
 		if (ring->trail_seq ==
-- 
2.25.1



