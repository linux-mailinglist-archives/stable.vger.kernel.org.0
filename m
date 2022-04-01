Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB87B4EF462
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348984AbiDAPGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349866AbiDAO6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427A616AA48;
        Fri,  1 Apr 2022 07:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3A1A60A53;
        Fri,  1 Apr 2022 14:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A332C2BBE4;
        Fri,  1 Apr 2022 14:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824321;
        bh=pp9i/QafLErsnd1inFjTyppo7uMYtddoSpX1BRdMTIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zjeu955ulNENIn82nhsg2a6dDl3tuSVVgs4y4sPNzpK6wwoimByOpbbkvBchrG7PY
         Mxcc+fjPv37wSAxm7KobbmsACnW1ivYBmUkNaj4d3Mzwg+A6ZZdoiEBoiKWsBbWhlp
         zbwiW9ieBFducS9m9FCt3Snqz/WGGX3iUrFx2EX2SMZazJ7YA3VlWAQH/BP8EXb0Yd
         p1oMvOhcQ7NfTqsipBdPC8VBA6baNMajWyZ0C8F+NPYWSF0hjQSlN4cLTGvkct1O9U
         4cC4XtNHN+QQ4aPf/jjAsVwX0SlVr/tUfhwEaKVlnZLmaE3xebCC+PqycTTSbqXsVD
         JDQRfijB9meCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <Alexander.Deucher@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, nirmoy.das@amd.com,
        matthew.auld@intel.com, Roy.Sun@amd.com, tzimmermann@suse.de,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 12/37] drm/amdgpu: Fix recursive locking warning
Date:   Fri,  1 Apr 2022 10:44:21 -0400
Message-Id: <20220401144446.1954694-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144446.1954694-1-sashal@kernel.org>
References: <20220401144446.1954694-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>

[ Upstream commit 447c7997b62a5115ba4da846dcdee4fc12298a6a ]

Noticed the below warning while running a pytorch workload on vega10
GPUs. Change to trylock to avoid conflicts with already held reservation
locks.

[  +0.000003] WARNING: possible recursive locking detected
[  +0.000003] 5.13.0-kfd-rajneesh #1030 Not tainted
[  +0.000004] --------------------------------------------
[  +0.000002] python/4822 is trying to acquire lock:
[  +0.000004] ffff932cd9a259f8 (reservation_ww_class_mutex){+.+.}-{3:3},
at: amdgpu_bo_release_notify+0xc4/0x160 [amdgpu]
[  +0.000203]
              but task is already holding lock:
[  +0.000003] ffff932cbb7181f8 (reservation_ww_class_mutex){+.+.}-{3:3},
at: ttm_eu_reserve_buffers+0x270/0x470 [ttm]
[  +0.000017]
              other info that might help us debug this:
[  +0.000002]  Possible unsafe locking scenario:

[  +0.000003]        CPU0
[  +0.000002]        ----
[  +0.000002]   lock(reservation_ww_class_mutex);
[  +0.000004]   lock(reservation_ww_class_mutex);
[  +0.000003]
               *** DEADLOCK ***

[  +0.000002]  May be due to missing lock nesting notation

[  +0.000003] 7 locks held by python/4822:
[  +0.000003]  #0: ffff932c4ac028d0 (&process->mutex){+.+.}-{3:3}, at:
kfd_ioctl_map_memory_to_gpu+0x10b/0x320 [amdgpu]
[  +0.000232]  #1: ffff932c55e830a8 (&info->lock#2){+.+.}-{3:3}, at:
amdgpu_amdkfd_gpuvm_map_memory_to_gpu+0x64/0xf60 [amdgpu]
[  +0.000241]  #2: ffff932cc45b5e68 (&(*mem)->lock){+.+.}-{3:3}, at:
amdgpu_amdkfd_gpuvm_map_memory_to_gpu+0xdf/0xf60 [amdgpu]
[  +0.000236]  #3: ffffb2b35606fd28
(reservation_ww_class_acquire){+.+.}-{0:0}, at:
amdgpu_amdkfd_gpuvm_map_memory_to_gpu+0x232/0xf60 [amdgpu]
[  +0.000235]  #4: ffff932cbb7181f8
(reservation_ww_class_mutex){+.+.}-{3:3}, at:
ttm_eu_reserve_buffers+0x270/0x470 [ttm]
[  +0.000015]  #5: ffffffffc045f700 (*(sspp++)){....}-{0:0}, at:
drm_dev_enter+0x5/0xa0 [drm]
[  +0.000038]  #6: ffff932c52da7078 (&vm->eviction_lock){+.+.}-{3:3},
at: amdgpu_vm_bo_update_mapping+0xd5/0x4f0 [amdgpu]
[  +0.000195]
              stack backtrace:
[  +0.000003] CPU: 11 PID: 4822 Comm: python Not tainted
5.13.0-kfd-rajneesh #1030
[  +0.000005] Hardware name: GIGABYTE MZ01-CE0-00/MZ01-CE0-00, BIOS F02
08/29/2018
[  +0.000003] Call Trace:
[  +0.000003]  dump_stack+0x6d/0x89
[  +0.000010]  __lock_acquire+0xb93/0x1a90
[  +0.000009]  lock_acquire+0x25d/0x2d0
[  +0.000005]  ? amdgpu_bo_release_notify+0xc4/0x160 [amdgpu]
[  +0.000184]  ? lock_is_held_type+0xa2/0x110
[  +0.000006]  ? amdgpu_bo_release_notify+0xc4/0x160 [amdgpu]
[  +0.000184]  __ww_mutex_lock.constprop.17+0xca/0x1060
[  +0.000007]  ? amdgpu_bo_release_notify+0xc4/0x160 [amdgpu]
[  +0.000183]  ? lock_release+0x13f/0x270
[  +0.000005]  ? lock_is_held_type+0xa2/0x110
[  +0.000006]  ? amdgpu_bo_release_notify+0xc4/0x160 [amdgpu]
[  +0.000183]  amdgpu_bo_release_notify+0xc4/0x160 [amdgpu]
[  +0.000185]  ttm_bo_release+0x4c6/0x580 [ttm]
[  +0.000010]  amdgpu_bo_unref+0x1a/0x30 [amdgpu]
[  +0.000183]  amdgpu_vm_free_table+0x76/0xa0 [amdgpu]
[  +0.000189]  amdgpu_vm_free_pts+0xb8/0xf0 [amdgpu]
[  +0.000189]  amdgpu_vm_update_ptes+0x411/0x770 [amdgpu]
[  +0.000191]  amdgpu_vm_bo_update_mapping+0x324/0x4f0 [amdgpu]
[  +0.000191]  amdgpu_vm_bo_update+0x251/0x610 [amdgpu]
[  +0.000191]  update_gpuvm_pte+0xcc/0x290 [amdgpu]
[  +0.000229]  ? amdgpu_vm_bo_map+0xd7/0x130 [amdgpu]
[  +0.000190]  amdgpu_amdkfd_gpuvm_map_memory_to_gpu+0x912/0xf60
[amdgpu]
[  +0.000234]  kfd_ioctl_map_memory_to_gpu+0x182/0x320 [amdgpu]
[  +0.000218]  kfd_ioctl+0x2b9/0x600 [amdgpu]
[  +0.000216]  ? kfd_ioctl_unmap_memory_from_gpu+0x270/0x270 [amdgpu]
[  +0.000216]  ? lock_release+0x13f/0x270
[  +0.000006]  ? __fget_files+0x107/0x1e0
[  +0.000007]  __x64_sys_ioctl+0x8b/0xd0
[  +0.000007]  do_syscall_64+0x36/0x70
[  +0.000004]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  +0.000007] RIP: 0033:0x7fbff90a7317
[  +0.000004] Code: b3 66 90 48 8b 05 71 4b 2d 00 64 c7 00 26 00 00 00
48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 41 4b 2d 00 f7 d8 64 89 01 48
[  +0.000005] RSP: 002b:00007fbe301fe648 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  +0.000006] RAX: ffffffffffffffda RBX: 00007fbcc402d820 RCX:
00007fbff90a7317
[  +0.000003] RDX: 00007fbe301fe690 RSI: 00000000c0184b18 RDI:
0000000000000004
[  +0.000003] RBP: 00007fbe301fe690 R08: 0000000000000000 R09:
00007fbcc402d880
[  +0.000003] R10: 0000000002001000 R11: 0000000000000246 R12:
00000000c0184b18
[  +0.000003] R13: 0000000000000004 R14: 00007fbf689593a0 R15:
00007fbcc402d820

Cc: Christian König <christian.koenig@amd.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <Alexander.Deucher@amd.com>

Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 532d1842f6a3..4cc0dd494a42 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1305,7 +1305,8 @@ void amdgpu_bo_release_notify(struct ttm_buffer_object *bo)
 	    !(abo->flags & AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE))
 		return;
 
-	dma_resv_lock(bo->base.resv, NULL);
+	if (WARN_ON_ONCE(!dma_resv_trylock(bo->base.resv)))
+		return;
 
 	r = amdgpu_fill_buffer(abo, AMDGPU_POISON, bo->base.resv, &fence);
 	if (!WARN_ON(r)) {
-- 
2.34.1

