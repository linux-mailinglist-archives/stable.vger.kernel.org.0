Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4230731BCAF
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhBOPdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:33:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhBOPbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:31:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 155DD64E9F;
        Mon, 15 Feb 2021 15:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402985;
        bh=Pn7l9gZA9hmYzvfX6CYAYGZj5Z4+nt3VK3k1AXB4JAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2onTUX/kOslOKGNWm5Veudfy5OQ8d3ts8p8BKVGuhGfcHZt6YTJ+X0+2dUHsMbYjG
         v4lqWBwjRtBSKPWic8WnRW2KQwHo9QZFgZly4bQOBEaQxJHvmaPWKXqoNJcTn934Ws
         Keea0PZQAElqG2QqmPo+ezds9D8KRj6ZpiruElbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Andre Heider <a.heider@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/60] drm/sun4i: dw-hdmi: Fix max. frequency for H6
Date:   Mon, 15 Feb 2021 16:27:31 +0100
Message-Id: <20210215152716.748705458@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 1926a0508d8947cf081280d85ff035300dc71da7 ]

It turns out that reasoning for lowering max. supported frequency is
wrong. Scrambling works just fine. Several now fixed bugs prevented
proper functioning, even with rates lower than 340 MHz. Issues were just
more pronounced with higher frequencies.

Fix that by allowing max. supported frequency in HW and fix the comment.

Fixes: cd9063757a22 ("drm/sun4i: DW HDMI: Lower max. supported rate for H6")
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Andre Heider <a.heider@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210209175900.7092-6-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
index 12fe241956213..8f721be26477b 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -49,11 +49,9 @@ sun8i_dw_hdmi_mode_valid_h6(struct drm_connector *connector,
 {
 	/*
 	 * Controller support maximum of 594 MHz, which correlates to
-	 * 4K@60Hz 4:4:4 or RGB. However, for frequencies greater than
-	 * 340 MHz scrambling has to be enabled. Because scrambling is
-	 * not yet implemented, just limit to 340 MHz for now.
+	 * 4K@60Hz 4:4:4 or RGB.
 	 */
-	if (mode->clock > 340000)
+	if (mode->clock > 594000)
 		return MODE_CLOCK_HIGH;
 
 	return MODE_OK;
-- 
2.27.0



