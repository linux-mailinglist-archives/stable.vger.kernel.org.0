Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7049A3CA6F7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbhGOSvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239816AbhGOSu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:50:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1A6D613E4;
        Thu, 15 Jul 2021 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374877;
        bh=FrBFz7/w6+PKW1mVMpwaR/JBwSjt+rMNS1Y/1JJj+qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EfVV7OO4JOoQgpk8u8od2h1pVxvGXHU1Wc0SKtK9xjXajTIo8XIKoky1tVYIXzKb
         X/mK7Q0uMP0je57+/9osvU8OQL6qhmY1479W0yeNHCHom400R3WbX609a16U0osQ1p
         v4PpXBKCPGAzDvzxvnvs9ewBkFTGQ2GOjGbEC7+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Li <roman.li@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/215] drm/amd/display: Update scaling settings on modeset
Date:   Thu, 15 Jul 2021 20:37:17 +0200
Message-Id: <20210715182610.887608218@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index df26c07cb912..b413a7a2e92f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8291,7 +8291,8 @@ skip_modeset:
 	BUG_ON(dm_new_crtc_state->stream == NULL);
 
 	/* Scaling or underscan settings */
-	if (is_scaling_state_different(dm_old_conn_state, dm_new_conn_state))
+	if (is_scaling_state_different(dm_old_conn_state, dm_new_conn_state) ||
+				drm_atomic_crtc_needs_modeset(new_crtc_state))
 		update_stream_scaling_settings(
 			&new_crtc_state->mode, dm_new_conn_state, dm_new_crtc_state->stream);
 
-- 
2.30.2



