Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC8AD9E85
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438526AbfJPV7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438521AbfJPV73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:29 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38610218DE;
        Wed, 16 Oct 2019 21:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263169;
        bh=HCHL/0b7wsmiqEtQgSxAV7TiQ81FqSzff9r9X6rGXcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecYO2DUNllefL2QgnUUuXp+/B2AdMHl/onEUGWDoMbqmof7sYIhmh37WghTe7y9cJ
         GhdmK5sXYnvw+Keki4hMd69HcAfImtqVVE13KkmNrLYMW2nxNrMSD+8YGqMIzrY0im
         VllLuaiuLJHhuM8qnaQkFoPCxH45ZBpEoO7QpKd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Leho Kraav <leho@kraav.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 097/112] drm/i915: Bump skl+ max plane width to 5k for linear/x-tiled
Date:   Wed, 16 Oct 2019 14:51:29 -0700
Message-Id: <20191016214906.115287254@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit dc7890995e04bacb45ab21e0daaeae1e7c803eb3 upstream.

The officially validated plane width limit is 4k on skl+, however
we already had people using 5k displays before we started to enforce
the limit. Also it seems Windows allows 5k resolutions as well
(though not sure if they do it with one plane or two).

According to hw folks 5k should work with the possible
exception of the following features:
- Ytile (already limited to 4k)
- FP16 (already limited to 4k)
- render compression (already limited to 4k)
- KVMR sprite and cursor (don't care)
- horizontal panning (need to verify this)
- pipe and plane scaling (need to verify this)

So apart from last two items on that list we are already
fine. We should really verify what happens with those last
two items but I don't have a 5k display on hand atm so it'll
have to wait.

In the meantime let's just bump the limit back up to 5k since
several users have already been using it without apparent issues.
At least we'll be no worse off than we were prior to lowering
the limits.

Cc: stable@vger.kernel.org
Cc: Sean Paul <sean@poorly.run>
Cc: José Roberto de Souza <jose.souza@intel.com>
Tested-by: Leho Kraav <leho@kraav.com>
Fixes: 372b9ffb5799 ("drm/i915: Fix skl+ max plane width")
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111501
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190905135044.2001-1-ville.syrjala@linux.intel.com
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Sean Paul <sean@poorly.run>
(cherry picked from commit bed34ef544f9ab37ab349c04cf4142282c4dcf5d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -3291,7 +3291,20 @@ static int skl_max_plane_width(const str
 	switch (fb->modifier) {
 	case DRM_FORMAT_MOD_LINEAR:
 	case I915_FORMAT_MOD_X_TILED:
-		return 4096;
+		/*
+		 * Validated limit is 4k, but has 5k should
+		 * work apart from the following features:
+		 * - Ytile (already limited to 4k)
+		 * - FP16 (already limited to 4k)
+		 * - render compression (already limited to 4k)
+		 * - KVMR sprite and cursor (don't care)
+		 * - horizontal panning (TODO verify this)
+		 * - pipe and plane scaling (TODO verify this)
+		 */
+		if (cpp == 8)
+			return 4096;
+		else
+			return 5120;
 	case I915_FORMAT_MOD_Y_TILED_CCS:
 	case I915_FORMAT_MOD_Yf_TILED_CCS:
 		/* FIXME AUX plane? */


