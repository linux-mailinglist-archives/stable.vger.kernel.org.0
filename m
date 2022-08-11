Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95DE590043
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbiHKPkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiHKPjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:39:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8E09AFA1;
        Thu, 11 Aug 2022 08:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48857B82123;
        Thu, 11 Aug 2022 15:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E6CC433C1;
        Thu, 11 Aug 2022 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232102;
        bh=yiDJVQm4e6NZsd0zPhUQaqgcrkk57fe/1dE73Cr3ak0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QS4P0IC15ZKRT7m3XjSyqsPNCB786GZnF5U6SkUCLO4/i/iSBC+Lq/ro6HTSU9RKf
         zBgycqCvYxZpdNe+FabptIJO2M0Sk7fQ5ejbmg16AClRDAh3cLRQNWI2WbqqHJJVbY
         EeoyE7aGD+SkQWIJKgEk2wxWkbk3Qnu5tVi9+V4bnOoCn88WDujVjEymeMxRWo2qX+
         NKJDzB4A61ah3ggiGsNamOjZAddWN1BQ0YTrLVmo+UK93Ltdebv58uKqsQKLnPFX8H
         bKUByl2zvuF8YQqpMPbsCrS6YeoKgqIn7NsWGN0VKf85gmvXArw3max3rByVxc2pY7
         86OZ+12DdU8Dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, nicholas.kazlauskas@amd.com,
        roman.li@amd.com, qingqing.zhuo@amd.com, shenshih@amd.com,
        Wayne.Lin@amd.com, contact@emersion.fr, alex.hung@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 059/105] drm/amd/display: Fix dmub soft hang for PSR 1
Date:   Thu, 11 Aug 2022 11:27:43 -0400
Message-Id: <20220811152851.1520029-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 22676bc500c27d987a0b42cbe162aebf783f1c38 ]

[Why]
Unexpected change of aux hw mapping causes dmub soft hang when
initiate aux transation at wrong aux channel.

ddc_channel stands for hw dp aux index which is from vbios,
but link_index is pure software concept for link count depending on which link
is probed first. They are not interchangeable.

dmub aux transaction could pass if happens eDP link_index gets
the same value as vbios ddc_channel, e.g., ddc_channel = 1, link_index = 1
if they gets different, e.g., ddc_channel = 2, link_index = 0, overwrite
ddc_channel with link_index will have wrong ddc channel being used for aux
transaction in dmub PSR, cause aux transaction soft hang.

[How]
ddc_channel mapping to each link is determined by vbios and further
parsed in dc. Such info. should not be touched in any kind, otherwise
the mapping is screwed up leading to aux transaction timeout.

Reviewed-by: Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3087dd1a1856..a6efd5c1fa2a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8538,7 +8538,7 @@ static int amdgpu_dm_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 	if (dc_submit_i2c(
 			ddc_service->ctx->dc,
-			ddc_service->ddc_pin->hw_info.ddc_channel,
+			ddc_service->link->link_index,
 			&cmd))
 		result = num;
 
@@ -8574,8 +8574,6 @@ create_i2c(struct ddc_service *ddc_service,
 	snprintf(i2c->base.name, sizeof(i2c->base.name), "AMDGPU DM i2c hw bus %d", link_index);
 	i2c_set_adapdata(&i2c->base, i2c);
 	i2c->ddc_service = ddc_service;
-	if (i2c->ddc_service->ddc_pin)
-		i2c->ddc_service->ddc_pin->hw_info.ddc_channel = link_index;
 
 	return i2c;
 }
-- 
2.35.1

