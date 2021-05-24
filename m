Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4A738EB70
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhEXPDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234683AbhEXPA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49CCE6144D;
        Mon, 24 May 2021 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867806;
        bh=RTjny6HL8e3577Pf5+XgvUc+oCBngcpPP1oip52yf+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YL1L7skPS1pdqqcPTYle5gMD2gqTGAVNqVowJz8bTf0UYfqKo1l/1fMI2YN5Wbo/p
         wyIZwr+j+QWQYhYGtfruFZXekVrvomAjVQ5/5bMVmxvGvsq/KxjQvo0wHYAMYWF8oP
         Rnw2x4CKrBF/13Lh6enINCJ1d62oTfeFHp+wKtW1/AAwbF5qEE5WVJbTcY/4cwWk5y
         oEwa5xG7WFEgWh+Kc5EfwuN8K83uMBQnpEqE9MhB/d9xh6LVm8NKQEJVH4XHd18ovu
         i8yh3qCC84qsMOVEEFiefLhHDBU4OpfYZ6lgHjNsrv7IBDg3/G22EhW18hlREm+Cjr
         yq90dSGTHcVpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 51/52] drm/amdgpu: Fix a use-after-free
Date:   Mon, 24 May 2021 10:49:01 -0400
Message-Id: <20210524144903.2498518-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit 1e5c37385097c35911b0f8a0c67ffd10ee1af9a2 ]

looks like we forget to set ttm->sg to NULL.
Hit panic below

[ 1235.844104] general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b7b4b: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
[ 1235.989074] Call Trace:
[ 1235.991751]  sg_free_table+0x17/0x20
[ 1235.995667]  amdgpu_ttm_backend_unbind.cold+0x4d/0xf7 [amdgpu]
[ 1236.002288]  amdgpu_ttm_backend_destroy+0x29/0x130 [amdgpu]
[ 1236.008464]  ttm_tt_destroy+0x1e/0x30 [ttm]
[ 1236.013066]  ttm_bo_cleanup_memtype_use+0x51/0xa0 [ttm]
[ 1236.018783]  ttm_bo_release+0x262/0xa50 [ttm]
[ 1236.023547]  ttm_bo_put+0x82/0xd0 [ttm]
[ 1236.027766]  amdgpu_bo_unref+0x26/0x50 [amdgpu]
[ 1236.032809]  amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu+0x7aa/0xd90 [amdgpu]
[ 1236.040400]  kfd_ioctl_alloc_memory_of_gpu+0xe2/0x330 [amdgpu]
[ 1236.046912]  kfd_ioctl+0x463/0x690 [amdgpu]

Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 91e3a87b1de8..58e14d3040f0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1300,6 +1300,7 @@ static void amdgpu_ttm_tt_unpopulate(struct ttm_tt *ttm)
 	if (gtt && gtt->userptr) {
 		amdgpu_ttm_tt_set_user_pages(ttm, NULL);
 		kfree(ttm->sg);
+		ttm->sg = NULL;
 		ttm->page_flags &= ~TTM_PAGE_FLAG_SG;
 		return;
 	}
-- 
2.30.2

