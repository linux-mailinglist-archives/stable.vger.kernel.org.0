Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5E83CCFF4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbhGSIXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235880AbhGSIXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50EC461248;
        Mon, 19 Jul 2021 08:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626684955;
        bh=ePBRj5YLuTR2mrim4zCUTZtMKw2CWxFnXRWiPcpzi9Y=;
        h=Subject:To:Cc:From:Date:From;
        b=UGe+Lyb+EiLiTMJ7IMTgTlJ4zS5rF/Sy42t+4p+7ghk9cKNIhVCCT+V6RrCGdTxmm
         ALIRezwrk/Le7EkpNNRAtCPnLC0gi1ngQ2e8wgAaGecz6W8YIYcd64G8qCb+2RZXwO
         GNWUds78Ode68vpt9vg3kHiKnBoMJAodoUBw8Gw0=
Subject: FAILED: patch "[PATCH] KVM: x86: Use kernel's x86_phys_bits to handle reduced" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 10:52:40 +0200
Message-ID: <162668476021559@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e39f00f60ebd2e7b295c37a05e6349df656d3eb8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 23 Jun 2021 16:05:47 -0700
Subject: [PATCH] KVM: x86: Use kernel's x86_phys_bits to handle reduced
 MAXPHYADDR

Use boot_cpu_data.x86_phys_bits instead of the raw CPUID information to
enumerate the MAXPHYADDR for KVM guests when TDP is disabled (the guest
version is only relevant to NPT/TDP).

When using shadow paging, any reductions to the host's MAXPHYADDR apply
to KVM and its guests as well, i.e. using the raw CPUID info will cause
KVM to misreport the number of PA bits available to the guest.

Unconditionally zero out the "Physical Address bit reduction" entry.
For !TDP, the adjustment is already done, and for TDP enumerating the
host's reduction is wrong as the reduction does not apply to GPAs.

Fixes: 9af9b94068fb ("x86/cpu/AMD: Handle SME reduction in physical address size")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210623230552.4027702-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1a4217b3e185..ca7866d63e98 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -941,11 +941,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		unsigned phys_as = entry->eax & 0xff;
 
 		/*
-		 * Use bare metal's MAXPHADDR if the CPU doesn't report guest
-		 * MAXPHYADDR separately, or if TDP (NPT) is disabled, as the
-		 * guest version "applies only to guests using nested paging".
+		 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
+		 * the guest operates in the same PA space as the host, i.e.
+		 * reductions in MAXPHYADDR for memory encryption affect shadow
+		 * paging, too.
+		 *
+		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
+		 * provided, use the raw bare metal MAXPHYADDR as reductions to
+		 * the HPAs do not affect GPAs.
 		 */
-		if (!g_phys_as || !tdp_enabled)
+		if (!tdp_enabled)
+			g_phys_as = boot_cpu_data.x86_phys_bits;
+		else if (!g_phys_as)
 			g_phys_as = phys_as;
 
 		entry->eax = g_phys_as | (virt_as << 8);
@@ -970,12 +977,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 0x8000001a:
 	case 0x8000001e:
 		break;
-	/* Support memory encryption cpuid if host supports it */
 	case 0x8000001F:
-		if (!kvm_cpu_cap_has(X86_FEATURE_SEV))
+		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
-		else
+		} else {
 			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
+
+			/*
+			 * Enumerate '0' for "PA bits reduction", the adjusted
+			 * MAXPHYADDR is enumerated directly (see 0x80000008).
+			 */
+			entry->ebx &= ~GENMASK(11, 6);
+		}
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:

