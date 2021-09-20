Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2E2412503
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349170AbhITSlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346748AbhITShT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EE376141B;
        Mon, 20 Sep 2021 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158985;
        bh=Dl4mxtMwzlTqQKa07pgktE0TjFGpjOgMFhdd7xXD0VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6GHbgcCgQPd2i55wPC1LwXHqYyZOYc7AUpWJEGJ+x1leMDvzRjOQkujUMmE/djoe
         9yMOl/C5Ia1/CYYMGwAK+9QRuinrZd2yKIaQb16ThJMjo9ynsupsbPDOEXH5+OycJV
         T6iR5oi6+Sb0BzQ+NAIy8jHv0WBe53XSYHiwe6CY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.14 023/168] drm/i915/dp: Use max params for panels < eDP 1.4
Date:   Mon, 20 Sep 2021 18:42:41 +0200
Message-Id: <20210920163922.409845362@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit c8dead5751b81dfa6b10449b740ed1062ff670c5 upstream.

Users reported that after commit 2bbd6dba84d4 ("drm/i915: Try to use
fast+narrow link on eDP again and fall back to the old max strategy on
failure"), the screen starts to have wobbly effect.

Commit a5c936add6a2 ("drm/i915/dp: Use slow and wide link training for
everything") doesn't help either, that means the affected eDP 1.2 panels
only work with max params.

So use max params for panels < eDP 1.4 as Windows does to solve the
issue.

v3:
 - Do the eDP rev check in intel_edp_init_dpcd()

v2:
 - Check eDP 1.4 instead of DPCD 1.1 to apply max params

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3714
Fixes: 2bbd6dba84d4 ("drm/i915: Try to use fast+narrow link on eDP again and fall back to the old max strategy on failure")
Fixes: a5c936add6a2 ("drm/i915/dp: Use slow and wide link training for everything")
Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210820075301.693099-1-kai.heng.feng@canonical.com
(cherry picked from commit d7f213c131adf0bec8b731553eb82990cdac265d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2453,11 +2453,14 @@ intel_edp_init_dpcd(struct intel_dp *int
 	 */
 	if (drm_dp_dpcd_read(&intel_dp->aux, DP_EDP_DPCD_REV,
 			     intel_dp->edp_dpcd, sizeof(intel_dp->edp_dpcd)) ==
-			     sizeof(intel_dp->edp_dpcd))
+			     sizeof(intel_dp->edp_dpcd)) {
 		drm_dbg_kms(&dev_priv->drm, "eDP DPCD: %*ph\n",
 			    (int)sizeof(intel_dp->edp_dpcd),
 			    intel_dp->edp_dpcd);
 
+		intel_dp->use_max_params = intel_dp->edp_dpcd[0] < DP_EDP_14;
+	}
+
 	/*
 	 * This has to be called after intel_dp->edp_dpcd is filled, PSR checks
 	 * for SET_POWER_CAPABLE bit in intel_dp->edp_dpcd[1]


