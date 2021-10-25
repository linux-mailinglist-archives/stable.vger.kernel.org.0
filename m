Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD77F43A163
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbhJYTiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236753AbhJYTfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BB176109E;
        Mon, 25 Oct 2021 19:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190384;
        bh=FihqFdg/OlAEqNv5rG9PDDT7bFwKwyMFGzDf69/dTRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W04cKPJthqkyyFWvtro7q9pJwMpToC8fAX7S+1UfpLaZyNc8jw4UzF5dgBO7Noc4g
         ZgW6KubyHvHLD5dzPO96DqAvOqWLMhPALtgkF2xz28fM0CdzDpL1kQSuuIvDDl0Hfq
         ZLOcOoiQtV6pxBrxhxDj6+m6fIuO31Mchk9R2Vo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 62/95] KVM: nVMX: promptly process interrupts delivered while in guest mode
Date:   Mon, 25 Oct 2021 21:14:59 +0200
Message-Id: <20211025191005.944365320@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
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
@@ -6316,18 +6316,13 @@ static int vmx_sync_pir_to_irr(struct kv
 
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


