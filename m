Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1EE26F235
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbgIRCGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727713AbgIRCGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18D9123888;
        Fri, 18 Sep 2020 02:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394767;
        bh=h0sytWbdEGOEgVs+icjGQEMOPOER/gMbDxTDVREQRBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leNX6JZ25rK4BoQ7ueO7xXl2Z75kSNlTYcHC90p9BhOV3WIJhqLLvtTORhyClBPp4
         AwIFJldI71c26drUcsTHLPXwERz6HmLYnAz41cDbUnNO3utme5BuBMRKxV52aFjLMo
         l8lKNxbzMkIooF/CheJ3RMUnxLjL5MDQd3sFwdo4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 242/330] KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu destroy
Date:   Thu, 17 Sep 2020 21:59:42 -0400
Message-Id: <20200918020110.2063155-242-sashal@kernel.org>
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

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit 969ce8b5260d8ec01e6f1949d2927a86419663ce ]

It's likely that the vcpu fails to handle all virtual interrupts if
userspace decides to destroy it, leaving the pending ones stay in the
ap_list. If the un-handled one is a LPI, its vgic_irq structure will
be eventually leaked because of an extra refcount increment in
vgic_queue_irq_unlock().

This was detected by kmemleak on almost every guest destroy, the
backtrace is as follows:

unreferenced object 0xffff80725aed5500 (size 128):
comm "CPU 5/KVM", pid 40711, jiffies 4298024754 (age 166366.512s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 08 01 a9 73 6d 80 ff ff ...........sm...
c8 61 ee a9 00 20 ff ff 28 1e 55 81 6c 80 ff ff .a... ..(.U.l...
backtrace:
[<000000004bcaa122>] kmem_cache_alloc_trace+0x2dc/0x418
[<0000000069c7dabb>] vgic_add_lpi+0x88/0x418
[<00000000bfefd5c5>] vgic_its_cmd_handle_mapi+0x4dc/0x588
[<00000000cf993975>] vgic_its_process_commands.part.5+0x484/0x1198
[<000000004bd3f8e3>] vgic_its_process_commands+0x50/0x80
[<00000000b9a65b2b>] vgic_mmio_write_its_cwriter+0xac/0x108
[<0000000009641ebb>] dispatch_mmio_write+0xd0/0x188
[<000000008f79d288>] __kvm_io_bus_write+0x134/0x240
[<00000000882f39ac>] kvm_io_bus_write+0xe0/0x150
[<0000000078197602>] io_mem_abort+0x484/0x7b8
[<0000000060954e3c>] kvm_handle_guest_abort+0x4cc/0xa58
[<00000000e0d0cd65>] handle_exit+0x24c/0x770
[<00000000b44a7fad>] kvm_arch_vcpu_ioctl_run+0x460/0x1988
[<0000000025fb897c>] kvm_vcpu_ioctl+0x4f8/0xee0
[<000000003271e317>] do_vfs_ioctl+0x160/0xcd8
[<00000000e7f39607>] ksys_ioctl+0x98/0xd8

Fix it by retiring all pending LPIs in the ap_list on the destroy path.

p.s. I can also reproduce it on a normal guest shutdown. It is because
userspace still send LPIs to vcpu (through KVM_SIGNAL_MSI ioctl) while
the guest is being shutdown and unable to handle it. A little strange
though and haven't dig further...

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
[maz: moved the distributor deallocation down to avoid an UAF splat]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200414030349.625-2-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-init.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 6d85c6d894c39..6899101538890 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -358,6 +358,12 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
+	/*
+	 * Retire all pending LPIs on this vcpu anyway as we're
+	 * going to destroy it.
+	 */
+	vgic_flush_pending_lpis(vcpu);
+
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
 }
 
@@ -369,10 +375,10 @@ static void __kvm_vgic_destroy(struct kvm *kvm)
 
 	vgic_debug_destroy(kvm);
 
-	kvm_vgic_dist_destroy(kvm);
-
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_destroy(vcpu);
+
+	kvm_vgic_dist_destroy(kvm);
 }
 
 void kvm_vgic_destroy(struct kvm *kvm)
-- 
2.25.1

