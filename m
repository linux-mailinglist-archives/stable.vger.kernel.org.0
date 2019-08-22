Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A54799AFA
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387496AbfHVRRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390280AbfHVRIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:22 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D3FC23428;
        Thu, 22 Aug 2019 17:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493701;
        bh=zdlWUlopslHIVVFc4/X/Ym+gbxfUMbmngZmdRU2WrcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNmUOp17F723zfGEluJwSJ6qtSK5XZOVliOAna2Sr58Cwbpqv70yokRcJj2Qq7MmP
         0C+xpCnSRC3znll44qh+vauE/wnqumlqknqeI6qPuW5LfZnWN+yHsNBCVYAw1hxSPD
         oQe3oLKhQ7lXSMZQDce08vhIHfBMp+Ee/4yZPDEg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 013/135] drm/amdgpu: fix gfx9 soft recovery
Date:   Thu, 22 Aug 2019 13:06:09 -0400
Message-Id: <20190822170811.13303-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

commit 17b6d2d528542bc60ad400add35728b2259b3cc1 upstream.

The SOC15_REG_OFFSET() macro wasn't used, making the soft recovery fail.

v2: use WREG32_SOC15 instead of WREG32 + SOC15_REG_OFFSET

Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 2f18c64d531ff..2f7f0a2e4a6c5 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -4553,7 +4553,7 @@ static void gfx_v9_0_ring_soft_recovery(struct amdgpu_ring *ring, unsigned vmid)
 	value = REG_SET_FIELD(value, SQ_CMD, MODE, 0x01);
 	value = REG_SET_FIELD(value, SQ_CMD, CHECK_VMID, 1);
 	value = REG_SET_FIELD(value, SQ_CMD, VM_ID, vmid);
-	WREG32(mmSQ_CMD, value);
+	WREG32_SOC15(GC, 0, mmSQ_CMD, value);
 }
 
 static void gfx_v9_0_set_gfx_eop_interrupt_state(struct amdgpu_device *adev,
-- 
2.20.1

