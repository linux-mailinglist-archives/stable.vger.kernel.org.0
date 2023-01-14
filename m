Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7797866AAA9
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjANJre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjANJre (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:47:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6CC4495
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:47:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42A2CCE0949
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C89C433D2;
        Sat, 14 Jan 2023 09:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689649;
        bh=U48xccqeNG3LhgpqVv4iI3Fr8kZWXJlK7685htyLKFk=;
        h=Subject:To:Cc:From:Date:From;
        b=o5aosQ0hZ2/CDbcEjhYCml/7PPvFpevqscAFPuUrOinhRVZFJiyvSH84OY8r60I50
         ZJDpYvKJPip7eqohE9lh6rk26FjwZn/L4UL+5LiBpA1Egi+hSiAzoEqckADYafupFF
         CsUsA9nnApeZ5MDrAdcHWzPFsiGeIthimUa8aNzw=
Subject: FAILED: patch "[PATCH] KVM: x86: Do not return host topology information from" failed to apply to 5.10-stable tree
To:     pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:47:23 +0100
Message-ID: <16736896434384@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

45e966fcca03 ("KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID")
cde363ab7ca7 ("Documentation: KVM: add API issues section")
ba7bb663f554 ("KVM: x86: Provide per VM capability for disabling PMU virtualization")
4dfc4ec2b7f5 ("Merge branch 'kvm-ppc-cap-210' into kvm-next-5.18")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 45e966fcca03ecdcccac7cb236e16eea38cc18af Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 22 Oct 2022 04:17:53 -0400
Subject: [PATCH] KVM: x86: Do not return host topology information from
 KVM_GET_SUPPORTED_CPUID

Passing the host topology to the guest is almost certainly wrong
and will confuse the scheduler.  In addition, several fields of
these CPUID leaves vary on each processor; it is simply impossible to
return the right values from KVM_GET_SUPPORTED_CPUID in such a way that
they can be passed to KVM_SET_CPUID2.

The values that will most likely prevent confusion are all zeroes.
Userspace will have to override it anyway if it wishes to present a
specific topology to the guest.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index deb494f759ed..d8ea37dfddf4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8310,6 +8310,20 @@ CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not reported by ``KVM_GET_SUPPORTED_CPUID``
 It can be enabled if ``KVM_CAP_TSC_DEADLINE_TIMER`` is present and the kernel
 has enabled in-kernel emulation of the local APIC.
 
+CPU topology
+~~~~~~~~~~~~
+
+Several CPUID values include topology information for the host CPU:
+0x0b and 0x1f for Intel systems, 0x8000001e for AMD systems.  Different
+versions of KVM return different values for this information and userspace
+should not rely on it.  Currently they return all zeroes.
+
+If userspace wishes to set up a guest topology, it should be careful that
+the values of these three leaves differ for each CPU.  In particular,
+the APIC ID is found in EDX for all subleaves of 0x0b and 0x1f, and in EAX
+for 0x8000001e; the latter also encodes the core id and node id in bits
+7:0 of EBX and ECX respectively.
+
 Obsolete ioctls and capabilities
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b14653b61470..596061c1610e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -770,16 +770,22 @@ struct kvm_cpuid_array {
 	int nent;
 };
 
+static struct kvm_cpuid_entry2 *get_next_cpuid(struct kvm_cpuid_array *array)
+{
+	if (array->nent >= array->maxnent)
+		return NULL;
+
+	return &array->entries[array->nent++];
+}
+
 static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 					      u32 function, u32 index)
 {
-	struct kvm_cpuid_entry2 *entry;
+	struct kvm_cpuid_entry2 *entry = get_next_cpuid(array);
 
-	if (array->nent >= array->maxnent)
+	if (!entry)
 		return NULL;
 
-	entry = &array->entries[array->nent++];
-
 	memset(entry, 0, sizeof(*entry));
 	entry->function = function;
 	entry->index = index;
@@ -956,22 +962,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = edx.full;
 		break;
 	}
-	/*
-	 * Per Intel's SDM, the 0x1f is a superset of 0xb,
-	 * thus they can be handled by common code.
-	 */
 	case 0x1f:
 	case 0xb:
 		/*
-		 * Populate entries until the level type (ECX[15:8]) of the
-		 * previous entry is zero.  Note, CPUID EAX.{0x1f,0xb}.0 is
-		 * the starting entry, filled by the primary do_host_cpuid().
+		 * No topology; a valid topology is indicated by the presence
+		 * of subleaf 1.
 		 */
-		for (i = 1; entry->ecx & 0xff00; ++i) {
-			entry = do_host_cpuid(array, function, i);
-			if (!entry)
-				goto out;
-		}
+		entry->eax = entry->ebx = entry->ecx = 0;
 		break;
 	case 0xd: {
 		u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
@@ -1202,6 +1199,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001e:
+		/* Do not return host topology information.  */
+		entry->eax = entry->ebx = entry->ecx = 0;
+		entry->edx = 0; /* reserved */
 		break;
 	case 0x8000001F:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {

