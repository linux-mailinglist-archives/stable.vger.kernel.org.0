Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5973C542B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347605AbhGLH5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245628AbhGLHxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB0B06113E;
        Mon, 12 Jul 2021 07:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076221;
        bh=wtlB+wYJGWfg/KxXJqPSwijEtBnn7Fa7PPcu9M+URC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PipEoiMwcaOQsoAqLtKxOML7g4XbUEVnDLMF3obBoYKy3E9HazT1mIgSz+uzEbLk3
         bWhZOSe6GLgBVUcfck2BDKUA/zkRQ+7H1FmbG3hzn6bTAoB/T7rwM2gjWDaEAxBHV8
         20N6n4sTsjd4LfDLQ25rPxhSNJKsct/S8jTkHDRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krishna Manikandan <mkrishn@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 549/800] drm/msm/disp/dpu1: avoid perf update in frame done event
Date:   Mon, 12 Jul 2021 08:09:32 +0200
Message-Id: <20210712061025.788671801@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna Manikandan <mkrishn@codeaurora.org>

[ Upstream commit a1f2ba60eace242fd034173db3762f342a824a2e ]

Crtc perf update from frame event work can result in
wrong bandwidth and clock update from dpu if the work
is scheduled after the swap state has happened.

Avoid such issues by moving perf update to complete
commit once the frame is accepted by the hardware.

Fixes: a29c8c024165 ("drm/msm/disp/dpu1: fix display underruns during modeset")
Signed-off-by: Krishna Manikandan <mkrishn@codeaurora.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/1622092076-5100-1-git-send-email-mkrishn@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 18bc76b7f1a3..4523d6ba891b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -407,9 +407,6 @@ static void dpu_crtc_frame_event_work(struct kthread_work *work)
 								fevent->event);
 		}
 
-		if (fevent->event & DPU_ENCODER_FRAME_EVENT_DONE)
-			dpu_core_perf_crtc_update(crtc, 0, false);
-
 		if (fevent->event & (DPU_ENCODER_FRAME_EVENT_DONE
 					| DPU_ENCODER_FRAME_EVENT_ERROR))
 			frame_done = true;
@@ -477,6 +474,7 @@ static void dpu_crtc_frame_event_cb(void *data, u32 event)
 void dpu_crtc_complete_commit(struct drm_crtc *crtc)
 {
 	trace_dpu_crtc_complete_commit(DRMID(crtc));
+	dpu_core_perf_crtc_update(crtc, 0, false);
 	_dpu_crtc_complete_flip(crtc);
 }
 
-- 
2.30.2



