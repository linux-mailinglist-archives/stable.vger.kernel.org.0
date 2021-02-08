Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC304313C77
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbhBHSHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235288AbhBHSDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64AF364EDA;
        Mon,  8 Feb 2021 17:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807157;
        bh=nT1ve2AIRZuz7eDW8i0oXHiR6/aEXbA+Rkjiez1uNCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToAd8m85HFtyQYPeohpbOqVFnzVQZZeB/wFUsF92ou38ljEmMs+e2gBtRCgaSApby
         u7vJ3v1/23WGaKzlHDAs1+zNuzTNWQxeGX3x/Azhp5+nKETQJG1YBYsorAuVmRexXw
         /NIFXjY1TPVkRnmjceKaznTmjURFHIyxUAbZWLsO+PZmG23Wzka5fgC26MD1RYhDbv
         UUxN0ViAc5YJvK+DUcrQPrnxUAR4UGCQ+EkMnHDoAJC8ncjrSx5EYIgq9q7/K2L/Bw
         OPH6ojgR+/l5GxGhuH/OcoYkR7Nmlj17p4+iSjPDwABbKJiR+q8RtS/Bg/gsmXFztN
         pSxbogWfEOSEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Lu <victorchengchi.lu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 13/19] drm/amd/display: Decrement refcount of dc_sink before reassignment
Date:   Mon,  8 Feb 2021 12:58:52 -0500
Message-Id: <20210208175858.2092008-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175858.2092008-1-sashal@kernel.org>
References: <20210208175858.2092008-1-sashal@kernel.org>
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
index 9284960d24b0a..13f963047766b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1417,8 +1417,10 @@ amdgpu_dm_update_connector_after_detect(struct amdgpu_dm_connector *aconnector)
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

