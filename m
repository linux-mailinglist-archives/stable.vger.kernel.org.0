Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8897F1F22E8
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgFHXLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbgFHXLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E42EF2100A;
        Mon,  8 Jun 2020 23:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657861;
        bh=FSSEj0I+Qs96LnMPO/9ObpRwOVHhKyOHosCzGUsdNQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nY3tjfeOqLqgfHbWwjoH5T27o3y8gH28q9tJMm/TN+uLkzmsmETD7q9GbZGbt3Fzk
         x6UXe4Of/sKdjqdk6XzkpyLFiBUxWY38cM+xhfdeKmOGyi2QZWaQ+AdNoehyxmQ59V
         ZXutCAWtYP3Li6wveroouNtF2jTLn7h+SzEQ7WoM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        Jay Cornwall <Jay.Cornwall@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 224/274] drm/amdgpu: Sync with VM root BO when switching VM to CPU update mode
Date:   Mon,  8 Jun 2020 19:05:17 -0400
Message-Id: <20200608230607.3361041-224-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit 90ca78deb004abe75b5024968a199acb96bb70f9 ]

This fixes an intermittent bug where a root PD clear operation still in
progress could overwrite a PDE update done by the CPU, resulting in a
VM fault.

Fixes: 108b4d928c03 ("drm/amd/amdgpu: Update VM function pointer")
Reported-by: Jay Cornwall <Jay.Cornwall@amd.com>
Tested-by: Jay Cornwall <Jay.Cornwall@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 6d9252a27916..06242096973c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2996,10 +2996,17 @@ int amdgpu_vm_make_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		   !amdgpu_gmc_vram_full_visible(&adev->gmc)),
 		  "CPU update of VM recommended only for large BAR system\n");
 
-	if (vm->use_cpu_for_update)
+	if (vm->use_cpu_for_update) {
+		/* Sync with last SDMA update/clear before switching to CPU */
+		r = amdgpu_bo_sync_wait(vm->root.base.bo,
+					AMDGPU_FENCE_OWNER_UNDEFINED, true);
+		if (r)
+			goto free_idr;
+
 		vm->update_funcs = &amdgpu_vm_cpu_funcs;
-	else
+	} else {
 		vm->update_funcs = &amdgpu_vm_sdma_funcs;
+	}
 	dma_fence_put(vm->last_update);
 	vm->last_update = NULL;
 	vm->is_compute_context = true;
-- 
2.25.1

