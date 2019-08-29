Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96AABA24EA
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbfH2SPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729415AbfH2SPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABFF823428;
        Thu, 29 Aug 2019 18:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102543;
        bh=Vw944yrMgVSeIH8DQiVR4dOFQUZk+j5F2HI7fbQSz2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5ToN+LGDwB8llkfTnyyAordmuiWTCW8NExEiA6OtuXHdR+60XdoNFMgpYUWardfa
         CJG/OdjUgcjE8VtagFo4fwIuegDOQHP7F0+C9iOvY8K6tDPl+eu+U652Kx+85UsoVf
         jgQWy4vWahmjgHKdz6qh6X2HwHYfo3OwDoSC1MWE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.2 76/76] KVM: arm/arm64: VGIC: Properly initialise private IRQ affinity
Date:   Thu, 29 Aug 2019 14:13:11 -0400
Message-Id: <20190829181311.7562-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 2e16f3e926ed48373c98edea85c6ad0ef69425d1 ]

At the moment we initialise the target *mask* of a virtual IRQ to the
VCPU it belongs to, even though this mask is only defined for GICv2 and
quickly runs out of bits for many GICv3 guests.
This behaviour triggers an UBSAN complaint for more than 32 VCPUs:
------
[ 5659.462377] UBSAN: Undefined behaviour in virt/kvm/arm/vgic/vgic-init.c:223:21
[ 5659.471689] shift exponent 32 is too large for 32-bit type 'unsigned int'
------
Also for GICv3 guests the reporting of TARGET in the "vgic-state" debugfs
dump is wrong, due to this very same problem.

Because there is no requirement to create the VGIC device before the
VCPUs (and QEMU actually does it the other way round), we can't safely
initialise mpidr or targets in kvm_vgic_vcpu_init(). But since we touch
every private IRQ for each VCPU anyway later (in vgic_init()), we can
just move the initialisation of those fields into there, where we
definitely know the VGIC type.

On the way make sure we really have either a VGICv2 or a VGICv3 device,
since the existing code is just checking for "VGICv3 or not", silently
ignoring the uninitialised case.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reported-by: Dave Martin <dave.martin@arm.com>
Tested-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-init.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index bdbc297d06fb4..e621b5d45b278 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -8,6 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
@@ -164,12 +165,18 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu0;
 		kref_init(&irq->refcount);
-		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+		switch (dist->vgic_model) {
+		case KVM_DEV_TYPE_ARM_VGIC_V2:
 			irq->targets = 0;
 			irq->group = 0;
-		} else {
+			break;
+		case KVM_DEV_TYPE_ARM_VGIC_V3:
 			irq->mpidr = 0;
 			irq->group = 1;
+			break;
+		default:
+			kfree(dist->spis);
+			return -EINVAL;
 		}
 	}
 	return 0;
@@ -209,7 +216,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		irq->intid = i;
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu;
-		irq->targets = 1U << vcpu->vcpu_id;
 		kref_init(&irq->refcount);
 		if (vgic_irq_is_sgi(i)) {
 			/* SGIs */
@@ -219,11 +225,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 			/* PPIs */
 			irq->config = VGIC_CONFIG_LEVEL;
 		}
-
-		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
-			irq->group = 1;
-		else
-			irq->group = 0;
 	}
 
 	if (!irqchip_in_kernel(vcpu->kvm))
@@ -286,10 +287,19 @@ int vgic_init(struct kvm *kvm)
 
 		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
 			struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
-			if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+			switch (dist->vgic_model) {
+			case KVM_DEV_TYPE_ARM_VGIC_V3:
 				irq->group = 1;
-			else
+				irq->mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+				break;
+			case KVM_DEV_TYPE_ARM_VGIC_V2:
 				irq->group = 0;
+				irq->targets = 1U << idx;
+				break;
+			default:
+				ret = -EINVAL;
+				goto out;
+			}
 		}
 	}
 
-- 
2.20.1

