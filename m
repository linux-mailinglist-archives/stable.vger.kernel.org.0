Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B7C31BCF4
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhBOPht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231300AbhBOPgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:36:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 907BF64ED0;
        Mon, 15 Feb 2021 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403118;
        bh=sN/6ha34otOeEaBysqzwB3pj0rwepRQlUkw7Q+tX/U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTwlqFk3/Cl0Oi/xRBHV951eMAS6w57hAWIlP9ZBptH6Cprkbh4+Tz/HcyoqNrHSe
         rEcdPiO6BeyyahgvxlU+SvsQ2/NZIhjrkt1ZtjlSCLR3u5yPfhMhrialNw+iXHVBu3
         23KOHz/KPWlrHwUJHkvJBOr3EWVEOtLj2CqovpN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikita Lipski <mikita.lipski@amd.com>,
        Eryk Brol <Eryk.Brol@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/104] drm/amd/display: Release DSC before acquiring
Date:   Mon, 15 Feb 2021 16:26:46 +0100
Message-Id: <20210215152720.557440832@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikita Lipski <mikita.lipski@amd.com>

[ Upstream commit 58180a0cc0c57fe62a799a112f95b60f6935bd96 ]

[why]
Need to unassign DSC from pipes that are not using it
so other pipes can acquire it. That is needed for
asic's that have unmatching number of DSC engines from
the number of pipes.

[how]
Before acquiring dsc to stream resources, first remove it.

Signed-off-by: Mikita Lipski <mikita.lipski@amd.com>
Reviewed-by: Eryk Brol <Eryk.Brol@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index eee19edeeee5c..1e448f1b39a18 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -828,6 +828,9 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 		if (computed_streams[i])
 			continue;
 
+		if (dcn20_remove_stream_from_ctx(stream->ctx->dc, dc_state, stream) != DC_OK)
+			return false;
+
 		mutex_lock(&aconnector->mst_mgr.lock);
 		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link)) {
 			mutex_unlock(&aconnector->mst_mgr.lock);
@@ -845,7 +848,8 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 		stream = dc_state->streams[i];
 
 		if (stream->timing.flags.DSC == 1)
-			dc_stream_add_dsc_to_resource(stream->ctx->dc, dc_state, stream);
+			if (dc_stream_add_dsc_to_resource(stream->ctx->dc, dc_state, stream) != DC_OK)
+				return false;
 	}
 
 	return true;
-- 
2.27.0



