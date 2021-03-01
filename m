Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2A3328D2F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240996AbhCATHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240835AbhCATBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:01:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B867D64FEE;
        Mon,  1 Mar 2021 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618209;
        bh=GtK7MvN7qnXVkm4E8sDIVbl9sf+/4Rf8cGBy2Fg2fIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnlJNGfQL8Ozq16/WFnF8GZJfnJ0lhhW6wvfeV5BR2xSBelrUrfv6Vt+mbjfe3D4i
         gdpesSBZCbTzQhnNZE3j3TtpwXHIAzlKYwJoed+EwoPjNI1dQWasN8ZL+bn/1yB03G
         Ofbcbkl8fNLOPCyxIjqXz4nYPmj8XUYUYCZbYsY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Mika Kahola <mika.kahola@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.4 330/340] drm/i915: Reject 446-480MHz HDMI clock on GLK
Date:   Mon,  1 Mar 2021 17:14:34 +0100
Message-Id: <20210301161104.534697603@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
@@ -2129,7 +2129,11 @@ hdmi_port_clock_valid(struct intel_hdmi
 	if (clock > hdmi_port_clock_limit(hdmi, respect_downstream_limits, force_dvi))
 		return MODE_CLOCK_HIGH;
 
-	/* BXT DPLL can't generate 223-240 MHz */
+	/* GLK DPLL can't generate 446-480 MHz */
+	if (IS_GEMINILAKE(dev_priv) && clock > 446666 && clock < 480000)
+		return MODE_CLOCK_RANGE;
+
+	/* BXT/GLK DPLL can't generate 223-240 MHz */
 	if (IS_GEN9_LP(dev_priv) && clock > 223333 && clock < 240000)
 		return MODE_CLOCK_RANGE;
 


