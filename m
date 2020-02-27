Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281F9171F11
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbgB0OCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:02:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733111AbgB0OCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:02:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C49A21D7E;
        Thu, 27 Feb 2020 14:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812143;
        bh=tOmoxyHH7aI3s0hZrRZfclMTF0zSrdSwaBsKgAUc8u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBSXXHaCmlGhVIVpyYhpnfPVOUfSzTGtW24w8XeOPxSTB5qDcZOXJv/Xzk8k/OIiO
         OR55dtaZ3WfDvIeQS29g+6LC51tU5i8ktXMtiUThQWxvNQKGmflK5eRSDWUwpwveq1
         G0J94fs26RPGFMbF639atFUS2LsDpan8nMeetn0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 200/237] KVM: x86: dont notify userspace IOAPIC on edge-triggered interrupt EOI
Date:   Thu, 27 Feb 2020 14:36:54 +0100
Message-Id: <20200227132310.995652885@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
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
@@ -427,7 +427,7 @@ void kvm_scan_ioapic_routes(struct kvm_v
 
 			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
 
-			if (irq.level && kvm_apic_match_dest(vcpu, NULL, 0,
+			if (irq.trig_mode && kvm_apic_match_dest(vcpu, NULL, 0,
 						irq.dest_id, irq.dest_mode))
 				__set_bit(irq.vector, ioapic_handled_vectors);
 		}


