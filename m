Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DCD5480B8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiFMHiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiFMHio (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0041D33E
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4909B60F39
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500C4C34114;
        Mon, 13 Jun 2022 07:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655105922;
        bh=yqkfxu16uwZcd4u4i0MRjC5bhf39TxsS8i1vxI0VPqI=;
        h=Subject:To:Cc:From:Date:From;
        b=zVJbr2nxfJ5OyZOCyNKob3pcDnbIscBE8qDXpgEdT9DDfhU8DnHs5ypMzFzO0ATgr
         3iXPFvmOTgFlg0ujvVNl1y438NskSLAQZfe+wqttTsod7oyNWWipX28AlX5vdcpS9K
         yjGGyxETygQ5W5WTrRTAhBp4jUZY8sNGnr8CbQj8=
Subject: FAILED: patch "[PATCH] drm/atomic: Force bridge self-refresh-exit on CRTC switch" failed to apply to 5.4-stable tree
To:     briannorris@chromium.org, dianders@chromium.org,
        seanpaul@chromium.org, stable@vger.kernel.org,
        victor.liu@oss.nxp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:38:40 +0200
Message-ID: <1655105920160205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e54a4424925a27ed94dff046db3ce5caf4b1e748 Mon Sep 17 00:00:00 2001
From: Brian Norris <briannorris@chromium.org>
Date: Mon, 28 Feb 2022 12:25:32 -0800
Subject: [PATCH] drm/atomic: Force bridge self-refresh-exit on CRTC switch

It's possible to change which CRTC is in use for a given
connector/encoder/bridge while we're in self-refresh without fully
disabling the connector/encoder/bridge along the way. This can confuse
the bridge encoder/bridge, because
(a) it needs to track the SR state (trying to perform "active"
    operations while the panel is still in SR can be Bad(TM)); and
(b) it tracks the SR state via the CRTC state (and after the switch, the
    previous SR state is lost).

Thus, we need to either somehow carry the self-refresh state over to the
new CRTC, or else force an encoder/bridge self-refresh transition during
such a switch.

I choose the latter, so we disable the encoder (and exit PSR) before
attaching it to the new CRTC (where we can continue to assume a clean
(non-self-refresh) state).

This fixes PSR issues seen on Rockchip RK3399 systems with
drivers/gpu/drm/bridge/analogix/analogix_dp_core.c.

Change in v2:

- Drop "->enable" condition; this could possibly be "->active" to
  reflect the intended hardware state, but it also is a little
  over-specific. We want to make a transition through "disabled" any
  time we're exiting PSR at the same time as a CRTC switch.
  (Thanks Liu Ying)

Cc: Liu Ying <victor.liu@oss.nxp.com>
Cc: <stable@vger.kernel.org>
Fixes: 1452c25b0e60 ("drm: Add helpers to kick off self refresh mode in drivers")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220228122522.v2.2.Ic15a2ef69c540aee8732703103e2cff51fb9c399@changeid

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 9603193d2fa1..987e4b212e9f 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1011,9 +1011,19 @@ crtc_needs_disable(struct drm_crtc_state *old_state,
 		return drm_atomic_crtc_effectively_active(old_state);
 
 	/*
-	 * We need to run through the crtc_funcs->disable() function if the CRTC
-	 * is currently on, if it's transitioning to self refresh mode, or if
-	 * it's in self refresh mode and needs to be fully disabled.
+	 * We need to disable bridge(s) and CRTC if we're transitioning out of
+	 * self-refresh and changing CRTCs at the same time, because the
+	 * bridge tracks self-refresh status via CRTC state.
+	 */
+	if (old_state->self_refresh_active &&
+	    old_state->crtc != new_state->crtc)
+		return true;
+
+	/*
+	 * We also need to run through the crtc_funcs->disable() function if
+	 * the CRTC is currently on, if it's transitioning to self refresh
+	 * mode, or if it's in self refresh mode and needs to be fully
+	 * disabled.
 	 */
 	return old_state->active ||
 	       (old_state->self_refresh_active && !new_state->active) ||

