Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADE834DA4C
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhC2WWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231936AbhC2WV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8A8161985;
        Mon, 29 Mar 2021 22:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056516;
        bh=AbfZNAVrVdAXkaXBMh0tMeyE6LfWTDezyo6Qkci3oXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaSiECbM4sTqmTMEr/iPfx19MNiBL9mpUOMXealW7Y4h3e5rVs06WUdXUquwTN9Yl
         4xbw7SfX+mXEhUb/n7ZeBElcQDgO2k3UQtPueYE67GPcP8mxFK7G5h6JdLWtz5UXMo
         C0fH0b30Ueb9QHhYp333N6ixWBSwxz01nVNon+fbymkyY4m1Kp37Kv0ZE7kwI8L3lF
         kY6lh1gan0RVr/VBcLL3WEL1v+ZXD09N2a7+6UJ9U3PU0oXhU3325eypFCYrrFcSs9
         MfoRmOIGyH+XVyRStQ5v/ILYirDK7DaIlZlLQnb0zu+MK5qzOiP68byxT70RRfUudl
         UgWa8mWE8Hqbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 18/38] drm/msm: Ratelimit invalid-fence message
Date:   Mon, 29 Mar 2021 18:21:13 -0400
Message-Id: <20210329222133.2382393-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
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
index ad2703698b05..cd59a5918038 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -45,7 +45,7 @@ int msm_wait_fence(struct msm_fence_context *fctx, uint32_t fence,
 	int ret;
 
 	if (fence > fctx->last_fence) {
-		DRM_ERROR("%s: waiting on invalid fence: %u (of %u)\n",
+		DRM_ERROR_RATELIMITED("%s: waiting on invalid fence: %u (of %u)\n",
 				fctx->name, fence, fctx->last_fence);
 		return -EINVAL;
 	}
-- 
2.30.1

