Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E07371D03
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbhECQ5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235076AbhECQzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE02161951;
        Mon,  3 May 2021 16:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060167;
        bh=n609f3gMSJRljYhN1/ve688WgsyGXq4QRIENlWuUpFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDavrWVHbPz+bjDyJSfCqKX1PAplA0wMmh+S6nWCWymXq0RrF1VSgvf+qOS/908Ax
         9ANT7fvKSz54RbwxZiavgb5+OrmdeZY0gBXcnCUHx1rJ7KyPKXtzs4uG2odgv8vnG0
         Smw2YDhjYmIJ8x278shcsY/DAKJjXqRZVXSmleDTqtmgNJK/F95y+BTx3OJkjkRMKZ
         u0FNdrGV6HqUTooxV+k4HF35pUXBezbb0Kt0Upe0ZRrCn1nsrxyqe5pnyPKbNotjav
         ZLYpUq1eN+H7Dqhmw+n6JtGHnUDwIuGbWPycO+BBkKR+249eQFbbzVk7d+Rbm5yljN
         60vFrtVYjD4pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guchun Chen <guchun.chen@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 28/31] drm/amdgpu: fix NULL pointer dereference
Date:   Mon,  3 May 2021 12:42:01 -0400
Message-Id: <20210503164204.2854178-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 3c3dc654333f6389803cdcaf03912e94173ae510 ]

ttm->sg needs to be checked before accessing its child member.

Call Trace:
 amdgpu_ttm_backend_destroy+0x12/0x70 [amdgpu]
 ttm_bo_cleanup_memtype_use+0x3a/0x60 [ttm]
 ttm_bo_release+0x17d/0x300 [ttm]
 amdgpu_bo_unref+0x1a/0x30 [amdgpu]
 amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu+0x78b/0x8b0 [amdgpu]
 kfd_ioctl_alloc_memory_of_gpu+0x118/0x220 [amdgpu]
 kfd_ioctl+0x222/0x400 [amdgpu]
 ? kfd_dev_is_large_bar+0x90/0x90 [amdgpu]
 __x64_sys_ioctl+0x8e/0xd0
 ? __context_tracking_exit+0x52/0x90
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f97f264d317
Code: b3 66 90 48 8b 05 71 4b 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 41 4b 2d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffdb402c338 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f97f3cc63a0 RCX: 00007f97f264d317
RDX: 00007ffdb402c380 RSI: 00000000c0284b16 RDI: 0000000000000003
RBP: 00007ffdb402c380 R08: 00007ffdb402c428 R09: 00000000c4000004
R10: 00000000c4000004 R11: 0000000000000246 R12: 00000000c0284b16
R13: 0000000000000003 R14: 00007f97f3cc63a0 R15: 00007f8836200000

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index ae700e445fbc..d057bc29bf4c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -742,7 +742,7 @@ static void amdgpu_ttm_tt_unpin_userptr(struct ttm_tt *ttm)
 		DMA_BIDIRECTIONAL : DMA_TO_DEVICE;
 
 	/* double check that we don't free the table twice */
-	if (!ttm->sg->sgl)
+	if (!ttm->sg || !ttm->sg->sgl)
 		return;
 
 	/* free the sg table and pages again */
-- 
2.30.2

