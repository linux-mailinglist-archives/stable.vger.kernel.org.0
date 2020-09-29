Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F8727C82D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbgI2L7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730327AbgI2LlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A6782065C;
        Tue, 29 Sep 2020 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379681;
        bh=ZZNJK65ntMv3itHnvKIAkX4hgmrikXv/Ak/qwIrHRzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t44vUuVeI/muLYBJO9doIVAfAEoDkFsrNESLcRupPDN30BdG4XHvPhXitvFw0M8Hx
         BtD4JN70P6P6aBhQ3jP3JPKxuVIi9T0XX+dXgeItORCFakwu52YQmAejfAoD4RZkUF
         5E1MGvqhqfuU4pGfsA9QfoAR946FNTfxPkTQ/5hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 271/388] drm/amdkfd: fix restore worker race condition
Date:   Tue, 29 Sep 2020 13:00:02 +0200
Message-Id: <20200929110023.580104217@linuxfoundation.org>
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



