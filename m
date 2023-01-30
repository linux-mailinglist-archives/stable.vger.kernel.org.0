Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1EA681095
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbjA3OFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237064AbjA3OEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A3830F7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FF2B61032
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97513C433EF;
        Mon, 30 Jan 2023 14:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087488;
        bh=ncb5Oym5fMqNbpP4HNgb57+Y06GfPFAEoWeCU/qiN40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fj2xK0ToYtXBcX99hhAI6uL/1q8SDyrVhsMqbOx4f25sFAD7LRGnSdAl++cGihkdZ
         KSUsIwpb87LA7EwqTgvrcWXtpjtZbIuaN7U1p2tsCkFGNHJ/RF+6bhXW68U8t7I54H
         nzSfxJazeQ7s04wOP61EO2AYTujki1XNtpM4xM+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 224/313] KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation
Date:   Mon, 30 Jan 2023 14:50:59 +0100
Message-Id: <20230130134347.146693528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit ef3691683d7bfd0a2acf48812e4ffe894f10bfa8 upstream.

To save the vgic LPI pending state with GICv4.1, the VPEs must all be
unmapped from the ITSs so that the sGIC caches can be flushed.
The opposite is done once the state is saved.

This is all done by using the activate/deactivate irqdomain callbacks
directly from the vgic code. Crutially, this is done without holding
the irqdesc lock for the interrupts that represent the VPE. And these
callbacks are changing the state of the irqdesc. What could possibly
go wrong?

If a doorbell fires while we are messing with the irqdesc state,
it will acquire the lock and change the interrupt state concurrently.
Since we don't hole the lock, curruption occurs in on the interrupt
state. Oh well.

While acquiring the lock would fix this (and this was Shanker's
initial approach), this is still a layering violation we could do
without. A better approach is actually to free the VPE interrupt,
do what we have to do, and re-request it.

It is more work, but this usually happens only once in the lifetime
of the VM and we don't really care about this sort of overhead.

Fixes: f66b7b151e00 ("KVM: arm64: GICv4.1: Try to save VLPI state in save_pending_tables")
Reported-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230118022348.4137094-1-sdonthineni@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c |   25 +++++++++++--------------
 arch/arm64/kvm/vgic/vgic-v4.c |    8 ++++++--
 arch/arm64/kvm/vgic/vgic.h    |    1 +
 3 files changed, 18 insertions(+), 16 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -350,26 +350,23 @@ retry:
  * The deactivation of the doorbell interrupt will trigger the
  * unmapping of the associated vPE.
  */
-static void unmap_all_vpes(struct vgic_dist *dist)
+static void unmap_all_vpes(struct kvm *kvm)
 {
-	struct irq_desc *desc;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	int i;
 
-	for (i = 0; i < dist->its_vm.nr_vpes; i++) {
-		desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
-		irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
-	}
+	for (i = 0; i < dist->its_vm.nr_vpes; i++)
+		free_irq(dist->its_vm.vpes[i]->irq, kvm_get_vcpu(kvm, i));
 }
 
-static void map_all_vpes(struct vgic_dist *dist)
+static void map_all_vpes(struct kvm *kvm)
 {
-	struct irq_desc *desc;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	int i;
 
-	for (i = 0; i < dist->its_vm.nr_vpes; i++) {
-		desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
-		irq_domain_activate_irq(irq_desc_get_irq_data(desc), false);
-	}
+	for (i = 0; i < dist->its_vm.nr_vpes; i++)
+		WARN_ON(vgic_v4_request_vpe_irq(kvm_get_vcpu(kvm, i),
+						dist->its_vm.vpes[i]->irq));
 }
 
 /**
@@ -394,7 +391,7 @@ int vgic_v3_save_pending_tables(struct k
 	 * and enabling of the doorbells have already been done.
 	 */
 	if (kvm_vgic_global_state.has_gicv4_1) {
-		unmap_all_vpes(dist);
+		unmap_all_vpes(kvm);
 		vlpi_avail = true;
 	}
 
@@ -444,7 +441,7 @@ int vgic_v3_save_pending_tables(struct k
 
 out:
 	if (vlpi_avail)
-		map_all_vpes(dist);
+		map_all_vpes(kvm);
 
 	return ret;
 }
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -222,6 +222,11 @@ void vgic_v4_get_vlpi_state(struct vgic_
 	*val = !!(*ptr & mask);
 }
 
+int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq)
+{
+	return request_irq(irq, vgic_v4_doorbell_handler, 0, "vcpu", vcpu);
+}
+
 /**
  * vgic_v4_init - Initialize the GICv4 data structures
  * @kvm:	Pointer to the VM being initialized
@@ -283,8 +288,7 @@ int vgic_v4_init(struct kvm *kvm)
 			irq_flags &= ~IRQ_NOAUTOEN;
 		irq_set_status_flags(irq, irq_flags);
 
-		ret = request_irq(irq, vgic_v4_doorbell_handler,
-				  0, "vcpu", vcpu);
+		ret = vgic_v4_request_vpe_irq(vcpu, irq);
 		if (ret) {
 			kvm_err("failed to allocate vcpu IRQ%d\n", irq);
 			/*
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -331,5 +331,6 @@ int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
 void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val);
+int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq);
 
 #endif


