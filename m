Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C844835E0
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbiACRak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:30:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60370 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235538AbiACRaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:30:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEE426119C;
        Mon,  3 Jan 2022 17:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062B7C36AED;
        Mon,  3 Jan 2022 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231016;
        bh=XcKRw6VU8Obus4eQJer9KGJAkNtdp7IY/7VWiIpTi1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZvAExh6WAaU5afxv14EKISZKVNJ5MhA7B5ERY+FLqnTwCv7vsiSVn9pUx2jSzpg5
         Tzac4Kjfy7EQ9Y9G5302Xr0HEKuiTjNOm+IMUVVxkf1Cssl6Bs98+JrpI/GeSJTcD/
         nGGXE09AiLAyjxXOsvAqPNZPVrxyvuI5deE9COcCWSgI2rl8YBqsLY58s4NjGc1zth
         JJxuoxlO4KbzU74vOLDzbLzVnVLhsE4Pc93mDyIWjvDliLXAzx+Wngz8RH5tS4typV
         3/FL0Q9NFpAdOLwVMpEtOXL6QMPef55G5+0NOCn4xgxJe3/dOaa0Q0/H7WYpvVOoV8
         2oW6jzJVw46JQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Lai, Derek" <Derek.Lai@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, qingqing.zhuo@amd.com,
        wyatt.wood@amd.com, Jun.Lei@amd.com, aurabindo.pillai@amd.com,
        paul.hsieh@amd.com, Wesley.Chalmers@amd.com,
        victorchengchi.lu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 7/8] drm/amd/display: Added power down for DCN10
Date:   Mon,  3 Jan 2022 12:30:00 -0500
Message-Id: <20220103173001.1613277-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173001.1613277-1-sashal@kernel.org>
References: <20220103173001.1613277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Lai, Derek" <Derek.Lai@amd.com>

[ Upstream commit d97e631af2db84c8c9d63abf68d487d0bb559e4c ]

[Why]
The change of setting a timer callback on boot for 10 seconds is still
working, just lacked power down for DCN10.

[How]
Added power down for DCN10.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Derek Lai <Derek.Lai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
index b24c8ae8b1ece..7e228c181b298 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
@@ -77,6 +77,7 @@ static const struct hw_sequencer_funcs dcn10_funcs = {
 	.get_clock = dcn10_get_clock,
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
 	.calc_vupdate_position = dcn10_calc_vupdate_position,
+	.power_down = dce110_power_down,
 	.set_backlight_level = dce110_set_backlight_level,
 	.set_abm_immediate_disable = dce110_set_abm_immediate_disable,
 	.set_pipe = dce110_set_pipe,
-- 
2.34.1

