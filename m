Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D5AB1F00
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389582AbfIMNOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389572AbfIMNOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:47 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0D26214D8;
        Fri, 13 Sep 2019 13:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380486;
        bh=4a0vGrW+CnmkDDaS4x/PjJ+/2ynwK9Nw6PbHXjSevbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZTbKVCK/rhhzGuVohcnm6sllPX2Z9jTrsSctuBANHZjByReBK9icFVY30xGPFeKg
         kgzcjm2fOHYFKxPCRk8pr1cH24kYEYJWLzS+H98PpIr1CUqURsptaL9xyqj6ZbWy8Z
         sCLoV5unfUtNE+faSbuq3qrKfuecADxIrw56mM1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/190] drm/vblank: Allow dynamic per-crtc max_vblank_count
Date:   Fri, 13 Sep 2019 14:05:36 +0100
Message-Id: <20190913130605.989659274@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ed20151a7699bb2c77eba3610199789a126940c4 ]

On i965gm we need to adjust max_vblank_count dynamically
depending on whether the TV encoder is used or not. To
that end add a per-crtc max_vblank_count that takes
precedence over its device wide counterpart. The driver
can now call drm_crtc_set_max_vblank_count() to configure
the per-crtc value before calling drm_vblank_on().

Also looks like there was some discussion about exynos needing
similar treatment.

v2: Drop the extra max_vblank_count!=0 check for the
    WARN(last!=current), will take care of it in i915 code (Daniel)
    WARN_ON(!inmodeset) (Daniel)
    WARN_ON(dev->max_vblank_count)
    Pimp up the docs (Daniel)

Cc: stable@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181127182004.28885-1-ville.syrjala@linux.intel.com
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_vblank.c | 45 +++++++++++++++++++++++++++++++++---
 include/drm/drm_device.h     |  8 ++++++-
 include/drm/drm_vblank.h     | 22 ++++++++++++++++++
 3 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
index 28cdcf76b6f99..d1859bcc7ccbc 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -105,13 +105,20 @@ static void store_vblank(struct drm_device *dev, unsigned int pipe,
 	write_sequnlock(&vblank->seqlock);
 }
 
+static u32 drm_max_vblank_count(struct drm_device *dev, unsigned int pipe)
+{
+	struct drm_vblank_crtc *vblank = &dev->vblank[pipe];
+
+	return vblank->max_vblank_count ?: dev->max_vblank_count;
+}
+
 /*
  * "No hw counter" fallback implementation of .get_vblank_counter() hook,
  * if there is no useable hardware frame counter available.
  */
 static u32 drm_vblank_no_hw_counter(struct drm_device *dev, unsigned int pipe)
 {
-	WARN_ON_ONCE(dev->max_vblank_count != 0);
+	WARN_ON_ONCE(drm_max_vblank_count(dev, pipe) != 0);
 	return 0;
 }
 
@@ -198,6 +205,7 @@ static void drm_update_vblank_count(struct drm_device *dev, unsigned int pipe,
 	ktime_t t_vblank;
 	int count = DRM_TIMESTAMP_MAXRETRIES;
 	int framedur_ns = vblank->framedur_ns;
+	u32 max_vblank_count = drm_max_vblank_count(dev, pipe);
 
 	/*
 	 * Interrupts were disabled prior to this call, so deal with counter
@@ -216,9 +224,9 @@ static void drm_update_vblank_count(struct drm_device *dev, unsigned int pipe,
 		rc = drm_get_last_vbltimestamp(dev, pipe, &t_vblank, in_vblank_irq);
 	} while (cur_vblank != __get_vblank_counter(dev, pipe) && --count > 0);
 
-	if (dev->max_vblank_count != 0) {
+	if (max_vblank_count) {
 		/* trust the hw counter when it's around */
-		diff = (cur_vblank - vblank->last) & dev->max_vblank_count;
+		diff = (cur_vblank - vblank->last) & max_vblank_count;
 	} else if (rc && framedur_ns) {
 		u64 diff_ns = ktime_to_ns(ktime_sub(t_vblank, vblank->time));
 
@@ -1204,6 +1212,37 @@ void drm_crtc_vblank_reset(struct drm_crtc *crtc)
 }
 EXPORT_SYMBOL(drm_crtc_vblank_reset);
 
+/**
+ * drm_crtc_set_max_vblank_count - configure the hw max vblank counter value
+ * @crtc: CRTC in question
+ * @max_vblank_count: max hardware vblank counter value
+ *
+ * Update the maximum hardware vblank counter value for @crtc
+ * at runtime. Useful for hardware where the operation of the
+ * hardware vblank counter depends on the currently active
+ * display configuration.
+ *
+ * For example, if the hardware vblank counter does not work
+ * when a specific connector is active the maximum can be set
+ * to zero. And when that specific connector isn't active the
+ * maximum can again be set to the appropriate non-zero value.
+ *
+ * If used, must be called before drm_vblank_on().
+ */
+void drm_crtc_set_max_vblank_count(struct drm_crtc *crtc,
+				   u32 max_vblank_count)
+{
+	struct drm_device *dev = crtc->dev;
+	unsigned int pipe = drm_crtc_index(crtc);
+	struct drm_vblank_crtc *vblank = &dev->vblank[pipe];
+
+	WARN_ON(dev->max_vblank_count);
+	WARN_ON(!READ_ONCE(vblank->inmodeset));
+
+	vblank->max_vblank_count = max_vblank_count;
+}
+EXPORT_SYMBOL(drm_crtc_set_max_vblank_count);
+
 /**
  * drm_crtc_vblank_on - enable vblank events on a CRTC
  * @crtc: CRTC in question
diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
index f9c6e0e3aec7d..fa117e11458ae 100644
--- a/include/drm/drm_device.h
+++ b/include/drm/drm_device.h
@@ -174,7 +174,13 @@ struct drm_device {
 	 * races and imprecision over longer time periods, hence exposing a
 	 * hardware vblank counter is always recommended.
 	 *
-	 * If non-zeor, &drm_crtc_funcs.get_vblank_counter must be set.
+	 * This is the statically configured device wide maximum. The driver
+	 * can instead choose to use a runtime configurable per-crtc value
+	 * &drm_vblank_crtc.max_vblank_count, in which case @max_vblank_count
+	 * must be left at zero. See drm_crtc_set_max_vblank_count() on how
+	 * to use the per-crtc value.
+	 *
+	 * If non-zero, &drm_crtc_funcs.get_vblank_counter must be set.
 	 */
 	u32 max_vblank_count;           /**< size of vblank counter register */
 
diff --git a/include/drm/drm_vblank.h b/include/drm/drm_vblank.h
index d25a9603ab570..e9c676381fd4f 100644
--- a/include/drm/drm_vblank.h
+++ b/include/drm/drm_vblank.h
@@ -128,6 +128,26 @@ struct drm_vblank_crtc {
 	 * @last: Protected by &drm_device.vbl_lock, used for wraparound handling.
 	 */
 	u32 last;
+	/**
+	 * @max_vblank_count:
+	 *
+	 * Maximum value of the vblank registers for this crtc. This value +1
+	 * will result in a wrap-around of the vblank register. It is used
+	 * by the vblank core to handle wrap-arounds.
+	 *
+	 * If set to zero the vblank core will try to guess the elapsed vblanks
+	 * between times when the vblank interrupt is disabled through
+	 * high-precision timestamps. That approach is suffering from small
+	 * races and imprecision over longer time periods, hence exposing a
+	 * hardware vblank counter is always recommended.
+	 *
+	 * This is the runtime configurable per-crtc maximum set through
+	 * drm_crtc_set_max_vblank_count(). If this is used the driver
+	 * must leave the device wide &drm_device.max_vblank_count at zero.
+	 *
+	 * If non-zero, &drm_crtc_funcs.get_vblank_counter must be set.
+	 */
+	u32 max_vblank_count;
 	/**
 	 * @inmodeset: Tracks whether the vblank is disabled due to a modeset.
 	 * For legacy driver bit 2 additionally tracks whether an additional
@@ -206,4 +226,6 @@ bool drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev,
 void drm_calc_timestamping_constants(struct drm_crtc *crtc,
 				     const struct drm_display_mode *mode);
 wait_queue_head_t *drm_crtc_vblank_waitqueue(struct drm_crtc *crtc);
+void drm_crtc_set_max_vblank_count(struct drm_crtc *crtc,
+				   u32 max_vblank_count);
 #endif
-- 
2.20.1



