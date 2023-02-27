Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB7F6A3899
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjB0Cbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjB0Cb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:31:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F4F1F5C3;
        Sun, 26 Feb 2023 18:29:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3726760D3D;
        Mon, 27 Feb 2023 02:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D70C433EF;
        Mon, 27 Feb 2023 02:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463800;
        bh=2KRm2l3JY2uKj7HESanxZ1bGdswzim8PwgzKABcw6e4=;
        h=From:To:Cc:Subject:Date:From;
        b=bzDdlNS4XK8HD024fngc73IQmtqqLjfL/6rP8SaKy9D3AseSv6zXYuNgoUIbhdaPE
         zPmZaudfentez7GuLr+EJfTI7MSLIMbDIAb9HmC80FvburLiy1M4MWIawvPA79Iuf0
         PJ8s2yF9JttjFNPFCdiWvsa81bBr0jQxeY+BmhiQJ5i/fvsthmKU9wuIr9XPvEpWhW
         7/a6aRcm3Qif4rhpLZ8QvhR8GVYV5bqnVVoJNUOlYFby7rCmzK7wlTm5vHzlT0+PlM
         gSs+Ita1NNDoGnNY6loCuoxcl1YHh0eO8Tx/xOOIbAcfRVeZQDjxCQm22U58ydM5jR
         S/U/tchWMptbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <roman.li@amd.com>, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, aurabindo.pillai@amd.com, hersenxs.wu@amd.com,
        stylon.wang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 01/19] drm/amd/display: Fix potential null-deref in dm_resume
Date:   Sun, 26 Feb 2023 21:09:36 -0500
Message-Id: <20230227020957.1052252-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <roman.li@amd.com>

[ Upstream commit 7a7175a2cd84b7874bebbf8e59f134557a34161b ]

[Why]
Fixing smatch error:
dm_resume() error: we previously assumed 'aconnector->dc_link' could be null

[How]
Check if dc_link null at the beginning of the loop,
so further checks can be dropped.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index fbe15f4b75fd5..dbdf0e210522c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2051,12 +2051,14 @@ static int dm_resume(void *handle)
 	drm_for_each_connector_iter(connector, &iter) {
 		aconnector = to_amdgpu_dm_connector(connector);
 
+		if (!aconnector->dc_link)
+			continue;
+
 		/*
 		 * this is the case when traversing through already created
 		 * MST connectors, should be skipped
 		 */
-		if (aconnector->dc_link &&
-		    aconnector->dc_link->type == dc_connection_mst_branch)
+		if (aconnector->dc_link->type == dc_connection_mst_branch)
 			continue;
 
 		mutex_lock(&aconnector->hpd_lock);
-- 
2.39.0

