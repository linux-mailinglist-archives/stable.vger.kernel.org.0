Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA3348918B
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbiAJHdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:33:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59722 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239770AbiAJHbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:31:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33878B8121A;
        Mon, 10 Jan 2022 07:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3F2C36AED;
        Mon, 10 Jan 2022 07:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799862;
        bh=VFsMEDFi2et/sw+n4+sEQCpcZOafJvKtFXe8OymcemI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffgk2llh5OLsqb+RpmajVWvgdNZNt8Eu8VU4raaQG9rGNKPCxfDoAcE1K+rEJxo+Y
         FqOmP18cbxv5tMZbNVefdBOKn8HACu4befET8TE2+jcNBk0+UTFf/h/6GRFL/LbQ9g
         5rm/R8Fd6v4AeWw/YL8Qq01ASIOsT2s9wMh9InG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Derek Lai <Derek.Lai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/43] drm/amd/display: Added power down for DCN10
Date:   Mon, 10 Jan 2022 08:23:37 +0100
Message-Id: <20220110071818.701348709@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
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



