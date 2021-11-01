Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7C84418CB
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhKAJvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234775AbhKAJtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:49:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 203F761205;
        Mon,  1 Nov 2021 09:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759094;
        bh=fZVerNpCBZyP9MJ/63mzMn5VUC7cc2H05bLULyo8nNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQkHL9wOA2iVMfX+4vZEPMURPX/Xpt0HM6OiuZGBZXGLQbSucmqxSdb9c++gIRoVr
         ZsQvnvqsgWOqGMNjden0G/1N42+/p/aeZh9S0xGyXQTpAhxXng2LYRaj+efC8cOtdW
         +DklO6z1Esjl6OIt0q3C3ESkn8bxlXpeUGD5afqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 113/125] KVM: s390: clear kicked_mask before sleeping again
Date:   Mon,  1 Nov 2021 10:18:06 +0100
Message-Id: <20211101082554.460781400@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit 9b57e9d5010bbed7c0d9d445085840f7025e6f9a ]

The idea behind kicked mask is that we should not re-kick a vcpu that
is already in the "kick" process, i.e. that was kicked and is
is about to be dispatched if certain conditions are met.

The problem with the current implementation is, that it assumes the
kicked vcpu is going to enter SIE shortly. But under certain
circumstances, the vcpu we just kicked will be deemed non-runnable and
will remain in wait state. This can happen, if the interrupt(s) this
vcpu got kicked to deal with got already cleared (because the interrupts
got delivered to another vcpu). In this case kvm_arch_vcpu_runnable()
would return false, and the vcpu would remain in kvm_vcpu_block(),
but this time with its kicked_mask bit set. So next time around we
wouldn't kick the vcpu form __airqs_kick_single_vcpu(), but would assume
that we just kicked it.

Let us make sure the kicked_mask is cleared before we give up on
re-dispatching the vcpu.

Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20211019175401.3757927-2-pasic@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8580543c5bc3..46ad1bdd53a2 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3341,6 +3341,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
+	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
 	return kvm_s390_vcpu_has_irq(vcpu, 0);
 }
 
-- 
2.33.0



