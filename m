Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D871C451157
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbhKOTE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:04:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238884AbhKOTBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:01:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0409763343;
        Mon, 15 Nov 2021 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000073;
        bh=KlfN6bbcL+O05xZjXpvrkkXuhISBGW7q4dKcYA4fEXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J39HunwkNR6mXOzvCZD9D97vFGAejYH9uW2XK1TiLWo8Fp3YdDH9hw7hlc3d5plXO
         K/qmahsLXckHdhkpKVsuIzeRNnj1U9tEcvtiOmTxRWmtkM4Rvowj2V7rCAjHDbErKQ
         FoeEy7gNtokTGJ7fnTNCeSWfZ3SU+jUAYZJ8wCCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <lang.yu@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 526/849] drm/amdgpu: fix a potential memory leak in amdgpu_device_fini_sw()
Date:   Mon, 15 Nov 2021 18:00:09 +0100
Message-Id: <20211115165438.061707524@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Yu <lang.yu@amd.com>

[ Upstream commit a5c5d8d50ecf5874be90a76e1557279ff8a30c9e ]

amdgpu_fence_driver_sw_fini() should be executed before
amdgpu_device_ip_fini(), otherwise fence driver resource
won't be properly freed as adev->rings have been tore down.

Fixes: 72c8c97b1522 ("drm/amdgpu: Split amdgpu_device_fini into early and late")

Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index eddf03450f1ce..f03247e2af78f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3818,8 +3818,8 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 
 void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 {
-	amdgpu_device_ip_fini(adev);
 	amdgpu_fence_driver_sw_fini(adev);
+	amdgpu_device_ip_fini(adev);
 	release_firmware(adev->firmware.gpu_info_fw);
 	adev->firmware.gpu_info_fw = NULL;
 	adev->accel_working = false;
-- 
2.33.0



