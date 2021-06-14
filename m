Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915203A63EC
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbhFNLSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235087AbhFNLQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A564A61971;
        Mon, 14 Jun 2021 10:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667802;
        bh=zdW9g7x9tBO1D7Vv/ypeiPNb5pWPmL0EbyMnOs1qUbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1CKDS8l7yErj+GZl3NpNDKqyMDqrdYl7m/9VLqI0QaHCUxUVpD95O4ffkC3ql7Z9
         2xp5DEQ6PsLgjI0ddU0OpL89oWBqtO4JugM6nm3RA4L4j8+Iow+WHPvVwVppPh/sBd
         fuIV5tryRhx11NIK+V5auVqU5RUQVNBm2AVtPaQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 063/173] KVM: x86: Unload MMU on guest TLB flush if TDP disabled to force MMU sync
Date:   Mon, 14 Jun 2021 12:26:35 +0200
Message-Id: <20210614102700.260682623@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit b53e84eed08b88fd3ff59e5c2a7f1a69d4004e32 upstream.

When using shadow paging, unload the guest MMU when emulating a guest TLB
flush to ensure all roots are synchronized.  From the guest's perspective,
flushing the TLB ensures any and all modifications to its PTEs will be
recognized by the CPU.

Note, unloading the MMU is overkill, but is done to mirror KVM's existing
handling of INVPCID(all) and ensure the bug is squashed.  Future cleanup
can be done to more precisely synchronize roots when servicing a guest
TLB flush.

If TDP is enabled, synchronizing the MMU is unnecessary even if nested
TDP is in play, as a "legacy" TLB flush from L1 does not invalidate L1's
TDP mappings.  For EPT, an explicit INVEPT is required to invalidate
guest-physical mappings; for NPT, guest mappings are always tagged with
an ASID and thus can only be invalidated via the VMCB's ASID control.

This bug has existed since the introduction of KVM_VCPU_FLUSH_TLB.
It was only recently exposed after Linux guests stopped flushing the
local CPU's TLB prior to flushing remote TLBs (see commit 4ce94eabac16,
"x86/mm/tlb: Flush remote and local TLBs concurrently"), but is also
visible in Windows 10 guests.

Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
[sean: massaged comment and changelog]
Message-Id: <20210531172256.2908-1-jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2982,6 +2982,19 @@ static void kvm_vcpu_flush_tlb_all(struc
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
+
+	if (!tdp_enabled) {
+               /*
+		 * A TLB flush on behalf of the guest is equivalent to
+		 * INVPCID(all), toggling CR4.PGE, etc., which requires
+		 * a forced sync of the shadow page tables.  Unload the
+		 * entire MMU here and the subsequent load will sync the
+		 * shadow page tables, and also flush the TLB.
+		 */
+		kvm_mmu_unload(vcpu);
+		return;
+	}
+
 	static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 


