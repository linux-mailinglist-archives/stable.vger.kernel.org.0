Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5DF257DCD
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgHaPlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbgHaP3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:29:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99142083E;
        Mon, 31 Aug 2020 15:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887785;
        bh=SRqgg3klPwBNdAHE2XPrbrhQ1Oghy5wWaGBIxVOjjxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drGTpZTRufPB+NpGfm7UhzPU46xIvgAJ1cEaI0VymGd2DPKl6qfU2GkeUhbEWnLD7
         es7/9mQkxBaxv/Cf1paO4jABabYwzVc/gfTr9BrtjjGH2YrR5EvJtuLWh6EFhOi7Z2
         l3FktYCJ1SMInPHCmBHeZrDtgECFcOo40EW4fZBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        kernel test robot <lkp@intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 06/42] drm/msm/dpu: fix unitialized variable error
Date:   Mon, 31 Aug 2020 11:28:58 -0400
Message-Id: <20200831152934.1023912-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

