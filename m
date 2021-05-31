Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B1B3960BC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbhEaObK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233710AbhEaO3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:29:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3877161421;
        Mon, 31 May 2021 13:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468884;
        bh=iTFHOW+j+J+7qE5PeNjpJG59ARpmR1B1eKLj1kqXsnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kScPhQdoVhceAEPrpj5rYy/c3woDGkcnQ9OFzoJaUw1ssq2NwKGsy+UsFWVWtrsNt
         z2WRB+pHZSUAywkkNk6q4kf87hyWb/EgmTouwAIPoTdKd9lIbqf8G4dEEvIxUfNAfM
         pEFgYGrNHQ2haVvO9i2qtozVDGE+CgVQmnJhbtXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Park <Chris.Park@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/177] drm/amd/display: Disconnect non-DP with no EDID
Date:   Mon, 31 May 2021 15:14:48 +0200
Message-Id: <20210531130652.462134267@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Park <Chris.Park@amd.com>

[ Upstream commit 080039273b126eeb0185a61c045893a25dbc046e ]

[Why]
Active DP dongles return no EDID when dongle
is connected, but VGA display is taken out.
Current driver behavior does not remove the
active display when this happens, and this is
a gap between dongle DTP and dongle behavior.

[How]
For active DP dongles and non-DP scenario,
disconnect sink on detection when no EDID
is read due to timeout.

Signed-off-by: Chris Park <Chris.Park@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 40041c61a100..6b03267021ea 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -936,6 +936,24 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 			    dc_is_dvi_signal(link->connector_signal)) {
 				if (prev_sink != NULL)
 					dc_sink_release(prev_sink);
+				link_disconnect_sink(link);
+
+				return false;
+			}
+			/*
+			 * Abort detection for DP connectors if we have
+			 * no EDID and connector is active converter
+			 * as there are no display downstream
+			 *
+			 */
+			if (dc_is_dp_sst_signal(link->connector_signal) &&
+				(link->dpcd_caps.dongle_type ==
+						DISPLAY_DONGLE_DP_VGA_CONVERTER ||
+				link->dpcd_caps.dongle_type ==
+						DISPLAY_DONGLE_DP_DVI_CONVERTER)) {
+				if (prev_sink)
+					dc_sink_release(prev_sink);
+				link_disconnect_sink(link);
 
 				return false;
 			}
-- 
2.30.2



