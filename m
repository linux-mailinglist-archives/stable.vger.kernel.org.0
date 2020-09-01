Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7350C259B0B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgIAPX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729800AbgIAPX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:23:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CAED206FA;
        Tue,  1 Sep 2020 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973806;
        bh=I0kOzhv1g8NoCAaKgJBn0Xb3Tnk6vW4cGCeV6bycCBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=foEKt4SmSfkDYcNZo0BgBYScSbKDa9gsKAs9vHtzS3Oxby0ufWnBcgjlXWQodb7pf
         Ufv2HN0bPV4I6/2YEf/37TIMgXqy4vs1z0tr9yXS+8LEV4nGtSBM2CcQ1gPiY1/Lq5
         1QtSDV7Ls3AF+Ma/H0pvP+vXBiUYj/f5QjBRDJGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/125] drm/msm/adreno: fix updating ring fence
Date:   Tue,  1 Sep 2020 17:10:09 +0200
Message-Id: <20200901150937.201029823@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit f228af11dfa1d1616bc67f3a4119ab77c36181f1 ]

We need to set it to the most recent completed fence, not the most
recent submitted.  Otherwise we have races where we think we can retire
submits that the GPU is not finished with, if the GPU doesn't manage to
overwrite the seqno before we look at it.

This can show up with hang recovery if one of the submits after the
crashing submit also hangs after it is replayed.

Fixes: f97decac5f4c ("drm/msm: Support multiple ringbuffers")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 93d70f4a2154e..c9f831604558f 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -221,7 +221,7 @@ int adreno_hw_init(struct msm_gpu *gpu)
 		ring->next = ring->start;
 
 		/* reset completed fence seqno: */
-		ring->memptrs->fence = ring->seqno;
+		ring->memptrs->fence = ring->fctx->completed_fence;
 		ring->memptrs->rptr = 0;
 	}
 
-- 
2.25.1



