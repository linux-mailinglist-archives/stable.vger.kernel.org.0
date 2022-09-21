Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B635D5C0390
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiIUQHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiIUQG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:06:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26AEA3464;
        Wed, 21 Sep 2022 08:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F56C6313C;
        Wed, 21 Sep 2022 15:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420B7C433D6;
        Wed, 21 Sep 2022 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775635;
        bh=ON79Ezb0W4s0GNf/NoqKu+FimfoSIUQjcZclqHc3mXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPeSYZyrxLRELOC/IWH30UIOFOnK0jtTWg6XLRsreStnucbI/p8u10xjLeO4XqG+5
         gsWG/WuOfScBZq6oRi4gA4ZysEvNeMKbefM4zHrUQECl7Qqg/7aZOJKxVgvyxYiyui
         AHA3Uml6E16i187tZNh1o2g/76+VQIfc97I7IWHxwrQrbDMhDPhzxUNUrReuRihKq3
         dPZ5q+D4CZjAit3ZvBBEUrW/ni8fweewGibD+/Sx0wwrQCI7q5Hx4OXmhQvqMUwqCj
         yVkCaks+qTXZQlLq4p645ZZkOaRgG4R0TvSuXAWJp9Rs740ESgUy9+FVk4TbFddZfY
         mH8tMmbJ23RMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Candice Li <candice.li@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        tao.zhou1@amd.com, YiPeng.Chai@amd.com, john.clements@amd.com,
        Stanley.Yang@amd.com, mukul.joshi@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 10/16] drm/amdgpu: Skip reset error status for psp v13_0_0
Date:   Wed, 21 Sep 2022 11:53:26 -0400
Message-Id: <20220921155332.234913-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155332.234913-1-sashal@kernel.org>
References: <20220921155332.234913-1-sashal@kernel.org>
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

From: Candice Li <candice.li@amd.com>

[ Upstream commit 86875d558b91cb46f43be112799c06ecce60ec1e ]

No need to reset error status since only umc ras supported on psp v13_0_0.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index dac202ae864d..9193ca5d6fe7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1805,7 +1805,8 @@ static void amdgpu_ras_log_on_err_counter(struct amdgpu_device *adev)
 		amdgpu_ras_query_error_status(adev, &info);
 
 		if (adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 2) &&
-		    adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 4)) {
+		    adev->ip_versions[MP0_HWIP][0] != IP_VERSION(11, 0, 4) &&
+		    adev->ip_versions[MP0_HWIP][0] != IP_VERSION(13, 0, 0)) {
 			if (amdgpu_ras_reset_error_status(adev, info.head.block))
 				dev_warn(adev->dev, "Failed to reset error counter and error status");
 		}
-- 
2.35.1

