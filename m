Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC866492E
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 17:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfGJPEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 11:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728127AbfGJPDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 11:03:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0799214AF;
        Wed, 10 Jul 2019 15:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562770996;
        bh=aS5Y4MQmSBaAsAw/0yPvVmQcEdM123UkC2/dejKG1JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkxvBbg3I18AdIcrabVLmsB0qc4saU++fBVefzLsW3jXMfmRm9uaOnMMc0VkjNmxd
         zATNv7u9oW7sDidZv9tV57UV7fFX4hVarEzjg7vHZAddcvN5nfz5J8NnU7opIP2FZw
         wFMh6LkqQ7vErTRC3nWAgIiOM40etjPyas7JW3dI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Beckett <bob.beckett@collabora.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 8/9] drm/imx: only send event on crtc disable if kept disabled
Date:   Wed, 10 Jul 2019 11:02:58 -0400
Message-Id: <20190710150301.7129-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710150301.7129-1-sashal@kernel.org>
References: <20190710150301.7129-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Beckett <bob.beckett@collabora.com>

[ Upstream commit 5aeab2bfc9ffa72d3ca73416635cb3785dfc076f ]

The event will be sent as part of the vblank enable during the modeset
if the crtc is not being kept disabled.

Fixes: 5f2f911578fb ("drm/imx: atomic phase 3 step 1: Use atomic configuration")

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 1b5870e7bacc..ff34f9bb55a1 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -101,7 +101,7 @@ static void ipu_crtc_atomic_disable(struct drm_crtc *crtc,
 	drm_crtc_vblank_off(crtc);
 
 	spin_lock_irq(&crtc->dev->event_lock);
-	if (crtc->state->event) {
+	if (crtc->state->event && !crtc->state->active) {
 		drm_crtc_send_vblank_event(crtc, crtc->state->event);
 		crtc->state->event = NULL;
 	}
-- 
2.20.1

