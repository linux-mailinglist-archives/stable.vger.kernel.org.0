Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF66F171A19
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731288AbgB0Nuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731275AbgB0Nun (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:50:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD89920578;
        Thu, 27 Feb 2020 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811443;
        bh=OW+ALG046xOVoYPJkM6XOofOHr8SIKyni8Hj2tdseyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcDLT4nRbfodbNFxnPbOEsZn98sfPZDdjbQa2I4FsA71EEqSag4aba8mazyGGNynP
         sE6M+89D3Vg+KK3bnuhidknXCO7y5ilH08zxIygKtQHy82Tmc2S/u7Vxq++QqGJxsT
         YfHT0SwjOglgUKOdxMLsYWavomYWesQwOjWSyz40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 135/165] KVM: x86: dont notify userspace IOAPIC on edge-triggered interrupt EOI
Date:   Thu, 27 Feb 2020 14:36:49 +0100
Message-Id: <20200227132250.789065321@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 7455a8327674e1a7c9a1f5dd1b0743ab6713f6d1 upstream.

Commit 13db77347db1 ("KVM: x86: don't notify userspace IOAPIC on edge
EOI") said, edge-triggered interrupts don't set a bit in TMR, which means
that IOAPIC isn't notified on EOI. And var level indicates level-triggered
interrupt.
But commit 3159d36ad799 ("KVM: x86: use generic function for MSI parsing")
replace var level with irq.level by mistake. Fix it by changing irq.level
to irq.trig_mode.

Cc: stable@vger.kernel.org
Fixes: 3159d36ad799 ("KVM: x86: use generic function for MSI parsing")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/irq_comm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -436,7 +436,7 @@ void kvm_scan_ioapic_routes(struct kvm_v
 
 			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
 
-			if (irq.level && kvm_apic_match_dest(vcpu, NULL, 0,
+			if (irq.trig_mode && kvm_apic_match_dest(vcpu, NULL, 0,
 						irq.dest_id, irq.dest_mode))
 				__set_bit(irq.vector, ioapic_handled_vectors);
 		}


