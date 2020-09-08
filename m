Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628F6261F0F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbgIHT6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730518AbgIHPfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2B4422470;
        Tue,  8 Sep 2020 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579282;
        bh=SRqgg3klPwBNdAHE2XPrbrhQ1Oghy5wWaGBIxVOjjxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cH5t/UvprO7bygB8Yh7H0ENQ8vLN5LQapruUQJzeTou8kJGWuPIW1W4rZW07o4nrJ
         W04/EhPQqL4nSg6JWiolPFiLjwu1694tCrTIO+QyEz2LMF8aJA2Lj/+ZtXcGmsPQK4
         MNDZbI0ORQiOFo9kuKk75pHCIfAm6tIdnxclnD40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Rob Clark <robdclark@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 005/186] drm/msm/dpu: fix unitialized variable error
Date:   Tue,  8 Sep 2020 17:22:27 +0200
Message-Id: <20200908152241.910947083@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 35c719da95c0d28560bff7bafeaf07ebb212665e ]

 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c:817 dpu_crtc_enable() error: uninitialized symbol 'request_bandwidth'.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 969d95aa873c4..1026e1e5bec10 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -827,7 +827,7 @@ static void dpu_crtc_enable(struct drm_crtc *crtc,
 {
 	struct dpu_crtc *dpu_crtc;
 	struct drm_encoder *encoder;
-	bool request_bandwidth;
+	bool request_bandwidth = false;
 
 	if (!crtc) {
 		DPU_ERROR("invalid crtc\n");
-- 
2.25.1



