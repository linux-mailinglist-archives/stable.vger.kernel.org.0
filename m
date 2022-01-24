Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB2B49A9C1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323405AbiAYD2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445597AbiAXVE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:04:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CFDC068084;
        Mon, 24 Jan 2022 12:04:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F1CC6090A;
        Mon, 24 Jan 2022 20:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600EBC340E5;
        Mon, 24 Jan 2022 20:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054650;
        bh=LexXsOHLM2Zyt+r8gcyKj5jMn+0GNWWGVK2D4CaDRiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9WZL8K1sM0c2jlFsX+uyUxNWMa1ajeqndE7gI/g5L+Nzesu3d47HHC8RYIcLoXNm
         t17Mefom4mJd8acMddFZ1nRnbEDD3ubpEnwUs2/s70mHbuqivR+UCnEYWMx80SVl8x
         gMgtzOSzmS9Q0OMPgWRCPtM1bTltMoksy14CY5xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zain Wang <wzz@rock-chips.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Robert Foss <robert.foss@linaro.org>
Subject: [PATCH 5.10 457/563] drm/bridge: analogix_dp: Make PSR-exit block less
Date:   Mon, 24 Jan 2022 19:43:42 +0100
Message-Id: <20220124184040.252701251@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit c4c6ef229593366ab593d4d424addc7025b54a76 upstream.

Prior to commit 6c836d965bad ("drm/rockchip: Use the helpers for PSR"),
"PSR exit" used non-blocking analogix_dp_send_psr_spd(). The refactor
started using the blocking variant, for a variety of reasons -- quoting
Sean Paul's potentially-faulty memory:

"""
 - To avoid racing a subsequent PSR entry (if exit takes a long time)
 - To avoid racing disable/modeset
 - We're not displaying new content while exiting PSR anyways, so there
   is minimal utility in allowing frames to be submitted
 - We're lying to userspace telling them frames are on the screen when
   we're just dropping them on the floor
"""

However, I'm finding that this blocking transition is causing upwards of
60+ ms of unneeded latency on PSR-exit, to the point that initial cursor
movements when leaving PSR are unbearably jumpy.

It turns out that we need to meet in the middle somewhere: Sean is right
that we were "lying to userspace" with a non-blocking PSR-exit, but the
new blocking behavior is also waiting too long:

According to the eDP specification, the sink device must support PSR
entry transitions from both state 4 (ACTIVE_RESYNC) and state 0
(INACTIVE). It also states that in ACTIVE_RESYNC, "the Sink device must
display the incoming active frames from the Source device with no
visible glitches and/or artifacts."

Thus, for our purposes, we only need to wait for ACTIVE_RESYNC before
moving on; we are ready to display video, and subsequent PSR-entry is
safe.

Tested on a Samsung Chromebook Plus (i.e., Rockchip RK3399 Gru Kevin),
where this saves about 60ms of latency, for PSR-exit that used to
take about 80ms.

Fixes: 6c836d965bad ("drm/rockchip: Use the helpers for PSR")
Cc: <stable@vger.kernel.org>
Cc: Zain Wang <wzz@rock-chips.com>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211103135112.v3.1.I67612ea073c3306c71b46a87be894f79707082df@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
@@ -1086,11 +1086,21 @@ int analogix_dp_send_psr_spd(struct anal
 	if (!blocking)
 		return 0;
 
+	/*
+	 * db[1]!=0: entering PSR, wait for fully active remote frame buffer.
+	 * db[1]==0: exiting PSR, wait for either
+	 *  (a) ACTIVE_RESYNC - the sink "must display the
+	 *      incoming active frames from the Source device with no visible
+	 *      glitches and/or artifacts", even though timings may still be
+	 *      re-synchronizing; or
+	 *  (b) INACTIVE - the transition is fully complete.
+	 */
 	ret = readx_poll_timeout(analogix_dp_get_psr_status, dp, psr_status,
 		psr_status >= 0 &&
 		((vsc->db[1] && psr_status == DP_PSR_SINK_ACTIVE_RFB) ||
-		(!vsc->db[1] && psr_status == DP_PSR_SINK_INACTIVE)), 1500,
-		DP_TIMEOUT_PSR_LOOP_MS * 1000);
+		(!vsc->db[1] && (psr_status == DP_PSR_SINK_ACTIVE_RESYNC ||
+				 psr_status == DP_PSR_SINK_INACTIVE))),
+		1500, DP_TIMEOUT_PSR_LOOP_MS * 1000);
 	if (ret) {
 		dev_warn(dp->dev, "Failed to apply PSR %d\n", ret);
 		return ret;


