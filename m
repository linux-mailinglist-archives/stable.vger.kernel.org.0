Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B525E795F2
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389922AbfG2TrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390301AbfG2TrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1302C217F5;
        Mon, 29 Jul 2019 19:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429629;
        bh=zHWQ4vB4yChNAxj7Pubo3/hI2N8Gu8lbnnRHWq8vIg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSiUUBSt+fUBS+XrWQTVyVmC2XH+33uLr1Z0B74xA6zgF0AdP8EM0Mp31y/HmWTdV
         qEjVbQogaoqNfCBY2jm3mNfSEW9bdtlhCX7uQRROU1soGxvx8XYWDrtvS/uRBQmVIz
         LXMlqn5ryRP9tcfM43wSg0YJAC7FLxgyANHSQVOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shayenne Moura <shayenneluzmoura@gmail.com>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 045/215] drm/vkms: Forward timer right after drm_crtc_handle_vblank
Date:   Mon, 29 Jul 2019 21:20:41 +0200
Message-Id: <20190729190748.348003180@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7355965da22b8d9ebac8bce4b776399fb0bb9d32 ]

In

commit def35e7c592616bc09be328de8795e5e624a3cf8
Author: Shayenne Moura <shayenneluzmoura@gmail.com>
Date:   Wed Jan 30 14:06:36 2019 -0200

    drm/vkms: Bugfix extra vblank frame

we fixed the vblank counter to give accurate results outside of
drm_crtc_handle_vblank, which fixed bugs around vblank timestamps
being off-by-one and causing the vblank counter to jump when it
shouldn't.

The trouble is that this completely broke crc generation. Shayenne and
Rodrigo tracked this down to the vblank timestamp going backwards in
time somehow. Which then resulted in an underflow in drm_vblank.c
code, which resulted in all kinds of things breaking really badly.

The reason for this is that once we've called drm_crtc_handle_vblank
and the hrtimer isn't forwarded yet, we're returning a vblank
timestamp in the past. This race is really hard to hit since it's
small, except when you enable crc generation: In that case there's a
call to drm_crtc_accurate_vblank right in-betwen, so we're guaranteed
to hit the bug.

The fix is to roll the hrtimer forward _before_ we do the vblank
processing (which has a side-effect of incrementing the vblank
counter), and we always subtract one frame from the hrtimer - since
now it's always one frame in the future.

To make sure we don't hit this again also add a WARN_ON checking for
whether our timestamp is somehow moving into the past, which is never
should.

This also aligns more with how real hw works:
1. first all registers are updated with the new timestamp/vblank
counter values.
2. then an interrupt is generated
3. kernel interrupt handler eventually fires.

So doing this aligns vkms closer with what drm_vblank.c expects.
Document this also in a comment.

Cc: Shayenne Moura <shayenneluzmoura@gmail.com>
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Tested-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Reviewed-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Signed-off-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190606084404.12014-1-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_crtc.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vkms/vkms_crtc.c b/drivers/gpu/drm/vkms/vkms_crtc.c
index bb66dbcd5e3f..e447b7588d06 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -15,6 +15,10 @@ static enum hrtimer_restart vkms_vblank_simulate(struct hrtimer *timer)
 
 	spin_lock(&output->lock);
 
+	ret_overrun = hrtimer_forward_now(&output->vblank_hrtimer,
+					  output->period_ns);
+	WARN_ON(ret_overrun != 1);
+
 	ret = drm_crtc_handle_vblank(crtc);
 	if (!ret)
 		DRM_ERROR("vkms failure on handling vblank");
@@ -35,10 +39,6 @@ static enum hrtimer_restart vkms_vblank_simulate(struct hrtimer *timer)
 			DRM_WARN("failed to queue vkms_crc_work_handle");
 	}
 
-	ret_overrun = hrtimer_forward_now(&output->vblank_hrtimer,
-					  output->period_ns);
-	WARN_ON(ret_overrun != 1);
-
 	spin_unlock(&output->lock);
 
 	return HRTIMER_RESTART;
@@ -74,11 +74,21 @@ bool vkms_get_vblank_timestamp(struct drm_device *dev, unsigned int pipe,
 {
 	struct vkms_device *vkmsdev = drm_device_to_vkms_device(dev);
 	struct vkms_output *output = &vkmsdev->output;
+	struct drm_vblank_crtc *vblank = &dev->vblank[pipe];
 
 	*vblank_time = output->vblank_hrtimer.node.expires;
 
-	if (!in_vblank_irq)
-		*vblank_time -= output->period_ns;
+	if (WARN_ON(*vblank_time == vblank->time))
+		return true;
+
+	/*
+	 * To prevent races we roll the hrtimer forward before we do any
+	 * interrupt processing - this is how real hw works (the interrupt is
+	 * only generated after all the vblank registers are updated) and what
+	 * the vblank core expects. Therefore we need to always correct the
+	 * timestampe by one frame.
+	 */
+	*vblank_time -= output->period_ns;
 
 	return true;
 }
-- 
2.20.1



