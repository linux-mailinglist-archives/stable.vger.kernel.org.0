Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007AE359A63
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhDIJ60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233546AbhDIJ51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B4356115B;
        Fri,  9 Apr 2021 09:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962234;
        bh=/hcAZJmm17gJ2OaKFdmad4yz/lq+HaoucV/AZuP8RKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ef67rbHLiOQPnaC+Lk22vQ1gRdZhfst+ofpn1n5XkyIqtamS8ZwKtQOaxbpdsf6hF
         5ETr7cD+q5/zmU2gPMdRlouohBIVIneAt/cnFrEpgEPTRenZNd+HragKRS7wx4f1Jd
         Gk2C6eOaHbHJNMglbYYCtLTNx6ZOidqlnR6qUl2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/18] drm/msm: Ratelimit invalid-fence message
Date:   Fri,  9 Apr 2021 11:53:35 +0200
Message-Id: <20210409095301.768301965@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095301.525783608@linuxfoundation.org>
References: <20210409095301.525783608@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.30.2



