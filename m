Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF18409324
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245577AbhIMOSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241480AbhIMOQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3476561423;
        Mon, 13 Sep 2021 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540666;
        bh=r5lrTw+9ScswXcmi6nOb35GIpJFygjPbcfwnTlDrRrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBbituFpBC7rx0iv7Ij///A8Wfaf3FJaktsf4jQRHr9bg6h2TmZM+V66zvEGz8UTU
         JPN7fRvtdWRfAN4cIDLG7+aCHZzYdD8u4cMUHM/a5Q98ES0Yd9W9Wby9HzoXaKGdLV
         +qocXQy3icaGiHx2gGyhk6j8yLm3DXRMf2t6fFKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 286/300] KVM: nVMX: Unconditionally clear nested.pi_pending on nested VM-Enter
Date:   Mon, 13 Sep 2021 15:15:47 +0200
Message-Id: <20210913131118.999909236@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit f7782bb8d818d8f47c26b22079db10599922787a upstream.

Clear nested.pi_pending on nested VM-Enter even if L2 will run without
posted interrupts enabled.  If nested.pi_pending is left set from a
previous L2, vmx_complete_nested_posted_interrupt() will pick up the
stale flag and exit to userspace with an "internal emulation error" due
the new L2 not having a valid nested.pi_desc.

Arguably, vmx_complete_nested_posted_interrupt() should first check for
posted interrupts being enabled, but it's also completely reasonable that
KVM wouldn't screw up a fundamental flag.  Not to mention that the mere
existence of nested.pi_pending is a long-standing bug as KVM shouldn't
move the posted interrupt out of the IRR until it's actually processed,
e.g. KVM effectively drops an interrupt when it performs a nested VM-Exit
with a "pending" posted interrupt.  Fixing the mess is a future problem.

Prior to vmx_complete_nested_posted_interrupt() interpreting a null PI
descriptor as an error, this was a benign bug as the null PI descriptor
effectively served as a check on PI not being enabled.  Even then, the
new flow did not become problematic until KVM started checking the result
of kvm_check_nested_events().

Fixes: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing")
Fixes: 966eefb89657 ("KVM: nVMX: Disable vmcs02 posted interrupts if vmcs12 PID isn't mappable")
Fixes: 47d3530f86c0 ("KVM: x86: Exit to userspace when kvm_check_nested_events fails")
Cc: stable@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210810144526.2662272-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2226,12 +2226,11 @@ static void prepare_vmcs02_early(struct
 			 ~PIN_BASED_VMX_PREEMPTION_TIMER);
 
 	/* Posted interrupts setting is only taken from vmcs12.  */
-	if (nested_cpu_has_posted_intr(vmcs12)) {
+	vmx->nested.pi_pending = false;
+	if (nested_cpu_has_posted_intr(vmcs12))
 		vmx->nested.posted_intr_nv = vmcs12->posted_intr_nv;
-		vmx->nested.pi_pending = false;
-	} else {
+	else
 		exec_control &= ~PIN_BASED_POSTED_INTR;
-	}
 	pin_controls_set(vmx, exec_control);
 
 	/*


