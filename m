Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8414EF46F
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350145AbiDAPHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350127AbiDAO7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:59:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398A9184B4F;
        Fri,  1 Apr 2022 07:46:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB0B560AC0;
        Fri,  1 Apr 2022 14:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A8DC3410F;
        Fri,  1 Apr 2022 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824384;
        bh=FdC1Qi/w1GcVPIE3V0IbzsA9PxSqblnKMj//IRcgbGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LuHGdYN21AXqakC0bwvy6l/qBRr4Kgzm4qw+5JU4S4KXzzwJk+agyLvQCiiYgssIK
         9IJOTZVYx5O9jwbcTaqzUkDGzoov6bz4cN8IRvtZSCEWvyu6farLXFPNs3428Ee5pU
         ytfSgSAW0RXCRQW0XWdIyJoP6XjcFCHx9nd+xuJNdpum4VbpwtJm4f55IeYnfNpDnN
         8i/ETbuas+aNHVRpsCaCLwgJSTmiM7OJuoowMQywmmdBckwDe3kcT8/lBFSWpUMOPH
         tioeDONo1wybylr7fpsVxdvXBWOFqpp3ZD8Xb4RJu/I2YXTuHou5m/hL9oczv622Rm
         xqSHkb7pw+Dug==
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
Subject: [PATCH AUTOSEL 4.19 03/29] drm/amd/amdgpu/amdgpu_cs: fix refcount leak of a dma_fence obj
Date:   Fri,  1 Apr 2022 10:45:46 -0400
Message-Id: <20220401144612.1955177-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144612.1955177-1-sashal@kernel.org>
References: <20220401144612.1955177-1-sashal@kernel.org>
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
index 81001d879322..023309296bfc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1469,6 +1469,7 @@ int amdgpu_cs_fence_to_handle_ioctl(struct drm_device *dev, void *data,
 		return 0;
 
 	default:
+		dma_fence_put(fence);
 		return -EINVAL;
 	}
 }
-- 
2.34.1

