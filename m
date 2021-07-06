Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855613BCF83
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhGFLam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234589AbhGFL2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:28:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E60E61CBA;
        Tue,  6 Jul 2021 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570408;
        bh=wzLjToPbmfSkVbXTXcbLjOwt06ZRBN570Qx/iMEQvNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbd/hpKMemRjfDX40khNa5rVvgZHgCUf1AwFv2UYQxGATptdC93u8sJer3gTuc+Zl
         N6GTlAvbt7kYo2REQFwUlBDFXRw2wRA4xivbBp7fF77h7T0RySZOkpGzU5Zu+V5x1E
         oLCTM/nxYxwRuSNjTm6etErnGmv0fSreEEQUXOq5OZkMQSEewCdHC3ffj5ajCePY3l
         9mZ1mEZjuaKBX22FGC3o+/Ua/u2+cQDq+hEBfmYlwerVx2Q7NpkDl7htO7P4LRpBOv
         oCh/ACfUdHdPQe0zNVJdP5zBvm7XQVpRN1XlFHDGsz0i0VcuRy0gHBlGQgE3ZGX9ZL
         9l+LTkUxnpAEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <roman.li@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 076/160] drm/amd/display: Update scaling settings on modeset
Date:   Tue,  6 Jul 2021 07:17:02 -0400
Message-Id: <20210706111827.2060499-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <roman.li@amd.com>

[ Upstream commit c521fc316d12fb9ea7b7680e301d673bceda922e ]

[Why]
We update scaling settings when scaling mode has been changed.
However when changing mode from native resolution the scaling mode previously
set gets ignored.

[How]
Perform scaling settings update on modeset.

Signed-off-by: Roman Li <roman.li@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d95569e0e53a..217b5e50eebe 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8924,7 +8924,8 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	BUG_ON(dm_new_crtc_state->stream == NULL);
 
 	/* Scaling or underscan settings */
-	if (is_scaling_state_different(dm_old_conn_state, dm_new_conn_state))
+	if (is_scaling_state_different(dm_old_conn_state, dm_new_conn_state) ||
+				drm_atomic_crtc_needs_modeset(new_crtc_state))
 		update_stream_scaling_settings(
 			&new_crtc_state->mode, dm_new_conn_state, dm_new_crtc_state->stream);
 
-- 
2.30.2

