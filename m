Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01ADAE6847
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731239AbfJ0VXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbfJ0VXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:04 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B63022064A;
        Sun, 27 Oct 2019 21:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211383;
        bh=vdyYnKwvAV0Rcj7lYYBcr2EqFHtlSNWDkV77CDNA09c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+B7JSkm2NegXvgSq3NKUinQ70m7Fq+hrXSXCilqA87ltonrbSmc3h+LHLbFtC3hq
         9ik1DGD4yBNbgSxxv9nCunHKZeTEyR3CfJJWi90EBu+vWJ/OmVAGpcUsSSlO+fxVyO
         sxASQdNbem/UFuSKOMHBFZNfyZ80864GzVuZ4Mn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Masami Ichikawa <masami256@gmail.com>,
        Torsten <freedesktop201910@liggy.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 130/197] drm/i915: Favor last VBT child device with conflicting AUX ch/DDC pin
Date:   Sun, 27 Oct 2019 22:00:48 +0100
Message-Id: <20191027203358.739910000@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 0336ab580878f4c5663dfa2b66095821fdc3e588 upstream.

The first come first served apporoach to handling the VBT
child device AUX ch conflicts has backfired. We have machines
in the wild where the VBT specifies both port A eDP and
port E DP (in that order) with port E being the real one.

So let's try to flip the preference around and let the last
child device win once again.

Cc: stable@vger.kernel.org
Cc: Jani Nikula <jani.nikula@intel.com>
Tested-by: Masami Ichikawa <masami256@gmail.com>
Tested-by: Torsten <freedesktop201910@liggy.de>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111966
Fixes: 36a0f92020dc ("drm/i915/bios: make child device order the priority order")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191011202030.8829-1-ville.syrjala@linux.intel.com
Acked-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 41e35ffb380bde1379e4030bb5b2ac824d5139cf)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_bios.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1269,7 +1269,7 @@ static void sanitize_ddc_pin(struct drm_
 		DRM_DEBUG_KMS("port %c trying to use the same DDC pin (0x%x) as port %c, "
 			      "disabling port %c DVI/HDMI support\n",
 			      port_name(port), info->alternate_ddc_pin,
-			      port_name(p), port_name(port));
+			      port_name(p), port_name(p));
 
 		/*
 		 * If we have multiple ports supposedly sharing the
@@ -1277,9 +1277,14 @@ static void sanitize_ddc_pin(struct drm_
 		 * port. Otherwise they share the same ddc bin and
 		 * system couldn't communicate with them separately.
 		 *
-		 * Give child device order the priority, first come first
-		 * served.
+		 * Give inverse child device order the priority,
+		 * last one wins. Yes, there are real machines
+		 * (eg. Asrock B250M-HDV) where VBT has both
+		 * port A and port E with the same AUX ch and
+		 * we must pick port E :(
 		 */
+		info = &dev_priv->vbt.ddi_port_info[p];
+
 		info->supports_dvi = false;
 		info->supports_hdmi = false;
 		info->alternate_ddc_pin = 0;
@@ -1315,7 +1320,7 @@ static void sanitize_aux_ch(struct drm_i
 		DRM_DEBUG_KMS("port %c trying to use the same AUX CH (0x%x) as port %c, "
 			      "disabling port %c DP support\n",
 			      port_name(port), info->alternate_aux_channel,
-			      port_name(p), port_name(port));
+			      port_name(p), port_name(p));
 
 		/*
 		 * If we have multiple ports supposedlt sharing the
@@ -1323,9 +1328,14 @@ static void sanitize_aux_ch(struct drm_i
 		 * port. Otherwise they share the same aux channel
 		 * and system couldn't communicate with them separately.
 		 *
-		 * Give child device order the priority, first come first
-		 * served.
+		 * Give inverse child device order the priority,
+		 * last one wins. Yes, there are real machines
+		 * (eg. Asrock B250M-HDV) where VBT has both
+		 * port A and port E with the same AUX ch and
+		 * we must pick port E :(
 		 */
+		info = &dev_priv->vbt.ddi_port_info[p];
+
 		info->supports_dp = false;
 		info->alternate_aux_channel = 0;
 	}


