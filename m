Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D80415CA9
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfEGGFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727419AbfEGFeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:34:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7329C21479;
        Tue,  7 May 2019 05:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207245;
        bh=MNlaOp58lREvSwWjRtLUes/DZFyGYNHZNIS4RhI6RfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMDbeNzsAWo2b4TyP0WzAitrS261kOLPkPe9WprGS/oct3LG/GzT7WF5suug6irS6
         /q+YNsl4LtEBPVHrgzEpJ5ieH644jeTgLDG7v0F95v/P33h1smPogblrC7KBHQgvyn
         e03Fw9IKFRx0UpQCZLF80Ce+Z0wSPmHPbhMLYEqA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 47/99] KVM: fix spectrev1 gadgets
Date:   Tue,  7 May 2019 01:31:41 -0400
Message-Id: <20190507053235.29900-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 1d487e9bf8ba66a7174c56a0029c54b1eca8f99c ]

These were found with smatch, and then generalized when applicable.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c     |  4 +++-
 include/linux/kvm_host.h | 10 ++++++----
 virt/kvm/irqchip.c       |  5 +++--
 virt/kvm/kvm_main.c      |  6 ++++--
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4b6c2da7265c..e196e187d2f1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -138,6 +138,7 @@ static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		if (offset <= max_apic_id) {
 			u8 cluster_size = min(max_apic_id - offset + 1, 16U);
 
+			offset = array_index_nospec(offset, map->max_apic_id + 1);
 			*cluster = &map->phys_map[offset];
 			*mask = dest_id & (0xffff >> (16 - cluster_size));
 		} else {
@@ -900,7 +901,8 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 		if (irq->dest_id > map->max_apic_id) {
 			*bitmap = 0;
 		} else {
-			*dst = &map->phys_map[irq->dest_id];
+			u32 dest_id = array_index_nospec(irq->dest_id, map->max_apic_id + 1);
+			*dst = &map->phys_map[dest_id];
 			*bitmap = 1;
 		}
 		return true;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cf761ff58224..e41503b2c5a1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -28,6 +28,7 @@
 #include <linux/irqbypass.h>
 #include <linux/swait.h>
 #include <linux/refcount.h>
+#include <linux/nospec.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -492,10 +493,10 @@ static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
 
 static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 {
-	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu, in case
-	 * the caller has read kvm->online_vcpus before (as is the case
-	 * for kvm_for_each_vcpu, for example).
-	 */
+	int num_vcpus = atomic_read(&kvm->online_vcpus);
+	i = array_index_nospec(i, num_vcpus);
+
+	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu.  */
 	smp_rmb();
 	return kvm->vcpus[i];
 }
@@ -579,6 +580,7 @@ void kvm_put_kvm(struct kvm *kvm);
 
 static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
 {
+	as_id = array_index_nospec(as_id, KVM_ADDRESS_SPACE_NUM);
 	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
 			lockdep_is_held(&kvm->slots_lock) ||
 			!refcount_read(&kvm->users_count));
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index b1286c4e0712..0bd0683640bd 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -144,18 +144,19 @@ static int setup_routing_entry(struct kvm *kvm,
 {
 	struct kvm_kernel_irq_routing_entry *ei;
 	int r;
+	u32 gsi = array_index_nospec(ue->gsi, KVM_MAX_IRQ_ROUTES);
 
 	/*
 	 * Do not allow GSI to be mapped to the same irqchip more than once.
 	 * Allow only one to one mapping between GSI and non-irqchip routing.
 	 */
-	hlist_for_each_entry(ei, &rt->map[ue->gsi], link)
+	hlist_for_each_entry(ei, &rt->map[gsi], link)
 		if (ei->type != KVM_IRQ_ROUTING_IRQCHIP ||
 		    ue->type != KVM_IRQ_ROUTING_IRQCHIP ||
 		    ue->u.irqchip.irqchip == ei->irqchip.irqchip)
 			return -EINVAL;
 
-	e->gsi = ue->gsi;
+	e->gsi = gsi;
 	e->type = ue->type;
 	r = kvm_set_routing_entry(kvm, e, ue);
 	if (r)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b4f2d892a1d3..ff68b07e94e9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2974,12 +2974,14 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	struct kvm_device_ops *ops = NULL;
 	struct kvm_device *dev;
 	bool test = cd->flags & KVM_CREATE_DEVICE_TEST;
+	int type;
 	int ret;
 
 	if (cd->type >= ARRAY_SIZE(kvm_device_ops_table))
 		return -ENODEV;
 
-	ops = kvm_device_ops_table[cd->type];
+	type = array_index_nospec(cd->type, ARRAY_SIZE(kvm_device_ops_table));
+	ops = kvm_device_ops_table[type];
 	if (ops == NULL)
 		return -ENODEV;
 
@@ -2994,7 +2996,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	dev->kvm = kvm;
 
 	mutex_lock(&kvm->lock);
-	ret = ops->create(dev, cd->type);
+	ret = ops->create(dev, type);
 	if (ret < 0) {
 		mutex_unlock(&kvm->lock);
 		kfree(dev);
-- 
2.20.1

