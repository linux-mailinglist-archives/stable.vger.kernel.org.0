Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDB26DABE
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbfGSED4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729690AbfGSED4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:03:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05796218A3;
        Fri, 19 Jul 2019 04:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509034;
        bh=KLNygqYyFHSspqiGbQoEEhnB0BiMvRcyv/HVld6ouGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gG92Eaf41xslAw5ZuRsfh3CNcCGf7LtU/QhL4z6rbN1kEtdsIrK5I1ygbhj3+39zH
         LJ9/UoL4yKlb8KIYdmOs1X5Za6zU72p8Ojzzt4p6EsRnzhAqZu8Rks4M/IYekL2qcd
         44XblHDPC8JmCOnU+yNf59bX3fNoCmts6013jx7M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Shayenne Moura <shayenneluzmoura@gmail.com>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 033/141] drm/vkms: Forward timer right after drm_crtc_handle_vblank
Date:   Fri, 19 Jul 2019 00:00:58 -0400
Message-Id: <20190719040246.15945-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

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
index 8a9aeb0a9ea8..0947a9f75c79 100644
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

