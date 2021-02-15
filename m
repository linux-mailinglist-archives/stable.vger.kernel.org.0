Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A7A31BD09
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhBOPi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231360AbhBOPhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DA5464ED6;
        Mon, 15 Feb 2021 15:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403136;
        bh=UwJWluWcNg2b6jt/cHSlCJiCOzOKbIm8NV448JHNE84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvqda1xLN02MB28cbaOFt5EeJeu+6ZXblRW4Un6CJvswoa1qYqbNPkpMF55rhcsyZ
         Q9xznzuCBo85DlOOBqUegDdpnrRWrlPjImACMsJZ/4Rfvdq8Gas2ie7L7ZCRl00mT5
         BOrcktB9Z/4F2wAMkeilRwIOCVqm+cFxfl1vt7gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 008/104] drm/i915: Fix overlay frontbuffer tracking
Date:   Mon, 15 Feb 2021 16:26:21 +0100
Message-Id: <20210215152719.736885823@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 5feba0e905c495a217aea9db4ea91093d8fe5dde upstream.

We don't have a persistent fb holding a reference to the frontbuffer
object, so every time we do the get+put we throw the frontbuffer object
immediately away. And so the next time around we get a pristine
frontbuffer object with bits==0 even for the old vma. This confuses
the frontbuffer tracking code which understandably expects the old
frontbuffer to have the overlay's bit set.

Fix this by hanging on to the frontbuffer reference until the next
flip. And just to make this a bit more clear let's track the frontbuffer
explicitly instead of just grabbing it via the old vma.

Cc: stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1136
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210209021918.16234-2-ville.syrjala@linux.intel.com
Fixes: 8e7cb1799b4f ("drm/i915: Extract intel_frontbuffer active tracking")
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
(cherry picked from commit 553c23bdb4775130f333f07a51b047276bc53f79)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_overlay.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -182,6 +182,7 @@ struct intel_overlay {
 	struct intel_crtc *crtc;
 	struct i915_vma *vma;
 	struct i915_vma *old_vma;
+	struct intel_frontbuffer *frontbuffer;
 	bool active;
 	bool pfit_active;
 	u32 pfit_vscale_ratio; /* shifted-point number, (1<<12) == 1.0 */
@@ -282,21 +283,19 @@ static void intel_overlay_flip_prepare(s
 				       struct i915_vma *vma)
 {
 	enum pipe pipe = overlay->crtc->pipe;
-	struct intel_frontbuffer *from = NULL, *to = NULL;
+	struct intel_frontbuffer *frontbuffer = NULL;
 
 	drm_WARN_ON(&overlay->i915->drm, overlay->old_vma);
 
-	if (overlay->vma)
-		from = intel_frontbuffer_get(overlay->vma->obj);
 	if (vma)
-		to = intel_frontbuffer_get(vma->obj);
+		frontbuffer = intel_frontbuffer_get(vma->obj);
 
-	intel_frontbuffer_track(from, to, INTEL_FRONTBUFFER_OVERLAY(pipe));
+	intel_frontbuffer_track(overlay->frontbuffer, frontbuffer,
+				INTEL_FRONTBUFFER_OVERLAY(pipe));
 
-	if (to)
-		intel_frontbuffer_put(to);
-	if (from)
-		intel_frontbuffer_put(from);
+	if (overlay->frontbuffer)
+		intel_frontbuffer_put(overlay->frontbuffer);
+	overlay->frontbuffer = frontbuffer;
 
 	intel_frontbuffer_flip_prepare(overlay->i915,
 				       INTEL_FRONTBUFFER_OVERLAY(pipe));


