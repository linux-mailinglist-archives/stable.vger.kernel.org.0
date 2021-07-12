Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C156A3C5370
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352414AbhGLHyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350348AbhGLHu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE7A61492;
        Mon, 12 Jul 2021 07:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075887;
        bh=AzgD081GVOj1nSJ9aqmz22YnS93jMMGKGDUINaY2tRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJZTgoVG5fzsGGXXfy98hdjYJZ+i7sDtyTtft8Z+sl/vPsFk5ysimnitjJBxxOm7u
         BcPMMoh+VAVhs/Z39TSqZkxc4cnzc/spFmfkWTvXMsSQAWeIQtyYwb4pqA2tU4lDOV
         LL31WioAcL9slt0e4wJZskBlWXcOLB2QMtIt5fx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dri-devel@lists.freedesktop.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 407/800] drm/i915: Merge fix for "drm: Switch to %p4cc format modifier"
Date:   Mon, 12 Jul 2021 08:07:10 +0200
Message-Id: <20210712061010.458667018@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

[ Upstream commit e3c2f1870af43fc95f6fe141537f5142c5fe4717 ]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 92f1d09ca4ed ("drm: Switch to %p4cc format modifier")
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Link: https://lore.kernel.org/dri-devel/20210514115307.4364aff9@canb.auug.org.au/T/#macc61d4e0b17ca0da2b26aae8fbbcbf47324da13
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_universal_plane.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_universal_plane.c b/drivers/gpu/drm/i915/display/skl_universal_plane.c
index 7ffd7b570b54..538682f882b1 100644
--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -1082,7 +1082,6 @@ static int skl_plane_check_fb(const struct intel_crtc_state *crtc_state,
 	struct drm_i915_private *dev_priv = to_i915(plane->base.dev);
 	const struct drm_framebuffer *fb = plane_state->hw.fb;
 	unsigned int rotation = plane_state->hw.rotation;
-	struct drm_format_name_buf format_name;
 
 	if (!fb)
 		return 0;
@@ -1130,9 +1129,8 @@ static int skl_plane_check_fb(const struct intel_crtc_state *crtc_state,
 		case DRM_FORMAT_XVYU12_16161616:
 		case DRM_FORMAT_XVYU16161616:
 			drm_dbg_kms(&dev_priv->drm,
-				    "Unsupported pixel format %s for 90/270!\n",
-				    drm_get_format_name(fb->format->format,
-							&format_name));
+				    "Unsupported pixel format %p4cc for 90/270!\n",
+				    &fb->format->format);
 			return -EINVAL;
 		default:
 			break;
-- 
2.30.2



