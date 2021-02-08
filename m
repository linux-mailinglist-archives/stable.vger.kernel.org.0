Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CA73137DE
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhBHPce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233897AbhBHP2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:28:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3370764F2B;
        Mon,  8 Feb 2021 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797385;
        bh=bx8yniSGutcdBDeBR8riEYEOyPfJq7o1oMVhAX/sDUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x70RRzBTLrnbt4EGqpbNBf+u9XlLdL0b40KBZF54AqhnHIphu9+wYzhx+a8yoSQh7
         hllQtA8ydP0RboYndTFNXxsFG5diOtlJbkUs4o8Bi02vIg8DzPOz2hPWi0RKEd5IMH
         CwUxdfcyBWCJi/aZAU4gnlreE/V6o2UzjSIhcq9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 090/120] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off
Date:   Mon,  8 Feb 2021 16:01:17 +0100
Message-Id: <20210208145821.977693535@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 7131636e7ea5b50ca910f8953f6365ef2d1f741c upstream.

Userspace that does not know about KVM_GET_MSR_FEATURE_INDEX_LIST
will generally use the default value for MSR_IA32_ARCH_CAPABILITIES.
When this happens and the host has tsx=on, it is possible to end up with
virtual machines that have HLE and RTM disabled, but TSX_CTRL available.

If the fleet is then switched to tsx=off, kvm_get_arch_capabilities()
will clear the ARCH_CAP_TSX_CTRL_MSR bit and it will not be possible to
use the tsx=off hosts as migration destinations, even though the guests
do not have TSX enabled.

To allow this migration, allow guests to write to their TSX_CTRL MSR,
while keeping the host MSR unchanged for the entire life of the guests.
This ensures that TSX remains disabled and also saves MSR reads and
writes, and it's okay to do because with tsx=off we know that guests will
not have the HLE and RTM features in their CPUID.  (If userspace sets
bogus CPUID data, we do not expect HLE and RTM to work in guests anyway).

Cc: stable@vger.kernel.org
Fixes: cbbaa2727aa3 ("KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   17 +++++++++++++----
 arch/x86/kvm/x86.c     |   26 +++++++++++++++++---------
 2 files changed, 30 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6874,11 +6874,20 @@ static int vmx_create_vcpu(struct kvm_vc
 		switch (index) {
 		case MSR_IA32_TSX_CTRL:
 			/*
-			 * No need to pass TSX_CTRL_CPUID_CLEAR through, so
-			 * let's avoid changing CPUID bits under the host
-			 * kernel's feet.
+			 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID
+			 * interception.  Keep the host value unchanged to avoid
+			 * changing CPUID bits under the host kernel's feet.
+			 *
+			 * hle=0, rtm=0, tsx_ctrl=1 can be found with some
+			 * combinations of new kernel and old userspace.  If
+			 * those guests run on a tsx=off host, do allow guests
+			 * to use TSX_CTRL, but do not change the value on the
+			 * host so that TSX remains always disabled.
 			 */
-			vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			if (boot_cpu_has(X86_FEATURE_RTM))
+				vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			else
+				vmx->guest_uret_msrs[j].mask = 0;
 			break;
 		default:
 			vmx->guest_uret_msrs[j].mask = -1ull;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1376,16 +1376,24 @@ static u64 kvm_get_arch_capabilities(voi
 	if (!boot_cpu_has_bug(X86_BUG_MDS))
 		data |= ARCH_CAP_MDS_NO;
 
-	/*
-	 * On TAA affected systems:
-	 *      - nothing to do if TSX is disabled on the host.
-	 *      - we emulate TSX_CTRL if present on the host.
-	 *	  This lets the guest use VERW to clear CPU buffers.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_RTM))
-		data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
-	else if (!boot_cpu_has_bug(X86_BUG_TAA))
+	if (!boot_cpu_has(X86_FEATURE_RTM)) {
+		/*
+		 * If RTM=0 because the kernel has disabled TSX, the host might
+		 * have TAA_NO or TSX_CTRL.  Clear TAA_NO (the guest sees RTM=0
+		 * and therefore knows that there cannot be TAA) but keep
+		 * TSX_CTRL: some buggy userspaces leave it set on tsx=on hosts,
+		 * and we want to allow migrating those guests to tsx=off hosts.
+		 */
+		data &= ~ARCH_CAP_TAA_NO;
+	} else if (!boot_cpu_has_bug(X86_BUG_TAA)) {
 		data |= ARCH_CAP_TAA_NO;
+	} else {
+		/*
+		 * Nothing to do here; we emulate TSX_CTRL if present on the
+		 * host so the guest can choose between disabling TSX or
+		 * using VERW to clear CPU buffers.
+		 */
+	}
 
 	return data;
 }


