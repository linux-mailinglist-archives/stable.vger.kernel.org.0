Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589CE14E208
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbgA3StA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731649AbgA3Ss7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACB7F2082E;
        Thu, 30 Jan 2020 18:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410139;
        bh=s2rmcFHlg0bundURMOPl/pYu5ppo6GpvVpIgo6Gqktk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uz044B4Av4Sv8nvgZDoJ6ucaMPBqGC6j519l3rVKjkkQ5gg7TyOBWT1mZg0JSZPyW
         WZUmV4HKxRUuo4H9i3RXDzUxOOEH6X0QAuaaJ6eZzm1D6Vq5Gjbo3Wh5ZzR8daZ7DD
         0c1J66fRp0fYph4B0lKbA2Zp9Pd7AP6CRGsYIAtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.19 55/55] KVM: arm64: Write arch.mdcr_el2 changes since last vcpu_load on VHE
Date:   Thu, 30 Jan 2020 19:39:36 +0100
Message-Id: <20200130183618.321089628@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

commit 4942dc6638b07b5326b6d2faa142635c559e7cd5 upstream.

On VHE systems arch.mdcr_el2 is written to mdcr_el2 at vcpu_load time to
set options for self-hosted debug and the performance monitors
extension.

Unfortunately the value of arch.mdcr_el2 is not calculated until
kvm_arm_setup_debug() in the run loop after the vcpu has been loaded.
This means that the initial brief iterations of the run loop use a zero
value of mdcr_el2 - until the vcpu is preempted. This also results in a
delay between changes to vcpu->guest_debug taking effect.

Fix this by writing to mdcr_el2 in kvm_arm_setup_debug() on VHE systems
when a change to arch.mdcr_el2 has been detected.

Fixes: d5a21bcc2995 ("KVM: arm64: Move common VHE/non-VHE trap config in separate functions")
Cc: <stable@vger.kernel.org> # 4.17.x-
Suggested-by: James Morse <james.morse@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/debug.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -112,7 +112,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
 	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
-	unsigned long mdscr;
+	unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
 
 	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
 
@@ -208,6 +208,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 
+	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
+	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
+		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+
 	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }


