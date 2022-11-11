Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F66625078
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiKKCfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiKKCfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:35:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BCC183A7;
        Thu, 10 Nov 2022 18:34:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99C64B823E1;
        Fri, 11 Nov 2022 02:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB54C433C1;
        Fri, 11 Nov 2022 02:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134061;
        bh=EuzErssSyHjynzOKeKg6p5l3yLMRR0f+GKAXW2NIwjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3xJq1j7f7l7b6PRktJP8OtHtkR7YHtVqfm0KdgNLv7WRIshvcon+N2tkqeGhJIzJ
         LLWqRrUsEt6JK7nEMfrv6EOiO5LlT9JHuBTYu97MjzB3OGniKXMkEY227OO63khG3f
         ClG2z/ZrpOiwJ6nE7NxtCq8sGwbbsQhHkufBOsusncxk1qG2uZAFKpxnMOCj5uC+pK
         0Cy/07jOFlyf8Uo8cmms0BOAKpiSIYiZOPQCSIg5Ia2dQ+QgF9lNVagdB+HenZAjcJ
         6xWK0LH7j5dz6tDzshio/4+DqQlSPFiWdtEGc34ztCHuXKsLA5GuMFodYo5JarBVNZ
         SpOWxAKbKSArQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvin Lee <Alvin.Lee2@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Martin Leung <Martin.Leung@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, mwen@igalia.com,
        HaoPing.Liu@amd.com, yang.lee@linux.alibaba.com,
        magalilemes00@gmail.com, dillon.varone@amd.com, Eric.Yang2@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 19/30] drm/amd/display: Enable timing sync on DCN32
Date:   Thu, 10 Nov 2022 21:33:27 -0500
Message-Id: <20221111023340.227279-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Lee <Alvin.Lee2@amd.com>

[ Upstream commit c3d3f35b725bf9c93bec6d3c056f6bb7cfd27403 ]

Missed enabling timing sync on DCN32 because DCN32 has a different DML
param.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
index d34e0f1314d9..bc4f48ea8d4c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -1228,6 +1228,7 @@ int dcn20_populate_dml_pipes_from_context(
 		pipes[pipe_cnt].pipe.src.dcc = false;
 		pipes[pipe_cnt].pipe.src.dcc_rate = 1;
 		pipes[pipe_cnt].pipe.dest.synchronized_vblank_all_planes = synchronized_vblank;
+		pipes[pipe_cnt].pipe.dest.synchronize_timings = synchronized_vblank;
 		pipes[pipe_cnt].pipe.dest.hblank_start = timing->h_total - timing->h_front_porch;
 		pipes[pipe_cnt].pipe.dest.hblank_end = pipes[pipe_cnt].pipe.dest.hblank_start
 				- timing->h_addressable
-- 
2.35.1

