Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D35165027B
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiLRQrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiLRQqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:46:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D4710B6C;
        Sun, 18 Dec 2022 08:16:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F61AB80BE7;
        Sun, 18 Dec 2022 16:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B196C433F0;
        Sun, 18 Dec 2022 16:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380189;
        bh=NCUk6bB7VPH3vQWVQfzyYHYNWWpQAY1rTqiNAogsDkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1R/f8G4t8PCOU67by1N+CkZ/yq2f7tjB9pIwUKjYfoejL1ZIxvTRk9yjekFjWVTA
         HtvZkncTGbattX448dOnDiJImyFtpgrY6Hef6oMxpNGD19MaP/B/BUt/jhMji6nGdN
         arsBQhcD87x0J4k54h0pZkp4Dm784JQVBundj2fI9YhoqrZjSGPwZG6MyX1FHyJBFd
         TPJRz/ZqoJT5lhXFIfkL/R6FxKuJOnh8tMNvI1TPHGvHAMtOgoq+P3aXgGBHklsFnY
         dn9A555gsXMEh2Q9A5ZmcYCZeaqecSlk8al9gbiigVewkGJDVBmc2viUgCHwxUIlc7
         +/tuu0XfO5LBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     gehao <gehao@kylinos.cn>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, aurabindo.pillai@amd.com,
        HaoPing.Liu@amd.com, alex.hung@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 07/39] drm/amd/display: prevent memory leak
Date:   Sun, 18 Dec 2022 11:15:27 -0500
Message-Id: <20221218161559.932604-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161559.932604-1-sashal@kernel.org>
References: <20221218161559.932604-1-sashal@kernel.org>
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

From: gehao <gehao@kylinos.cn>

[ Upstream commit d232afb1f3417ae8194ccf19ad3a8360e70e104e ]

In dce6(0,1,4)_create_resource_pool and dce80_create_resource_pool
the allocated memory should be released if construct pool fails.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: gehao <gehao@kylinos.cn>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c | 3 +++
 drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
index 5a5a9cb77acb..bcdd8a958fc0 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
@@ -1132,6 +1132,7 @@ struct resource_pool *dce60_create_resource_pool(
 	if (dce60_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
@@ -1329,6 +1330,7 @@ struct resource_pool *dce61_create_resource_pool(
 	if (dce61_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
@@ -1522,6 +1524,7 @@ struct resource_pool *dce64_create_resource_pool(
 	if (dce64_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
index a19be9de2df7..2eefa07762ae 100644
--- a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
@@ -1141,6 +1141,7 @@ struct resource_pool *dce80_create_resource_pool(
 	if (dce80_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
@@ -1338,6 +1339,7 @@ struct resource_pool *dce81_create_resource_pool(
 	if (dce81_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
-- 
2.35.1

