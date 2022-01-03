Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1952048336E
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiACOgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:36:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38140 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbiACOeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:34:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15F9EB80EF1;
        Mon,  3 Jan 2022 14:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CED6C36AEB;
        Mon,  3 Jan 2022 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220451;
        bh=E+5/RIiKY/m5zMhWOzcyZNyybm3tMmAh2V2Ya+OtY6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kog1QiDsPOo99jEHC+v6TIzUdsQ0r6YcKDE7e7/uQ0JGc291lV9/t7fA+2djyLQtQ
         HEizRwNljhYb8tsqPEOaAZF8PwtN8dszVnYppSfGQUrZvPK/qKQUzarwjSi2Q3lpO3
         71gBhPiGnIEg6Xuo2Ty+s8PHsAn21NzylBsPehSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 40/73] drm/amd/display: Set optimize_pwr_state for DCN31
Date:   Mon,  3 Jan 2022 15:24:01 +0100
Message-Id: <20220103142058.199888144@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 33735c1c8d0223170d79dbe166976d9cd7339c7a ]

[Why]
We'll exit optimized power state to do link detection but we won't enter
back into the optimized power state.

This could potentially block s2idle entry depending on the sequencing,
but it also means we're losing some power during the transition period.

[How]
Hook up the handler like DCN21. It was also missed like the
exit_optimized_pwr_state callback.

Fixes: 64b1d0e8d500 ("drm/amd/display: Add DCN3.1 HWSEQ")

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
index ac8fb202fd5ee..4e9fe090b770a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
@@ -100,6 +100,7 @@ static const struct hw_sequencer_funcs dcn31_funcs = {
 	.z10_save_init = dcn31_z10_save_init,
 	.is_abm_supported = dcn31_is_abm_supported,
 	.set_disp_pattern_generator = dcn30_set_disp_pattern_generator,
+	.optimize_pwr_state = dcn21_optimize_pwr_state,
 	.exit_optimized_pwr_state = dcn21_exit_optimized_pwr_state,
 	.update_visual_confirm_color = dcn20_update_visual_confirm_color,
 };
-- 
2.34.1



