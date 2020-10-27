Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E768D29C48B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900999AbgJ0OSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900977AbgJ0OR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:17:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4DC7206FA;
        Tue, 27 Oct 2020 14:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808276;
        bh=cANSAbQCCWxP0fO4Z+68L2ftTLnC/Ey2RAly1gtw1Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qo2s/7gQbh8ry13+EHWaPnEFFbedxX//4GlOwbfU9JdHFkGsBRBVGKcT9q9BEjNUh
         e9nkyk6eE3nclFtQpKW/2fcuGqzehHnzCO5o8YcV/oQfwhYSB4RqBuHkVeqwfyjPhr
         fdFub4R7VqR/9FjS4R9jQ3xTpnBKdev4mBNxNI/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 030/264] KVM: SVM: Initialize prev_ga_tag before use
Date:   Tue, 27 Oct 2020 14:51:28 +0100
Message-Id: <20201027135432.073078123@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit f6426ab9c957e97418ac5b0466538792767b1738 upstream.

The function amd_ir_set_vcpu_affinity makes use of the parameter struct
amd_iommu_pi_data.prev_ga_tag to determine if it should delete struct
amd_iommu_pi_data from a list when not running in AVIC mode.

However, prev_ga_tag is initialized only when AVIC is enabled. The non-zero
uninitialized value can cause unintended code path, which ends up making
use of the struct vcpu_svm.ir_list and ir_list_lock without being
initialized (since they are intended only for the AVIC case).

This triggers NULL pointer dereference bug in the function vm_ir_list_del
with the following call trace:

    svm_update_pi_irte+0x3c2/0x550 [kvm_amd]
    ? proc_create_single_data+0x41/0x50
    kvm_arch_irq_bypass_add_producer+0x40/0x60 [kvm]
    __connect+0x5f/0xb0 [irqbypass]
    irq_bypass_register_producer+0xf8/0x120 [irqbypass]
    vfio_msi_set_vector_signal+0x1de/0x2d0 [vfio_pci]
    vfio_msi_set_block+0x77/0xe0 [vfio_pci]
    vfio_pci_set_msi_trigger+0x25c/0x2f0 [vfio_pci]
    vfio_pci_set_irqs_ioctl+0x88/0xb0 [vfio_pci]
    vfio_pci_ioctl+0x2ea/0xed0 [vfio_pci]
    ? alloc_file_pseudo+0xa5/0x100
    vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
    ? vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
    __x64_sys_ioctl+0x96/0xd0
    do_syscall_64+0x37/0x80
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Therefore, initialize prev_ga_tag to zero before use. This should be safe
because ga_tag value 0 is invalid (see function avic_vm_init).

Fixes: dfa20099e26e ("KVM: SVM: Refactor AVIC vcpu initialization into avic_init_vcpu()")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-Id: <20201003232707.4662-1-suravee.suthikulpanit@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5380,6 +5380,7 @@ static int svm_update_pi_irte(struct kvm
 			 * - Tell IOMMU to use legacy mode for this interrupt.
 			 * - Retrieve ga_tag of prior interrupt remapping data.
 			 */
+			pi.prev_ga_tag = 0;
 			pi.is_guest_mode = false;
 			ret = irq_set_vcpu_affinity(host_irq, &pi);
 


