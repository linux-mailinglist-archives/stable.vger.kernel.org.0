Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3954417EC
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhKAJlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233419AbhKAJjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A7E361186;
        Mon,  1 Nov 2021 09:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758837;
        bh=R8wHN2xghOx33mYGjdO6JMzjo4Nblujv+vL+t3+NtfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0C3DrNC6HKODesAISPqHhqBJRYNwUqMYwK3K1WuKgn2ehTe4RpNty1fLZ02gH995N
         ZM/roib/v8BvFpXKepZWABu065wsAPDTtsPujWxK6XS2pIpKNXmzRoZiKeK3li9HBN
         XuRHPhYngmU7rNsQUKOkiFrQkYnBlzMBq6Fiixw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 72/77] KVM: s390: clear kicked_mask before sleeping again
Date:   Mon,  1 Nov 2021 10:18:00 +0100
Message-Id: <20211101082526.600825558@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
index 7f719b468b44..00f03f363c9b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3312,6 +3312,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
+	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
 	return kvm_s390_vcpu_has_irq(vcpu, 0);
 }
 
-- 
2.33.0



