Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131313786A0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhEJLJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235543AbhEJLBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:01:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B17E61C19;
        Mon, 10 May 2021 10:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644011;
        bh=BIQX3mrgQjYbqsK75Q+FnWt0J3RwnuA2FH8ieLqU8b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqb0HJOd8pcC/0CDOZvkbBence7jeN9anDybsYU+LLYxF0QpdwZVoQS6tangRsIhV
         rCyLB9kdoT/AN0yHuroDW5Ul0rCMrFxz8Tx4ZZZvgq58S4ome+qnQ4Hd+0Bf4FZu3I
         v2HCJrZ+glywN+UczUSLu23VDhj/udlGtsd61I6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Gomez <daniel@qtec.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 216/342] drm/radeon/ttm: Fix memory leak userptr pages
Date:   Mon, 10 May 2021 12:20:06 +0200
Message-Id: <20210510102017.232164864@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Gomez <daniel@qtec.com>

[ Upstream commit 5aeaa43e0ef1006320c077cbc49f4a8229ca3460 ]

If userptr pages have been pinned but not bounded,
they remain uncleared.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Daniel Gomez <daniel@qtec.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_ttm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 176cb55062be..08a015a36304 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -486,13 +486,14 @@ static void radeon_ttm_backend_unbind(struct ttm_bo_device *bdev, struct ttm_tt
 	struct radeon_ttm_tt *gtt = (void *)ttm;
 	struct radeon_device *rdev = radeon_get_rdev(bdev);
 
+	if (gtt->userptr)
+		radeon_ttm_tt_unpin_userptr(bdev, ttm);
+
 	if (!gtt->bound)
 		return;
 
 	radeon_gart_unbind(rdev, gtt->offset, ttm->num_pages);
 
-	if (gtt->userptr)
-		radeon_ttm_tt_unpin_userptr(bdev, ttm);
 	gtt->bound = false;
 }
 
-- 
2.30.2



