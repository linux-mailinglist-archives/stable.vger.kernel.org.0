Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F224EF432
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349721AbiDAO5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349289AbiDAOvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:51:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE612B4A5B;
        Fri,  1 Apr 2022 07:42:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C168BB824D5;
        Fri,  1 Apr 2022 14:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879A1C2BBE4;
        Fri,  1 Apr 2022 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824142;
        bh=Or5Rp8UJEUhpq/Xbmlxww9VvoFfOSM1I4I49HSOWxqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=repogBi7rgH2A7uS9h+a6waMvqOGbpNvTrq4Khxkwv9XXhCTdHktwX+HckiWMiBCN
         LSt+3WgozYH7W1SamdHROE3Q8njZteBBYItsjZMfOpsa9IKP7ydBa46gMiYxbnuFWv
         Ms/hyqJmxjr2cQDmK29PpQD3ree9Fn32TAG3Cr3csyVrsIa4MoJBmRZoeV0CcBa1ZO
         g/XE2wTodRGr8zpQPppTLIDTPSNCTokEQ1mEY9+nc1Nviug1lCl7SyGXdP7PG+5nk1
         4AcvWfzkqWTKQ8e5UNIvRkqcQ6aBbbc0m+5I7m8DaBNgzAMthXXRIgnLC29oTL30bq
         6F1AmoXaZ5jnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Xiong <xiongx18@fudan.edu.cn>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, sumit.semwal@linaro.org,
        JinhuiEric.Huang@amd.com, nirmoy.das@amd.com, Ken.Xue@amd.com,
        Lang.Yu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.10 04/65] drm/amd/amdgpu/amdgpu_cs: fix refcount leak of a dma_fence obj
Date:   Fri,  1 Apr 2022 10:41:05 -0400
Message-Id: <20220401144206.1953700-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Xin Xiong <xiongx18@fudan.edu.cn>

[ Upstream commit dfced44f122c500004a48ecc8db516bb6a295a1b ]

This issue takes place in an error path in
amdgpu_cs_fence_to_handle_ioctl(). When `info->in.what` falls into
default case, the function simply returns -EINVAL, forgetting to
decrement the reference count of a dma_fence obj, which is bumped
earlier by amdgpu_cs_get_fence(). This may result in reference count
leaks.

Fix it by decreasing the refcount of specific object before returning
the error code.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 12598a4b5c78..867fcee6b0d3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1484,6 +1484,7 @@ int amdgpu_cs_fence_to_handle_ioctl(struct drm_device *dev, void *data,
 		return 0;
 
 	default:
+		dma_fence_put(fence);
 		return -EINVAL;
 	}
 }
-- 
2.34.1

