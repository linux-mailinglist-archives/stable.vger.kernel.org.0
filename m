Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6081ACE57
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 19:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732667AbgDPRE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 13:04:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:7421 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393172AbgDPREY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 13:04:24 -0400
IronPort-SDR: H5AgMknRdKdZN0hChy6pcEyS5DRO/u/35BNhhnfDb0TzGoLnexPFfq4xVxajCZpHmqZjGWtdM8
 ipvB/Lw0NKKQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 10:04:23 -0700
IronPort-SDR: CHlCpPPTn0wP84hCQFbtidgGiD3xrJB8aLRxv3YCNK+vUaNWxQe/io2+hmePQGg7C1FALNcyqo
 SKp8Y1qqAmWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="277385993"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga008.jf.intel.com with SMTP; 16 Apr 2020 10:04:20 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 16 Apr 2020 20:04:20 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] drm: Fix page flip ioctl format check
Date:   Thu, 16 Apr 2020 20:04:20 +0300
Message-Id: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Revert back to comparing fb->format->format instead fb->format for the
page flip ioctl. This check was originally only here to disallow pixel
format changes, but when we changed it to do the pointer comparison
we potentially started to reject some (but definitely not all) modifier
changes as well. In fact the current behaviour depends on whether the
driver overrides the format info for a specific format+modifier combo.
Eg. on i915 this now rejects compression vs. no compression changes but
does not reject any other tiling changes. That's just inconsistent
nonsense.

The main reason we have to go back to the old behaviour is to fix page
flipping with Xorg. At some point Xorg got its atomic rights taken away
and since then we can't page flip between compressed and non-compressed
fbs on i915. Currently we get no page flipping for any games pretty much
since Mesa likes to use compressed buffers. Not sure how compositors are
working around this (don't use one myself). I guess they must be doing
something to get non-compressed buffers instead. Either that or
somehow no one noticed the tearing from the blit fallback.

Looking back at the original discussion on this change we pretty much
just did it in the name of skipping a few extra pointer dereferences.
However, I've decided not to revert the whole thing in case someone
has since started to depend on these changes. None of the other checks
are relevant for i915 anyways.

Cc: stable@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Fixes: dbd4d5761e1f ("drm: Replace 'format->format' comparisons to just 'format' comparisons")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/drm_plane.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
index d6ad60ab0d38..f2ca5315f23b 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -1153,7 +1153,7 @@ int drm_mode_page_flip_ioctl(struct drm_device *dev,
 	if (ret)
 		goto out;
 
-	if (old_fb->format != fb->format) {
+	if (old_fb->format->format != fb->format->format) {
 		DRM_DEBUG_KMS("Page flip is not allowed to change frame buffer format.\n");
 		ret = -EINVAL;
 		goto out;
-- 
2.24.1

