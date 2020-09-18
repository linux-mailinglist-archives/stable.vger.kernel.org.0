Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5221026F220
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgIRC43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgIRCHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 749EA239E5;
        Fri, 18 Sep 2020 02:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394812;
        bh=ZZNJK65ntMv3itHnvKIAkX4hgmrikXv/Ak/qwIrHRzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykbfgYFye76ZD58NhLWPmz1KEC8nZ1SMLcrLQN/G3n4ZzfJFMhBstuwxFrax1oCs0
         +ljBDbB4ENsZqmfiGf3LImKukxrsQxKl8gxnLMxojVUOW3t1Z2lZHARq8iiGkL6unU
         vVURt9VgBmR+fPICBLKL4yck+CfC9K0Kz4PsnujY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 279/330] drm/amdkfd: fix restore worker race condition
Date:   Thu, 17 Sep 2020 22:00:19 -0400
Message-Id: <20200918020110.2063155-279-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit f7646585a30ed8ef5ab300d4dc3b0c1d6afbe71d ]

In free memory of gpu path, remove bo from validate_list to make sure
restore worker don't access the BO any more, then unregister bo MMU
interval notifier. Otherwise, the restore worker will crash in the
middle of validating BO user pages if MMU interval notifer is gone.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index edb561baf8b90..f3fa271e3394c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1247,15 +1247,15 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 	 * be freed anyway
 	 */
 
-	/* No more MMU notifiers */
-	amdgpu_mn_unregister(mem->bo);
-
 	/* Make sure restore workers don't access the BO any more */
 	bo_list_entry = &mem->validate_list;
 	mutex_lock(&process_info->lock);
 	list_del(&bo_list_entry->head);
 	mutex_unlock(&process_info->lock);
 
+	/* No more MMU notifiers */
+	amdgpu_mn_unregister(mem->bo);
+
 	ret = reserve_bo_and_cond_vms(mem, NULL, BO_VM_ALL, &ctx);
 	if (unlikely(ret))
 		return ret;
-- 
2.25.1

