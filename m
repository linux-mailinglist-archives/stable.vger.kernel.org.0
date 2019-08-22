Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A53999F3
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbfHVRIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390528AbfHVRIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:49 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF50B23404;
        Thu, 22 Aug 2019 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493729;
        bh=gK56fSYyRsg25NtN0vMOBKtrbqwKisNofmHMCKKZoVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6yo0tKgfceRK4pnVkQfm2r7kclt4rTK4ZBBLRAB3p82aXqBYJbag3A2HdfITDoPI
         W/gd4lwE5/Fv34RyKXr2PgqAz9uMiiFN08Azb3ZCImUF3nbDWCtiUgtpPMKrQp9eBA
         B7ZNhp4RD28p6ws4WH026J0mxLW95ZNy+CSCTvPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kent Russell <kent.russell@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 063/135] drm/amdkfd: Fix byte align on VegaM
Date:   Thu, 22 Aug 2019 13:06:59 -0400
Message-Id: <20190822170811.13303-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Russell <kent.russell@amd.com>

[ Upstream commit d65848657c3da5c0d4b685f823d0230f151ab34e ]

This was missed during the addition of VegaM support

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 4b192e0ce92f4..ed7977d0dd018 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1148,7 +1148,8 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 			adev->asic_type != CHIP_FIJI &&
 			adev->asic_type != CHIP_POLARIS10 &&
 			adev->asic_type != CHIP_POLARIS11 &&
-			adev->asic_type != CHIP_POLARIS12) ?
+			adev->asic_type != CHIP_POLARIS12 &&
+			adev->asic_type != CHIP_VEGAM) ?
 			VI_BO_SIZE_ALIGN : 1;
 
 	mapping_flags = AMDGPU_VM_PAGE_READABLE;
-- 
2.20.1

