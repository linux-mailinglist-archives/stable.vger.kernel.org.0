Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B663E76816
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387861AbfGZNmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387857AbfGZNmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:42:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C2B922CC0;
        Fri, 26 Jul 2019 13:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148528;
        bh=REl6k3boKm8ZeBbrUdXU6rTwEXTni+C2iWBFMPPHPtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0cw4zLc1X0BJYtN/lZPdEyTOZXJ3ZGC9/dRMPr05qZGDKCuJ4+IWLwbCxVgak+r2X
         I4Uv1nS0XvprBW+QmK91ZDBzhZUyg+whmLvBE0zj/9SuFJfmV3HijBgRxu7uRTH5Pi
         d4tz1gtJHQQXZ8musPijoO+E/xvCvZiPq9l9QdeA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 85/85] drm/nouveau/dmem: missing mutex_lock in error path
Date:   Fri, 26 Jul 2019 09:39:35 -0400
Message-Id: <20190726133936.11177-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>

[ Upstream commit d304654bd79332ace9ac46b9a3d8de60acb15da3 ]

In nouveau_dmem_pages_alloc(), the drm->dmem->mutex is unlocked before
calling nouveau_dmem_chunk_alloc() as shown when CONFIG_PROVE_LOCKING
is enabled:

[ 1294.871933] =====================================
[ 1294.876656] WARNING: bad unlock balance detected!
[ 1294.881375] 5.2.0-rc3+ #5 Not tainted
[ 1294.885048] -------------------------------------
[ 1294.889773] test-malloc-vra/6299 is trying to release lock (&drm->dmem->mutex) at:
[ 1294.897482] [<ffffffffa01a220f>] nouveau_dmem_migrate_alloc_and_copy+0x79f/0xbf0 [nouveau]
[ 1294.905782] but there are no more locks to release!
[ 1294.910690]
[ 1294.910690] other info that might help us debug this:
[ 1294.917249] 1 lock held by test-malloc-vra/6299:
[ 1294.921881]  #0: 0000000016e10454 (&mm->mmap_sem#2){++++}, at: nouveau_svmm_bind+0x142/0x210 [nouveau]
[ 1294.931313]
[ 1294.931313] stack backtrace:
[ 1294.935702] CPU: 4 PID: 6299 Comm: test-malloc-vra Not tainted 5.2.0-rc3+ #5
[ 1294.942786] Hardware name: ASUS X299-A/PRIME X299-A, BIOS 1401 05/21/2018
[ 1294.949590] Call Trace:
[ 1294.952059]  dump_stack+0x7c/0xc0
[ 1294.955469]  ? nouveau_dmem_migrate_alloc_and_copy+0x79f/0xbf0 [nouveau]
[ 1294.962213]  print_unlock_imbalance_bug.cold.52+0xca/0xcf
[ 1294.967641]  lock_release+0x306/0x380
[ 1294.971383]  ? nouveau_dmem_migrate_alloc_and_copy+0x79f/0xbf0 [nouveau]
[ 1294.978089]  ? lock_downgrade+0x2d0/0x2d0
[ 1294.982121]  ? find_held_lock+0xac/0xd0
[ 1294.985979]  __mutex_unlock_slowpath+0x8f/0x3f0
[ 1294.990540]  ? wait_for_completion+0x230/0x230
[ 1294.995002]  ? rwlock_bug.part.2+0x60/0x60
[ 1294.999197]  nouveau_dmem_migrate_alloc_and_copy+0x79f/0xbf0 [nouveau]
[ 1295.005751]  ? page_mapping+0x98/0x110
[ 1295.009511]  migrate_vma+0xa74/0x1090
[ 1295.013186]  ? move_to_new_page+0x480/0x480
[ 1295.017400]  ? __kmalloc+0x153/0x300
[ 1295.021052]  ? nouveau_dmem_migrate_vma+0xd8/0x1e0 [nouveau]
[ 1295.026796]  nouveau_dmem_migrate_vma+0x157/0x1e0 [nouveau]
[ 1295.032466]  ? nouveau_dmem_init+0x490/0x490 [nouveau]
[ 1295.037612]  ? vmacache_find+0xc2/0x110
[ 1295.041537]  nouveau_svmm_bind+0x1b4/0x210 [nouveau]
[ 1295.046583]  ? nouveau_svm_fault+0x13e0/0x13e0 [nouveau]
[ 1295.051912]  drm_ioctl_kernel+0x14d/0x1a0
[ 1295.055930]  ? drm_setversion+0x330/0x330
[ 1295.059971]  drm_ioctl+0x308/0x530
[ 1295.063384]  ? drm_version+0x150/0x150
[ 1295.067153]  ? find_held_lock+0xac/0xd0
[ 1295.070996]  ? __pm_runtime_resume+0x3f/0xa0
[ 1295.075285]  ? mark_held_locks+0x29/0xa0
[ 1295.079230]  ? _raw_spin_unlock_irqrestore+0x3c/0x50
[ 1295.084232]  ? lockdep_hardirqs_on+0x17d/0x250
[ 1295.088768]  nouveau_drm_ioctl+0x9a/0x100 [nouveau]
[ 1295.093661]  do_vfs_ioctl+0x137/0x9a0
[ 1295.097341]  ? ioctl_preallocate+0x140/0x140
[ 1295.101623]  ? match_held_lock+0x1b/0x230
[ 1295.105646]  ? match_held_lock+0x1b/0x230
[ 1295.109660]  ? find_held_lock+0xac/0xd0
[ 1295.113512]  ? __do_page_fault+0x324/0x630
[ 1295.117617]  ? lock_downgrade+0x2d0/0x2d0
[ 1295.121648]  ? mark_held_locks+0x79/0xa0
[ 1295.125583]  ? handle_mm_fault+0x352/0x430
[ 1295.129687]  ksys_ioctl+0x60/0x90
[ 1295.133020]  ? mark_held_locks+0x29/0xa0
[ 1295.136964]  __x64_sys_ioctl+0x3d/0x50
[ 1295.140726]  do_syscall_64+0x68/0x250
[ 1295.144400]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1295.149465] RIP: 0033:0x7f1a3495809b
[ 1295.153053] Code: 0f 1e fa 48 8b 05 ed bd 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d bd bd 0c 00 f7 d8 64 89 01 48
[ 1295.171850] RSP: 002b:00007ffef7ed1358 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 1295.179451] RAX: ffffffffffffffda RBX: 00007ffef7ed1628 RCX: 00007f1a3495809b
[ 1295.186601] RDX: 00007ffef7ed13b0 RSI: 0000000040406449 RDI: 0000000000000004
[ 1295.193759] RBP: 00007ffef7ed13b0 R08: 0000000000000000 R09: 000000000157e770
[ 1295.200917] R10: 000000000151c010 R11: 0000000000000246 R12: 0000000040406449
[ 1295.208083] R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000

Reacquire the lock before continuing to the next page.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 40c47d6a7d78..745e197a4775 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -385,9 +385,10 @@ nouveau_dmem_pages_alloc(struct nouveau_drm *drm,
 			ret = nouveau_dmem_chunk_alloc(drm);
 			if (ret) {
 				if (c)
-					break;
+					return 0;
 				return ret;
 			}
+			mutex_lock(&drm->dmem->mutex);
 			continue;
 		}
 
-- 
2.20.1

