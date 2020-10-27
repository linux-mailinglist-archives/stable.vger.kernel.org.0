Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA2629B770
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799746AbgJ0PdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799740AbgJ0PdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE85122202;
        Tue, 27 Oct 2020 15:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812785;
        bh=cxuiL3mnDWULZ60LSzmIyrobP5TNhgzpVdTON2kYVoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjdWkJ3RtVjCQkbXFm0O1iuLcog6pmHTbtbcCGk0ryTABM0lYF6Oc2QCrVVYeJqOd
         kmRENUUab/Hv8YhOKO0rYY9HtG9WmvAz2FIRrFC6iHPLQwS6aemDKZbpQmm8VJMgjK
         O6EtQ8ZBljLGnm0F9BKgx/mVeKV5tUYmC/NoTAjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 329/757] drm/vc4: crtc: Rework a bit the CRTC state code
Date:   Tue, 27 Oct 2020 14:49:39 +0100
Message-Id: <20201027135505.978020673@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 427c4a0680a28f87bb9c7bbfeac26b39ef8682ad ]

The current CRTC state reset hook in vc4 allocates a vc4_crtc_state
structure as a drm_crtc_state, and relies on the fact that vc4_crtc_state
embeds drm_crtc_state as its first member, and therefore can be safely
cast.

However, this is pretty fragile especially since there's no check for this
in place, and we're going to need to access vc4_crtc_state member at reset
so this looks like a good occasion to make it more robust.

Fixes: 6d6e50039187 ("drm/vc4: Allocate the right amount of space for boot-time CRTC state.")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200923084032.218619-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 6d8fa6118fc1a..eaad187c41f07 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -723,11 +723,18 @@ void vc4_crtc_destroy_state(struct drm_crtc *crtc,
 
 void vc4_crtc_reset(struct drm_crtc *crtc)
 {
+	struct vc4_crtc_state *vc4_crtc_state;
+
 	if (crtc->state)
 		vc4_crtc_destroy_state(crtc, crtc->state);
-	crtc->state = kzalloc(sizeof(struct vc4_crtc_state), GFP_KERNEL);
-	if (crtc->state)
-		__drm_atomic_helper_crtc_reset(crtc, crtc->state);
+
+	vc4_crtc_state = kzalloc(sizeof(*vc4_crtc_state), GFP_KERNEL);
+	if (!vc4_crtc_state) {
+		crtc->state = NULL;
+		return;
+	}
+
+	__drm_atomic_helper_crtc_reset(crtc, &vc4_crtc_state->base);
 }
 
 static const struct drm_crtc_funcs vc4_crtc_funcs = {
-- 
2.25.1



