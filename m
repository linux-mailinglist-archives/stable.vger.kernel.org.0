Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5DC7119A30
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfLJVu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:50:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727346AbfLJVIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E1082469A;
        Tue, 10 Dec 2019 21:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012103;
        bh=hkuGnP/PLW8F2sD5+lSiGHfF7zSle7mPzYmQLvYVfY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rF1wU76s4X6gT3W5xrpX5y4Ee0aHSIvE6H38Jd8LbB+NG+fSELF0m7C0Za1r2a8RW
         x1KAdio+PeDo0SVNMC1e9H87/jW2IjxuLai9OOcq/JocSTVASF4EFhwfAj7eOvzupm
         QHsS0sMF2ValeehXQG+7y6fBNmXfYM7bSaz74ZZc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Keith Packard <keithp@keithp.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 078/350] drm/drm_vblank: Change EINVAL by the correct errno
Date:   Tue, 10 Dec 2019 16:03:03 -0500
Message-Id: <20191210210735.9077-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>

[ Upstream commit aed6105b28b10613f16c0bfe97525fe5a23338df ]

For historical reasons, the function drm_wait_vblank_ioctl always return
-EINVAL if something gets wrong. This scenario limits the flexibility
for the userspace to make detailed verification of any problem and take
some action. In particular, the validation of “if (!dev->irq_enabled)”
in the drm_wait_vblank_ioctl is responsible for checking if the driver
support vblank or not. If the driver does not support VBlank, the
function drm_wait_vblank_ioctl returns EINVAL, which does not represent
the real issue; this patch changes this behavior by return EOPNOTSUPP.
Additionally, drm_crtc_get_sequence_ioctl and
drm_crtc_queue_sequence_ioctl, also returns EINVAL if vblank is not
supported; this patch also changes the return value to EOPNOTSUPP in
these functions. Lastly, these functions are invoked by libdrm, which is
used by many compositors; because of this, it is important to check if
this change breaks any compositor. In this sense, the following projects
were examined:

* Drm-hwcomposer
* Kwin
* Sway
* Wlroots
* Wayland
* Weston
* Mutter
* Xorg (67 different drivers)

For each repository the verification happened in three steps:

* Update the main branch
* Look for any occurrence of "drmCrtcQueueSequence",
  "drmCrtcGetSequence", and "drmWaitVBlank" with the command git grep -n
  "STRING".
* Look in the git history of the project with the command
git log -S<STRING>

None of the above projects validate the use of EINVAL when using
drmWaitVBlank(), which make safe, at least for these projects, to change
the return values. On the other hand, mesa and xserver project uses
drmCrtcQueueSequence() and drmCrtcGetSequence(); this change is harmless
for both projects.

Change since V5 (Pekka Paalanen):
 - Check if the change also affects Mutter

Change since V4 (Daniel):
 - Also return EOPNOTSUPP in drm_crtc_[get|queue]_sequence_ioctl

Change since V3:
 - Return EINVAL for _DRM_VBLANK_SIGNAL (Daniel)

Change since V2:
 Daniel Vetter and Chris Wilson
 - Replace ENOTTY by EOPNOTSUPP
 - Return EINVAL if the parameters are wrong

Cc: Keith Packard <keithp@keithp.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Signed-off-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191002140516.adeyj3htylimmlmg@smtp.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_vblank.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
index fd1fbc77871f1..552ec82e9bc52 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -1581,7 +1581,7 @@ int drm_wait_vblank_ioctl(struct drm_device *dev, void *data,
 	unsigned int flags, pipe, high_pipe;
 
 	if (!dev->irq_enabled)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (vblwait->request.type & _DRM_VBLANK_SIGNAL)
 		return -EINVAL;
@@ -1838,7 +1838,7 @@ int drm_crtc_get_sequence_ioctl(struct drm_device *dev, void *data,
 		return -EOPNOTSUPP;
 
 	if (!dev->irq_enabled)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	crtc = drm_crtc_find(dev, file_priv, get_seq->crtc_id);
 	if (!crtc)
@@ -1896,7 +1896,7 @@ int drm_crtc_queue_sequence_ioctl(struct drm_device *dev, void *data,
 		return -EOPNOTSUPP;
 
 	if (!dev->irq_enabled)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	crtc = drm_crtc_find(dev, file_priv, queue_seq->crtc_id);
 	if (!crtc)
-- 
2.20.1

