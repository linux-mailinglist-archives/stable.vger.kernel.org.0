Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E3F6578DD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiL1Oz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiL1Oy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:54:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63041120B4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01049614B2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10840C433D2;
        Wed, 28 Dec 2022 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239295;
        bh=3y4iQoXRH8v3UkWob2qZig+KyZBNl65cZ5Zd1ZhNBVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5/+6KA3dtNmCT2cgEDfF5tthVJYiNCIJ3FBLd4JhtsBtOc6B4uB2i28rZpVIji0B
         BF6BHSolReq8PVK74/9hmPsim+YrqrF94ukRdsGuJCo+K8X7KKWAlQlyfNfwT0fO09
         f4n6LM9CX64Ffi7lEzBg17ORB4NfADop09SoX3T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/731] amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()
Date:   Wed, 28 Dec 2022 15:35:06 +0100
Message-Id: <20221228144302.333001666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit d27252b5706e51188aed7647126e44dcf9e940c1 ]

In the PP_OD_EDIT_VDDC_CURVE case the "input_index" variable is capped at
2 but not checked for negative values so it results in an out of bounds
read.  This value comes from the user via sysfs.

Fixes: d5bf26539494 ("drm/amd/powerplay: added vega20 overdrive support V3")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
index 85d55ab4e369..299b5c838bf7 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -2961,7 +2961,8 @@ static int vega20_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
 			data->od8_settings.od8_settings_array;
 	OverDriveTable_t *od_table =
 			&(data->smc_state_table.overdrive_table);
-	int32_t input_index, input_clk, input_vol, i;
+	int32_t input_clk, input_vol, i;
+	uint32_t input_index;
 	int od8_id;
 	int ret;
 
-- 
2.35.1



