Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8D61D0E9F
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733014AbgEMKB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgEMJuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:50:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4EF520575;
        Wed, 13 May 2020 09:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363455;
        bh=CXVsfp0dJQu1Fcsy1N3InxY3gjc4AOdrPhido3R2SBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLrtAgfnkQgpofosfkD6MFPfYU5PGpatJD3lOnTkgJ8cbfBMjA2LGnUsCM+4upI+L
         Agu+/CKfR3FKWVAQPYj8VjhI/+pXPE5AGNOhqO0KYPWLSDO9drRxMpWGZu+4Dzn1GI
         yMrRza9fSDLBl4oNuhhOnPTD8XjqBlTN9Jj5b9UU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 79/90] KVM: x86: Fixes posted interrupt check for IRQs delivery modes
Date:   Wed, 13 May 2020 11:45:15 +0200
Message-Id: <20200513094417.469987816@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit 637543a8d61c6afe4e9be64bfb43c78701a83375 upstream.

Current logic incorrectly uses the enum ioapic_irq_destination_types
to check the posted interrupt destination types. However, the value was
set using APIC_DM_XXX macros, which are left-shifted by 8 bits.

Fixes by using the APIC_DM_FIXED and APIC_DM_LOWEST instead.

Fixes: (fdcf75621375 'KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes')
Cc: Alexander Graf <graf@amazon.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-Id: <1586239989-58305-1-git-send-email-suravee.suthikulpanit@amd.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1608,8 +1608,8 @@ void kvm_set_msi_irq(struct kvm *kvm, st
 static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 {
 	/* We can only post Fixed and LowPrio IRQs */
-	return (irq->delivery_mode == dest_Fixed ||
-		irq->delivery_mode == dest_LowestPrio);
+	return (irq->delivery_mode == APIC_DM_FIXED ||
+		irq->delivery_mode == APIC_DM_LOWEST);
 }
 
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)


