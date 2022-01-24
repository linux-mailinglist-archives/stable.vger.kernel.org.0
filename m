Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0592F497E03
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbiAXLbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:31:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50184 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiAXLbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:31:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DB72B80AE3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4201C340E1;
        Mon, 24 Jan 2022 11:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643023875;
        bh=FoiFidFRtJglsI+G8ZU157MDaIOu/+kShfpMcZ4NBz4=;
        h=Subject:To:Cc:From:Date:From;
        b=z7hgFFyev+jTVjdoBuXoHF+gUjZu8DD84QSSGgDppbBL21IRCcnEwcz4xpcZTLf7C
         4NHe2U5LGeeH/X7UrRY7aDum2OZD0bHxDk3L7KxcED+X0BoiwuJdTuggnjuzxTHIMi
         eVywMyPZ3MNtUYkcchFGxxa2y3h1LODFcjN/O1Yg=
Subject: FAILED: patch "[PATCH] drm/vc4: kms: Wait for the commit before increasing our clock" failed to apply to 5.15-stable tree
To:     maxime@cerno.tech, daniel.vetter@intel.com,
        dave.stevenson@raspberrypi.com, jhp@endlessos.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 12:31:12 +0100
Message-ID: <164302387278254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 244a36e50da05c33b860d20638ee4628017a5334 Mon Sep 17 00:00:00 2001
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
[danvet: re-apply this from 0c980a006d3f ("drm/vc4: kms: Wait for the
commit before increasing our clock rate") because I lost that part in
my merge resolution in 99b03ca651f1 ("Merge v5.16-rc5 into drm-next")]
Fixes: 99b03ca651f1 ("Merge v5.16-rc5 into drm-next")
Acked-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://lore.kernel.org/r/20211117094527.146275-2-maxime@cerno.tech

diff --git a/drivers/gpu/drm/vc4/vc4_kms.c b/drivers/gpu/drm/vc4/vc4_kms.c
index bf3706f97ec7..24de29bc1cda 100644
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -365,14 +365,6 @@ static void vc4_atomic_commit_tail(struct drm_atomic_state *state)
 		vc4_hvs_mask_underrun(dev, vc4_crtc_state->assigned_channel);
 	}
 
-	if (vc4->hvs->hvs5) {
-		unsigned long core_rate = max_t(unsigned long,
-						500000000,
-						new_hvs_state->core_clock_rate);
-
-		clk_set_min_rate(hvs->core_clk, core_rate);
-	}
-
 	for (channel = 0; channel < HVS_NUM_CHANNELS; channel++) {
 		struct drm_crtc_commit *commit;
 		int ret;
@@ -392,6 +384,13 @@ static void vc4_atomic_commit_tail(struct drm_atomic_state *state)
 		old_hvs_state->fifo_state[channel].pending_commit = NULL;
 	}
 
+	if (vc4->hvs->hvs5) {
+		unsigned long core_rate = max_t(unsigned long,
+						500000000,
+						new_hvs_state->core_clock_rate);
+
+		clk_set_min_rate(hvs->core_clk, core_rate);
+	}
 	drm_atomic_helper_commit_modeset_disables(dev, state);
 
 	vc4_ctm_commit(vc4, state);

