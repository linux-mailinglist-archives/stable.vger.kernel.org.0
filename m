Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4354137CB2D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242452AbhELQeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241525AbhELQ13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A5EA61DE1;
        Wed, 12 May 2021 15:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834827;
        bh=8YvGxLhF+KGEry1RgdKfe+X3kOTBL+vZd2cWKnzvk3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtPCTX7Q83mSQqqF9aNr+XbIWZiryr5Kx4cWmw26+9GjIhMCM7oxrlZEAbMWZpRKK
         l3OrtjUroh4IXHFy9h9LQDMG7fbboUZCtkgIMHWxIGtEOGQ+JEdwlgP9BjLgBHPavR
         CLrZJ+eKFvO69n9mLXB1tAptFDyOwxe8qJLwrkro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.12 099/677] KVM: s390: VSIE: correctly handle MVPG when in VSIE
Date:   Wed, 12 May 2021 16:42:25 +0200
Message-Id: <20210512144840.509930254@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit bdf7509bbefa20855d5f6bacdc5b62a8489477c9 upstream.

Correctly handle the MVPG instruction when issued by a VSIE guest.

Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
Cc: stable@vger.kernel.org # f85f1baaa189: KVM: s390: split kvm_s390_logical_to_effective
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20210302174443.514363-4-imbrenda@linux.ibm.com
[borntraeger@de.ibm.com: apply fixup from Claudio]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/vsie.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 93 insertions(+), 5 deletions(-)

--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -417,11 +417,6 @@ static void unshadow_scb(struct kvm_vcpu
 		memcpy((void *)((u64)scb_o + 0xc0),
 		       (void *)((u64)scb_s + 0xc0), 0xf0 - 0xc0);
 		break;
-	case ICPT_PARTEXEC:
-		/* MVPG only */
-		memcpy((void *)((u64)scb_o + 0xc0),
-		       (void *)((u64)scb_s + 0xc0), 0xd0 - 0xc0);
-		break;
 	}
 
 	if (scb_s->ihcpu != 0xffffU)
@@ -984,6 +979,95 @@ static int handle_stfle(struct kvm_vcpu
 }
 
 /*
+ * Get a register for a nested guest.
+ * @vcpu the vcpu of the guest
+ * @vsie_page the vsie_page for the nested guest
+ * @reg the register number, the upper 4 bits are ignored.
+ * returns: the value of the register.
+ */
+static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, u8 reg)
+{
+	/* no need to validate the parameter and/or perform error handling */
+	reg &= 0xf;
+	switch (reg) {
+	case 15:
+		return vsie_page->scb_s.gg15;
+	case 14:
+		return vsie_page->scb_s.gg14;
+	default:
+		return vcpu->run->s.regs.gprs[reg];
+	}
+}
+
+static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+{
+	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	unsigned long pei_dest, pei_src, src, dest, mask;
+	u64 *pei_block = &vsie_page->scb_o->mcic;
+	int edat, rc_dest, rc_src;
+	union ctlreg0 cr0;
+
+	cr0.val = vcpu->arch.sie_block->gcr[0];
+	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
+	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
+
+	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
+	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
+
+	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
+	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
+	/*
+	 * Either everything went well, or something non-critical went wrong
+	 * e.g. because of a race. In either case, simply retry.
+	 */
+	if (rc_dest == -EAGAIN || rc_src == -EAGAIN || (!rc_dest && !rc_src)) {
+		retry_vsie_icpt(vsie_page);
+		return -EAGAIN;
+	}
+	/* Something more serious went wrong, propagate the error */
+	if (rc_dest < 0)
+		return rc_dest;
+	if (rc_src < 0)
+		return rc_src;
+
+	/* The only possible suppressing exception: just deliver it */
+	if (rc_dest == PGM_TRANSLATION_SPEC || rc_src == PGM_TRANSLATION_SPEC) {
+		clear_vsie_icpt(vsie_page);
+		rc_dest = kvm_s390_inject_program_int(vcpu, PGM_TRANSLATION_SPEC);
+		WARN_ON_ONCE(rc_dest);
+		return 1;
+	}
+
+	/*
+	 * Forward the PEI intercept to the guest if it was a page fault, or
+	 * also for segment and region table faults if EDAT applies.
+	 */
+	if (edat) {
+		rc_dest = rc_dest == PGM_ASCE_TYPE ? rc_dest : 0;
+		rc_src = rc_src == PGM_ASCE_TYPE ? rc_src : 0;
+	} else {
+		rc_dest = rc_dest != PGM_PAGE_TRANSLATION ? rc_dest : 0;
+		rc_src = rc_src != PGM_PAGE_TRANSLATION ? rc_src : 0;
+	}
+	if (!rc_dest && !rc_src) {
+		pei_block[0] = pei_dest;
+		pei_block[1] = pei_src;
+		return 1;
+	}
+
+	retry_vsie_icpt(vsie_page);
+
+	/*
+	 * The host has edat, and the guest does not, or it was an ASCE type
+	 * exception. The host needs to inject the appropriate DAT interrupts
+	 * into the guest.
+	 */
+	if (rc_dest)
+		return inject_fault(vcpu, rc_dest, dest, 1);
+	return inject_fault(vcpu, rc_src, src, 0);
+}
+
+/*
  * Run the vsie on a shadow scb and a shadow gmap, without any further
  * sanity checks, handling SIE faults.
  *
@@ -1071,6 +1155,10 @@ static int do_vsie_run(struct kvm_vcpu *
 		if ((scb_s->ipa & 0xf000) != 0xf000)
 			scb_s->ipa += 0x1000;
 		break;
+	case ICPT_PARTEXEC:
+		if (scb_s->ipa == 0xb254)
+			rc = vsie_handle_mvpg(vcpu, vsie_page);
+		break;
 	}
 	return rc;
 }


