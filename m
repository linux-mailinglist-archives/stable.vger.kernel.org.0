Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4074B657DFD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbiL1PtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbiL1Ps6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:48:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F98418390
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:48:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F0EEB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B820C433D2;
        Wed, 28 Dec 2022 15:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242531;
        bh=jrcC32pe8Kolx3MaVTPjSS7wyKA9V9nxMWJ6XbOIkaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOP8oNABDkOkuHl7TqDjhnRybnow6I+lCPJeIvmxiMAMSuSxwg/XvuuYf8TuVrEwL
         6vnUU2sp+PJYa2euyRdzpuLN958HQwxR5D9P0EJdYCSpeOEbLNcDqyBhuwkTY4qZrx
         dPb4fLnZnsienubeVF+hx0ACdlQdsu8GOgL1UCh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0380/1146] drm/amdgpu: fix pci device refcount leak
Date:   Wed, 28 Dec 2022 15:31:59 +0100
Message-Id: <20221228144340.488228515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index f1e9663b4051..2cf72cfa2e60 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5027,6 +5027,8 @@ static void amdgpu_device_resume_display_audio(struct amdgpu_device *adev)
 		pm_runtime_enable(&(p->dev));
 		pm_runtime_resume(&(p->dev));
 	}
+
+	pci_dev_put(p);
 }
 
 static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
@@ -5065,6 +5067,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 		if (expires < ktime_get_mono_fast_ns()) {
 			dev_warn(adev->dev, "failed to suspend display audio\n");
+			pci_dev_put(p);
 			/* TODO: abort the succeeding gpu reset? */
 			return -ETIMEDOUT;
 		}
@@ -5072,6 +5075,7 @@ static int amdgpu_device_suspend_display_audio(struct amdgpu_device *adev)
 
 	pm_runtime_disable(&(p->dev));
 
+	pci_dev_put(p);
 	return 0;
 }
 
-- 
2.35.1



