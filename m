Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431D515C1E8
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgBMP1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729450AbgBMP1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:36 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9228524685;
        Thu, 13 Feb 2020 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607655;
        bh=eA2xG7o/gojCA1Jlfncc6S6XqFxRCP2rOYoV6DMyWws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAgKL7Ibq+qEObgz82l392ieSs3SfJPkiaxIPL+GYFaI+Fk2I9d6r22MbWxmEfgTM
         f/rP2fnnRkBO3JKhp1AM7usRIoSnKKBHqtWJ41QYu1MJa02OioOME0Y45xjjOd8BI+
         H1PdeBiJp68Xmrnw326Scu+1epvMKbACvOMGwzYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Beata Michalska <beata.michalska@linaro.org>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 70/96] KVM: arm: Make inject_abt32() inject an external abort instead
Date:   Thu, 13 Feb 2020 07:21:17 -0800
Message-Id: <20200213151905.657123366@linuxfoundation.org>
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

commit 21aecdbd7f3ab02c9b82597dc733ee759fb8b274 upstream.

KVM's inject_abt64() injects an external-abort into an aarch64 guest.
The KVM_CAP_ARM_INJECT_EXT_DABT is intended to do exactly this, but
for an aarch32 guest inject_abt32() injects an implementation-defined
exception, 'Lockdown fault'.

Change this to external abort. For non-LPAE we now get the documented:
| Unhandled fault: external abort on non-linefetch (0x008) at 0x9c800f00
and for LPAE:
| Unhandled fault: synchronous external abort (0x210) at 0x9c800f00

Fixes: 74a64a981662a ("KVM: arm/arm64: Unify 32bit fault injection")
Reported-by: Beata Michalska <beata.michalska@linaro.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200121123356.203000-3-james.morse@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/aarch32.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -15,6 +15,10 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
+#define DFSR_FSC_EXTABT_LPAE	0x10
+#define DFSR_FSC_EXTABT_nLPAE	0x08
+#define DFSR_LPAE		BIT(9)
+
 /*
  * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
  */
@@ -182,10 +186,10 @@ static void inject_abt32(struct kvm_vcpu
 	/* Give the guest an IMPLEMENTATION DEFINED exception */
 	is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
 	if (is_lpae) {
-		*fsr = 1 << 9 | 0x34;
+		*fsr = DFSR_LPAE | DFSR_FSC_EXTABT_LPAE;
 	} else {
-		/* Surprise! DFSR's FS[4] lives in bit 10 */
-		*fsr = BIT(10) | 0x4; /* 0x14 */
+		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
+		*fsr = DFSR_FSC_EXTABT_nLPAE;
 	}
 }
 


