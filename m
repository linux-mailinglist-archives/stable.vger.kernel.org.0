Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EED1D0DD3
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388385AbgEMJ4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388379AbgEMJ4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:56:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63AB020575;
        Wed, 13 May 2020 09:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363770;
        bh=k4fil7W7//XYo4e4PP6yH1KzkpmbhcrSQ5oYqDqR9Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjskAzsR45s9KzmOLCBGAQy2sWYhqAfdZ2Thad8ykmAhWNxAHz82l6QCh0nPK/yc4
         Ep9y+D3IRzLGlGI9Z6QcQC3PwMoIxDErkD3VWh2OHkeJ05gcCZ4DA/sCb6xTq+Wo+n
         mrTPI37tKcveI+0umZeXZBa5jawjT1XC119Xedns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        borisvk@bstnet.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.6 109/118] kvm: ioapic: Restrict lazy EOI update to edge-triggered interrupts
Date:   Wed, 13 May 2020 11:45:28 +0200
Message-Id: <20200513094427.609460224@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 8be8f932e3db5fe4ed178b8892eeffeab530273a upstream.

Commit f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI") introduces
the following infinite loop:

BUG: stack guard page was hit at 000000008f595917 \
(stack is 00000000bdefe5a4..00000000ae2b06f5)
kernel stack overflow (double-fault): 0000 [#1] SMP NOPTI
RIP: 0010:kvm_set_irq+0x51/0x160 [kvm]
Call Trace:
 irqfd_resampler_ack+0x32/0x90 [kvm]
 kvm_notify_acked_irq+0x62/0xd0 [kvm]
 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
 ioapic_set_irq+0x20e/0x240 [kvm]
 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
 kvm_set_irq+0xbb/0x160 [kvm]
 ? kvm_hv_set_sint+0x20/0x20 [kvm]
 irqfd_resampler_ack+0x32/0x90 [kvm]
 kvm_notify_acked_irq+0x62/0xd0 [kvm]
 kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
 ioapic_set_irq+0x20e/0x240 [kvm]
 kvm_ioapic_set_irq+0x5c/0x80 [kvm]
 kvm_set_irq+0xbb/0x160 [kvm]
 ? kvm_hv_set_sint+0x20/0x20 [kvm]
....

The re-entrancy happens because the irq state is the OR of
the interrupt state and the resamplefd state.  That is, we don't
want to show the state as 0 until we've had a chance to set the
resamplefd.  But if the interrupt has _not_ gone low then
ioapic_set_irq is invoked again, causing an infinite loop.

This can only happen for a level-triggered interrupt, otherwise
irqfd_inject would immediately set the KVM_USERSPACE_IRQ_SOURCE_ID high
and then low.  Fortunately, in the case of level-triggered interrupts the VMEXIT already happens because
TMR is set.  Thus, fix the bug by restricting the lazy invocation
of the ack notifier to edge-triggered interrupts, the only ones that
need it.

Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reported-by: borisvk@bstnet.org
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://www.spinics.net/lists/kvm/msg213512.html
Fixes: f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207489
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/ioapic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -225,12 +225,12 @@ static int ioapic_set_irq(struct kvm_ioa
 	}
 
 	/*
-	 * AMD SVM AVIC accelerate EOI write and do not trap,
-	 * in-kernel IOAPIC will not be able to receive the EOI.
-	 * In this case, we do lazy update of the pending EOI when
-	 * trying to set IOAPIC irq.
+	 * AMD SVM AVIC accelerate EOI write iff the interrupt is edge
+	 * triggered, in which case the in-kernel IOAPIC will not be able
+	 * to receive the EOI.  In this case, we do a lazy update of the
+	 * pending EOI when trying to set IOAPIC irq.
 	 */
-	if (kvm_apicv_activated(ioapic->kvm))
+	if (edge && kvm_apicv_activated(ioapic->kvm))
 		ioapic_lazy_update_eoi(ioapic, irq);
 
 	/*


