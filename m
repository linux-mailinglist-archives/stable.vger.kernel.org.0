Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F546797D8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390375AbfG2Trw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389961AbfG2Trw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E87E2054F;
        Mon, 29 Jul 2019 19:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429671;
        bh=BHGsMctAAKajpWPyduF1Vy/iq5jNO/ew+a7KQB/4AGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNkZZ8xf6UZUrrOAlnVPjvK5eOAv1xRn1GUfVX2OCnh3btBzKgZ2nHIczbzOKaBxq
         fX+8P//Pa4V+Cy4ebWTRVgU/VK7bBaBL7sEOWRit+Z40hmDR8NbRV6sYLbOvGqtyk7
         hEuOzkYd8fdGlr8L4zoSCJBdRG6Sed2CiKCzC9o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samson Tam <Samson.Tam@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 057/215] drm/amd/display: set link->dongle_max_pix_clk to 0 on a disconnect
Date:   Mon, 29 Jul 2019 21:20:53 +0200
Message-Id: <20190729190750.398062385@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 233d87a579b8adcc6da5823fa507ecb6675e7562 ]

[Why]
Found issue in EDID Emulation where if we connect a display using
 a passive HDMI-DP dongle, disconnect it and then try to emulate
 a display using DP, we could not see 4K modes.  This was because
 on a disconnect, dongle_max_pix_clk was still set so when we
 emulate using DP, in dc_link_validate_mode_timing(), it would
 think we were still using a dongle and limit the modes we support.

[How]
In dc_link_detect(), set dongle_max_pix_clk to 0 when we detect
 a hotplug out ( if new_connection_type = dc_connection_none ).

Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index b37ecc3ede61..a3ff33ff6da1 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -960,6 +960,12 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 
 		link->type = dc_connection_none;
 		sink_caps.signal = SIGNAL_TYPE_NONE;
+		/* When we unplug a passive DP-HDMI dongle connection, dongle_max_pix_clk
+		 *  is not cleared. If we emulate a DP signal on this connection, it thinks
+		 *  the dongle is still there and limits the number of modes we can emulate.
+		 *  Clear dongle_max_pix_clk on disconnect to fix this
+		 */
+		link->dongle_max_pix_clk = 0;
 	}
 
 	LINK_INFO("link=%d, dc_sink_in=%p is now %s prev_sink=%p dpcd same=%d edid same=%d\n",
-- 
2.20.1



