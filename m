Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C44B313C45
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbhBHSEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:04:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235169AbhBHSAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FB4464EBF;
        Mon,  8 Feb 2021 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807121;
        bh=JWGIl2wJdPtQsta544evU1X5AIPRaSGLq/L7vizkwzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTRyvndFHaDwqFEcIH7iJiQD9SmTWm6vjC9vrq0CqHkvcjOQRQRxFlCYqIpVY75er
         D2Nu8+pD42+EH2JI+YYPAMKLOYFmC0lIFY7MbmiM7kCoTItCYjJ7oPi6VNOaaWxGRU
         Qk0z7NT+QTur6NVvX342Yn6cMGrPfM0+R8cPdwOmARezq/Cg+A+5xZoOO5EjEyeiFS
         cz+dHw6fTiD1rzfLMVCr0Y1KIs9ilfRbcZ6h0yfsSM+/pTKenHdc4mViv2Ky74nI4A
         DE+l1rIxlzQbHFVgrpd1lv4EEi5LuV4UDX9j4FFZylmmDkFJRSCHjl+SuHEnM74jog
         NIPWsDhkjLaUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Lu <victorchengchi.lu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 25/36] drm/amd/display: Decrement refcount of dc_sink before reassignment
Date:   Mon,  8 Feb 2021 12:57:55 -0500
Message-Id: <20210208175806.2091668-25-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Lu <victorchengchi.lu@amd.com>

[ Upstream commit 8e92bb0fa75bca9a57e4aba2e36f67d8016a3053 ]

[why]
An old dc_sink state is causing a memory leak because it is missing a
dc_sink_release before a new dc_sink is assigned back to
aconnector->dc_sink.

[how]
Decrement the dc_sink refcount before reassigning it to a new dc_sink.

Signed-off-by: Victor Lu <victorchengchi.lu@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 695a5b83c00f9..022821334153b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2261,8 +2261,10 @@ void amdgpu_dm_update_connector_after_detect(
 		 * TODO: check if we still need the S3 mode update workaround.
 		 * If yes, put it here.
 		 */
-		if (aconnector->dc_sink)
+		if (aconnector->dc_sink) {
 			amdgpu_dm_update_freesync_caps(connector, NULL);
+			dc_sink_release(aconnector->dc_sink);
+		}
 
 		aconnector->dc_sink = sink;
 		dc_sink_retain(aconnector->dc_sink);
-- 
2.27.0

