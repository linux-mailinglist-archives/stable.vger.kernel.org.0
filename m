Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A2C1D8304
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbgERSBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732362AbgERSBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50956207C4;
        Mon, 18 May 2020 18:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824876;
        bh=eaIyUyzCHnzRegr0eSHfSrV6GZNmMPomomNCa6DpJwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZE8mQUWneyQMy0jB3tohFClVYSNTEvE1ybZN547BkJ6817bTD5LX5AmXrcwFH7Chb
         4TIybUEVwiHBpekB/Ackp0531R/ADUPpKexMZR1DgYpjgDVIKsPhrRWw5V6zQpi/r1
         b3PBWCdMZi/Jlp/qoXLDiV1MrxR/V6d7TJyLZhgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Atwood <matthew.s.atwood@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 005/194] drm/i915/tgl: Add Wa_14010477008:tgl
Date:   Mon, 18 May 2020 19:34:55 +0200
Message-Id: <20200518173532.024625982@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 81fdd7bfeb8e8f76bcdfef9174ec580707c37d38 ]

Media decompression support should not be advertised on any display
planes for steppings A0-C0.

Bspec: 53273
Fixes: 2dfbf9d2873a ("drm/i915/tgl: Gen-12 display can decompress surfaces compressed by the media engine")
Cc: Matt Atwood <matthew.s.atwood@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200414211118.2787489-3-matthew.d.roper@intel.com
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit dbff5a8db9c630f61a892ab41a283445e01270f5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_sprite.c | 17 ++++++++++++-----
 drivers/gpu/drm/i915/i915_drv.h             |  2 ++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_sprite.c b/drivers/gpu/drm/i915/display/intel_sprite.c
index fca77ec1e0ddf..f55404a94eba6 100644
--- a/drivers/gpu/drm/i915/display/intel_sprite.c
+++ b/drivers/gpu/drm/i915/display/intel_sprite.c
@@ -2754,19 +2754,25 @@ static bool skl_plane_format_mod_supported(struct drm_plane *_plane,
 	}
 }
 
-static bool gen12_plane_supports_mc_ccs(enum plane_id plane_id)
+static bool gen12_plane_supports_mc_ccs(struct drm_i915_private *dev_priv,
+					enum plane_id plane_id)
 {
+	/* Wa_14010477008:tgl[a0..c0] */
+	if (IS_TGL_REVID(dev_priv, TGL_REVID_A0, TGL_REVID_C0))
+		return false;
+
 	return plane_id < PLANE_SPRITE4;
 }
 
 static bool gen12_plane_format_mod_supported(struct drm_plane *_plane,
 					     u32 format, u64 modifier)
 {
+	struct drm_i915_private *dev_priv = to_i915(_plane->dev);
 	struct intel_plane *plane = to_intel_plane(_plane);
 
 	switch (modifier) {
 	case I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS:
-		if (!gen12_plane_supports_mc_ccs(plane->id))
+		if (!gen12_plane_supports_mc_ccs(dev_priv, plane->id))
 			return false;
 		/* fall through */
 	case DRM_FORMAT_MOD_LINEAR:
@@ -2935,9 +2941,10 @@ static const u32 *icl_get_plane_formats(struct drm_i915_private *dev_priv,
 	}
 }
 
-static const u64 *gen12_get_plane_modifiers(enum plane_id plane_id)
+static const u64 *gen12_get_plane_modifiers(struct drm_i915_private *dev_priv,
+					    enum plane_id plane_id)
 {
-	if (gen12_plane_supports_mc_ccs(plane_id))
+	if (gen12_plane_supports_mc_ccs(dev_priv, plane_id))
 		return gen12_plane_format_modifiers_mc_ccs;
 	else
 		return gen12_plane_format_modifiers_rc_ccs;
@@ -3008,7 +3015,7 @@ skl_universal_plane_create(struct drm_i915_private *dev_priv,
 
 	plane->has_ccs = skl_plane_has_ccs(dev_priv, pipe, plane_id);
 	if (INTEL_GEN(dev_priv) >= 12) {
-		modifiers = gen12_get_plane_modifiers(plane_id);
+		modifiers = gen12_get_plane_modifiers(dev_priv, plane_id);
 		plane_funcs = &gen12_plane_funcs;
 	} else {
 		if (plane->has_ccs)
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 810e3ccd56ecb..dff1342651126 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1601,6 +1601,8 @@ IS_SUBPLATFORM(const struct drm_i915_private *i915,
 	(IS_ICELAKE(p) && IS_REVID(p, since, until))
 
 #define TGL_REVID_A0		0x0
+#define TGL_REVID_B0		0x1
+#define TGL_REVID_C0		0x2
 
 #define IS_TGL_REVID(p, since, until) \
 	(IS_TIGERLAKE(p) && IS_REVID(p, since, until))
-- 
2.20.1



