Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC1320C01
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfEPQAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:00:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43014 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727077AbfEPP6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:47 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImK-0006zu-DJ; Thu, 16 May 2019 16:58:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001R8-Cb; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Eduardo Habkost" <ehabkost@redhat.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.325761355@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 60/86] kvm: x86: Report STIBP on GET_SUPPORTED_CPUID
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eduardo Habkost <ehabkost@redhat.com>

commit d7b09c827a6cf291f66637a36f46928dd1423184 upstream.

Months ago, we have added code to allow direct access to MSR_IA32_SPEC_CTRL
to the guest, which makes STIBP available to guests.  This was implemented
by commits d28b387fb74d ("KVM/VMX: Allow direct access to
MSR_IA32_SPEC_CTRL") and b2ac58f90540 ("KVM/SVM: Allow direct access to
MSR_IA32_SPEC_CTRL").

However, we never updated GET_SUPPORTED_CPUID to let userspace know that
STIBP can be enabled in CPUID.  Fix that by updating
kvm_cpuid_8000_0008_ebx_x86_features and kvm_cpuid_7_0_edx_x86_features.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -303,7 +303,7 @@ static inline int __do_cpuid_ent(struct
 	/* cpuid 0x80000008.ebx */
 	const u32 kvm_cpuid_8000_0008_ebx_x86_features =
 		F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO);
+		F(AMD_SSB_NO) | F(AMD_STIBP);
 
 	/* cpuid 0xC0000001.edx */
 	const u32 kvm_supported_word5_x86_features =
@@ -319,7 +319,8 @@ static inline int __do_cpuid_ent(struct
 
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
-		F(SPEC_CTRL) | F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES);
+		F(SPEC_CTRL) | F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) |
+		F(INTEL_STIBP);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();

