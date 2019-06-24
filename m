Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E73F250729
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfFXKE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbfFXKEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:48 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02AB5205ED;
        Mon, 24 Jun 2019 10:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370687;
        bh=ux5ZLLyQLAvQ2u7HPasXsmocZYrBXqREkPVyN9c0Wps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wH62Kbg+EvdDSW7NCFGLKe+QXfB+qmH/7IAWqJvD3K7nQfjhZLFAmzcBkMbM3wu1I
         MRScdQeF38X8Bx4pVXCjXXNFHMm9JzzADLjjZH+f/SSu2M1c5qIKfpeHeQ1tRcgZ4z
         WIHJTex7omC1jBHjvIGK4MR/tv/18LlPbpy5k8r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen He <wen.he_1@nxp.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/90] drm/arm/mali-dp: Add a loop around the second set CVAL and try 5 times
Date:   Mon, 24 Jun 2019 17:56:45 +0800
Message-Id: <20190624092317.745033085@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6a88e0c14813d00f8520d0e16cd4136c6cf8b4d4 ]

This patch trying to fix monitor freeze issue caused by drm error
'flip_done timed out' on LS1028A platform. this set try is make a loop
around the second setting CVAL and try like 5 times before giveing up.

Signed-off-by: Wen He <wen.he_1@nxp.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_drv.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index 94d6dabec2dc..1ab511e33243 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -190,6 +190,7 @@ static void malidp_atomic_commit_hw_done(struct drm_atomic_state *state)
 {
 	struct drm_device *drm = state->dev;
 	struct malidp_drm *malidp = drm->dev_private;
+	int loop = 5;
 
 	malidp->event = malidp->crtc.state->event;
 	malidp->crtc.state->event = NULL;
@@ -204,8 +205,18 @@ static void malidp_atomic_commit_hw_done(struct drm_atomic_state *state)
 			drm_crtc_vblank_get(&malidp->crtc);
 
 		/* only set config_valid if the CRTC is enabled */
-		if (malidp_set_and_wait_config_valid(drm) < 0)
+		if (malidp_set_and_wait_config_valid(drm) < 0) {
+			/*
+			 * make a loop around the second CVAL setting and
+			 * try 5 times before giving up.
+			 */
+			while (loop--) {
+				if (!malidp_set_and_wait_config_valid(drm))
+					break;
+			}
 			DRM_DEBUG_DRIVER("timed out waiting for updated configuration\n");
+		}
+
 	} else if (malidp->event) {
 		/* CRTC inactive means vblank IRQ is disabled, send event directly */
 		spin_lock_irq(&drm->event_lock);
-- 
2.20.1



