Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3192013BD
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405406AbgFSQDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392132AbgFSPLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:11:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D46120776;
        Fri, 19 Jun 2020 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579499;
        bh=qvMEqAuOf5Z/TluxxmrPx3SKltHINKkkkiAXGoLWkaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfQnHfD//U8ZfiWJOrqCMrD2cBdQpA+PdCUBQIgxoIC3sR1gPlxHgrMvtgA3OnUBf
         JDYiSTwriXmlc3UGy8eyy8xX33JDpRGjj1nbRvH2i0KL6amz1gXhQL9YjYq98Pu7cI
         tRy4aW6CCfQnKEXe+YlDMcDMNcKEVl+AJlJYzLoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Cornwall <Jay.Cornwall@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/261] drm/amdgpu: Sync with VM root BO when switching VM to CPU update mode
Date:   Fri, 19 Jun 2020 16:32:19 +0200
Message-Id: <20200619141656.002097270@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



