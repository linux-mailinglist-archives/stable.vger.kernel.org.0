Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC6F6DEEF
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbfGSEEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729872AbfGSEEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:04:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA5C321873;
        Fri, 19 Jul 2019 04:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509050;
        bh=Zi3S6g+M0f/uYB3tHMAq1rTIrfHzL08LqPJ7bywJJHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQR9Eu5LglclQpD9t2ZY/5V6GnVvwKe3NBxjv9SD0jMzBtT8bpPaZe7fGoUiHVdtL
         2QRwSrjhpmYD7K33jtmR3R8dY/2QEzQO8tsCPLO4TJ2HwVsCjmpG7ci/5q3uFp2f4Q
         yI4VyLNaH2oo1Zd3HeIqKwD115RhIOhQqWF3iBAk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samson Tam <Samson.Tam@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 040/141] drm/amd/display: set link->dongle_max_pix_clk to 0 on a disconnect
Date:   Fri, 19 Jul 2019 00:01:05 -0400
Message-Id: <20190719040246.15945-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samson Tam <Samson.Tam@amd.com>

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
index 6072636da388..1367e2679082 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -922,6 +922,12 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 
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

