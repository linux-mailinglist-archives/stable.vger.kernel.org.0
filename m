Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C16657D4C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbiL1PmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiL1Plo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:41:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0DA17436
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:41:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E486155E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D591C433EF;
        Wed, 28 Dec 2022 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242097;
        bh=RYc/kThGKmz4l+8HTPcND0yU5YHMcBhLtKlKASwdUPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ya8XTS7MHt1WSfnjffs8Z3mrSx3GWBR/0f8pjOazqh6LC4yz+7WzMU2feyuR8XcYX
         aPmBDMQqkcM019Qig3brzhGLeJYUjsVOzSCUukOfyCvBXLdmtEl/CtQ3qqy5Vl2cSL
         HCbgPHQfLULz49swGtCsIn0bHgdZTO4/CoJpmB2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0367/1073] drm/amdgpu: fix pci device refcount leak
Date:   Wed, 28 Dec 2022 15:32:35 +0100
Message-Id: <20221228144337.972158829@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index e0c960cc1d2e..f04e698e631c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5004,6 +5004,8 @@ static void amdgpu_device_resume_display_audio(struct amdgpu_device *adev)
 		pm_runtime_enable(&(p->dev));
 		pm_runtime_resume(&(p->dev));
 	}
+
+	pci_dev_put(p);
 }
 
 static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
@@ -5042,6 +5044,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 		if (expires < ktime_get_mono_fast_ns()) {
 			dev_warn(adev->dev, "failed to suspend display audio\n");
+			pci_dev_put(p);
 			/* TODO: abort the succeeding gpu reset? */
 			return -ETIMEDOUT;
 		}
@@ -5049,6 +5052,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 	pm_runtime_disable(&(p->dev));
 
+	pci_dev_put(p);
 	return 0;
 }
 
-- 
2.35.1



