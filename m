Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76872E176C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgLWDKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbgLWCSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CF432312E;
        Wed, 23 Dec 2020 02:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689814;
        bh=Vx3ezAW5GJLBA67L7m77bVSFJqgm6ZZ07DOmRVrLuZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Krz+61sH3vYZl1a28xJqKdjQU2B0vvkNOyjTW7amKFEhEd48T1CH/EAgvwH+23FNI
         TEf2qpbjHgVh0gFuwujnYjw+8753nE6cwDOzn8c/Rk7T/HS4SIvk45PKSG4V9Jsrqo
         vymIRX5u2+JqWd5HzT8tMx/4wsELm2PfW18rpiOLP3DWXoGbmYbVxhG2DRHRa5LSPQ
         4prMWkWF2AxfBLwMyrerN9NJeMS2igqIzER36tV+n7SD7D4grnjjdM3rcVziux8C/U
         Yc1OjSHKFBm4jnzkoQnmus0rs4i0tjU9yTTHrNbkco5J726frHJ6rOqSGuXWJ6Q48N
         c3iPRJlGnYiiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lewis Huang <Lewis.Huang@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 021/217] drm/amd/display: stop top_mgr when type change to non-MST during s3
Date:   Tue, 22 Dec 2020 21:13:10 -0500
Message-Id: <20201223021626.2790791-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lewis Huang <Lewis.Huang@amd.com>

[ Upstream commit e748b59fb74e8725c8774a4b0753fabba9de7b97 ]

[Why]
Driver keeps the invalid information cause report the
incorrect monitor which save in remote sink to OS

[How]
When connector type change from MST to non-MST,
stop the topology manager.

Signed-off-by: Lewis Huang <Lewis.Huang@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 5b0cedfa824a9..59c5915665112 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -854,6 +854,7 @@ static bool dc_link_detect_helper(struct dc_link *link,
 	struct dpcd_caps prev_dpcd_caps;
 	bool same_dpcd = true;
 	enum dc_connection_type new_connection_type = dc_connection_none;
+	enum dc_connection_type pre_connection_type = dc_connection_none;
 	bool perform_dp_seamless_boot = false;
 	const uint32_t post_oui_delay = 30; // 30ms
 
@@ -889,6 +890,7 @@ static bool dc_link_detect_helper(struct dc_link *link,
 
 	link_disconnect_sink(link);
 	if (new_connection_type != dc_connection_none) {
+		pre_connection_type = link->type;
 		link->type = new_connection_type;
 		link->link_state_valid = false;
 
@@ -962,6 +964,12 @@ static bool dc_link_detect_helper(struct dc_link *link,
 				return true;
 			}
 
+			// link switch from MST to non-MST stop topology manager
+			if (pre_connection_type == dc_connection_mst_branch &&
+				link->type != dc_connection_mst_branch) {
+				dm_helpers_dp_mst_stop_top_mgr(link->ctx, link);
+			}
+
 			if (link->type == dc_connection_mst_branch) {
 				LINK_INFO("link=%d, mst branch is now Connected\n",
 					  link->link_index);
-- 
2.27.0

