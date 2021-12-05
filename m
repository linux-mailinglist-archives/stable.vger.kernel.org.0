Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B64D468B45
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhLEN4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:56:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60158 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbhLEN4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:56:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAA8A60FC8
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E528C341C1;
        Sun,  5 Dec 2021 13:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638712391;
        bh=NA7Pay6EPVc7k9lHh1sBeL/5/TBICXA6aWqDEbnkfIk=;
        h=Subject:To:Cc:From:Date:From;
        b=ZRK467Co7puCZqSPw/TgUHAQFtZOCVUcUkqKqDOPesU+avQGpkopTKe6sGfSAashR
         CPv9i2tYnpCvS2XOXTeaAS9mihXIxvFzAg3wUqH24MaN8gkp+J6zt6M0Bc1sLASalo
         BMqqfI7ozIvRCDkgObrjhfLMx4nqdGpriF9Z/Hn4=
Subject: FAILED: patch "[PATCH] drm/vc4: kms: Wait for the commit before increasing our clock" failed to apply to 5.10-stable tree
To:     maxime@cerno.tech, dave.stevenson@raspberrypi.com,
        jhp@endlessos.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:53:08 +0100
Message-ID: <163871238856156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0c980a006d3fbee86c4d0698f66d6f5381831787 Mon Sep 17 00:00:00 2001
From: Maxime Ripard <maxime@cerno.tech>
Date: Wed, 17 Nov 2021 10:45:22 +0100
Subject: [PATCH] drm/vc4: kms: Wait for the commit before increasing our clock
 rate

Several DRM/KMS atomic commits can run in parallel if they affect
different CRTC. These commits share the global HVS state, so we have
some code to make sure we run commits in sequence. This synchronization
code is one of the first thing that runs in vc4_atomic_commit_tail().

Another constraints we have is that we need to make sure the HVS clock
gets a boost during the commit. That code relies on clk_set_min_rate and
will remove the old minimum and set a new one. We also need another,
temporary, minimum for the duration of the commit.

The algorithm is thus to set a temporary minimum, drop the previous
one, do the commit, and finally set the minimum for the current mode.

However, the part that sets the temporary minimum and drops the older
one runs before the commit synchronization code.

Thus, under the proper conditions, we can end up mixing up the minimums
and ending up with the wrong one for our current step.

To avoid it, let's move the clock setup in the protected section.

Fixes: d7d96c00e585 ("drm/vc4: hvs: Boost the core clock during modeset")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Tested-by: Jian-Hong Pan <jhp@endlessos.org>
Link: https://lore.kernel.org/r/20211117094527.146275-2-maxime@cerno.tech

diff --git a/drivers/gpu/drm/vc4/vc4_kms.c b/drivers/gpu/drm/vc4/vc4_kms.c
index f0b3e4cf5bce..764ddb41a4ce 100644
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -353,9 +353,6 @@ static void vc4_atomic_commit_tail(struct drm_atomic_state *state)
 		vc4_hvs_mask_underrun(dev, vc4_crtc_state->assigned_channel);
 	}
 
-	if (vc4->hvs->hvs5)
-		clk_set_min_rate(hvs->core_clk, 500000000);
-
 	old_hvs_state = vc4_hvs_get_old_global_state(state);
 	if (!old_hvs_state)
 		return;
@@ -377,6 +374,9 @@ static void vc4_atomic_commit_tail(struct drm_atomic_state *state)
 			drm_err(dev, "Timed out waiting for commit\n");
 	}
 
+	if (vc4->hvs->hvs5)
+		clk_set_min_rate(hvs->core_clk, 500000000);
+
 	drm_atomic_helper_commit_modeset_disables(dev, state);
 
 	vc4_ctm_commit(vc4, state);

