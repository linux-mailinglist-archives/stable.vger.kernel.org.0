Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA7F4BAB63
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 22:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243716AbiBQVEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 16:04:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbiBQVEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 16:04:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD048606C0
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 13:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G/CPDOAT8bzl2lNB0wAlIxIvLWdbJ2Gig5UCTwUtGwg=;
        b=UvMOXQgg9CibfA+RLNy5R88m5znrmJNtlNuBXT0e6P+/gn96zXpCK3+E436hX4llGbf5GO
        k1ZhcsFSt5jLTuDWumWJxXw/l4OBbqtbPxpxNJGYRdFWawiBl1nE1aiwZinxbROhl43wRe
        7GnPGSes3KXY0afKpM0oINlqJOza/BI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-f527QjhrOGCw6lnX8liIuA-1; Thu, 17 Feb 2022 16:03:43 -0500
X-MC-Unique: f527QjhrOGCw6lnX8liIuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A0672F4A;
        Thu, 17 Feb 2022 21:03:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A148546982;
        Thu, 17 Feb 2022 21:03:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH v2 01/18] KVM: x86: host-initiated EFER.LME write affects the MMU
Date:   Thu, 17 Feb 2022 16:03:23 -0500
Message-Id: <20220217210340.312449-2-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While the guest runs, EFER.LME cannot change unless CR0.PG is clear, and therefore
EFER.NX is the only bit that can affect the MMU role.  However, set_efer accepts
a host-initiated change to EFER.LME even with CR0.PG=1.  In that case, the
MMU has to be reset.

Fixes: 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h | 1 +
 arch/x86/kvm/x86.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 51faa2c76ca5..a5a50cfeffff 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -48,6 +48,7 @@
 			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE)
 
 #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
+#define KVM_MMU_EFER_ROLE_BITS (EFER_LME | EFER_NX)
 
 static __always_inline u64 rsvd_bits(int s, int e)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3da64106685..99a58c25f5c2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1647,7 +1647,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	}
 
 	/* Update reserved bits */
-	if ((efer ^ old_efer) & EFER_NX)
+	if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
 
 	return 0;
-- 
2.31.1


