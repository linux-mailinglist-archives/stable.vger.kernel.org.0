Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA843CE1C0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345223AbhGSP1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348179AbhGSPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EF96610D0;
        Mon, 19 Jul 2021 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710561;
        bh=JPZ1QH1T5+Mt94s6tph9BvVZ54XQrQXfi7brPNhg968=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+Pr1B7xs2wiXhim+tfyYGg/FMKXmdm+oJTvsJvSeBF5zljc5kH43yMcOvRcQdE0w
         r13J5y7Uqjf3uUMFZUyapssxn8u/AEyYZAb5uRDyb3hkQHshVXTNg//bdk0cuweL9J
         Lh0L9MAfBRlWOaHWnvHIBZwscuerbO9gbDGfDHZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 007/351] KVM: x86: Use kernels x86_phys_bits to handle reduced MAXPHYADDR
Date:   Mon, 19 Jul 2021 16:49:13 +0200
Message-Id: <20210719144944.773505248@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit e39f00f60ebd2e7b295c37a05e6349df656d3eb8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -941,11 +941,18 @@ static inline int __do_cpuid_func(struct
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
@@ -970,12 +977,18 @@ static inline int __do_cpuid_func(struct
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


