Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87803BD12F
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbhGFLif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236378AbhGFLfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59DC861E2B;
        Tue,  6 Jul 2021 11:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570612;
        bh=4C0lKNgXTCKNz35FbKot2gFcyMQerStQtkexXZeC10M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1bijugOFPWUdEA7VdfVci19d5a8kHFobpaa67GG0lgfNS8MDwqQkSbsY20EASMyN
         4dj+9SH6HW8K/7sIFasXsc6epQSbtnw7QO9LWp0xwHkwGlYbf2POogQaFeDUmNHQ2Q
         npVynA/qkST9ilvr47kn9pHJsH9Svtcnm6WOIJImc3ACjS9hHmuR2tN+WhR6TbJpZb
         npfLHNbLbVcxUFun1WGwNha37pyJWN7xgaMgwSWyUNMioKJIQqTvuIIvAGsmI+gCBq
         yLMADxEcA6TORgk4B1Rgoi636/3C9vm6YyyCp3UqR47DjBShqlTMZmoBt/uWxqthNA
         ybPOSnlSV9gsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Stempen <vladimir.stempen@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 069/137] drm/amd/display: Release MST resources on switch from MST to SST
Date:   Tue,  6 Jul 2021 07:20:55 -0400
Message-Id: <20210706112203.2062605-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Stempen <vladimir.stempen@amd.com>

[ Upstream commit 3f8518b60c10aa96f3efa38a967a0b4eb9211ac0 ]

[why]
When OS overrides training link training parameters
for MST device to SST mode, MST resources are not
released and leak of the resource may result crash and
incorrect MST discovery during following hot plugs.

[how]
Retaining sink object to be reused by SST link and
releasing MST  resources.

Signed-off-by: Vladimir Stempen <vladimir.stempen@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 32b73ea86673..a7f8caf1086b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1704,6 +1704,8 @@ static void set_dp_mst_mode(struct dc_link *link, bool mst_enable)
 		link->type = dc_connection_single;
 		link->local_sink = link->remote_sinks[0];
 		link->local_sink->sink_signal = SIGNAL_TYPE_DISPLAY_PORT;
+		dc_sink_retain(link->local_sink);
+		dm_helpers_dp_mst_stop_top_mgr(link->ctx, link);
 	} else if (mst_enable == true &&
 			link->type == dc_connection_single &&
 			link->remote_sinks[0] != NULL) {
-- 
2.30.2

