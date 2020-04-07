Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0AA1A0BFC
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgDGKcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgDGKcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:32:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE64120644;
        Tue,  7 Apr 2020 10:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255560;
        bh=EaD1Kn8VYLmOGXzmva1zo3k7Zh6m00qrt36XnH0ewDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vA99e8UPNHYo3pYUYHDTE7eQ97fLq0UkdmEul5qO+W+/A5dsd3rL+D5x3dml2XvM5
         pOEkwFVqEosxXA2U928ZlzIgu7rh9utz8EOLNwmOkJqQUyQkQQG1Xi8aijN1Vctnsp
         Zmk/gPepk5R6DwBQpraJ3diS2Wh7OK5Ml4yvQEUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4?= <ville.syrjala@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        "Souza, Jose" <jose.souza@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        SweeAun Khor <swee.aun.khor@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Giacomo Comes <comes@naic.edu>
Subject: [PATCH 5.6 14/29] drm/i915/display: Fix mode private_flags comparison at atomic_check
Date:   Tue,  7 Apr 2020 12:22:11 +0200
Message-Id: <20200407101453.730127410@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uma Shankar <uma.shankar@intel.com>

commit 2bdd4c28baff29163808677a70942de2b45f17dc upstream.

This patch fixes the private_flags of mode to be checked and
compared against uapi.mode and not from hw.mode. This helps
properly trigger modeset at boot if desired by driver.

It helps resolve audio_codec initialization issues if display
is connected at boot. Initial discussion on this issue has happened
on below thread:
https://patchwork.freedesktop.org/series/74828/

v2: No functional change. Fixed the Closes tag and added
Maarten's RB.

v3: Added Fixes tag.

Cc: Ville Syrjä <ville.syrjala@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: Souza, Jose <jose.souza@intel.com>
Fixes: 58d124ea2739 ("drm/i915: Complete crtc hw/uapi split, v6.")
Closes: https://gitlab.freedesktop.org/drm/intel/issues/1363
Suggested-by: Ville Syrjä <ville.syrjala@linux.intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: SweeAun Khor <swee.aun.khor@intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200326125111.11081-1-uma.shankar@intel.com
(cherry picked from commit d5e56705927e00f703b2eb5a98299dd6622d16e5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Giacomo Comes <comes@naic.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -14582,8 +14582,8 @@ static int intel_atomic_check(struct drm
 	/* Catch I915_MODE_FLAG_INHERITED */
 	for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
 					    new_crtc_state, i) {
-		if (new_crtc_state->hw.mode.private_flags !=
-		    old_crtc_state->hw.mode.private_flags)
+		if (new_crtc_state->uapi.mode.private_flags !=
+		    old_crtc_state->uapi.mode.private_flags)
 			new_crtc_state->uapi.mode_changed = true;
 	}
 


