Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAABC11E23
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfEBP0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbfEBP0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:26:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BD7620B7C;
        Thu,  2 May 2019 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810778;
        bh=eQoMAiMPgAa7Jk+mLLcjetzGFfCz+dZ6eXoOnbLmNJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LitZvNjxcDw4sBxaisMMvg4g87BLBCGLGuLhYKFbtDu70dUZgCaxR8ZdRp4LdzGiN
         AZdwNbmlt6ZYfoF4ID44oOeqoshf4ADbZ5fIV6/mpQG4vuJCKaMIXGEkejbkMi3PHg
         z4MYuPCbHs21AAW7UvkoJqdSmOTLfkfjJnBGNWyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 26/72] KVM: arm/arm64: vgic-its: Take the srcu lock when parsing the memslots
Date:   Thu,  2 May 2019 17:20:48 +0200
Message-Id: <20190502143335.509390622@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7494cec6cb3ba7385a6a223b81906384f15aae34 ]

Calling kvm_is_visible_gfn() implies that we're parsing the memslots,
and doing this without the srcu lock is frown upon:

[12704.164532] =============================
[12704.164544] WARNING: suspicious RCU usage
[12704.164560] 5.1.0-rc1-00008-g600025238f51-dirty #16 Tainted: G        W
[12704.164573] -----------------------------
[12704.164589] ./include/linux/kvm_host.h:605 suspicious rcu_dereference_check() usage!
[12704.164602] other info that might help us debug this:
[12704.164616] rcu_scheduler_active = 2, debug_locks = 1
[12704.164631] 6 locks held by qemu-system-aar/13968:
[12704.164644]  #0: 000000007ebdae4f (&kvm->lock){+.+.}, at: vgic_its_set_attr+0x244/0x3a0
[12704.164691]  #1: 000000007d751022 (&its->its_lock){+.+.}, at: vgic_its_set_attr+0x250/0x3a0
[12704.164726]  #2: 00000000219d2706 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164761]  #3: 00000000a760aecd (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164794]  #4: 000000000ef8e31d (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164827]  #5: 000000007a872093 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164861] stack backtrace:
[12704.164878] CPU: 2 PID: 13968 Comm: qemu-system-aar Tainted: G        W         5.1.0-rc1-00008-g600025238f51-dirty #16
[12704.164887] Hardware name: rockchip evb_rk3399/evb_rk3399, BIOS 2019.04-rc3-00124-g2feec69fb1 03/15/2019
[12704.164896] Call trace:
[12704.164910]  dump_backtrace+0x0/0x138
[12704.164920]  show_stack+0x24/0x30
[12704.164934]  dump_stack+0xbc/0x104
[12704.164946]  lockdep_rcu_suspicious+0xcc/0x110
[12704.164958]  gfn_to_memslot+0x174/0x190
[12704.164969]  kvm_is_visible_gfn+0x28/0x70
[12704.164980]  vgic_its_check_id.isra.0+0xec/0x1e8
[12704.164991]  vgic_its_save_tables_v0+0x1ac/0x330
[12704.165001]  vgic_its_set_attr+0x298/0x3a0
[12704.165012]  kvm_device_ioctl_attr+0x9c/0xd8
[12704.165022]  kvm_device_ioctl+0x8c/0xf8
[12704.165035]  do_vfs_ioctl+0xc8/0x960
[12704.165045]  ksys_ioctl+0x8c/0xa0
[12704.165055]  __arm64_sys_ioctl+0x28/0x38
[12704.165067]  el0_svc_common+0xd8/0x138
[12704.165078]  el0_svc_handler+0x38/0x78
[12704.165089]  el0_svc+0x8/0xc

Make sure the lock is taken when doing this.

Fixes: bf308242ab98 ("KVM: arm/arm64: VGIC/ITS: protect kvm_read_guest() calls with SRCU lock")
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index c1071ed888e2..621bb004067e 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -760,8 +760,9 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
 	int esz = GITS_BASER_ENTRY_SIZE(baser);
-	int index;
+	int index, idx;
 	gfn_t gfn;
+	bool ret;
 
 	switch (type) {
 	case GITS_BASER_TYPE_DEVICE:
@@ -788,7 +789,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 		if (eaddr)
 			*eaddr = addr;
-		return kvm_is_visible_gfn(its->dev->kvm, gfn);
+
+		goto out;
 	}
 
 	/* calculate and check the index into the 1st level */
@@ -822,7 +824,12 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 	if (eaddr)
 		*eaddr = indirect_ptr;
-	return kvm_is_visible_gfn(its->dev->kvm, gfn);
+
+out:
+	idx = srcu_read_lock(&its->dev->kvm->srcu);
+	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
+	srcu_read_unlock(&its->dev->kvm->srcu, idx);
+	return ret;
 }
 
 static int vgic_its_alloc_collection(struct vgic_its *its,
-- 
2.19.1



