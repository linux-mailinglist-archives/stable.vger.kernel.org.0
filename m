Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A9346AA06
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351174AbhLFVXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:23:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58640 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351220AbhLFVW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:22:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8CE8B8110F;
        Mon,  6 Dec 2021 21:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B8FC341C1;
        Mon,  6 Dec 2021 21:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825564;
        bh=90oVr+l1nw0SKDOGAbCUXHNjVu4a5/eCBcOj63Rg83E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLacqnqrQg3dFJLM1N/YYTxPBBsWMKwjHSHEt0MTQgkKquOn0azdTTV04Q5Te9ZQF
         6psK8dz8zRxenNXpLt7i/07ksTUnYtHx41eyvkcQ9yE2VKoyo5fZrLgoFX/dLvOaj/
         rZjF4gpZ0D3u8ViSN/aErSx3LqcbxrSwlm/RigQ/sIR1VZ1QEE1pWTSs7XYm+FMMLn
         gKnt/bghyYMiL7iqHew0CuctNK4Q9LsJAzXp6Do9/QgfTp7obYqx9uslpMnq3UNEms
         l1rY0zCMSveVLXU/TB8JT0P07pZbTEtxJJDbP2E/dNRiOqggpNo1D0um1IpnHStM6f
         XVHpAKdxGaxQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Perry Yuan <Perry.Yuan@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, sunpeng.li@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Wayne.Lin@amd.com, Nicholas.Kazlauskas@amd.com,
        Stylon.Wang@amd.com, dingchen.zhang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 09/10] drm/amd/display: add connector type check for CRC source set
Date:   Mon,  6 Dec 2021 16:17:28 -0500
Message-Id: <20211206211738.1661003-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211738.1661003-1-sashal@kernel.org>
References: <20211206211738.1661003-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Perry Yuan <Perry.Yuan@amd.com>

[ Upstream commit 2da34b7bb59e1caa9a336e0e20a76b8b6a4abea2 ]

[Why]
IGT bypass test will set crc source as DPRX,and display DM didn`t check
connection type, it run the test on the HDMI connector ,then the kernel
will be crashed because aux->transfer is set null for HDMI connection.
This patch will skip the invalid connection test and fix kernel crash issue.

[How]
Check the connector type while setting the pipe crc source as DPRX or
auto,if the type is not DP or eDP, the crtc crc source will not be set
and report error code to IGT test,IGT will show the this subtest as no
valid crtc/connector combinations found.

116.779714] [IGT] amd_bypass: starting subtest 8bpc-bypass-mode
[ 117.730996] BUG: kernel NULL pointer dereference, address: 0000000000000000
[ 117.731001] #PF: supervisor instruction fetch in kernel mode
[ 117.731003] #PF: error_code(0x0010) - not-present page
[ 117.731004] PGD 0 P4D 0
[ 117.731006] Oops: 0010 [#1] SMP NOPTI
[ 117.731009] CPU: 11 PID: 2428 Comm: amd_bypass Tainted: G OE 5.11.0-34-generic #36~20.04.1-Ubuntu
[ 117.731011] Hardware name: AMD CZN/, BIOS AB.FD 09/07/2021
[ 117.731012] RIP: 0010:0x0
[ 117.731015] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[ 117.731016] RSP: 0018:ffffa8d64225bab8 EFLAGS: 00010246
[ 117.731017] RAX: 0000000000000000 RBX: 0000000000000020 RCX: ffffa8d64225bb5e
[ 117.731018] RDX: ffff93151d921880 RSI: ffffa8d64225bac8 RDI: ffff931511a1a9d8
[ 117.731022] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 117.731023] CR2: ffffffffffffffd6 CR3: 000000010d5a4000 CR4: 0000000000750ee0
[ 117.731023] PKRU: 55555554
[ 117.731024] Call Trace:
[ 117.731027] drm_dp_dpcd_access+0x72/0x110 [drm_kms_helper]
[ 117.731036] drm_dp_dpcd_read+0xb7/0xf0 [drm_kms_helper]
[ 117.731040] drm_dp_start_crc+0x38/0xb0 [drm_kms_helper]
[ 117.731047] amdgpu_dm_crtc_set_crc_source+0x1ae/0x3e0 [amdgpu]
[ 117.731149] crtc_crc_open+0x174/0x220 [drm]
[ 117.731162] full_proxy_open+0x168/0x1f0
[ 117.731165] ? open_proxy_open+0x100/0x100

BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1546
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
index f0b001b3af578..883ee517673bd 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -221,6 +221,14 @@ int amdgpu_dm_crtc_set_crc_source(struct drm_crtc *crtc, const char *src_name)
 			ret = -EINVAL;
 			goto cleanup;
 		}
+
+		if ((aconn->base.connector_type != DRM_MODE_CONNECTOR_DisplayPort) &&
+				(aconn->base.connector_type != DRM_MODE_CONNECTOR_eDP)) {
+			DRM_DEBUG_DRIVER("No DP connector available for CRC source\n");
+			ret = -EINVAL;
+			goto cleanup;
+		}
+
 	}
 
 	if (amdgpu_dm_crtc_configure_crc_source(crtc, crtc_state, source)) {
-- 
2.33.0

