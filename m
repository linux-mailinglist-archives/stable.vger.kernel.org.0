Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155ED16731A
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgBUIJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:09:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732322AbgBUIJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:09:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D1FD20722;
        Fri, 21 Feb 2020 08:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272552;
        bh=M5bDtOSaKOorgrGmBZmg62PQvqREkOUogOkzfz94Uy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrhSOpTNqinFZWLi1ihQykLkp/uc9h/sBWHJRJXIM1Ti/t6zH7oWDazEq4u+ozDZB
         zZcU1C0tw5D8FkWfksQSbQ/HlTl1VraO8hlbnxUJlILUK0ABgxAXWmMdjuQdXwPzAw
         SfAeTrQvhj/aEBIcDf1kg/fCqL+EmWHvRXiaRDkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bibby Hsieh <bibby.hsieh@mediatek.com>,
        CK Hu <ck.hu@mediatek.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/344] drm/mediatek: handle events when enabling/disabling crtc
Date:   Fri, 21 Feb 2020 08:39:08 +0100
Message-Id: <20200221072402.322430311@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bibby Hsieh <bibby.hsieh@mediatek.com>

[ Upstream commit 411f5c1eacfebb1f6e40b653d29447cdfe7282aa ]

The driver currently handles vblank events only when updating planes on
an already enabled CRTC. The atomic update API however allows requesting
an event when enabling or disabling a CRTC. This currently leads to
event objects being leaked in the kernel and to events not being sent
out. Fix it.

Signed-off-by: Bibby Hsieh <bibby.hsieh@mediatek.com>
Signed-off-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 34a7317557912..0b3d284d19569 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -298,6 +298,7 @@ err_pm_runtime_put:
 static void mtk_crtc_ddp_hw_fini(struct mtk_drm_crtc *mtk_crtc)
 {
 	struct drm_device *drm = mtk_crtc->base.dev;
+	struct drm_crtc *crtc = &mtk_crtc->base;
 	int i;
 
 	DRM_DEBUG_DRIVER("%s\n", __func__);
@@ -319,6 +320,13 @@ static void mtk_crtc_ddp_hw_fini(struct mtk_drm_crtc *mtk_crtc)
 	mtk_disp_mutex_unprepare(mtk_crtc->mutex);
 
 	pm_runtime_put(drm->dev);
+
+	if (crtc->state->event && !crtc->state->active) {
+		spin_lock_irq(&crtc->dev->event_lock);
+		drm_crtc_send_vblank_event(crtc, crtc->state->event);
+		crtc->state->event = NULL;
+		spin_unlock_irq(&crtc->dev->event_lock);
+	}
 }
 
 static void mtk_crtc_ddp_config(struct drm_crtc *crtc)
-- 
2.20.1



