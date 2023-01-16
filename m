Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E11366C47D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjAPPzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjAPPzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BB9234C6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62A5561037
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796FEC433EF;
        Mon, 16 Jan 2023 15:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884513;
        bh=/xurSwePBhInU3fUm/N7e3Q59ErIcs75CcyG05ZTjQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBIteLCX7B/JAAFWIkg6Hj4TJkZUu4XljnCGUVVi4IJmvCnJPgiPnctAlRI7UGvql
         i2KninqX1EAXgVTBGHSeOuvK9xbyuDQxwQTK3qVQvtXxn09Wcu3LYvk3PRh/DwVWPM
         K9rila2FhNM6gtFy3JPYso3TRMxCDjubCUJ51DNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 007/183] KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID
Date:   Mon, 16 Jan 2023 16:48:50 +0100
Message-Id: <20230116154803.683444886@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit 45e966fcca03ecdcccac7cb236e16eea38cc18af upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/api.rst |   14 ++++++++++++++
 arch/x86/kvm/cpuid.c           |   32 ++++++++++++++++----------------
 2 files changed, 30 insertions(+), 16 deletions(-)

--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8248,6 +8248,20 @@ CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not
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
 
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -759,16 +759,22 @@ struct kvm_cpuid_array {
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
@@ -945,22 +951,13 @@ static inline int __do_cpuid_func(struct
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
@@ -1193,6 +1190,9 @@ static inline int __do_cpuid_func(struct
 		entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001e:
+		/* Do not return host topology information.  */
+		entry->eax = entry->ebx = entry->ecx = 0;
+		entry->edx = 0; /* reserved */
 		break;
 	case 0x8000001F:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {


