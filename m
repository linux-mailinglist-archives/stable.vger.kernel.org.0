Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5B14EEF78
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346919AbiDAO2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346936AbiDAO2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:28:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0520A1DEC27;
        Fri,  1 Apr 2022 07:26:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A44BFB824AF;
        Fri,  1 Apr 2022 14:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3CFC340EE;
        Fri,  1 Apr 2022 14:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823168;
        bh=La4Vy9liKzyGA8wVYgzCzfHjBUk/e1nXmMqsKwIY7Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIaqaDjJRmOncK7NLTxxVgiHu7MqckvkuH9dxmIxxIhx9eIaNbs3tmUg89JQpjQMF
         V+OAIirLtz3azukWfCmd9NU9TISL2Ylpg0LKvFismE7O9bK5baY11GpgUz1I4954zI
         9BYoSEP/49yOo7sj+VjkvbTAJwlHuHraT0NM/FnzdZuF0kXV2+gyCrfZnQil2IPcUM
         AvgUeNewqY6UTGRPr/4bbsltTQJL1S8sT9OJaeOTVcFBBut9OxOIezHiTE2osl6nmo
         kL++vaDmLXkuFkSNAqDEQp1F0REDNgf96UgkiUnecsmNe7BODOIGd7OG1ZVBBjnOUg
         Tc+SOWK5JVVjQ==
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
Subject: [PATCH AUTOSEL 5.17 011/149] drm/amd/amdgpu/amdgpu_cs: fix refcount leak of a dma_fence obj
Date:   Fri,  1 Apr 2022 10:23:18 -0400
Message-Id: <20220401142536.1948161-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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
index 06d07502a1f6..a34be65c9eaa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1509,6 +1509,7 @@ int amdgpu_cs_fence_to_handle_ioctl(struct drm_device *dev, void *data,
 		return 0;
 
 	default:
+		dma_fence_put(fence);
 		return -EINVAL;
 	}
 }
-- 
2.34.1

