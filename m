Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925C9593F3F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243282AbiHOVTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbiHOVQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:16:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70730F3B;
        Mon, 15 Aug 2022 12:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B1DA60BB7;
        Mon, 15 Aug 2022 19:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357A9C433D6;
        Mon, 15 Aug 2022 19:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591217;
        bh=koEmmcXb9FfrHcn5esncw0TNEGulqIwaVYmOpG1i0Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BV9ZSZ6y7NkALF1uzg/u42WFx8pQ7wA1eUDbv7TtgPqodvWFIsRy7at3fue8sXniy
         SldHjSjhOvUZIMcXw18Xy3HNnE4eAeGr1jBNfIbwt+Z/fHuM+99JGmyUUgukIlNBj3
         0ZN6WNQGd8DT/FP8LCKWSK6vhv3yswdvh/KySCZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0510/1095] drm/amd/display: fix signedness bug in execute_synaptics_rc_command()
Date:   Mon, 15 Aug 2022 19:58:29 +0200
Message-Id: <20220815180450.629402741@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 06ac561fb0edf868f7b292fb4a3c8ffbbb1e14bb ]

The "ret" variable needs to be signed for the error handling to work.

Fixes: 2ca97adccdc9 ("drm/amd/display: Add Synaptics Fifo Reset Workaround")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index f5f39984702f..a3282ddbff86 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -571,7 +571,7 @@ static bool execute_synaptics_rc_command(struct drm_dp_aux *aux,
 	unsigned char rc_cmd = 0;
 	unsigned char rc_result = 0xFF;
 	unsigned char i = 0;
-	uint8_t ret = 0;
+	int ret;
 
 	if (is_write_cmd) {
 		// write rc data
-- 
2.35.1



