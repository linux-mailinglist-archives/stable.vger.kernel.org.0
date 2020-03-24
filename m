Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9461190EF6
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgCXNQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbgCXNQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:16:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 088F320775;
        Tue, 24 Mar 2020 13:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055784;
        bh=88/XO/N93K3OgCv2drcOHgS1Mvwynwf+rNzOUc7lL+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snY7veSKT+p1kInSHALOlJCGY9KJxgcEPnWsWlwbwxwDo7/M67ijw6R3Dr2YT0IcS
         GdYSGOO0UWAHVxCUiPO4KkAf2dRFQaWP2CTbEeFwy+xDHkhPK3o19P1BNxfDhUlUTd
         txdyBtwBT8pIrSUxzYU+balIA1/0etm8Hk/6ouEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yintian Tao <yttao@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Monk Liu <Monk.Liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/102] drm/amdgpu: clean wptr on wb when gpu recovery
Date:   Tue, 24 Mar 2020 14:10:20 +0100
Message-Id: <20200324130809.342801187@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yintian Tao <yttao@amd.com>

[ Upstream commit 2ab7e274b86739f4ceed5d94b6879f2d07b2802f ]

The TDR will be randomly failed due to compute ring
test failure. If the compute ring wptr & 0x7ff(ring_buf_mask)
is 0x100 then after map mqd the compute ring rptr will be
synced with 0x100. And the ring test packet size is also 0x100.
Then after invocation of amdgpu_ring_commit, the cp will not
really handle the packet on the ring buffer because rptr is equal to wptr.

Signed-off-by: Yintian Tao <yttao@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Monk Liu <Monk.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 2816d03297385..14417cebe38ba 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3555,6 +3555,7 @@ static int gfx_v10_0_kcq_init_queue(struct amdgpu_ring *ring)
 
 		/* reset ring buffer */
 		ring->wptr = 0;
+		atomic64_set((atomic64_t *)&adev->wb.wb[ring->wptr_offs], 0);
 		amdgpu_ring_clear_ring(ring);
 	} else {
 		amdgpu_ring_clear_ring(ring);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index d85e1e559c826..40034efa64bbc 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3756,6 +3756,7 @@ static int gfx_v9_0_kcq_init_queue(struct amdgpu_ring *ring)
 
 		/* reset ring buffer */
 		ring->wptr = 0;
+		atomic64_set((atomic64_t *)&adev->wb.wb[ring->wptr_offs], 0);
 		amdgpu_ring_clear_ring(ring);
 	} else {
 		amdgpu_ring_clear_ring(ring);
-- 
2.20.1



