Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774BF15C3DB
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgBMPoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:44:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729447AbgBMP1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:35 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0139E222C2;
        Thu, 13 Feb 2020 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607655;
        bh=GWMijhkMymqjblTVbuq2KK6lu2cqa3S12LTf6rYgJfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDsxi6e80J+P0oIxSVxCJL2wrBbWBNsUe2MO2j0VdWXzIYgn0YRAGYBAl5mlqfeUB
         FJ+fyJINdDSkR2u1VzE+qi8asdJRGdbJf2dzHRXv5Ie7/J6SQ3ATi0WMInDLXb8hMX
         hPr5sMmsh5ecyh9FktAr2iDC9Vzb84JGYg1CsATQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Beata Michalska <beata.michalska@linaro.org>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 69/96] KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests
Date:   Thu, 13 Feb 2020 07:21:16 -0800
Message-Id: <20200213151905.391087429@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 018f22f95e8a6c3e27188b7317ef2c70a34cb2cd upstream.

Beata reports that KVM_SET_VCPU_EVENTS doesn't inject the expected
exception to a non-LPAE aarch32 guest.

The host intends to inject DFSR.FS=0x14 "IMPLEMENTATION DEFINED fault
(Lockdown fault)", but the guest receives DFSR.FS=0x04 "Fault on
instruction cache maintenance". This fault is hooked by
do_translation_fault() since ARMv6, which goes on to silently 'handle'
the exception, and restart the faulting instruction.

It turns out, when TTBCR.EAE is clear DFSR is split, and FS[4] has
to shuffle up to DFSR[10].

As KVM only does this in one place, fix up the static values. We
now get the expected:
| Unhandled fault: lock abort (0x404) at 0x9c800f00

Fixes: 74a64a981662a ("KVM: arm/arm64: Unify 32bit fault injection")
Reported-by: Beata Michalska <beata.michalska@linaro.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200121123356.203000-2-james.morse@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/aarch32.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -181,10 +181,12 @@ static void inject_abt32(struct kvm_vcpu
 
 	/* Give the guest an IMPLEMENTATION DEFINED exception */
 	is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
-	if (is_lpae)
+	if (is_lpae) {
 		*fsr = 1 << 9 | 0x34;
-	else
-		*fsr = 0x14;
+	} else {
+		/* Surprise! DFSR's FS[4] lives in bit 10 */
+		*fsr = BIT(10) | 0x4; /* 0x14 */
+	}
 }
 
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)


