Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17AB63579F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiKWJoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiKWJnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B28128E32
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:41:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BE4161B3B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91105C433C1;
        Wed, 23 Nov 2022 09:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196498;
        bh=Ur+6ung+1Jg5W4OUPwgfM4XGfn/eozgws0JTSUiElDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fF5LONsmQd8TYq9UVZhMYOBsJlp6HU5z1BtZdE98+hyoiHwbkFcQ2ZbptngHKUBmD
         AvOWgw0dneMCFybeqOK5HBHk9MTTb2lGFMiz1NyWX34gVDDQEpgN6m53R6nHBMDhZW
         Sv3Qp4ylBeKzlL5201hyi4WEsNQbQnhmRmELBmtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Broadworth <mark.broadworth@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 049/314] drm/amd/display: Ignore Cable ID Feature
Date:   Wed, 23 Nov 2022 09:48:14 +0100
Message-Id: <20221123084627.732434082@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 14aed119942f6c2f1286022323139f7404db5d2b ]

Ignore cable ID for DP2 receivers that does not support the feature.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3be70848b202..54c76ed1ad75 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1549,6 +1549,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	adev->dm.dc->debug.visual_confirm = amdgpu_dc_visual_confirm;
 
+	/* TODO: Remove after DP2 receiver gets proper support of Cable ID feature */
+	adev->dm.dc->debug.ignore_cable_id = true;
+
 	r = dm_dmub_hw_init(adev);
 	if (r) {
 		DRM_ERROR("DMUB interface failed to initialize: status=%d\n", r);
-- 
2.35.1



