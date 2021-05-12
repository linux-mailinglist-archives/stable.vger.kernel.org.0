Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF3537C734
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhELP7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237732AbhELP4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E15D61965;
        Wed, 12 May 2021 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833296;
        bh=uCDtPvIg+BF7+DW/tFxwiAw8EJ22Uf6nOmsMa7kCj8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMPh8jCAJVVnQNQDqfFlSi2BxKtyUAF521S+O/+K5tZl1gEigZfrZYpMex8Aoh/Lo
         Nl9vGnp0DaHSNSfkv2RD4g6aFtAd8yRb8jAkhwZBehaQhjK6V+xsLDnml4fNDi76/8
         qfc3rJ3rRWEKKN59HFgwTi+/wyhMf2ZwEw5jjXME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.11 093/601] KVM: s390: VSIE: fix MVPG handling for prefixing and MSO
Date:   Wed, 12 May 2021 16:42:50 +0200
Message-Id: <20210512144830.894055249@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit c3171e94cc1cdcc3229565244112e869f052b8d9 upstream.

Prefixing needs to be applied to the guest real address to translate it
into a guest absolute address.

The value of MSO needs to be added to a guest-absolute address in order to
obtain the host-virtual.

Fixes: bdf7509bbefa ("s390/kvm: VSIE: correctly handle MVPG when in VSIE")
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210322140559.500716-3-imbrenda@linux.ibm.com
[borntraeger@de.ibm.com simplify mso]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/vsie.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1001,7 +1001,7 @@ static u64 vsie_get_register(struct kvm_
 static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
-	unsigned long pei_dest, pei_src, src, dest, mask;
+	unsigned long pei_dest, pei_src, src, dest, mask, prefix;
 	u64 *pei_block = &vsie_page->scb_o->mcic;
 	int edat, rc_dest, rc_src;
 	union ctlreg0 cr0;
@@ -1009,9 +1009,12 @@ static int vsie_handle_mvpg(struct kvm_v
 	cr0.val = vcpu->arch.sie_block->gcr[0];
 	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
 	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
+	prefix = scb_s->prefix << GUEST_PREFIX_SHIFT;
 
 	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
+	dest = _kvm_s390_real_to_abs(prefix, dest) + scb_s->mso;
 	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
+	src = _kvm_s390_real_to_abs(prefix, src) + scb_s->mso;
 
 	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
 	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);


