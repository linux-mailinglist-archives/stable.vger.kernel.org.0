Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9CF378454
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhEJKvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233425AbhEJKuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F00C619CE;
        Mon, 10 May 2021 10:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643127;
        bh=SZIz/g0o6vrwlXyk63PUQIv8XnYxuFtZ1b3aLMhAlRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEuu41wyU1U6lABPN0LoDRVBDkTNF9delGxj969FhsmSUR1teXWVy8kpsu32YNNU8
         Eqc9h+S2Y3qZJEcMRnjHQHHLnAnKNl8z2jxj+0n8pyQ+WculwEV279BDx+jFbicffo
         W6nmIdV+4LayLt12c26j3281lKreaacMDY9LuxxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Gomez <daniel@qtec.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/299] drm/amdgpu/ttm: Fix memory leak userptr pages
Date:   Mon, 10 May 2021 12:19:45 +0200
Message-Id: <20210510102011.159599673@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Gomez <daniel@qtec.com>

[ Upstream commit 0f6f9dd490d524930081a6ef1d60171ce39220b9 ]

If userptr pages have been pinned but not bounded,
they remain uncleared.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Daniel Gomez <daniel@qtec.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index a0248d78190f..06a662ea33dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1254,13 +1254,13 @@ static void amdgpu_ttm_backend_unbind(struct ttm_bo_device *bdev,
 	struct amdgpu_ttm_tt *gtt = (void *)ttm;
 	int r;
 
-	if (!gtt->bound)
-		return;
-
 	/* if the pages have userptr pinning then clear that first */
 	if (gtt->userptr)
 		amdgpu_ttm_tt_unpin_userptr(bdev, ttm);
 
+	if (!gtt->bound)
+		return;
+
 	if (gtt->offset == AMDGPU_BO_INVALID_OFFSET)
 		return;
 
-- 
2.30.2



