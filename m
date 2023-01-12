Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCE06674E0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbjALOPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbjALOOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:14:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC95C551EB
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A3E0CE1E6C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5034EC433EF;
        Thu, 12 Jan 2023 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532399;
        bh=kL86hwvl+mzpkaLMYMTawC1imvGiqqLPxqGU1sj4bfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUJGxDbD35VvXvBpy3+mDqNBACmJ5djQzUPyorqJIcU4HX3J4HPeTkWpXgyqG1LMd
         7doenipvjn8Z8r5NJJmvZY5GaKXKZVhuKwq8Z3K6oyMP9KHBQiQmfZIjfcZiZDG5VQ
         OUfDX2Hbullelt+a80bastbA6z1NWT3kY5UicAPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/783] amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()
Date:   Thu, 12 Jan 2023 14:47:46 +0100
Message-Id: <20230112135531.299340388@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 60cde0c52825..57a354a03e8a 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -2962,7 +2962,8 @@ static int vega20_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
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



