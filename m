Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CCF6C55F0
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjCVUCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCVUBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:01:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008D66B952;
        Wed, 22 Mar 2023 12:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D52E962294;
        Wed, 22 Mar 2023 19:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BCDC433D2;
        Wed, 22 Mar 2023 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515131;
        bh=mJgUxo5owB/ky529vzd/7Ni0Rn3/5W3EfAkj5ZdLqhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDV08gMM6Pbx28IZuIimh6FhitDb74UnBq88awmHxbVEEoYQFDCpZJ9Gq7eVsj/XO
         2nMyNo27CbICfdR2i0G28isZG2OjiXY/c8a4uCVk/BnKYmDoss2U3zmqF7FKOpclXZ
         QTKzgcfMJEIcT7Ikq9ZL9lEqapq57EfMmsPCvCt4g9AzTkj8z2iDJlJbSKuhuQLSQP
         QjnrvVe0bDQ7Z48qKiMWcCeMqG877MeTmiXQ2CdvRwBvbreAPnQSONy2DzSFvz33Z6
         UsRofuLdM2tcOAlEutu1GtTavyd9rxcZkAMJHnSDLshVzyjBIvADXpr1diuDcm1aQT
         TWQeSeVnPJ5PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Aurabindo Pillai <Aurabindo.Pillai@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Wayne.Lin@amd.com, tzimmermann@suse.de,
        hersenxs.wu@amd.com, roman.li@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 28/45] drm/amd/display: Fix HDCP failing to enable after suspend
Date:   Wed, 22 Mar 2023 15:56:22 -0400
Message-Id: <20230322195639.1995821-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>

[ Upstream commit 728cefa53a36ba378ed4a7f31a0c08289687d824 ]

[Why]
On resume some displays are not ready for HDCP, so they will fail if we
start the hdcp authentintication too soon.

Add a delay so that the displays can be ready before we start.

NOTE: Previoulsy this delay was set to 3 seconds but it was causing
issues with compliance, 2 seconds should enough for compliance and the
s3 resume case.

[How]
Change the Delay to 2 seconds.

Reviewed-by: Aurabindo Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index a7fd98f57f94c..dc62375a8e2c4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -495,7 +495,7 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	link->dp.mst_enabled = config->mst_enabled;
 	link->dp.usb4_enabled = config->usb4_enabled;
 	display->adjust.disable = MOD_HDCP_DISPLAY_DISABLE_AUTHENTICATION;
-	link->adjust.auth_delay = 0;
+	link->adjust.auth_delay = 2;
 	link->adjust.hdcp1.disable = 0;
 	conn_state = aconnector->base.state;
 
-- 
2.39.2

