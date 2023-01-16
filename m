Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB1566C621
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjAPQPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjAPQOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:14:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5639A1CAC1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:08:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 106C6B8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67160C433D2;
        Mon, 16 Jan 2023 16:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885319;
        bh=+0CqO0b06TengcFvuL6jea2IgCjILIpQ8IDa2MHHT2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5wMGIxeXYnCZjNzsebVa8fGoCKqUzHGuc3LP1/dYZ0gWj7x6I/yclg2gpPshPIS2
         9z7tg2b3PnErtUaprirdluusckaWKLYa3VNP1+xc05I1nZ7W/8058uZt/uCwUwVDgy
         tcNtiW3HFYtMNM3TZP5Fzw5tmjRZ5hcUCJ4RcMq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 54/64] KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID
Date:   Mon, 16 Jan 2023 16:52:01 +0100
Message-Id: <20230116154745.431127682@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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

[ Upstream commit 45e966fcca03ecdcccac7cb236e16eea38cc18af ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/api.rst | 14 ++++++++++++++
 arch/x86/kvm/cpuid.c           | 32 ++++++++++++++++----------------
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d807994360d4..2b4b64797191 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6433,6 +6433,20 @@ CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not reported by ``KVM_GET_SUPPORTED_CPUID``
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
index 06a776fdb90c..de4b171cb76b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -511,16 +511,22 @@ struct kvm_cpuid_array {
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
 	entry->function = function;
 	entry->index = index;
 	entry->flags = 0;
@@ -698,22 +704,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
 	case 0xd:
 		entry->eax &= supported_xcr0;
@@ -866,6 +863,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001e:
+		/* Do not return host topology information.  */
+		entry->eax = entry->ebx = entry->ecx = 0;
+		entry->edx = 0; /* reserved */
 		break;
 	/* Support memory encryption cpuid if host supports it */
 	case 0x8000001F:
-- 
2.35.1



