Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD49191C7
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfEISvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbfEISve (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1BC3217D7;
        Thu,  9 May 2019 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427894;
        bh=bHoOnIlsyTPfLVH1YTxoNF1t9ZcKKZiYw2OEkn5sGCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTkNNysOThHnZ2p2OD13+CsLMZeouHGzB2bW6S3Mat+PXzXFcGqxKfbIXD8G5T7nh
         2L2fYHBrka/yFl5Og+D1zIzBS+R0MAGbPeY6qJwbj3wsucZv5WPIYDE+ZDf28cUQ/v
         9GLrjOa1pHWdEd3hMyr6LEEy1wm/DTVfwl36QeDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wentao Lou <Wentao.Lou@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 44/95] drm/amdgpu: amdgpu_device_recover_vram always failed if only one node in shadow_list
Date:   Thu,  9 May 2019 20:42:01 +0200
Message-Id: <20190509181312.518662004@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1712fb1a2f6829150032ac76eb0e39b82a549cfb ]

amdgpu_bo_restore_shadow would assign zero to r if succeeded.
r would remain zero if there is only one node in shadow_list.
current code would always return failure when r <= 0.
restart the timeout for each wait was a rather problematic bug as well.
The value of tmo SHOULD be changed, otherwise we wait tmo jiffies on each loop.

Signed-off-by: Wentao Lou <Wentao.Lou@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 7ff3a28fc9038..d55dd570a7023 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3158,11 +3158,16 @@ static int amdgpu_device_recover_vram(struct amdgpu_device *adev)
 			break;
 
 		if (fence) {
-			r = dma_fence_wait_timeout(fence, false, tmo);
+			tmo = dma_fence_wait_timeout(fence, false, tmo);
 			dma_fence_put(fence);
 			fence = next;
-			if (r <= 0)
+			if (tmo == 0) {
+				r = -ETIMEDOUT;
 				break;
+			} else if (tmo < 0) {
+				r = tmo;
+				break;
+			}
 		} else {
 			fence = next;
 		}
@@ -3173,8 +3178,8 @@ static int amdgpu_device_recover_vram(struct amdgpu_device *adev)
 		tmo = dma_fence_wait_timeout(fence, false, tmo);
 	dma_fence_put(fence);
 
-	if (r <= 0 || tmo <= 0) {
-		DRM_ERROR("recover vram bo from shadow failed\n");
+	if (r < 0 || tmo <= 0) {
+		DRM_ERROR("recover vram bo from shadow failed, r is %ld, tmo is %ld\n", r, tmo);
 		return -EIO;
 	}
 
-- 
2.20.1



