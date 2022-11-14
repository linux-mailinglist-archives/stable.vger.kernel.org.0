Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E349E628036
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237643AbiKNNEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237729AbiKNNEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBEC27CFA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 02554CE0FF1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEC3C433D6;
        Mon, 14 Nov 2022 13:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431036;
        bh=g8AmWc3x8GdsNAoL2ndJWhAd/uIhGZ23jS+yGaWwjPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddScezY10Ngx0TRmamnZT54RQU96zPqZNFuDlFENpjBXgfBqLBX5wratCLZ2YpiLT
         lX6gRGc4VtnD3uLblm9s+1iFeyLKunbNABFbEXPtM3JV9ZszvOt4dG/UUlwFxuAV7/
         kcuKRtTht3Hn0qIIhVF8PiY4qLka+2S9TLHPWlkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Hartmayer <mhartmay@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 046/190] KVM: s390: pv: dont allow userspace to set the clock under PV
Date:   Mon, 14 Nov 2022 13:44:30 +0100
Message-Id: <20221114124500.819087277@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Nico Boehr <nrb@linux.ibm.com>

[ Upstream commit 6973091d1b50ab4042f6a2d495f59e9db3662ab8 ]

When running under PV, the guest's TOD clock is under control of the
ultravisor and the hypervisor isn't allowed to change it. Hence, don't
allow userspace to change the guest's TOD clock by returning
-EOPNOTSUPP.

When userspace changes the guest's TOD clock, KVM updates its
kvm.arch.epoch field and, in addition, the epoch field in all state
descriptions of all VCPUs.

But, under PV, the ultravisor will ignore the epoch field in the state
description and simply overwrite it on next SIE exit with the actual
guest epoch. This leads to KVM having an incorrect view of the guest's
TOD clock: it has updated its internal kvm.arch.epoch field, but the
ultravisor ignores the field in the state description.

Whenever a guest is now waiting for a clock comparator, KVM will
incorrectly calculate the time when the guest should wake up, possibly
causing the guest to sleep for much longer than expected.

With this change, kvm_s390_set_tod() will now take the kvm->lock to be
able to call kvm_s390_pv_is_protected(). Since kvm_s390_set_tod_clock()
also takes kvm->lock, use __kvm_s390_set_tod_clock() instead.

The function kvm_s390_set_tod_clock is now unused, hence remove it.
Update the documentation to indicate the TOD clock attr calls can now
return -EOPNOTSUPP.

Fixes: 0f3035047140 ("KVM: s390: protvirt: Do only reset registers that are accessible")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20221011160712.928239-2-nrb@linux.ibm.com
Message-Id: <20221011160712.928239-2-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/devices/vm.rst |  3 +++
 arch/s390/kvm/kvm-s390.c              | 26 +++++++++++++++++---------
 arch/s390/kvm/kvm-s390.h              |  1 -
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 0aa5b1cfd700..60acc39e0e93 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -215,6 +215,7 @@ KVM_S390_VM_TOD_EXT).
 :Parameters: address of a buffer in user space to store the data (u8) to
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    -EINVAL if setting the TOD clock extension to != 0 is not supported
+	    -EOPNOTSUPP for a PV guest (TOD managed by the ultravisor)
 
 3.2. ATTRIBUTE: KVM_S390_VM_TOD_LOW
 -----------------------------------
@@ -224,6 +225,7 @@ the POP (u64).
 
 :Parameters: address of a buffer in user space to store the data (u64) to
 :Returns:    -EFAULT if the given address is not accessible from kernel space
+	     -EOPNOTSUPP for a PV guest (TOD managed by the ultravisor)
 
 3.3. ATTRIBUTE: KVM_S390_VM_TOD_EXT
 -----------------------------------
@@ -237,6 +239,7 @@ it, it is stored as 0 and not allowed to be set to a value != 0.
 	     (kvm_s390_vm_tod_clock) to
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    -EINVAL if setting the TOD clock extension to != 0 is not supported
+	    -EOPNOTSUPP for a PV guest (TOD managed by the ultravisor)
 
 4. GROUP: KVM_S390_VM_CRYPTO
 ============================
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b7ef0b71014d..2486281027c0 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1207,6 +1207,8 @@ static int kvm_s390_vm_get_migration(struct kvm *kvm,
 	return 0;
 }
 
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
+
 static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	struct kvm_s390_vm_tod_clock gtod;
@@ -1216,7 +1218,7 @@ static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 
 	if (!test_kvm_facility(kvm, 139) && gtod.epoch_idx)
 		return -EINVAL;
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 
 	VM_EVENT(kvm, 3, "SET: TOD extension: 0x%x, TOD base: 0x%llx",
 		gtod.epoch_idx, gtod.tod);
@@ -1247,7 +1249,7 @@ static int kvm_s390_set_tod_low(struct kvm *kvm, struct kvm_device_attr *attr)
 			   sizeof(gtod.tod)))
 		return -EFAULT;
 
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 	VM_EVENT(kvm, 3, "SET: TOD base: 0x%llx", gtod.tod);
 	return 0;
 }
@@ -1259,6 +1261,16 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 	if (attr->flags)
 		return -EINVAL;
 
+	mutex_lock(&kvm->lock);
+	/*
+	 * For protected guests, the TOD is managed by the ultravisor, so trying
+	 * to change it will never bring the expected results.
+	 */
+	if (kvm_s390_pv_is_protected(kvm)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	switch (attr->attr) {
 	case KVM_S390_VM_TOD_EXT:
 		ret = kvm_s390_set_tod_ext(kvm, attr);
@@ -1273,6 +1285,9 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 		ret = -ENXIO;
 		break;
 	}
+
+out_unlock:
+	mutex_unlock(&kvm->lock);
 	return ret;
 }
 
@@ -4379,13 +4394,6 @@ static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_t
 	preempt_enable();
 }
 
-void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
-{
-	mutex_lock(&kvm->lock);
-	__kvm_s390_set_tod_clock(kvm, gtod);
-	mutex_unlock(&kvm->lock);
-}
-
 int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
 {
 	if (!mutex_trylock(&kvm->lock))
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index f6fd668f887e..4755492dfabc 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -363,7 +363,6 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
-- 
2.35.1



