Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6AF60B1F0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbiJXQlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbiJXQk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:40:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81744C897E;
        Mon, 24 Oct 2022 08:27:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CB64B8199D;
        Mon, 24 Oct 2022 12:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0794AC433D6;
        Mon, 24 Oct 2022 12:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615374;
        bh=JPKDlQyX1Or2SBLLYAGOShYpJEat7kKOamVfIL6mTxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2A3GJDAweXGWSsB6gLsHUkEhC3H1abonswXTI+zI6iqnrTEql7r9/Xe0M1X853Pi
         Qc/9jS84l1iUxMeP0CSKX8SiQeqIWBnGxqI3JgFryaCrmAFwEq49HQu7F7mOsfiem2
         FhOcz8WqSP4x0HJXaIHjUA/6NPifkOvbky+7gHgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 225/530] drm/amdgpu: add missing pci_disable_device() in amdgpu_pmops_runtime_resume()
Date:   Mon, 24 Oct 2022 13:29:29 +0200
Message-Id: <20221024113055.272733791@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 6b11af6d1c8f5d4135332bb932baaa06e511173d ]

Add missing pci_disable_device() if amdgpu_device_resume() fails.

Fixes: 8e4d5d43cc6c ("drm/amdgpu: Handling of amdgpu_device_resume return value for graceful teardown")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index f65b4b233ffb..28dea2eb61c7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2415,8 +2415,11 @@ static int amdgpu_pmops_runtime_resume(struct device *dev)
 		amdgpu_device_baco_exit(drm_dev);
 	}
 	ret = amdgpu_device_resume(drm_dev, false);
-	if (ret)
+	if (ret) {
+		if (amdgpu_device_supports_px(drm_dev))
+			pci_disable_device(pdev);
 		return ret;
+	}
 
 	if (amdgpu_device_supports_px(drm_dev))
 		drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
-- 
2.35.1



