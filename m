Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D810C3290C0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbhCAUOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242689AbhCAUDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:03:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7460C65399;
        Mon,  1 Mar 2021 17:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621478;
        bh=vzw1coLmeUeuiV7GKZBGfo1cDjNg9gawfNv6DKJAuMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWwYQnqbtEmFjvUkoISMCDj33TnholQX0i8xR0BFe5a9r5y5iArepMrs/gTEWyBDV
         RxjYF/7O/cH4z9KlaJgmKpKcU4IcjTXPEt9PMZtp2pfmhlzqs9c25n4rzVVpveLWTG
         AIXEkA4ZlN59pDxfcl0QmwePERLl5A5z8kDOEwec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 499/775] drm/msm/dp: trigger unplug event in msm_dp_display_disable
Date:   Mon,  1 Mar 2021 17:11:07 +0100
Message-Id: <20210301161226.174076651@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Judy Hsiao <judyhsiao@google.com>

[ Upstream commit c703d5789590935c573bbd080a2166b72d51a017 ]

1. Trigger the unplug event in msm_dp_display_disable() to shutdown audio
   properly.
2. Reset the completion before signal the disconnect event.

Fixes: 158b9aa74479 ("drm/msm/dp: wait for audio notification before disabling clocks")
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Judy Hsiao <judyhsiao@chromium.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 3bc7ed21de286..81f6794a25100 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -651,8 +651,8 @@ static int dp_hpd_unplug_handle(struct dp_display_private *dp, u32 data)
 	dp_add_event(dp, EV_DISCONNECT_PENDING_TIMEOUT, 0, DP_TIMEOUT_5_SECOND);
 
 	/* signal the disconnect event early to ensure proper teardown */
-	dp_display_handle_plugged_change(g_dp_display, false);
 	reinit_completion(&dp->audio_comp);
+	dp_display_handle_plugged_change(g_dp_display, false);
 
 	dp_catalog_hpd_config_intr(dp->catalog, DP_DP_HPD_PLUG_INT_MASK |
 					DP_DP_IRQ_HPD_INT_MASK, true);
@@ -890,6 +890,9 @@ static int dp_display_disable(struct dp_display_private *dp, u32 data)
 
 	/* wait only if audio was enabled */
 	if (dp_display->audio_enabled) {
+		/* signal the disconnect event */
+		reinit_completion(&dp->audio_comp);
+		dp_display_handle_plugged_change(dp_display, false);
 		if (!wait_for_completion_timeout(&dp->audio_comp,
 				HZ * 5))
 			DRM_ERROR("audio comp timeout\n");
-- 
2.27.0



