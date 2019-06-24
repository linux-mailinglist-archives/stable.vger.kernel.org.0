Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBED508CA
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfFXKVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfFXKVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:21:43 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A938A20645;
        Mon, 24 Jun 2019 10:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371702;
        bh=bD9YaJqBlzl1KE7+ecKFBN9ZNPFXK3KxohStnliNm60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK4nLNRpFig/SrmIREvUXfevaopa8Rhg5qLROSeEUmhGS802jXyOuhD95rHi969VC
         dxrMGUMU/5RoS6WfHq+QtDYWfzYaIr0bpPbYo4l9E5MBnW1Ce1KY0XHhGaEQbO+Mu1
         ArWRExiFSbJz0A8DXXpIyCXtddozghRltfwhIRIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen He <wen.he_1@nxp.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 070/121] drm/arm/mali-dp: Add a loop around the second set CVAL and try 5 times
Date:   Mon, 24 Jun 2019 17:56:42 +0800
Message-Id: <20190624092324.454603668@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
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
index ab50ad06e271..64da56f4b0cf 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -192,6 +192,7 @@ static void malidp_atomic_commit_hw_done(struct drm_atomic_state *state)
 {
 	struct drm_device *drm = state->dev;
 	struct malidp_drm *malidp = drm->dev_private;
+	int loop = 5;
 
 	malidp->event = malidp->crtc.state->event;
 	malidp->crtc.state->event = NULL;
@@ -206,8 +207,18 @@ static void malidp_atomic_commit_hw_done(struct drm_atomic_state *state)
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



