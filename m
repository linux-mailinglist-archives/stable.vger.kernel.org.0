Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6386B1D0EB9
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733292AbgEMJtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733282AbgEMJtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF1B206D6;
        Wed, 13 May 2020 09:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363385;
        bh=DRnfapKAHniPBH4Zid0FNAbb9Jm5YcXFpjFxVu5RRS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2AXu/74cl42d1kcA+raWguqEQdD2ABCx/QVfANaLKNC+2eYmEpS3A1oa9lmbBwbY
         l0OUmQGzFfiQG6qSyRsaag9vuCH5IgrB7MWyda8qajjhQi9zu9AxeL1saSnG67ZiMh
         /74IFJ/WX00wq4pi7lUgldAcEx8A/IKwUeVMOD9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 53/90] KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER
Date:   Wed, 13 May 2020 11:44:49 +0200
Message-Id: <20200513094414.397113042@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 1c32ca5dc6d00012f0c964e5fdd7042fcc71efb1 upstream.

When deciding whether a guest has to be stopped we check whether this
is a private interrupt or not. Unfortunately, there's an off-by-one bug
here, and we fail to recognize a whole range of interrupts as being
global (GICv2 SPIs 32-63).

Fix the condition from > to be >=.

Cc: stable@vger.kernel.org
Fixes: abd7229626b93 ("KVM: arm/arm64: Simplify active_change_prepare and plug race")
Reported-by: André Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/vgic/vgic-mmio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -389,7 +389,7 @@ static void vgic_mmio_change_active(stru
 static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 {
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid > VGIC_NR_PRIVATE_IRQS)
+	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_halt_guest(vcpu->kvm);
 }
 
@@ -397,7 +397,7 @@ static void vgic_change_active_prepare(s
 static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
 {
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid > VGIC_NR_PRIVATE_IRQS)
+	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_resume_guest(vcpu->kvm);
 }
 


