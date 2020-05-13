Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213431D0DF0
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388333AbgEMJzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388318AbgEMJzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:55:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DF4120575;
        Wed, 13 May 2020 09:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363753;
        bh=SphKFXtyq2bYK1PdVCX7qx6+wpQEnI7wpi1YanHsKVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4OAPbPfJ6b+yIKuH8Hyljid7yQXIJLknW2yFe9Fz+B+hvYuqBpl2BRfVincHUn7q
         0g5pBCLukz5sQQhE5upseVk6z/eQ6ObZbGx42RA19jY0+W8cbGetJCpdX+YYYGT1DV
         +9h3Btq5NAh09J8d26yLPp6JpjTRxQYDfwXHOV7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.6 073/118] KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER
Date:   Wed, 13 May 2020 11:44:52 +0200
Message-Id: <20200513094424.094701745@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
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
@@ -368,7 +368,7 @@ static void vgic_mmio_change_active(stru
 static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
 {
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid > VGIC_NR_PRIVATE_IRQS)
+	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_halt_guest(vcpu->kvm);
 }
 
@@ -376,7 +376,7 @@ static void vgic_change_active_prepare(s
 static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
 {
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid > VGIC_NR_PRIVATE_IRQS)
+	    intid >= VGIC_NR_PRIVATE_IRQS)
 		kvm_arm_resume_guest(vcpu->kvm);
 }
 


