Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E297C194D31
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgCZXYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbgCZXYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77BE42074D;
        Thu, 26 Mar 2020 23:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265047;
        bh=q7wvOp/B+vcsKe//MRTz/um2sZICyj6+bgXMc/jce7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6PxG26Cv/HG2KtE1WmvTHZhLXbIox26JvVyaqmpg0lzmxTWEf6del734yseTjDIf
         2Bm3CPugmjMKaqKe/C617J9e16z+kOJFZgA2FGwQsgZpM4MR0++6XE7Fn58G3hrNLh
         SEf/vRjyKFOM7jpVsDqInocmnuUXL/E3ZCUvE4qU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 08/28] drm/amdgpu: add fbdev suspend/resume on gpu reset
Date:   Thu, 26 Mar 2020 19:23:37 -0400
Message-Id: <20200326232357.7516-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232357.7516-1-sashal@kernel.org>
References: <20200326232357.7516-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 063e768ebd27d3ec0d6908b7f8ea9b0a732b9949 ]

This can fix the baco reset failure seen on Navi10.
And this should be a low risk fix as the same sequence
is already used for system suspend/resume.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 332b9c24a2cd0..9a8a1c6ca3210 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3854,6 +3854,8 @@ static int amdgpu_do_asic_reset(struct amdgpu_hive_info *hive,
 				if (r)
 					goto out;
 
+				amdgpu_fbdev_set_suspend(tmp_adev, 0);
+
 				/* must succeed. */
 				amdgpu_ras_resume(tmp_adev);
 
@@ -4023,6 +4025,8 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 		 */
 		amdgpu_unregister_gpu_instance(tmp_adev);
 
+		amdgpu_fbdev_set_suspend(adev, 1);
+
 		/* disable ras on ALL IPs */
 		if (!in_ras_intr && amdgpu_device_ip_need_full_reset(tmp_adev))
 			amdgpu_ras_suspend(tmp_adev);
-- 
2.20.1

