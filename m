Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFAE1EAC2A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbgFASQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731204AbgFASQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00E5D2065C;
        Mon,  1 Jun 2020 18:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035363;
        bh=rynJamA1lIjS8UZuZt+AefZJBK45Fj6llszBaNQyTC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOQ0t/6hRCO74HHLQ+PMJSQF0pat6XaTwxYPLFZlXGc3TUoKz1kc3k5SLO3xHpv2f
         3sHdFsSarZCDM4fR/lXDbuFLCgCoHAgLUfAjtrDC+5Bi/TP9RYjr6QwO/lFDycB9s/
         jRVb4fFFlVYTrO9giiogSS3C12DAQO32y7ApCqQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 124/177] drm/amd/display: drop cursor position check in atomic test
Date:   Mon,  1 Jun 2020 19:54:22 +0200
Message-Id: <20200601174058.909276270@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

[ Upstream commit f7d5991b92ff824798693ddf231cf814c9d5a88b ]

get_cursor_position already handles the case where the cursor has
negative off-screen coordinates by not setting
dc_cursor_position.enabled.

Signed-off-by: Simon Ser <contact@emersion.fr>
Fixes: 626bf90fe03f ("drm/amd/display: add basic atomic check for cursor plane")
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0cd11d3d4cf4..8e7cffe10cc5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7746,13 +7746,6 @@ static int dm_update_plane_state(struct dc *dc,
 			return -EINVAL;
 		}
 
-		if (new_plane_state->crtc_x <= -new_acrtc->max_cursor_width ||
-			new_plane_state->crtc_y <= -new_acrtc->max_cursor_height) {
-			DRM_DEBUG_ATOMIC("Bad cursor position %d, %d\n",
-							 new_plane_state->crtc_x, new_plane_state->crtc_y);
-			return -EINVAL;
-		}
-
 		return 0;
 	}
 
-- 
2.25.1



