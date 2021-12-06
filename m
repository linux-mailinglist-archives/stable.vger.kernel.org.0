Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE6D469F1E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391415AbhLFPph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390550AbhLFPmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FE5C0698D8;
        Mon,  6 Dec 2021 07:28:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C57FFB81120;
        Mon,  6 Dec 2021 15:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C4DC34901;
        Mon,  6 Dec 2021 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804506;
        bh=/BKPCJEstKX1aGtbfYuiieYyZSdnXwgmEawrRs4P09c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiFjzwtnjuwUkhr+hNkP4GNdZD46AclX5mNxxQf4lrFchN7e2Rm6D6x3FAjZdWL0P
         RuGM7miy78TyzIPX5aGcBl5fkvnGjfahH5XbF4oNsGW1dPCDQN5kQzb6F9I45SMezv
         MNdWwLYITwHUHCjdWA4TnqqIqI4DzDIgClGD08Hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH 5.15 139/207] drm/vc4: kms: Wait for the commit before increasing our clock rate
Date:   Mon,  6 Dec 2021 15:56:33 +0100
Message-Id: <20211206145615.040776412@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit 0c980a006d3fbee86c4d0698f66d6f5381831787 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_kms.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -353,9 +353,6 @@ static void vc4_atomic_commit_tail(struc
 		vc4_hvs_mask_underrun(dev, vc4_crtc_state->assigned_channel);
 	}
 
-	if (vc4->hvs->hvs5)
-		clk_set_min_rate(hvs->core_clk, 500000000);
-
 	old_hvs_state = vc4_hvs_get_old_global_state(state);
 	if (!old_hvs_state)
 		return;
@@ -377,6 +374,9 @@ static void vc4_atomic_commit_tail(struc
 			drm_err(dev, "Timed out waiting for commit\n");
 	}
 
+	if (vc4->hvs->hvs5)
+		clk_set_min_rate(hvs->core_clk, 500000000);
+
 	drm_atomic_helper_commit_modeset_disables(dev, state);
 
 	vc4_ctm_commit(vc4, state);


