Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBDD29BD75
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811021AbgJ0Qgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802385AbgJ0PsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:48:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2FA222284;
        Tue, 27 Oct 2020 15:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813682;
        bh=gZ5hX7BiaGGoFJsUDs4rmUHdZt47slybaLRfnGmle74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04kU1yrrjaTMZZsPKNROoneJ65IrJPeXBfA+IzWNbeVa5Gs00uwwVsJWZJFSpCyqI
         ZB/tnycxZ6ZeTgu3O/E7k1YsTtFhs3G3reeAfgQsbVVQ7XRG68N7qHc4z8Un/o415t
         u1jqgJwhg4akvzRWJi8z7/GnSXvpbe/wuCxt9Z2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 634/757] KVM: ioapic: break infinite recursion on lazy EOI
Date:   Tue, 27 Oct 2020 14:54:44 +0100
Message-Id: <20201027135520.294211662@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 77377064c3a94911339f13ce113b3abf265e06da ]

During shutdown the IOAPIC trigger mode is reset to edge triggered
while the vfio-pci INTx is still registered with a resampler.
This allows us to get into an infinite loop:

ioapic_set_irq
  -> ioapic_lazy_update_eoi
  -> kvm_ioapic_update_eoi_one
  -> kvm_notify_acked_irq
  -> kvm_notify_acked_gsi
  -> (via irq_acked fn ptr) irqfd_resampler_ack
  -> kvm_set_irq
  -> (via set fn ptr) kvm_set_ioapic_irq
  -> kvm_ioapic_set_irq
  -> ioapic_set_irq

Commit 8be8f932e3db ("kvm: ioapic: Restrict lazy EOI update to
edge-triggered interrupts", 2020-05-04) acknowledges that this recursion
loop exists and tries to avoid it at the call to ioapic_lazy_update_eoi,
but at this point the scenario is already set, we have an edge interrupt
with resampler on the same gsi.

Fortunately, the only user of irq ack notifiers (in addition to resamplefd)
is i8254 timer interrupt reinjection.  These are edge-triggered, so in
principle they would need the call to kvm_ioapic_update_eoi_one from
ioapic_lazy_update_eoi, but they already disable AVIC(*), so they don't
need the lazy EOI behavior.  Therefore, remove the call to
kvm_ioapic_update_eoi_one from ioapic_lazy_update_eoi.

This fixes CVE-2020-27152.  Note that this issue cannot happen with
SR-IOV assigned devices because virtual functions do not have INTx,
only MSI.

Fixes: f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI")
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/ioapic.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index d057376bd3d33..698969e18fe35 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -197,12 +197,9 @@ static void ioapic_lazy_update_eoi(struct kvm_ioapic *ioapic, int irq)
 
 		/*
 		 * If no longer has pending EOI in LAPICs, update
-		 * EOI for this vetor.
+		 * EOI for this vector.
 		 */
 		rtc_irq_eoi(ioapic, vcpu, entry->fields.vector);
-		kvm_ioapic_update_eoi_one(vcpu, ioapic,
-					  entry->fields.trig_mode,
-					  irq);
 		break;
 	}
 }
-- 
2.25.1



