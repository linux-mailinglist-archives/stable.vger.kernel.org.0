Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC8844171D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhKAJcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233023AbhKAJad (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8200161154;
        Mon,  1 Nov 2021 09:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758649;
        bh=dxk7TbGopJyzyNO3eRiRqncp7nU/TcTaKlKJOAs5gZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6CHNAQqqHrmYwtbKTnEzWidgDBMQtiyJ+Ghv/bsse7M9leb5RoJvKtTgyQEP/kPW
         WLsipTcqFoMPTU3+i7M+UVOgpfAaDbusOECec6AjhHfG8sp2KjbOnpRnqXp5ndAI1G
         dqsA/pW0BqFKhNIjcCIplCJjGz1/nOktpk0WXW50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/51] KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu
Date:   Mon,  1 Nov 2021 10:17:54 +0100
Message-Id: <20211101082512.103567222@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit 0e9ff65f455dfd0a8aea5e7843678ab6fe097e21 ]

Changing the deliverable mask in __airqs_kick_single_vcpu() is a bug. If
one idle vcpu can't take the interrupts we want to deliver, we should
look for another vcpu that can, instead of saying that we don't want
to deliver these interrupts by clearing the bits from the
deliverable_mask.

Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20211019175401.3757927-3-pasic@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/interrupt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index fa9483aa4f57..fd73a8aa89d2 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2987,13 +2987,14 @@ static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
 	int vcpu_idx, online_vcpus = atomic_read(&kvm->online_vcpus);
 	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
 	struct kvm_vcpu *vcpu;
+	u8 vcpu_isc_mask;
 
 	for_each_set_bit(vcpu_idx, kvm->arch.idle_mask, online_vcpus) {
 		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
 		if (psw_ioint_disabled(vcpu))
 			continue;
-		deliverable_mask &= (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
-		if (deliverable_mask) {
+		vcpu_isc_mask = (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
+		if (deliverable_mask & vcpu_isc_mask) {
 			/* lately kicked but not yet running */
 			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
 				return;
-- 
2.33.0



