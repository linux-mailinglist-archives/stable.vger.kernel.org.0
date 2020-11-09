Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5797D2ABB34
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732047AbgKINZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:25:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387607AbgKINRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE5220867;
        Mon,  9 Nov 2020 13:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927853;
        bh=EoXK49j1qjQ5ok6UWm/3rmC1hzEEfVJ48UGz1tGEh+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWP9KBOC8B3H+tGH8OaqWXtXtSv9Gn8JbRxcvd/zwDyHQ+Nk3stsgjvAYCenKf8N2
         S8NHKiVTR1QJV++5HIduuSwuPSHtnCTM0Fd4Lkh6vLH9L4NiwUtiRK+hgNcgyLfTWq
         aIo1sHZHTFmlvxkfw8FYdZQa7JUs5EDg4WIapgcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.9 044/133] drm/nouveau/kms/nv50-: Fix clock checking algorithm in nv50_dp_mode_valid()
Date:   Mon,  9 Nov 2020 13:55:06 +0100
Message-Id: <20201109125032.832194119@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

commit d7787cc04e0a1f2043264d1550465081096bd065 upstream.

While I thought I had this correct (since it actually did reject modes
like I expected during testing), Ville Syrjala from Intel pointed out
that the logic here isn't correct. max_clock refers to the max data rate
supported by the DP encoder. So, limiting it to the output of ds_clock (which
refers to the maximum dotclock of the downstream DP device) doesn't make any
sense. Additionally, since we're using the connector's bpc as the canonical BPC
we should use this in mode_valid until we support dynamically setting the bpp
based on bandwidth constraints.

https://lists.freedesktop.org/archives/dri-devel/2020-September/280276.html

For more info.

So, let's rewrite this using Ville's advice.

v2:
* Ville pointed out I mixed up the dotclock and the link rate. So fix that...
* ...and also rename all the variables in this function to be more appropriately
  labeled so I stop mixing them up.
* Reuse the bpp from the connector for now until we have dynamic bpp selection.
* Use use DIV_ROUND_UP for calculating the mode rate like i915 does, which we
  should also have been doing from the start

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 409d38139b42 ("drm/nouveau/kms/nv50-: Use downstream DP clock limits for mode validation")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/nouveau/nouveau_dp.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -114,7 +114,8 @@ nv50_dp_mode_valid(struct drm_connector
 		   unsigned *out_clock)
 {
 	const unsigned min_clock = 25000;
-	unsigned max_clock, clock = mode->clock;
+	unsigned int max_rate, mode_rate, clock = mode->clock;
+	const u8 bpp = connector->display_info.bpc * 3;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;
@@ -122,12 +123,13 @@ nv50_dp_mode_valid(struct drm_connector
 	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) == DRM_MODE_FLAG_3D_FRAME_PACKING)
 		clock *= 2;
 
-	max_clock = outp->dp.link_nr * outp->dp.link_bw;
-	clock = mode->clock * (connector->display_info.bpc * 3) / 10;
+	max_rate = outp->dp.link_nr * outp->dp.link_bw;
+	mode_rate = DIV_ROUND_UP(clock * bpp, 8);
+	if (mode_rate > max_rate)
+		return MODE_CLOCK_HIGH;
+
 	if (clock < min_clock)
 		return MODE_CLOCK_LOW;
-	if (clock > max_clock)
-		return MODE_CLOCK_HIGH;
 
 	if (out_clock)
 		*out_clock = clock;


