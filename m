Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA223E7E97
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhHJReX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232763AbhHJRdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9EB0610A0;
        Tue, 10 Aug 2021 17:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616807;
        bh=eSCplMMCmiCFNQYwKjfzRjfCkcDnLonYxNHYlBDptFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHEy9yNwMePnDsU3qLKM1bRVyDyjJ+D6jlqXsheQ4vF+gzwWw0eb2LPG6VEwCYbB5
         wzCxzYFk5iOfumDb23hvUcofPXo3wLsemclJnpfcf8jIY4MeyEf7+HxBbNBQlSb0Y8
         dctOFil67IiOrAUcUhuqrp3k2klhyo0dXM5SOvfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stas Sergeev <stsp2@yandex.ru>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 44/54] KVM: x86: accept userspace interrupt only if no event is injected
Date:   Tue, 10 Aug 2021 19:30:38 +0200
Message-Id: <20210810172945.648257457@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit fa7a549d321a4189677b0cea86e58d9db7977f7b upstream.

Once an exception has been injected, any side effects related to
the exception (such as setting CR2 or DR6) have been taked place.
Therefore, once KVM sets the VM-entry interruption information
field or the AMD EVENTINJ field, the next VM-entry must deliver that
exception.

Pending interrupts are processed after injected exceptions, so
in theory it would not be a problem to use KVM_INTERRUPT when
an injected exception is present.  However, DOSEMU is using
run->ready_for_interrupt_injection to detect interrupt windows
and then using KVM_SET_SREGS/KVM_SET_REGS to inject the
interrupt manually.  For this to work, the interrupt window
must be delayed after the completion of the previous event
injection.

Cc: stable@vger.kernel.org
Reported-by: Stas Sergeev <stsp2@yandex.ru>
Tested-by: Stas Sergeev <stsp2@yandex.ru>
Fixes: 71cc849b7093 ("KVM: x86: Fix split-irqchip vs interrupt injection window request")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3366,8 +3366,17 @@ static int kvm_cpu_accept_dm_intr(struct
 
 static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 {
-	return kvm_arch_interrupt_allowed(vcpu) &&
-		kvm_cpu_accept_dm_intr(vcpu);
+	/*
+	 * Do not cause an interrupt window exit if an exception
+	 * is pending or an event needs reinjection; userspace
+	 * might want to inject the interrupt manually using KVM_SET_REGS
+	 * or KVM_SET_SREGS.  For that to work, we must be at an
+	 * instruction boundary and with no events half-injected.
+	 */
+	return (kvm_arch_interrupt_allowed(vcpu) &&
+		kvm_cpu_accept_dm_intr(vcpu) &&
+		!kvm_event_needs_reinjection(vcpu) &&
+		!vcpu->arch.exception.pending);
 }
 
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,


