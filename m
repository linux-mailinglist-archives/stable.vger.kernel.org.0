Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7DC2AA16C
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 00:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgKFXae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 18:30:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729002AbgKFXab (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 18:30:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604705430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ew4rIAC9gbf7d0rKjHF4qfpwnpt8uKp6YFkSycCbhTQ=;
        b=fwuJg/331z1G/2VGZ2NL+BMuBnXl0GvoTOPPlwadhwEqqZ58WQClSIz7H6RJEH6fPRAORF
        UJITQTgWvXOl+fbqB8LIvENt+21UgHKLJkdqB5bnpmwhUZhiRSEg0oy9+p50uljDsrWRII
        fSCLJrjm3ZcOTvb8h4dgm++DqpmTMfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-g3HBWZfpNrCTU2cWf8kZmg-1; Fri, 06 Nov 2020 18:30:27 -0500
X-MC-Unique: g3HBWZfpNrCTU2cWf8kZmg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B2FD801F9A;
        Fri,  6 Nov 2020 23:30:26 +0000 (UTC)
Received: from Whitewolf.lyude.net (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 065F462A15;
        Fri,  6 Nov 2020 23:30:24 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] drm/nouveau/kms/nv50-: Fix clock checking algorithm in nv50_dp_mode_valid()
Date:   Fri,  6 Nov 2020 18:30:15 -0500
Message-Id: <20201106233016.2481179-3-lyude@redhat.com>
In-Reply-To: <20201106233016.2481179-1-lyude@redhat.com>
References: <160459060724988@kroah.com>
 <20201106233016.2481179-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Changes made for stable backport:
* 5.9 didn't use drm_dp_downstream_max_dotclock() yet, so remove that (the
  fix is still important regardless)

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
---
 drivers/gpu/drm/nouveau/nouveau_dp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index 40683e1244c3f..9c06d1cc43905 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -114,7 +114,8 @@ nv50_dp_mode_valid(struct drm_connector *connector,
 		   unsigned *out_clock)
 {
 	const unsigned min_clock = 25000;
-	unsigned max_clock, clock = mode->clock;
+	unsigned int max_rate, mode_rate, clock = mode->clock;
+	const u8 bpp = connector->display_info.bpc * 3;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;
@@ -122,12 +123,13 @@ nv50_dp_mode_valid(struct drm_connector *connector,
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
-- 
2.28.0

