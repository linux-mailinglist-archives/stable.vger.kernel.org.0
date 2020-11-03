Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D86C2A5911
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbgKCUnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729967AbgKCUnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 169952224E;
        Tue,  3 Nov 2020 20:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436200;
        bh=igF921TXROWhmKPIpqLWNTsZaYu2639iJ/eTAfAtvzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmc9IEeEcObjxPCit37MsklxkA9bPYUz1YxnR5RIn/9e6bDsOJKQo6W3xM6qsU24w
         898z2n/JjN7CuVo/cb6ckQvFHTdxZiY3cNPwcdiz7h7EqjP7rpI2J1DVDEnnThm2eh
         dT8AymWPfbTroDtDMG7T+oBmNx7jxoXxeqE9NmWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 139/391] drm/amd/display: Avoid set zero in the requested clk
Date:   Tue,  3 Nov 2020 21:33:10 +0100
Message-Id: <20201103203356.210599632@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.27.0



