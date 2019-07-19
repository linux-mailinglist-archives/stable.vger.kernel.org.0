Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A226DFF0
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfGSD60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728032AbfGSD60 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54A1E2189D;
        Fri, 19 Jul 2019 03:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508705;
        bh=sjTpvekg/2jA/Awx9NsiMfabj+abuEMmkKiAxKHsi9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwZTS6WDBmSQ7cizhIbPh+6YnFCMMN+wOE6jPo6F0geUjp54XMXIkd4kCMJBUpu87
         M3avqzucB+dtzURI0/TAphm9AMOr1X9+ZnYXahjUplMmc2nz238qkLkRZNI0s6Z8lE
         Ef26n4OpEzU4MqdRgmUEYi9581bN8WUz3nmd7xy8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Shayenne Moura <shayenneluzmoura@gmail.com>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 043/171] drm/vkms: Forward timer right after drm_crtc_handle_vblank
Date:   Thu, 18 Jul 2019 23:54:34 -0400
Message-Id: <20190719035643.14300-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
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

