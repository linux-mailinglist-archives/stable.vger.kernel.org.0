Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2752ABA28
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387456AbgKINQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387452AbgKINQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33FFF20663;
        Mon,  9 Nov 2020 13:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927776;
        bh=GRmfmyrXl39A7C2AfEqkzx/2HvGzUGtqU6/g6MiZ+Io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mc/upgkBxrcQFHPtassxpGI1OSYUe/dyAguBuH6zLZ2LEXD3bLpN2rTH7cLZvRu9B
         bYRV39dDhnBEMCjU7/wug4kRbRwy/jcej8ShfanTpf3IuUnfngkBeX0n67MgnTPFxB
         nHCVeuIIcMm/yI7ms9h1BG7dH4t3e9TjnGMIRUFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 018/133] drm/i915: Reject 90/270 degree rotated initial fbs
Date:   Mon,  9 Nov 2020 13:54:40 +0100
Message-Id: <20201109125031.592994380@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 61334ed227a5852100115180f5535b1396ed5227 upstream.

We don't currently handle the initial fb readout correctly
for 90/270 degree rotated scanout. Reject it.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201020194330.28568-1-ville.syrjala@linux.intel.com
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
(cherry picked from commit a40a8305a732f4ecc2186ac7ca132ba062ed770d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -10589,6 +10589,10 @@ skl_get_initial_plane_config(struct inte
 	    val & PLANE_CTL_FLIP_HORIZONTAL)
 		plane_config->rotation |= DRM_MODE_REFLECT_X;
 
+	/* 90/270 degree rotation would require extra work */
+	if (drm_rotation_90_or_270(plane_config->rotation))
+		goto error;
+
 	base = intel_de_read(dev_priv, PLANE_SURF(pipe, plane_id)) & 0xfffff000;
 	plane_config->base = base;
 


