Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341DC33B0B0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 12:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhCOLKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 07:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhCOLJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 07:09:58 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A87F164E83;
        Mon, 15 Mar 2021 11:09:57 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lLl6h-001dZy-OX; Mon, 15 Mar 2021 11:09:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
        stable@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH][stable-5.4] KVM: arm64: Reject VM creation when the default IPA size is unsupported
Date:   Mon, 15 Mar 2021 11:09:52 +0000
Message-Id: <20210315110952.4136142-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, stable@vger.kernel.org, drjones@redhat.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7d717558dd5ef10d28866750d5c24ff892ea3778 upstream.

KVM/arm64 has forever used a 40bit default IPA space, partially
due to its 32bit heritage (where the only choice is 40bit).

However, there are implementations in the wild that have a *cough*
much smaller *cough* IPA space, which leads to a misprogramming of
VTCR_EL2, and a guest that is stuck on its first memory access
if userspace dares to ask for the default IPA setting (which most
VMMs do).

Instead, blundly reject the creation of such VM, as we can't
satisfy the requirements from userspace (with a one-off warning).
Also clarify the boot warning, and document that the VM creation
will fail when an unsupported IPA size is provided.

Although this is an ABI change, it doesn't really change much
for userspace:

- the guest couldn't run before this change, but no error was
  returned. At least userspace knows what is happening.

- a memory slot that was accepted because it did fit the default
  IPA space now doesn't even get a chance to be registered.

The other thing that is left doing is to convince userspace to
actually use the IPA space setting instead of relying on the
antiquated default.

Fixes: 233a7cb23531 ("kvm: arm64: Allow tuning the physical address size for VM")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20210311100016.3830038-2-maz@kernel.org
---
 Documentation/virt/kvm/api.txt |  3 +++
 arch/arm64/kvm/reset.c         | 11 ++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 7064efd3b5ea..fd22224853e5 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -172,6 +172,9 @@ is dependent on the CPU capability and the kernel configuration. The limit can
 be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the KVM_CHECK_EXTENSION
 ioctl() at run-time.
 
+Creation of the VM will fail if the requested IPA size (whether it is
+implicit or explicit) is unsupported on the host.
+
 Please note that configuring the IPA size does not affect the capability
 exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only affects
 size of the address translated by the stage2 level (guest physical to
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 784d485218ca..a3105ae464be 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -378,10 +378,10 @@ void kvm_set_ipa_limit(void)
 		pr_info("kvm: Limiting the IPA size due to kernel %s Address limit\n",
 			(va_max < pa_max) ? "Virtual" : "Physical");
 
-	WARN(ipa_max < KVM_PHYS_SHIFT,
-	     "KVM IPA limit (%d bit) is smaller than default size\n", ipa_max);
 	kvm_ipa_limit = ipa_max;
-	kvm_info("IPA Size Limit: %dbits\n", kvm_ipa_limit);
+	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
+		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
+		  " (Reduced IPA size, limited VM/VMM compatibility)" : ""));
 }
 
 /*
@@ -408,6 +408,11 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 			return -EINVAL;
 	} else {
 		phys_shift = KVM_PHYS_SHIFT;
+		if (phys_shift > kvm_ipa_limit) {
+			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
+				     current->comm);
+			return -EINVAL;
+		}
 	}
 
 	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;
-- 
2.29.2

