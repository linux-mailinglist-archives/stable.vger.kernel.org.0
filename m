Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116C8608AB0
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiJVJE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiJVJDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:03:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEB22FBDF6;
        Sat, 22 Oct 2022 01:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C409CB82E04;
        Sat, 22 Oct 2022 07:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214A1C433D6;
        Sat, 22 Oct 2022 07:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424897;
        bh=pP2r2bExKP4Le3wtAbMnar0v4Dk3GywGU3NbELH8LRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t38+x8WkoAe7YJOx4avhVAz6+MLQ+4pvrun6ks6zv9mzakIQXPuWWfbx8vPgy9XuM
         3c1zcyMQvdYP3D0JNfGF7/6jNcuw96M9pveZ5GAz1mu2iE96C0lcM1WllhdayNt+WQ
         BkbsZ66TTqji7ffsaJOGruq9c8oIaKqgkd+EnZSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 317/717] drm/amdgpu: add missing pci_disable_device() in amdgpu_pmops_runtime_resume()
Date:   Sat, 22 Oct 2022 09:23:16 +0200
Message-Id: <20221022072508.171109408@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8890300766a5..5e8ca32bc3a9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2548,8 +2548,11 @@ static int amdgpu_pmops_runtime_resume(struct device *dev)
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



