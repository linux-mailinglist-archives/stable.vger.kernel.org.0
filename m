Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC0729A0EC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409327AbgJZXvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409258AbgJZXvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1919820B1F;
        Mon, 26 Oct 2020 23:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756269;
        bh=SbFHCpjFUIgnRes5SSzBfbN3T+ObB3Aq3esfOYYDvAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTRRimrOytpWvFAuwXfJw/g4fTnygSiMZhyPK/U7NhTvMb7HHZfuN8ihv+iiB8t1c
         1MKwWuUouc61UsRS/L3NeFScxmZtOhf51h2tTZMU8ddEstI4v9n5MDmTEGW0g+JtcO
         pOolzRxHHSx+Xd835u0Sv5z9O1F7rTcaWETC4TeI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 101/147] drm/amd/display: Avoid set zero in the requested clk
Date:   Mon, 26 Oct 2020 19:48:19 -0400
Message-Id: <20201026234905.1022767-101-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 2f8be0e516803cc3fd87c1671247896571a5a8fb ]

[Why]
Sometimes CRTCs can be disabled due to display unplugging or temporarily
transition in the userspace; in these circumstances, DCE tries to set
the minimum clock threshold. When we have this situation, the function
bw_calcs is invoked with number_of_displays set to zero, making DCE set
dispclk_khz and sclk_khz to zero. For these reasons, we have seen some
ATOM bios errors that look like:

[drm:atom_op_jump [amdgpu]] *ERROR* atombios stuck in loop for more than
5secs aborting
[drm:amdgpu_atom_execute_table_locked [amdgpu]] *ERROR* atombios stuck
executing EA8A (len 761, WS 0, PS 0) @ 0xEABA

[How]
This error happens due to an attempt to optimize the bandwidth using the
sclk, and the dispclk clock set to zero. Technically we handle this in
the function dce112_set_clock, but we are not considering the case that
this value is set to zero. This commit fixes this issue by ensuring that
we never set a minimum value below the minimum clock threshold.

Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.c
index d031bd3d30724..807dca8f7d7aa 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.c
@@ -79,8 +79,7 @@ int dce112_set_clock(struct clk_mgr *clk_mgr_base, int requested_clk_khz)
 	memset(&dce_clk_params, 0, sizeof(dce_clk_params));
 
 	/* Make sure requested clock isn't lower than minimum threshold*/
-	if (requested_clk_khz > 0)
-		requested_clk_khz = max(requested_clk_khz,
+	requested_clk_khz = max(requested_clk_khz,
 				clk_mgr_dce->base.dentist_vco_freq_khz / 62);
 
 	dce_clk_params.target_clock_frequency = requested_clk_khz;
-- 
2.25.1

