Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A822728384B
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgJEOpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgJEOpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C5ED20E65;
        Mon,  5 Oct 2020 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909134;
        bh=Vk4b54f9hxuGsBFXCqKKcYpVnZIjfAqZJjc5T6YXC70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQMm7788L5qHxGUfQKRGOkvm1Yij03/UbYgZKHUDAobQ2WviIy4J6gti7uDcUWVFc
         9j/9U5PSDorQ2ZurtNyGrW/DBjyESBFvFOSwgcdR7TIil7kiGJ5S1IJXDvNtHTctdj
         xX4gexqDl/dtEtOxM6IcoBRZdm1TLqrbYCMp/VcA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 2/2] drm/amdgpu: prevent double kfree ttm->sg
Date:   Mon,  5 Oct 2020 10:45:31 -0400
Message-Id: <20201005144531.2527844-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005144531.2527844-1-sashal@kernel.org>
References: <20201005144531.2527844-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 1d0e16ac1a9e800598dcfa5b6bc53b704a103390 ]

Set ttm->sg to NULL after kfree, to avoid memory corruption backtrace:

[  420.932812] kernel BUG at
/build/linux-do9eLF/linux-4.15.0/mm/slub.c:295!
[  420.934182] invalid opcode: 0000 [#1] SMP NOPTI
[  420.935445] Modules linked in: xt_conntrack ipt_MASQUERADE
[  420.951332] Hardware name: Dell Inc. PowerEdge R7525/0PYVT1, BIOS
1.5.4 07/09/2020
[  420.952887] RIP: 0010:__slab_free+0x180/0x2d0
[  420.954419] RSP: 0018:ffffbe426291fa60 EFLAGS: 00010246
[  420.955963] RAX: ffff9e29263e9c30 RBX: ffff9e29263e9c30 RCX:
000000018100004b
[  420.957512] RDX: ffff9e29263e9c30 RSI: fffff3d33e98fa40 RDI:
ffff9e297e407a80
[  420.959055] RBP: ffffbe426291fb00 R08: 0000000000000001 R09:
ffffffffc0d39ade
[  420.960587] R10: ffffbe426291fb20 R11: ffff9e49ffdd4000 R12:
ffff9e297e407a80
[  420.962105] R13: fffff3d33e98fa40 R14: ffff9e29263e9c30 R15:
ffff9e2954464fd8
[  420.963611] FS:  00007fa2ea097780(0000) GS:ffff9e297e840000(0000)
knlGS:0000000000000000
[  420.965144] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  420.966663] CR2: 00007f16bfffefb8 CR3: 0000001ff0c62000 CR4:
0000000000340ee0
[  420.968193] Call Trace:
[  420.969703]  ? __page_cache_release+0x3c/0x220
[  420.971294]  ? amdgpu_ttm_tt_unpopulate+0x5e/0x80 [amdgpu]
[  420.972789]  kfree+0x168/0x180
[  420.974353]  ? amdgpu_ttm_tt_set_user_pages+0x64/0xc0 [amdgpu]
[  420.975850]  ? kfree+0x168/0x180
[  420.977403]  amdgpu_ttm_tt_unpopulate+0x5e/0x80 [amdgpu]
[  420.978888]  ttm_tt_unpopulate.part.10+0x53/0x60 [amdttm]
[  420.980357]  ttm_tt_destroy.part.11+0x4f/0x60 [amdttm]
[  420.981814]  ttm_tt_destroy+0x13/0x20 [amdttm]
[  420.983273]  ttm_bo_cleanup_memtype_use+0x36/0x80 [amdttm]
[  420.984725]  ttm_bo_release+0x1c9/0x360 [amdttm]
[  420.986167]  amdttm_bo_put+0x24/0x30 [amdttm]
[  420.987663]  amdgpu_bo_unref+0x1e/0x30 [amdgpu]
[  420.989165]  amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu+0x9ca/0xb10
[amdgpu]
[  420.990666]  kfd_ioctl_alloc_memory_of_gpu+0xef/0x2c0 [amdgpu]

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 05ff98b43c50f..80c60a62d39ef 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -637,6 +637,7 @@ static int amdgpu_ttm_tt_pin_userptr(struct ttm_tt *ttm)
 
 release_sg:
 	kfree(ttm->sg);
+	ttm->sg = NULL;
 	return r;
 }
 
-- 
2.25.1

