Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4791243A2F7
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhJYTzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237482AbhJYTvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38E32610EA;
        Mon, 25 Oct 2021 19:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191009;
        bh=AAldmsiWCqqFUv2h8uCBzl82QKDdXhkS8goM7I32Zp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHwEjkorJPeDzPw0OUmbkMiKxy5zjZ/zBxbvTuPjJip+NH1HOkzRCTr9O9Lc2IuCW
         +XP5nkZeJ0OJfaS1MMAU+S3ntUQ3TUw89sTMsVPzwsOz/OA2gvl3laKdZk3NSJIwBY
         ff+Wqd45KxD+rV3nZyXzAf2nOtSWyxHQ/IruLXHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 104/169] KVM: nVMX: promptly process interrupts delivered while in guest mode
Date:   Mon, 25 Oct 2021 21:14:45 +0200
Message-Id: <20211025191031.225878686@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 3a25dfa67fe40f3a2690af2c562e0947a78bd6a0 upstream.

Since commit c300ab9f08df ("KVM: x86: Replace late check_nested_events() hack with
more precise fix") there is no longer the certainty that check_nested_events()
tries to inject an external interrupt vmexit to L1 on every call to vcpu_enter_guest.
Therefore, even in that case we need to set KVM_REQ_EVENT.  This ensures
that inject_pending_event() is called, and from there kvm_check_nested_events().

Fixes: c300ab9f08df ("KVM: x86: Replace late check_nested_events() hack with more precise fix")
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6288,18 +6288,13 @@ static int vmx_sync_pir_to_irr(struct kv
 
 		/*
 		 * If we are running L2 and L1 has a new pending interrupt
-		 * which can be injected, we should re-evaluate
-		 * what should be done with this new L1 interrupt.
-		 * If L1 intercepts external-interrupts, we should
-		 * exit from L2 to L1. Otherwise, interrupt should be
-		 * delivered directly to L2.
+		 * which can be injected, this may cause a vmexit or it may
+		 * be injected into L2.  Either way, this interrupt will be
+		 * processed via KVM_REQ_EVENT, not RVI, because we do not use
+		 * virtual interrupt delivery to inject L1 interrupts into L2.
 		 */
-		if (is_guest_mode(vcpu) && max_irr_updated) {
-			if (nested_exit_on_intr(vcpu))
-				kvm_vcpu_exiting_guest_mode(vcpu);
-			else
-				kvm_make_request(KVM_REQ_EVENT, vcpu);
-		}
+		if (is_guest_mode(vcpu) && max_irr_updated)
+			kvm_make_request(KVM_REQ_EVENT, vcpu);
 	} else {
 		max_irr = kvm_lapic_find_highest_irr(vcpu);
 	}


