Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745161EAB08
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbgFASNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731374AbgFASNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:13:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A21632065C;
        Mon,  1 Jun 2020 18:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035220;
        bh=/5gUvaIeXL5/SvAcmLxJzXgwL0RfqCvuytXsSmHeWtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QINc8cAHRitK2qEJZzHMARYBBcYUre5CNyKVIW82CDfiGpcGc0c8SR3lGpct1naUQ
         FpYYkFhzGfALlcYdH5e2RefF/JLuh5q5a5krtylkCcLVh7GxPYnS5CQhwXiVSS1lN0
         +ckxYKuCbU2ab8RXKgivfuy1MTpj/8XsX7pvwMBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Sierra <alex.sierra@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 062/177] drm/amdgpu: Use GEM obj reference for KFD BOs
Date:   Mon,  1 Jun 2020 19:53:20 +0200
Message-Id: <20200601174054.128986546@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit 39b3128d7ffd44e400e581e6f49e88cb42bef9a1 ]

Releasing the AMDGPU BO ref directly leads to problems when BOs were
exported as DMA bufs. Releasing the GEM reference makes sure that the
AMDGPU/TTM BO is not freed too early.

Also take a GEM reference when importing BOs from DMABufs to keep
references to imported BOs balances properly.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index fa8ac9d19a7a..6326c1792270 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1304,7 +1304,7 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 	}
 
 	/* Free the BO*/
-	amdgpu_bo_unref(&mem->bo);
+	drm_gem_object_put_unlocked(&mem->bo->tbo.base);
 	mutex_destroy(&mem->lock);
 	kfree(mem);
 
@@ -1647,7 +1647,8 @@ int amdgpu_amdkfd_gpuvm_import_dmabuf(struct kgd_dev *kgd,
 		 ALLOC_MEM_FLAGS_VRAM : ALLOC_MEM_FLAGS_GTT) |
 		ALLOC_MEM_FLAGS_WRITABLE | ALLOC_MEM_FLAGS_EXECUTABLE;
 
-	(*mem)->bo = amdgpu_bo_ref(bo);
+	drm_gem_object_get(&bo->tbo.base);
+	(*mem)->bo = bo;
 	(*mem)->va = va;
 	(*mem)->domain = (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM) ?
 		AMDGPU_GEM_DOMAIN_VRAM : AMDGPU_GEM_DOMAIN_GTT;
-- 
2.25.1



