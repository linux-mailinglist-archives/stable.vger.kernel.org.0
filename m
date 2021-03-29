Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC36634DB15
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhC2WZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232596AbhC2WXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0327619BA;
        Mon, 29 Mar 2021 22:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056596;
        bh=AbfZNAVrVdAXkaXBMh0tMeyE6LfWTDezyo6Qkci3oXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KC2I4SYsnYa7Xy0HmtoInz7lY1/A0kIUU5LRuGmA6jgD0I9rGJGUrFjjUG41sttgB
         0Waq+sq93io30zEgtXKKRFQkwYPGue48/UU8KnLasKzGYqUlq/sxjkt3wKy8cWl2S8
         yUqpGkb5gfywyGaJYl73VwuedSy+R5S3BiKytW594EoNUII+2whoQPVqpLzxOm4Zvg
         jF5JTs57zHvD5RYhHgaf7l0LqDff3q6dN9zJ35en7Dv647N3mrnrjlgGKJsC7862va
         Tky4KSk1XxRruaK2uNC8I+YC4XP5Z5vUbgT+yvLiqOoNmBYtbKVqhfYYVZO4UTODKj
         yfA0OpX0d9ICA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 11/19] drm/msm: Ratelimit invalid-fence message
Date:   Mon, 29 Mar 2021 18:22:54 -0400
Message-Id: <20210329222303.2383319-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222303.2383319-1-sashal@kernel.org>
References: <20210329222303.2383319-1-sashal@kernel.org>
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

