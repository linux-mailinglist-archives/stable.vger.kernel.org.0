Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAE1475EE6
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343728AbhLORZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245744AbhLORYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:24:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C21C06175F;
        Wed, 15 Dec 2021 09:24:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3026F619DD;
        Wed, 15 Dec 2021 17:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18600C36AE0;
        Wed, 15 Dec 2021 17:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589079;
        bh=AyoHifn+/ImfQlTAtfaiyUdaCTt/T06uqlHG0spFmN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsaFPY0KTlybPQyIe/jdBMUL4aSo+DrR45HgLteFrnV9T89Cj/bs2FPJeYUVZG86l
         bRTIII6vrid/zjCD84mDYpd7x5/AKcNLJO4yVC2E0KTZ7aeVnhr27wmjhADY2n58X1
         JtzRWRh78G+ZSiNwWNHF0X1ZUYztztDjX9cqh2RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Perry Yuan <Perry.Yuan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/33] drm/amd/display: add connector type check for CRC source set
Date:   Wed, 15 Dec 2021 18:21:11 +0100
Message-Id: <20211215172025.230572511@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e00a30e7d2529..04c20ce6e94df 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -226,6 +226,14 @@ int amdgpu_dm_crtc_set_crc_source(struct drm_crtc *crtc, const char *src_name)
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



