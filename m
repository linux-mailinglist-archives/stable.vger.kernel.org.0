Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF6A246F89
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389706AbgHQRsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388738AbgHQQNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:13:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5636720658;
        Mon, 17 Aug 2020 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680781;
        bh=5SdRxwewqwZ7KrqOvfnH5u5FxN5Aybc+C9XT0SFfjLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2BWb/Os53+eengOIit/IpcURRU5QEgtm7so4sIWOx/yTr+2B+4GGAMPUxV/01Ttm
         EA8S0bPlmmfJ5Kc6jEU/O1LYW9nC2sUUHIMc1M7WGJcZz8zwdE524+4rErSeWCpgcT
         0eps7aEdB7MlCzPlnGYX8/Wwj/AHFq9GiGP/Vbqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Abhinav Kumar <abhinavk@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/168] drm/msm: ratelimit crtc event overflow error
Date:   Mon, 17 Aug 2020 17:16:25 +0200
Message-Id: <20200817143736.449384458@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 5e16372b5940b1fecc3cc887fc02a50ba148d373 ]

This can happen a lot when things go pear shaped.  Lets not flood dmesg
when this happens.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Abhinav Kumar <abhinavk@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 4752f08f0884c..3c3b7f7013e87 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -659,7 +659,7 @@ static void dpu_crtc_frame_event_cb(void *data, u32 event)
 	spin_unlock_irqrestore(&dpu_crtc->spin_lock, flags);
 
 	if (!fevent) {
-		DRM_ERROR("crtc%d event %d overflow\n", crtc->base.id, event);
+		DRM_ERROR_RATELIMITED("crtc%d event %d overflow\n", crtc->base.id, event);
 		return;
 	}
 
-- 
2.25.1



