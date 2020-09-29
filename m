Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1A227C5DD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgI2Ljo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729879AbgI2Ljh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:39:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71F352083B;
        Tue, 29 Sep 2020 11:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379576;
        bh=9P09pX9CSmsoGNHoVEW3b11httRKm6P+siZpoeibr/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/PbyCNVl88u2xCt3RfRQPn0QNnuWWb7QdIZlZzSuMfjdT8/dBWbaz4/TkY+xJ5K7
         1hPccmaIbSgmsHSXQr1pP06iQh0V7kFT1FvRa862EguLSNv/FQp0Y7KMH8eDDI0M2d
         vxqgeKOwDaAitzwoyWiFz4+I+lFPirSxuW2zeqKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Zhang <Jack.Zhang1@amd.com>,
        Monk Liu <monk.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 226/388] drm/amdgpu/sriov add amdgpu_amdkfd_pre_reset in gpu reset
Date:   Tue, 29 Sep 2020 12:59:17 +0200
Message-Id: <20200929110021.420299442@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Zhang <Jack.Zhang1@amd.com>

[ Upstream commit 04bef61e5da18c2b301c629a209ccdba4d4c6fbb ]

kfd_pre_reset will free mem_objs allocated by kfd_gtt_sa_allocate

Without this change, sriov tdr code path will never free those allocated
memories and get memory leak.

v2:add a bugfix for kiq ring test fail

Signed-off-by: Jack Zhang <Jack.Zhang1@amd.com>
Reviewed-by: Monk Liu <monk.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c | 3 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c  | 3 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
index d10f483f5e273..ce30d4e8bf25f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
@@ -644,6 +644,9 @@ static int kgd_hqd_destroy(struct kgd_dev *kgd, void *mqd,
 	uint32_t temp;
 	struct v10_compute_mqd *m = get_mqd(mqd);
 
+	if (amdgpu_sriov_vf(adev) && adev->in_gpu_reset)
+		return 0;
+
 #if 0
 	unsigned long flags;
 	int retry;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
index e262f2ac07a35..92754cfb98086 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
@@ -540,6 +540,9 @@ int kgd_gfx_v9_hqd_destroy(struct kgd_dev *kgd, void *mqd,
 	uint32_t temp;
 	struct v9_mqd *m = get_mqd(mqd);
 
+	if (amdgpu_sriov_vf(adev) && adev->in_gpu_reset)
+		return 0;
+
 	if (adev->in_gpu_reset)
 		return -EIO;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 5e1dce4241547..4105fbf571674 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3466,6 +3466,8 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 	if (r)
 		return r;
 
+	amdgpu_amdkfd_pre_reset(adev);
+
 	/* Resume IP prior to SMC */
 	r = amdgpu_device_ip_reinit_early_sriov(adev);
 	if (r)
-- 
2.25.1



