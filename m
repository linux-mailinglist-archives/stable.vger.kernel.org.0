Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8229315EA38
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390094AbgBNRMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392106AbgBNQNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D6DE2469F;
        Fri, 14 Feb 2020 16:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696785;
        bh=oXto1Jy1Hz0pYiNQMzQhCG7uLEsa9omy0lSjRgjVriw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6Hf+rfHJgTbd8jGwAplXNyr1/gVmo6TQncG9cZPjCoN/PsmmdNBt9SYLm7HdiscA
         teAgsXbAWb0lfhksW9+XD3QCOiHqI+Y0mzCeSCQdlaEM+3e+CCzyM+MPRPjSQS/8Hm
         DFIAo99TXrzUWbXC5S9KzaFujmaFYcCXkeNLG+GQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 061/252] drm/amdgpu: remove set but not used variable 'invalid'
Date:   Fri, 14 Feb 2020 11:08:36 -0500
Message-Id: <20200214161147.15842-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit 9e089a29c696d86d26e79737bafbce94738fb462 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c: In function
‘amdgpu_amdkfd_evict_userptr’:
drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c:1665:6: warning:
variable ‘invalid’ set but not used [-Wunused-but-set-variable]

'invalid' is never used, so can be removed. Thus 'atomic_inc_return'
can be replaced as 'atomic_inc'

Fixes: 5ae0283e831a ("drm/amdgpu: Add userptr support for KFD")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index f92597c292fe5..370bdf5087291 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1639,10 +1639,10 @@ int amdgpu_amdkfd_evict_userptr(struct kgd_mem *mem,
 				struct mm_struct *mm)
 {
 	struct amdkfd_process_info *process_info = mem->process_info;
-	int invalid, evicted_bos;
+	int evicted_bos;
 	int r = 0;
 
-	invalid = atomic_inc_return(&mem->invalid);
+	atomic_inc(&mem->invalid);
 	evicted_bos = atomic_inc_return(&process_info->evicted_bos);
 	if (evicted_bos == 1) {
 		/* First eviction, stop the queues */
-- 
2.20.1

