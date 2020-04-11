Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61271A502C
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgDKMPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgDKMPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:15:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46BA620692;
        Sat, 11 Apr 2020 12:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607305;
        bh=64g/FuVY4FkADB9UpvuwvHmWfRLDc5mR7iw725sbOe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEhBmJgBrboQWKRA8HHhCvzQ/m1SwjX47inhuE+6UbDsP9e9pQ/s4ys5NnZB5Eezn
         7ZgRBM5JZYEl1JeNCIlgWolvMcIHLChtHFcAD9uoBSbjIrQX5EOpWhzAjBr/R26GC/
         ofgQVyKDeOsGO+MW7xAsqyZaXWdYSu6Xd/uCwIig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mario Kleiner <mario.kleiner.de@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/54] drm/amd/display: Add link_rate quirk for Apple 15" MBP 2017
Date:   Sat, 11 Apr 2020 14:08:48 +0200
Message-Id: <20200411115508.931334215@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Kleiner <mario.kleiner.de@gmail.com>

[ Upstream commit dec9de2ada523b344eb2428abfedf9d6cd0a0029 ]

This fixes a problem found on the MacBookPro 2017 Retina panel:

The panel reports 10 bpc color depth in its EDID, and the
firmware chooses link settings at boot which support enough
bandwidth for 10 bpc (324000 kbit/sec aka LINK_RATE_RBR2
aka 0xc), but the DP_MAX_LINK_RATE dpcd register only reports
2.7 Gbps (multiplier value 0xa) as possible, in direct
contradiction of what the firmware successfully set up.

This restricts the panel to 8 bpc, not providing the full
color depth of the panel on Linux <= 5.5. Additionally, commit
'4a8ca46bae8a ("drm/amd/display: Default max bpc to 16 for eDP")'
introduced into Linux 5.6-rc1 will unclamp panel depth to
its full 10 bpc, thereby requiring a eDP bandwidth for all
modes that exceeds the bandwidth available and causes all modes
to fail validation -> No modes for the laptop panel -> failure
to set any mode -> Panel goes dark.

This patch adds a quirk specific to the MBP 2017 15" Retina
panel to override reported max link rate to the correct maximum
of 0xc = LINK_RATE_RBR2 to fix the darkness and reduced display
precision.

Please apply for Linux 5.6+ to avoid regressing Apple MBP panel
support.

Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 122249da03ab7..a4928854a3de5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2440,6 +2440,17 @@ static bool retrieve_link_cap(struct dc_link *link)
 		sink_id.ieee_device_id,
 		sizeof(sink_id.ieee_device_id));
 
+	/* Quirk Apple MBP 2017 15" Retina panel: Wrong DP_MAX_LINK_RATE */
+	{
+		uint8_t str_mbp_2017[] = { 101, 68, 21, 101, 98, 97 };
+
+		if ((link->dpcd_caps.sink_dev_id == 0x0010fa) &&
+		    !memcmp(link->dpcd_caps.sink_dev_id_str, str_mbp_2017,
+			    sizeof(str_mbp_2017))) {
+			link->reported_link_cap.link_rate = 0x0c;
+		}
+	}
+
 	core_link_read_dpcd(
 		link,
 		DP_SINK_HW_REVISION_START,
-- 
2.20.1



