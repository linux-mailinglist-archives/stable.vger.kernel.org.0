Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4749634DBC0
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhC2Wak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhC2WYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C83619BC;
        Mon, 29 Mar 2021 22:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056616;
        bh=4BQ34GgzZal7sDaL7wotX1inHcJq9PRvyQIM7/egSko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgvt4jtgumh5CUXT4jRaDkAXj5CvCc0I7HytB22LyG/389tWgfq34qZiF3UDVo9mr
         93OCo+yfG0ulUNCW6Q82twVNTSYAf2acpsLq2XV2ATPeLikJqpOYvaKKMeyA7f5e6Z
         eWvpY6d/s5pUtvmVPWZv1GgxTNrulPqHlwEiUndRQzCvpJkWeOnDmyGjvCl3k0q7Is
         uQ/NpxGiQ9OqbQ+Q3Jmvn749Q5Qn8l95Djz0BcsSuqmc61bZELSjeF7rs0KuJfQ1xS
         8cZmi5FTMQDRDCyUIbE/cFLLUMPCYbB6BCPGr7QmpoFOdUqQDR9HZnkbz0r9DmZLXo
         vA+ULDN/iABSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 08/15] drm/msm: Ratelimit invalid-fence message
Date:   Mon, 29 Mar 2021 18:23:19 -0400
Message-Id: <20210329222327.2383533-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 7ad48d27a2846bfda29214fb454d001c3e02b9e7 ]

We have seen a couple cases where low memory situations cause something
bad to happen, followed by a flood of these messages obscuring the root
cause.  Lets ratelimit the dmesg spam so that next time it happens we
don't lose the kernel traces leading up to this.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_fence.c b/drivers/gpu/drm/msm/msm_fence.c
index 349c12f670eb..6c11be79574e 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -56,7 +56,7 @@ int msm_wait_fence(struct msm_fence_context *fctx, uint32_t fence,
 	int ret;
 
 	if (fence > fctx->last_fence) {
-		DRM_ERROR("%s: waiting on invalid fence: %u (of %u)\n",
+		DRM_ERROR_RATELIMITED("%s: waiting on invalid fence: %u (of %u)\n",
 				fctx->name, fence, fctx->last_fence);
 		return -EINVAL;
 	}
-- 
2.30.1

