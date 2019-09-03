Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680F6A708F
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfICQZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730195AbfICQZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64BB23711;
        Tue,  3 Sep 2019 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527902;
        bh=dyScu8qjbZFD3Z1Otv9eApLRGaXOxrDCaQ73RAPBdDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSVhRfjPF19hyq4OhTFrxVuYrZO6cV3Oe7+aoMMlel9KKBHqvGL4gwKQrofx7RUpQ
         sYnl38v5hc96Ux9l0/t9xEMmH2BZlTHPZDQlezJdmPv+4i+ai7u8mdFEu9WwDUzZGG
         2GChWj7gJf3pD4SbxfwXslLAn76su4Y//W/iE0YY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stefan Gottwald <gottwald@igel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 14/23] drm/i915: Make sure cdclk is high enough for DP audio on VLV/CHV
Date:   Tue,  3 Sep 2019 12:24:15 -0400
Message-Id: <20190903162424.6877-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

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
index ae40a8679314e..fd5236da039fb 100644
--- a/drivers/gpu/drm/i915/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/intel_cdclk.c
@@ -2269,6 +2269,17 @@ int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state)
 	if (crtc_state->has_audio && INTEL_GEN(dev_priv) >= 9)
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

