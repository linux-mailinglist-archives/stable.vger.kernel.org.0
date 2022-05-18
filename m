Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222E852BA1A
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbiERM1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbiERM1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:27:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBB7D9E95;
        Wed, 18 May 2022 05:27:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86FC2B81F40;
        Wed, 18 May 2022 12:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A982C385AA;
        Wed, 18 May 2022 12:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876839;
        bh=E0vUSpxPLIELQGfG4YeyedZtqjlmxegQcKpK3CCbthE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfHUldWT8Xb55/imk/v5BODMMKCN37xvePjU41MIbiDHoezb+xFXONij+GgN19QZi
         OQywl3CjOGckobljrFa6h7nJM2pzW0wiOlnVY1Up+qMguoGwVevXZkOL+fyup/y7sW
         WlIqVJX6uuYQNFs2roi1I8nIijM3gJHjhxxi/wRn3goesns21C+aN8NulUtnv3kF9I
         EPMqw1qL/Vs38q4ZS/gleijfWIKGFuGPpSg5tLbGFBgVKU/uKa5v6I0FLHjzJVl32d
         U0e69RVqk8b2wayLtKVHqBw9/AqLQzlHIubnQRBfSnZzUrK8wnnFLWoYsFshIQHBM4
         5fCXq4E9zGzkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Yang <Eric.Yang2@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com, haonan.wang2@amd.com,
        mikita.lipski@amd.com, wyatt.wood@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 13/23] drm/amd/display: undo clearing of z10 related function pointers
Date:   Wed, 18 May 2022 08:26:26 -0400
Message-Id: <20220518122641.342120-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Yang <Eric.Yang2@amd.com>

[ Upstream commit 9b9bd3f640640f94272a461b2dfe558f91b322c5 ]

[Why]
Z10 and S0i3 have some shared path. Previous code clean up ,
incorrectly removed these pointers, which breaks s0i3 restore

[How]
Do not clear the function pointers based on Z10 disable.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Signed-off-by: Eric Yang <Eric.Yang2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
index d7559e5a99ce..e708f07fe75a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c
@@ -153,9 +153,4 @@ void dcn31_hw_sequencer_construct(struct dc *dc)
 		dc->hwss.init_hw = dcn20_fpga_init_hw;
 		dc->hwseq->funcs.init_pipes = NULL;
 	}
-	if (dc->debug.disable_z10) {
-		/*hw not support z10 or sw disable it*/
-		dc->hwss.z10_restore = NULL;
-		dc->hwss.z10_save_init = NULL;
-	}
 }
-- 
2.35.1

