Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4002598ED
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgIAPaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730589AbgIAPaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D9EA214D8;
        Tue,  1 Sep 2020 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974212;
        bh=ycmxk5i8ePmn3f3t0OuO4dy8MaL56n5jOKzwYUsc690=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRjAm45hdirNS5OK3eYnhG8AMN4kq0LMMbYiGrvnNO5fXWWW8Eytu55h/OVR3VR3H
         pkzrTAjCRa0aNbhZqUOHHFvPdh21qwQB6lbjw56t35t2Jx7yLzOVQCf/Cv7ZSn5aZh
         afQvy0FhKlH+ZioAjJ+bFs13fo2VezyhMAkk/f04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stylon Wang <stylon.wang@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/214] drm/amd/display: Fix dmesg warning from setting abm level
Date:   Tue,  1 Sep 2020 17:09:28 +0200
Message-Id: <20200901150957.215018098@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

[ Upstream commit c5892a10218214d729699ab61bad6fc109baf0ce ]

[Why]
Setting abm level does not correctly update CRTC state. As a result
no surface update is added to dc stream state and triggers warning.

[How]
Correctly update CRTC state when setting abm level property.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3eb77f343bbfa..247f53d41993d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7306,6 +7306,29 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	if (ret)
 		goto fail;
 
+	/* Check connector changes */
+	for_each_oldnew_connector_in_state(state, connector, old_con_state, new_con_state, i) {
+		struct dm_connector_state *dm_old_con_state = to_dm_connector_state(old_con_state);
+		struct dm_connector_state *dm_new_con_state = to_dm_connector_state(new_con_state);
+
+		/* Skip connectors that are disabled or part of modeset already. */
+		if (!old_con_state->crtc && !new_con_state->crtc)
+			continue;
+
+		if (!new_con_state->crtc)
+			continue;
+
+		new_crtc_state = drm_atomic_get_crtc_state(state, new_con_state->crtc);
+		if (IS_ERR(new_crtc_state)) {
+			ret = PTR_ERR(new_crtc_state);
+			goto fail;
+		}
+
+		if (dm_old_con_state->abm_level !=
+		    dm_new_con_state->abm_level)
+			new_crtc_state->connectors_changed = true;
+	}
+
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 	if (adev->asic_type >= CHIP_NAVI10) {
 		for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
-- 
2.25.1



