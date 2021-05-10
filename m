Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56917378455
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhEJKvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233443AbhEJKuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9004616E8;
        Mon, 10 May 2021 10:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643130;
        bh=xuaQyowJnAi9b6Ss3OrZfWGSxAGyrYu9Gkf8tyxhaX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cr1gYvFrBT1/W0hZPnIIZGP3XWRxeP9WvOCFaVS7RgMQkWyHvStfsxcJRCsM6pu0W
         GiN6WP9ouw664D/WlZ7BBjU/aPFc0UyQaX4VScXBpgPpeIFd2w0zyD8DHh7DcOoshv
         UcBGtEUZwQqtL4cS8EpdwEs/MnDxbIClBTaDj9hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Gomez <daniel@qtec.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/299] drm/radeon/ttm: Fix memory leak userptr pages
Date:   Mon, 10 May 2021 12:19:46 +0200
Message-Id: <20210510102011.190492536@linuxfoundation.org>
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
index 36150b7f31a9..a65cb349fac2 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -566,13 +566,14 @@ static void radeon_ttm_backend_unbind(struct ttm_bo_device *bdev, struct ttm_tt
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



