Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C23933BC54
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhCOOY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238175AbhCOOWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:22:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08B7A64F43;
        Mon, 15 Mar 2021 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818174;
        bh=DpkIbpQEfZ7SwN5Ce3lKP8CqAMzPfPB5FdqZBWagldw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2WYHg4tzOJtuOdxU8AlUeJx6oNdoWtEoTfREIB/beakT5pTjZ3Bs89y6qhMh9AHE
         vgOxPvhYE6vVXLLleBbD7WUROR0hyatOFZKjM88AmrMwDg7/bp+ctX7QQ7bJIYXMFG
         uea3gjtXnkjf8/tKVN7An5pISfuc6JWbEEmK52RU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 5.10 281/290] KVM: arm64: Reject VM creation when the default IPA size is unsupported
Date:   Mon, 15 Mar 2021 15:22:31 +0100
Message-Id: <20210315135551.529410353@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135551.391322899@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135551.391322899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Marc Zyngier <maz@kernel.org>

commit 7d717558dd5ef10d28866750d5c24ff892ea3778 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/api.rst |    3 +++
 arch/arm64/kvm/reset.c         |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -182,6 +182,9 @@ is dependent on the CPU capability and t
 be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the KVM_CHECK_EXTENSION
 ioctl() at run-time.
 
+Creation of the VM will fail if the requested IPA size (whether it is
+implicit or explicit) is unsupported on the host.
+
 Please note that configuring the IPA size does not affect the capability
 exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only affects
 size of the address translated by the stage2 level (guest physical to
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -373,10 +373,9 @@ int kvm_set_ipa_limit(void)
 	}
 
 	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
-	WARN(kvm_ipa_limit < KVM_PHYS_SHIFT,
-	     "KVM IPA Size Limit (%d bits) is smaller than default size\n",
-	     kvm_ipa_limit);
-	kvm_info("IPA Size Limit: %d bits\n", kvm_ipa_limit);
+	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
+		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
+		  " (Reduced IPA size, limited VM/VMM compatibility)" : ""));
 
 	return 0;
 }
@@ -405,6 +404,11 @@ int kvm_arm_setup_stage2(struct kvm *kvm
 			return -EINVAL;
 	} else {
 		phys_shift = KVM_PHYS_SHIFT;
+		if (phys_shift > kvm_ipa_limit) {
+			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
+				     current->comm);
+			return -EINVAL;
+		}
 	}
 
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);


