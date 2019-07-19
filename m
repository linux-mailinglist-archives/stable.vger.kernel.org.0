Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADB76E00D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfGSEjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbfGSD6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20E5021850;
        Fri, 19 Jul 2019 03:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508729;
        bh=iBNWIBHZgGTe5Q+jdZRd+ngLa9VpaLIgZwj92vwqXyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxorIxo+cqLMrPMWZfPF0TxLhvDMEk/xqLJascO2VQRbtzGGqvy0lMKuVHaWFSqhJ
         KkIxN3PI5Ku7e2BTu6v7auoQ2/3kDSqZ/sqfRqtN2LvuOWIUywCbFwbqsOalQhz68v
         /8z2Yoo2O88Dq1MCSmWYPDRuSi09ECn708NHOx9s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samson Tam <Samson.Tam@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 055/171] drm/amd/display: set link->dongle_max_pix_clk to 0 on a disconnect
Date:   Thu, 18 Jul 2019 23:54:46 -0400
Message-Id: <20190719035643.14300-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
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

