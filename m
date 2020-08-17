Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC16247143
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390807AbgHQSX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388235AbgHQQDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:03:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED5FA2053B;
        Mon, 17 Aug 2020 16:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680198;
        bh=SKGMe+AprkijJRliWRr1iYnN8WQZPb7T8w0+0v5Nv6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCl1Zl8+ZPSnX2nZOjOkbtGCuJQNVfMxIeh/ksjMTczI4cU8l2vixNmmk/FTtrO/Q
         guhNTax9eliv0yPQn6/9JGzyZ5X3c2EPkjt/lsM1x3TEMllXt0q3TNAn+Eqnwm6AB+
         xHSTvHPUX9y0EybVpJTTXCrKZ2O+kYkcXk0JkHck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Abhinav Kumar <abhinavk@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/270] drm/msm: ratelimit crtc event overflow error
Date:   Mon, 17 Aug 2020 17:14:50 +0200
Message-Id: <20200817143800.194189346@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index ce59adff06aa1..36c85c05b7cf7 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -381,7 +381,7 @@ static void dpu_crtc_frame_event_cb(void *data, u32 event)
 	spin_unlock_irqrestore(&dpu_crtc->spin_lock, flags);
 
 	if (!fevent) {
-		DRM_ERROR("crtc%d event %d overflow\n", crtc->base.id, event);
+		DRM_ERROR_RATELIMITED("crtc%d event %d overflow\n", crtc->base.id, event);
 		return;
 	}
 
-- 
2.25.1



