Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A33554866A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384965AbiFMOqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386559AbiFMOqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:46:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE8EBF133;
        Mon, 13 Jun 2022 04:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD0546133B;
        Mon, 13 Jun 2022 11:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB819C34114;
        Mon, 13 Jun 2022 11:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121135;
        bh=MmMkYtXo0kaC/SGumxIQWqcUBTgb+3KADcP4UnpW0gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbGxBohw4UXA9p3bb3bLpvnnrn6CXwQcorIP/Yi0KvQEf0ICGy34b6RHKGvsG+KC3
         YRgGWXe6Drme1lkcc+ix0oTsLR98lZR51/gsXUDHGAnBRF5cOXlkTqZRr7N8EzJbVG
         5eOUyZBTBZFCglMMIcSXJwKJNSUUQN1qoPscc0cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Ying <victor.liu@oss.nxp.com>,
        Brian Norris <briannorris@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 5.17 285/298] drm/atomic: Force bridge self-refresh-exit on CRTC switch
Date:   Mon, 13 Jun 2022 12:12:59 +0200
Message-Id: <20220613094933.725811695@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Brian Norris <briannorris@chromium.org>

commit e54a4424925a27ed94dff046db3ce5caf4b1e748 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_helper.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1011,9 +1011,19 @@ crtc_needs_disable(struct drm_crtc_state
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


