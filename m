Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E1D37886B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhEJLVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237115AbhEJLLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C2BD616EA;
        Mon, 10 May 2021 11:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644832;
        bh=+6G9jAWff5aKPoueVO+hJ+guH4vf1GrWm+JiroM/+Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNo37Mznyptu2SDiJIQo94Koyb2p7aYKvo5vFBmP8bJajCvryWfM9yE5y2HWbN5sc
         H2N4qyc2MBI5EKIi5ZHGHfZbimTq8jCgT10GJqXr4tssQqhJ++zL4VTf5Ez95UDGY3
         I8IvMGjNS1nfbMJ0vbktIgn/JuZQCMg6zZ0Jxz2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Gomez <daniel@qtec.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 243/384] drm/radeon/ttm: Fix memory leak userptr pages
Date:   Mon, 10 May 2021 12:20:32 +0200
Message-Id: <20210510102022.890965508@linuxfoundation.org>
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
index 78893bea85ae..c0258d213a72 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -485,13 +485,14 @@ static void radeon_ttm_backend_unbind(struct ttm_bo_device *bdev, struct ttm_tt
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



