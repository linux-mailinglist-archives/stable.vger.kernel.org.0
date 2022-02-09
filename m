Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC964AF769
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 18:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbiBIRAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 12:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237572AbiBIRAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 12:00:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1A6FC05CB87
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 09:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jEqL6PLWr+bZ/5j2l/zElDfsDQbZUnnUlRxHORnTr6s=;
        b=Zd38iQXli3SjDNZ8sm5D3dGPZJTQrZDipm2aIlGOKhq4SQEqJnAo2Vm41tCKKICYfcrFkZ
        iljyTFYhSqVk6TSqeqqZoEQCrsKE0g/u5xPmfFyV78gIirCoLm+RqrfEr792naiar7rsYF
        iJgge2EVE79XKDuUnEiOtjlciEszTh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-YSjKLW7EP7yxonBU0a_7RQ-1; Wed, 09 Feb 2022 12:00:42 -0500
X-MC-Unique: YSjKLW7EP7yxonBU0a_7RQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 649588145E2;
        Wed,  9 Feb 2022 17:00:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B5657D499;
        Wed,  9 Feb 2022 17:00:29 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 01/12] KVM: x86: host-initiated EFER.LME write affects the MMU
Date:   Wed,  9 Feb 2022 12:00:09 -0500
Message-Id: <20220209170020.1775368-2-pbonzini@redhat.com>
In-Reply-To: <20220209170020.1775368-1-pbonzini@redhat.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 9a9006226501..5e1298aef9e2 100644
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


