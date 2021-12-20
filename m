Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9050447AF49
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbhLTPKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238821AbhLTPJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F2AC08E84C;
        Mon, 20 Dec 2021 06:55:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 564ACB80EE7;
        Mon, 20 Dec 2021 14:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2620C36AE7;
        Mon, 20 Dec 2021 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012123;
        bh=OoCeohcd7HIYL552fKMo1DNN9/hK0Qu5jurMhubwWhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sy7lBZ+Xx1cO8PWN2okkuFfse0+jG4etGpGTq3GUjAdC2QpKd1D/g7+kYMT4dCFxf
         9QuPpzmEgSKyDHaUPz0FzlGAutRlImp0zehMQsDIxa1A3vZ+/kC42rT4KghQ3JDGAj
         8eAAjyHG2hg+GLH1gWaHUxuQwhKlWjS+LMktc2OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Yang <Eric.Yang2@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/177] drm/amd/display: Set exit_optimized_pwr_state for DCN31
Date:   Mon, 20 Dec 2021 15:33:58 +0100
Message-Id: <20211220143043.076129992@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 7e4d2f30df3fb48f75ce9e96867d42bdddab83ac ]

[Why]
SMU now respects the PHY refclk disable request from driver.

This causes a hang during hotplug when PHY refclk was disabled
because it's not being re-enabled and the transmitter control
starts on dc_link_detect.

[How]
We normally would re-enable the clk with exit_optimized_pwr_state
but this is only set on DCN21 and DCN301. Set it for dcn31 as well.

This fixes DMCUB timeouts in the PHY.

Fixes: 64b1d0e8d500 ("drm/amd/display: Add DCN3.1 HWSEQ")

Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
index 40011cd3c8ef0..ac8fb202fd5ee 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
@@ -100,6 +100,7 @@ static const struct hw_sequencer_funcs dcn31_funcs = {
 	.z10_save_init = dcn31_z10_save_init,
 	.is_abm_supported = dcn31_is_abm_supported,
 	.set_disp_pattern_generator = dcn30_set_disp_pattern_generator,
+	.exit_optimized_pwr_state = dcn21_exit_optimized_pwr_state,
 	.update_visual_confirm_color = dcn20_update_visual_confirm_color,
 };
 
-- 
2.33.0



