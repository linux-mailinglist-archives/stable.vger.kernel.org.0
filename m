Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13DD1F29B1
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbgFIADW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731223AbgFHXVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B385D208B3;
        Mon,  8 Jun 2020 23:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658509;
        bh=qvMEqAuOf5Z/TluxxmrPx3SKltHINKkkkiAXGoLWkaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+df3N1+SndCxyYknxS80q3yv5EZHZFNKNaK05WjtnwbJbHYegkhe1CPF7QEUbRJ8
         uXkBYz2r6oPS/uO2wg1lNc8qcDfoj+pR3IUiOUIZYYBuRN/I2v8rV98x4RZMjaGfx+
         8oNKJsSJzDpNO42GWCOpYfYnZ4ySueTYpY2KN1Us=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        Jay Cornwall <Jay.Cornwall@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 139/175] drm/amdgpu: Sync with VM root BO when switching VM to CPU update mode
Date:   Mon,  8 Jun 2020 19:18:12 -0400
Message-Id: <20200608231848.3366970-139-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
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
index c7514f743409..6335bd4ae374 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2867,10 +2867,17 @@ int amdgpu_vm_make_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm, uns
 	WARN_ONCE((vm->use_cpu_for_update && !amdgpu_gmc_vram_full_visible(&adev->gmc)),
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
 
-- 
2.25.1

