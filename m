Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC8D3642C4
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbhDSNLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239777AbhDSNKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D574361369;
        Mon, 19 Apr 2021 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837811;
        bh=07fyHfePTqcu7mwntv5Jqbrm3xdWsZ0mEzRb0oiV66E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZK8rzpo7B2YM/WsYXI8cr7HBL7H7RI5piiIiQ6t5XaOCC/nrviw3Ec+36/d77z0zX
         6J2oRtkP37GqJq2yemm+I8Ixov6BbqCo5qzq1h10APIqKYDlJ9onrALvO2C86G3ggD
         l6Y1oFWwJc9jTEKl6Ze+e3Z4J82TbE1zhyELxykg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.11 061/122] drm/i915: Dont zero out the Y planes watermarks
Date:   Mon, 19 Apr 2021 15:05:41 +0200
Message-Id: <20210419130532.250125690@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit bf52dc49ba0101f648b4c3ea26b812061406b0d4 upstream.

Don't zero out the watermarks for the Y plane since we've already
computed them when computing the UV plane's watermarks (since the
UV plane always appears before ethe Y plane when iterating through
the planes).

This leads to allocating no DDB for the Y plane since .min_ddb_alloc
also gets zeroed. And that of course leads to underruns when scanning
out planar formats.

Cc: stable@vger.kernel.org
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: dbf71381d733 ("drm/i915: Nuke intel_atomic_crtc_state_for_each_plane_state() from skl+ wm code")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210327005945.4929-1-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit f99b805fb9413ff007ca0b6add871737664117dd)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5539,12 +5539,12 @@ static int icl_build_plane_wm(struct int
 	struct skl_plane_wm *wm = &crtc_state->wm.skl.raw.planes[plane_id];
 	int ret;
 
-	memset(wm, 0, sizeof(*wm));
-
 	/* Watermarks calculated in master */
 	if (plane_state->planar_slave)
 		return 0;
 
+	memset(wm, 0, sizeof(*wm));
+
 	if (plane_state->planar_linked_plane) {
 		const struct drm_framebuffer *fb = plane_state->hw.fb;
 		enum plane_id y_plane_id = plane_state->planar_linked_plane->id;


