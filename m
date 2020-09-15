Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5047926A727
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgIOOdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgIOOca (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F29222BB;
        Tue, 15 Sep 2020 14:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179834;
        bh=4sSaA8sSc/MSeLJiOieIDKBP7CzF7vHakoPHP8AZ5Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTUAhr/QVsV0d1p01tGVcaBk4aZ/KrfhZz4juuUBOP/XaYSn+ksF6X4sdViPjZIZl
         tJQccIaK/nHXeyVCDd+F/Eszz5fcyhXEkJuXG8QeFrlccAcS3j9s9F1aVLA0Flqxw8
         adx+Lrvj6G4iVxTMa/0IzoTMiRHAFe+VGo+P/4vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/132] drm/msm/gpu: make ringbuffer readonly
Date:   Tue, 15 Sep 2020 16:13:51 +0200
Message-Id: <20200915140650.568692745@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 352c83fb39cae3eff95a8e1ed23006291abb6196 ]

The GPU has no business writing into the ringbuffer, let's make it
readonly to the GPU.

Fixes: 7198e6b03155 ("drm/msm: add a3xx gpu support")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_ringbuffer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.c b/drivers/gpu/drm/msm/msm_ringbuffer.c
index e397c44cc0112..39ecb5a18431e 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -27,7 +27,8 @@ struct msm_ringbuffer *msm_ringbuffer_new(struct msm_gpu *gpu, int id,
 	ring->id = id;
 
 	ring->start = msm_gem_kernel_new(gpu->dev, MSM_GPU_RINGBUFFER_SZ,
-		MSM_BO_WC, gpu->aspace, &ring->bo, &ring->iova);
+		MSM_BO_WC | MSM_BO_GPU_READONLY, gpu->aspace, &ring->bo,
+		&ring->iova);
 
 	if (IS_ERR(ring->start)) {
 		ret = PTR_ERR(ring->start);
-- 
2.25.1



