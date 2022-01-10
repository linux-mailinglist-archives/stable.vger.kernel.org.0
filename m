Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB3C4891FF
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240972AbiAJHhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42584 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiAJHe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:34:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10C616066C;
        Mon, 10 Jan 2022 07:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC10EC36AED;
        Mon, 10 Jan 2022 07:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800066;
        bh=3d/VhBi2lZVpCSYF9b6YMw1VZK8qmealpP+wEmBOY5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBbUUfRE5YCLmmJAY9Z3T8nw+GJ5cGx6Q5WA6y4rNFWqCqzgby4EI28ZwuzKyEkGm
         a1/1PxVSRLxgxeEBmNo0ydQdPLv7Lc2r8VfWzc3+A3IDwgF6JG/mpxfPGswod4tmco
         DnteCQlNWkaro7mFAfIrWoFTcjGbOz946RWmhtZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Derek Lai <Derek.Lai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 66/72] drm/amd/display: Added power down for DCN10
Date:   Mon, 10 Jan 2022 08:23:43 +0100
Message-Id: <20220110071823.798696291@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai, Derek <Derek.Lai@amd.com>

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
index 34001a30d449a..10e613ec7d24f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
@@ -78,6 +78,7 @@ static const struct hw_sequencer_funcs dcn10_funcs = {
 	.get_clock = dcn10_get_clock,
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
 	.calc_vupdate_position = dcn10_calc_vupdate_position,
+	.power_down = dce110_power_down,
 	.set_backlight_level = dce110_set_backlight_level,
 	.set_abm_immediate_disable = dce110_set_abm_immediate_disable,
 	.set_pipe = dce110_set_pipe,
-- 
2.34.1



