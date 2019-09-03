Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA81A7062
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbfICQi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730540AbfICQ0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7BD823891;
        Tue,  3 Sep 2019 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527964;
        bh=h35IVQDj3bs9GCL91wugfmbfgHOaXuPVSjlljFLrPLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkAe1evdR5ICE0GHcEd52MNOjDnOtT3IyI3s6izEKWaSGPMAuXM/w94bTgzYQfNZM
         hI6wCHLVN/FEPq4E9Ts6idU2dGUVJJ8N7m1E/PgkH8DtmTjhJlmRebNqkkTcSvRDnY
         UXV1l+kMGTHOzRITgFAyfT0ns4Qkv6YiaDGlvogg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>, Jerry Zuo <Jerry.Zuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 024/167] drm/amd/dm: Understand why attaching path/tile properties are needed
Date:   Tue,  3 Sep 2019 12:22:56 -0400
Message-Id: <20190903162519.7136-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 04ac4b0ed412f65230b456fcd9aa07e13befff89 ]

Path property is used for userspace to know what MST connector goes to what actual DRM DisplayPort connector, the tiling property is for tiling configurations. Not sure what else there is to figure out.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Jerry (Fangzhi) Zuo <Jerry.Zuo@amd.com>
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 59445c83f0238..c85bea70d9652 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -377,9 +377,6 @@ dm_dp_add_mst_connector(struct drm_dp_mst_topology_mgr *mgr,
 	drm_connector_attach_encoder(&aconnector->base,
 				     &aconnector->mst_encoder->base);
 
-	/*
-	 * TODO: understand why this one is needed
-	 */
 	drm_object_attach_property(
 		&connector->base,
 		dev->mode_config.path_property,
-- 
2.20.1

