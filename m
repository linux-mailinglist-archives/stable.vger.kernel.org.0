Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0469A53ED95
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 20:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiFFSJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 14:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiFFSI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 14:08:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3D981E7158
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654538934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ouDcIYJZnuwxcggSN3JWhIbWktPsI+ueJ4oKyyKY60=;
        b=Ei+2ZnCtPPpfiC2lFmaR/UjtnX9MxoOigxL2z6lXAT1GS69+289VKkvKzl/lfAVOij/Nwe
        l0WTcCu+20vKNssbZjXkc3OvWg2XxgOoThmxtNcItKtzMC5lq2jCsgWYWneUCucChZ/ilH
        SkPpmhJbp0f5OTtACZMENrBMWbPe/2Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-295CEvSJM7-w7nt7JRQBvg-1; Mon, 06 Jun 2022 14:08:50 -0400
X-MC-Unique: 295CEvSJM7-w7nt7JRQBvg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E56C81010368;
        Mon,  6 Jun 2022 18:08:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BDEA1121314;
        Mon,  6 Jun 2022 18:08:46 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 4/7] KVM: x86: SVM: fix avic_kick_target_vcpus_fast
Date:   Mon,  6 Jun 2022 21:08:26 +0300
Message-Id: <20220606180829.102503-5-mlevitsk@redhat.com>
In-Reply-To: <20220606180829.102503-1-mlevitsk@redhat.com>
References: <20220606180829.102503-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are two issues in avic_kick_target_vcpus_fast

1. It is legal to issue an IPI request with APIC_DEST_NOSHORT
   and a physical destination of 0xFF (or 0xFFFFFFFF in case of x2apic),
   which must be treated as a broadcast destination.

   Fix this by explicitly checking for it.
   Also don’t use ‘index’ in this case as it gives no new information.

2. It is legal to issue a logical IPI request to more than one target.
   Index field only provides index in physical id table of first
   such target and therefore can't be used before we are sure
   that only a single target was addressed.

   Instead, parse the ICRL/ICRH, double check that a unicast interrupt
   was requested, and use that info to figure out the physical id
   of the target vCPU.
   At that point there is no need to use the index field as well.


In addition to fixing the above	issues,	also skip the call to
kvm_apic_match_dest.

It is possible to do this now, because now as long as AVIC is not
inhibited, it is guaranteed that none of the vCPUs changed their
apic id from its default value.


This fixes boot of windows guest with AVIC enabled because it uses
IPI with 0xFF destination and no destination shorthand.

Fixes: 7223fd2d5338 ("KVM: SVM: Use target APIC ID to complete AVIC IRQs when possible")
Cc: stable@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 105 ++++++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 072e2c8cc66aa..5d98ac575dedc 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -291,58 +291,91 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
 static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source,
 				       u32 icrl, u32 icrh, u32 index)
 {
-	u32 dest, apic_id;
-	struct kvm_vcpu *vcpu;
+	u32 l1_physical_id, dest;
+	struct kvm_vcpu *target_vcpu;
 	int dest_mode = icrl & APIC_DEST_MASK;
 	int shorthand = icrl & APIC_SHORT_MASK;
 	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
-	u32 *avic_logical_id_table = page_address(kvm_svm->avic_logical_id_table_page);
 
 	if (shorthand != APIC_DEST_NOSHORT)
 		return -EINVAL;
 
-	/*
-	 * The AVIC incomplete IPI #vmexit info provides index into
-	 * the physical APIC ID table, which can be used to derive
-	 * guest physical APIC ID.
-	 */
+	if (apic_x2apic_mode(source))
+		dest = icrh;
+	else
+		dest = GET_APIC_DEST_FIELD(icrh);
+
 	if (dest_mode == APIC_DEST_PHYSICAL) {
-		apic_id = index;
+		/* broadcast destination, use slow path */
+		if (apic_x2apic_mode(source) && dest == X2APIC_BROADCAST)
+			return -EINVAL;
+		if (!apic_x2apic_mode(source) && dest == APIC_BROADCAST)
+			return -EINVAL;
+
+		l1_physical_id = dest;
+
+		if (WARN_ON_ONCE(l1_physical_id != index))
+			return -EINVAL;
+
 	} else {
-		if (!apic_x2apic_mode(source)) {
-			/* For xAPIC logical mode, the index is for logical APIC table. */
-			apic_id = avic_logical_id_table[index] & 0x1ff;
+		u32 bitmap, cluster;
+		int logid_index;
+
+		if (apic_x2apic_mode(source)) {
+			/* 16 bit dest mask, 16 bit cluster id */
+			bitmap = dest & 0xFFFF0000;
+			cluster = (dest >> 16) << 4;
+		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
+			/* 8 bit dest mask*/
+			bitmap = dest;
+			cluster = 0;
 		} else {
-			return -EINVAL;
+			/* 4 bit desk mask, 4 bit cluster id */
+			bitmap = dest & 0xF;
+			cluster = (dest >> 4) << 2;
 		}
-	}
 
-	/*
-	 * Assuming vcpu ID is the same as physical apic ID,
-	 * and use it to retrieve the target vCPU.
-	 */
-	vcpu = kvm_get_vcpu_by_id(kvm, apic_id);
-	if (!vcpu)
-		return -EINVAL;
+		if (unlikely(!bitmap))
+			/* guest bug: nobody to send the logical interrupt to */
+			return 0;
 
-	if (apic_x2apic_mode(vcpu->arch.apic))
-		dest = icrh;
-	else
-		dest = GET_APIC_DEST_FIELD(icrh);
+		if (!is_power_of_2(bitmap))
+			/* multiple logical destinations, use slow path */
+			return -EINVAL;
 
-	/*
-	 * Try matching the destination APIC ID with the vCPU.
-	 */
-	if (kvm_apic_match_dest(vcpu, source, shorthand, dest, dest_mode)) {
-		vcpu->arch.apic->irr_pending = true;
-		svm_complete_interrupt_delivery(vcpu,
-						icrl & APIC_MODE_MASK,
-						icrl & APIC_INT_LEVELTRIG,
-						icrl & APIC_VECTOR_MASK);
-		return 0;
+		logid_index = cluster + __ffs(bitmap);
+
+		if (apic_x2apic_mode(source)) {
+			l1_physical_id = logid_index;
+		} else {
+			u32 *avic_logical_id_table =
+				page_address(kvm_svm->avic_logical_id_table_page);
+
+			u32 logid_entry = avic_logical_id_table[logid_index];
+
+			if (WARN_ON_ONCE(index != logid_index))
+				return -EINVAL;
+
+			/* guest bug: non existing/reserved logical destination */
+			if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
+				return 0;
+
+			l1_physical_id = logid_entry &
+					 AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
+		}
 	}
 
-	return -EINVAL;
+	target_vcpu = kvm_get_vcpu_by_id(kvm, l1_physical_id);
+	if (unlikely(!target_vcpu))
+		/* guest bug: non existing vCPU is a target of this IPI*/
+		return 0;
+
+	target_vcpu->arch.apic->irr_pending = true;
+	svm_complete_interrupt_delivery(target_vcpu,
+					icrl & APIC_MODE_MASK,
+					icrl & APIC_INT_LEVELTRIG,
+					icrl & APIC_VECTOR_MASK);
+	return 0;
 }
 
 static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
-- 
2.26.3

