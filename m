Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA804328F86
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242246AbhCATww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242193AbhCAToD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4FC46509C;
        Mon,  1 Mar 2021 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620017;
        bh=rrc5IzSMS3PkuhBOxZXgHn9g0RUZm0AlIwNm3ZP7jU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMLVtGAKOQc+Sr6Qy59EZlgTEAUaPcy4nXLkhK5kjydOr5lZENqOO1AASZ1WCjFQe
         9O51HUfbwoDpwgHqluic9RR18ya+S7G59ob6Vll4Qrt33xBrWdRQNxPOe7Uahg9UE1
         DEWjpaZqcmFIkaueP2gTMG14/qurPV9CLN1biPvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Mika Kahola <mika.kahola@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.10 655/663] drm/i915: Reject 446-480MHz HDMI clock on GLK
Date:   Mon,  1 Mar 2021 17:15:03 +0100
Message-Id: <20210301161214.261484293@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 7a6c6243b44a439bda4bf099032be35ebcf53406 upstream.

The BXT/GLK DPLL can't generate certain frequencies. We already
reject the 233-240MHz range on both. But on GLK the DPLL max
frequency was bumped from 300MHz to 594MHz, so now we get to
also worry about the 446-480MHz range (double the original
problem range). Reject any frequency within the higher
problematic range as well.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3000
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210203093044.30532-1-ville.syrjala@linux.intel.com
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
(cherry picked from commit 41751b3e5c1ac656a86f8d45a8891115281b729e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdmi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -2216,7 +2216,11 @@ hdmi_port_clock_valid(struct intel_hdmi
 					  has_hdmi_sink))
 		return MODE_CLOCK_HIGH;
 
-	/* BXT DPLL can't generate 223-240 MHz */
+	/* GLK DPLL can't generate 446-480 MHz */
+	if (IS_GEMINILAKE(dev_priv) && clock > 446666 && clock < 480000)
+		return MODE_CLOCK_RANGE;
+
+	/* BXT/GLK DPLL can't generate 223-240 MHz */
 	if (IS_GEN9_LP(dev_priv) && clock > 223333 && clock < 240000)
 		return MODE_CLOCK_RANGE;
 


