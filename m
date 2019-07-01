Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A9C1F13B
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbfEOLWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731441AbfEOLWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:22:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE44A20843;
        Wed, 15 May 2019 11:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919343;
        bh=6yewCPOiOdHUs0aQTSaM5h9YTqiRcgLS4eo6foYu5Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zr1QImUvtVe1HHFmCVpAcfe/QzvkI9z+Dl/nPI5ALdbSkfxtQwRjJrrflk95l4sW3
         RRoVv830u5A/ngtjW/zTF9aCuUWZLFBKihqReDQFC9TrUps7KixRMK/EF9rNr7urhj
         b1V0JLMtult+dUPzputSumj+QzUJnlLCAirChUsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/113] KVM: fix spectrev1 gadgets
Date:   Wed, 15 May 2019 12:55:29 +0200
Message-Id: <20190515090656.509320646@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 3692de84c4201..d2f5aa220355f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -133,6 +133,7 @@ static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		if (offset <= max_apic_id) {
 			u8 cluster_size = min(max_apic_id - offset + 1, 16U);
 
+			offset = array_index_nospec(offset, map->max_apic_id + 1);
 			*cluster = &map->phys_map[offset];
 			*mask = dest_id & (0xffff >> (16 - cluster_size));
 		} else {
@@ -896,7 +897,8 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
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
index 23c242a7ac524..30efb36638923 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -28,6 +28,7 @@
 #include <linux/irqbypass.h>
 #include <linux/swait.h>
 #include <linux/refcount.h>
+#include <linux/nospec.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -491,10 +492,10 @@ static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
 
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
@@ -578,6 +579,7 @@ void kvm_put_kvm(struct kvm *kvm);
 
 static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
 {
+	as_id = array_index_nospec(as_id, KVM_ADDRESS_SPACE_NUM);
 	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
 			lockdep_is_held(&kvm->slots_lock) ||
 			!refcount_read(&kvm->users_count));
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index b1286c4e07122..0bd0683640bdf 100644
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
index 6a79df88b5469..e909d9907b506 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2887,12 +2887,14 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
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
 
@@ -2907,7 +2909,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	dev->kvm = kvm;
 
 	mutex_lock(&kvm->lock);
-	ret = ops->create(dev, cd->type);
+	ret = ops->create(dev, type);
 	if (ret < 0) {
 		mutex_unlock(&kvm->lock);
 		kfree(dev);
-- 
2.20.1



