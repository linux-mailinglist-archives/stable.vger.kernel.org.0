Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18ACB5F950E
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiJJAPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiJJANf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:13:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14053893;
        Sun,  9 Oct 2022 16:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9820EB80DE5;
        Sun,  9 Oct 2022 23:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345B7C433C1;
        Sun,  9 Oct 2022 23:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359485;
        bh=mX24O1vGgImFyw9AlQ1u4BG7+ZHlcMrj6aWT8XAWarE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+Th4x7/eIGReD9DQ8j9epdjaqFOin6YTHYHX+P6n1865nf8iEw6pyLUDNSNuaTcJ
         5RG/SjQzYnTEfCcWyP5EosnujG2vxoEgnwJJW+Q7u8kaxMBfU4RLd2ttkyfL7HDjKM
         k6pPgPJTvt6dbcqskW5z/ZT0hpGiiuQgrTEHt9ivZzlTuqj0+RiUFwNfamIwomQhzi
         n+DExUzHfrpFIsFOfHW44V8bQZzQ7Tu4ezHAonFM1/Vfq5H9BUrrOtmwGJzTgDrkAq
         Na23BrO6/RRJ4PdbrsYYzAKGEeIDyrccbZpXjctBzs9YESDIruChlyFmtkOejhsWxN
         4o3cATatyogow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Wang <Yao.Wang1@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com,
        agustin.gutierrez@amd.com, Eric.Yang2@amd.com,
        michael.strauss@amd.com, mwen@igalia.com, gabe.teeger@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 31/44] drm/amd/display: correct hostvm flag
Date:   Sun,  9 Oct 2022 19:49:19 -0400
Message-Id: <20221009234932.1230196-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
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

From: Sherry Wang <Yao.Wang1@amd.com>

[ Upstream commit 796d6a37ff5ffaf9f2dc0f3f4bf9f4a1034c00de ]

[Why]
Hostvm should be enabled/disabled accordding to
the status of riommu_active, but hostvm always
be disabled on DCN31 which causes underflow

[How]
Set correct hostvm flag on DCN31

Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Sherry Wang <Yao.Wang1@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index aedff18aff56..2e5a21856eee 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -891,7 +891,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.optimize_edp_link_rate = true,
 	.enable_sw_cntl_psr = true,
 	.enable_z9_disable_interface = true, /* Allow support for the PMFW interface for disable Z9*/
-	.dml_hostvm_override = DML_HOSTVM_OVERRIDE_FALSE,
+	.dml_hostvm_override = DML_HOSTVM_NO_OVERRIDE,
 };
 
 static const struct dc_debug_options debug_defaults_diags = {
-- 
2.35.1

