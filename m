Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3052C378873
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbhEJLVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237111AbhEJLLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A28CD616E9;
        Mon, 10 May 2021 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644830;
        bh=Z2qFcwyxkrMbFdj6C9e+eOQCZl86x/w+6rNLoAKvwLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O85mQM/wDHE83J+y//Rsjm7ymDRPomICNCDffK1wf3qBhMHSWmX+xww57JaOY9thh
         j2rc/LFE5Ng3+tvAOCQhnvEnA/vlb5GQh1cGYmZqV316Ohbry7ThpV3A7H0oR31qPB
         AHycbTwAefRzob8MLo5t/vgUNczkYc61HOQJx6t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Gomez <daniel@qtec.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 242/384] drm/amdgpu/ttm: Fix memory leak userptr pages
Date:   Mon, 10 May 2021 12:20:31 +0200
Message-Id: <20210510102022.860942870@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
index 5efa331e3ee8..f61fd2cf3fee 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1162,13 +1162,13 @@ static void amdgpu_ttm_backend_unbind(struct ttm_bo_device *bdev,
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



