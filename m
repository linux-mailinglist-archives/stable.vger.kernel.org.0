Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4846674FF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbjALORF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbjALOQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:16:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141BD5D685
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:08:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C66CAB81E6C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E098C433EF;
        Thu, 12 Jan 2023 14:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532482;
        bh=ZcPegjstGGLTiZ+qoLsDD+RUF6I+sjBofIUTtOVtCi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GecB4hQOyQwlgodt4VOuiJA5P0FMLHh6e686c+CEbQ3SSgkF4B5R91/4lBYWSDaMX
         7RLwlVL3RKmXpccpJLlqoszUMcLZys1MyHOBYWs/qz9WG/xJMw22OO1i86HrMS8YUU
         hvNFKQfu/WsJMEeIWAkqlrSas+ZTloMBLxoj+n/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/783] drm/amdgpu: fix pci device refcount leak
Date:   Thu, 12 Jan 2023 14:48:05 +0100
Message-Id: <20230112135532.158392091@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b85e285e3d6352b02947fc1b72303673dfacb0aa ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put().

So before returning from amdgpu_device_resume|suspend_display_audio(),
pci_dev_put() is called to avoid refcount leak.

Fixes: 3f12acc8d6d4 ("drm/amdgpu: put the audio codec into suspend state before gpu reset V3")
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index bde0496d2f15..8bd887fb6e63 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4443,6 +4443,8 @@ static void amdgpu_device_resume_display_audio(struct amdgpu_device *adev)
 		pm_runtime_enable(&(p->dev));
 		pm_runtime_resume(&(p->dev));
 	}
+
+	pci_dev_put(p);
 }
 
 static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
@@ -4481,6 +4483,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 		if (expires < ktime_get_mono_fast_ns()) {
 			dev_warn(adev->dev, "failed to suspend display audio\n");
+			pci_dev_put(p);
 			/* TODO: abort the succeeding gpu reset? */
 			return -ETIMEDOUT;
 		}
@@ -4488,6 +4491,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 	pm_runtime_disable(&(p->dev));
 
+	pci_dev_put(p);
 	return 0;
 }
 
-- 
2.35.1



