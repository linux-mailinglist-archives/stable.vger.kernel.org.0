Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54CE4A426A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359623AbiAaLLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41462 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377102AbiAaLJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF95060F96;
        Mon, 31 Jan 2022 11:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C692C340E8;
        Mon, 31 Jan 2022 11:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627381;
        bh=H8Kqjec3vy20GA6mnXYJLGonJa+G2hoAOvhv1VCBA/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+RYh7TnTgtKe0Kit8HTV1C8g0EJvNz0nuCwM92eOUIFqzCylo6CnThxHtZnztMjA
         GcuZmNOuoRciuKIKH7jUm7atNusxmkTAC9aEJLuvS3PppqMrZXGZjy00q11bvECR9x
         SRJifsOJ5vf5Ne9v8SVCwl8Zq/dEnBKdCUrXWjcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Simon Ser <contact@emersion.fr>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        dri-devel@lists.freedesktop.org,
        Manasi Navare <manasi.d.navare@intel.com>
Subject: [PATCH 5.15 032/171] drm/atomic: Add the crtc to affected crtc only if uapi.enable = true
Date:   Mon, 31 Jan 2022 11:54:57 +0100
Message-Id: <20220131105231.108448665@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manasi Navare <manasi.d.navare@intel.com>

commit 5ec1cebd59300ddd26dbaa96c17c508764eef911 upstream.

In case of a modeset where a mode gets split across multiple CRTCs
in the driver specific implementation (bigjoiner in i915) we wrongly count
the affected CRTCs based on the drm_crtc_mask and indicate the stolen CRTC as
an affected CRTC in atomic_check_only().
This triggers a warning since affected CRTCs doent match requested CRTC.

To fix this in such bigjoiner configurations, we should only
increment affected crtcs if that CRTC is enabled in UAPI not
if it is just used internally in the driver to split the mode.

v3: Add the same uapi crtc_state->enable check in requested
crtc calc (Ville)

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Simon Ser <contact@emersion.fr>
Cc: Pekka Paalanen <pekka.paalanen@collabora.co.uk>
Cc: Daniel Stone <daniels@collabora.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.11+
Fixes: 919c2299a893 ("drm/i915: Enable bigjoiner")
Signed-off-by: Manasi Navare <manasi.d.navare@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211004115913.23889-1-manasi.d.navare@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1310,8 +1310,10 @@ int drm_atomic_check_only(struct drm_ato
 
 	DRM_DEBUG_ATOMIC("checking %p\n", state);
 
-	for_each_new_crtc_in_state(state, crtc, new_crtc_state, i)
-		requested_crtc |= drm_crtc_mask(crtc);
+	for_each_new_crtc_in_state(state, crtc, new_crtc_state, i) {
+		if (new_crtc_state->enable)
+			requested_crtc |= drm_crtc_mask(crtc);
+	}
 
 	for_each_oldnew_plane_in_state(state, plane, old_plane_state, new_plane_state, i) {
 		ret = drm_atomic_plane_check(old_plane_state, new_plane_state);
@@ -1360,8 +1362,10 @@ int drm_atomic_check_only(struct drm_ato
 		}
 	}
 
-	for_each_new_crtc_in_state(state, crtc, new_crtc_state, i)
-		affected_crtc |= drm_crtc_mask(crtc);
+	for_each_new_crtc_in_state(state, crtc, new_crtc_state, i) {
+		if (new_crtc_state->enable)
+			affected_crtc |= drm_crtc_mask(crtc);
+	}
 
 	/*
 	 * For commits that allow modesets drivers can add other CRTCs to the


