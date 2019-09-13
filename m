Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A442B204C
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390479AbfIMNT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389937AbfIMNT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:58 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D17206BB;
        Fri, 13 Sep 2019 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380797;
        bh=eEv89yTKsOuNGH2qX7v4+PEw5E5eaUCTVNT2AKD+VHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beIoLFyUbZYiNqqhaaND6c+Xvq234gG5bKv10PRIaNl5KrHhQvBZFNt1Q20Q8IRqu
         N8EmQXgia8Ii1atsZPuWAGmOrknGShys9WF7P3UdOY8zEmLyvHKoLH9BMfDdOq3IOo
         B9o1cSv0p0fD5PkSLIWTjpxuiPT2I6PUB2UoeOe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Gottwald <gottwald@igel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/190] drm/i915: Make sure cdclk is high enough for DP audio on VLV/CHV
Date:   Fri, 13 Sep 2019 14:07:15 +0100
Message-Id: <20190913130614.185853162@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a8f196a0fa6391a436f63f360a1fb57031fdf26c ]

On VLV/CHV there is some kind of linkage between the cdclk frequency
and the DP link frequency. The spec says:
"For DP audio configuration, cdclk frequency shall be set to
 meet the following requirements:
 DP Link Frequency(MHz) | Cdclk frequency(MHz)
 270                    | 320 or higher
 162                    | 200 or higher"

I suspect that would more accurately be expressed as
"cdclk >= DP link clock", and in any case we can express it like
that in the code because of the limited set of cdclk (200, 266,
320, 400 MHz) and link frequencies (162 and 270 MHz) we support.

Without this we can end up in a situation where the cdclk
is too low and enabling DP audio will kill the pipe. Happens
eg. with 2560x1440 modes where the 266MHz cdclk is sufficient
to pump the pixels (241.5 MHz dotclock) but is too low for
the DP audio due to the link frequency being 270 MHz.

v2: Spell out the cdclk and link frequencies we actually support

Cc: stable@vger.kernel.org
Tested-by: Stefan Gottwald <gottwald@igel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111149
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190717114536.22937-1-ville.syrjala@linux.intel.com
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
(cherry picked from commit bffb31f73b29a60ef693842d8744950c2819851d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_cdclk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_cdclk.c b/drivers/gpu/drm/i915/intel_cdclk.c
index 29075c7634280..7b4906ede148b 100644
--- a/drivers/gpu/drm/i915/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/intel_cdclk.c
@@ -2208,6 +2208,17 @@ int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state)
 	if (INTEL_GEN(dev_priv) >= 9)
 		min_cdclk = max(2 * 96000, min_cdclk);
 
+	/*
+	 * "For DP audio configuration, cdclk frequency shall be set to
+	 *  meet the following requirements:
+	 *  DP Link Frequency(MHz) | Cdclk frequency(MHz)
+	 *  270                    | 320 or higher
+	 *  162                    | 200 or higher"
+	 */
+	if ((IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv)) &&
+	    intel_crtc_has_dp_encoder(crtc_state) && crtc_state->has_audio)
+		min_cdclk = max(crtc_state->port_clock, min_cdclk);
+
 	/*
 	 * On Valleyview some DSI panels lose (v|h)sync when the clock is lower
 	 * than 320000KHz.
-- 
2.20.1



