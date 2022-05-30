Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51313537F14
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbiE3OD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbiE3OAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:00:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A425BDA0E;
        Mon, 30 May 2022 06:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83C7660F3B;
        Mon, 30 May 2022 13:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D1EC385B8;
        Mon, 30 May 2022 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917957;
        bh=+e7jOA+nZdM0ztWhPDDfDZIxRWdZM8KO7MGg41thVdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOQW2RnYARIlisr0UCiosBKDUvkNUMrfB9JkImCXFCFxLkDYERYrebUSk0E263SAE
         GyWv1qUIFlKBNtY2DUyFkzGbJUXhV3eh6Esz5BJWgzrczNUcyi8c3xkewMGqHE5gx4
         qe7OzfXnRem3eV7pN0RN5T1qWLtz0vemm1nH7BY/qsK6bCqCZLHYFBjkB81vvM0rm4
         7pkUyoqUaI2FXHGyP+mz2SNCwN1dblQ9OItIrDnMvIfzi5cHp4lYr0HQCyXkwjqc9g
         /3Ww0JNGSLWBOcI2cXe6vXPKcMgvOZbNx6iTuxGkp5graHQI2rMbb36/tLqF+1hNW3
         6as95bHPCNOvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saaem Rizvi <syerizvi@amd.com>, Eric Yang <Eric.Yang2@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com,
        michael.strauss@amd.com, Jerry.Zuo@amd.com, nikola.cornij@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 016/109] drm/amd/display: Disabling Z10 on DCN31
Date:   Mon, 30 May 2022 09:36:52 -0400
Message-Id: <20220530133825.1933431-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saaem Rizvi <syerizvi@amd.com>

[ Upstream commit 5d5af34072c8b11f60960c3bea57ff9de5877791 ]

[WHY]
Z10 is should not be enabled by default on DCN31.

[HOW]
Using DC debug flags to disable Z10 by default on DCN31.

Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Signed-off-by: Saaem Rizvi <syerizvi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index a5ef9d5e7685..310ced5058c4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -957,6 +957,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 			.optc = false,
 		}
 	},
+	.disable_z10 = true,
 	.optimize_edp_link_rate = true,
 	.enable_sw_cntl_psr = true,
 };
-- 
2.35.1

