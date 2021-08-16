Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FF53ED577
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbhHPNLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239312AbhHPNJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52FC5610E8;
        Mon, 16 Aug 2021 13:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119354;
        bh=HqoOsf7fQ17ViYTt6hdVND3wcDiVB/WVK1TQa3g5ET8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzcOZSMJJb9ZWelBnc+sG1rHDVr74dQ1x6lzfV6wA7KpQl+si1gd2Q9yuyo9UBP/T
         l+iSd6fmZEYa4wLSBgdh0Lhcj57wAPuxNKTES2qd3MElWFghDsfRZH+klmDHOMVLoi
         TPQqvO87/x42yJxs3nv6hGX967Ey0OdCX4P1i9yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 90/96] KVM: nVMX: Use vmx_need_pf_intercept() when deciding if L0 wants a #PF
Date:   Mon, 16 Aug 2021 15:02:40 +0200
Message-Id: <20210816125437.990931484@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 18712c13709d2de9516c5d3414f707c4f0a9c190 upstream.

Use vmx_need_pf_intercept() when determining if L0 wants to handle a #PF
in L2 or if the VM-Exit should be forwarded to L1.  The current logic fails
to account for the case where #PF is intercepted to handle
guest.MAXPHYADDR < host.MAXPHYADDR and ends up reflecting all #PFs into
L1.  At best, L1 will complain and inject the #PF back into L2.  At
worst, L1 will eat the unexpected fault and cause L2 to hang on infinite
page faults.

Note, while the bug was technically introduced by the commit that added
support for the MAXPHYADDR madness, the shame is all on commit
a0c134347baf ("KVM: VMX: introduce vmx_need_pf_intercept").

Fixes: 1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT violation and misconfig")
Cc: stable@vger.kernel.org
Cc: Peter Shier <pshier@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210812045615.3167686-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5779,7 +5779,8 @@ static bool nested_vmx_l0_wants_exit(str
 		if (is_nmi(intr_info))
 			return true;
 		else if (is_page_fault(intr_info))
-			return vcpu->arch.apf.host_apf_flags || !enable_ept;
+			return vcpu->arch.apf.host_apf_flags ||
+			       vmx_need_pf_intercept(vcpu);
 		else if (is_debug(intr_info) &&
 			 vcpu->guest_debug &
 			 (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))


