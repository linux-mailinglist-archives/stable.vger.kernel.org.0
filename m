Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A193437A18
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhJVPi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 11:38:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233509AbhJVPit (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 11:38:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71MZBzgsCVtvG92udOVm2WNEaszYSjduTe+CmRWx9Po=;
        b=BxjrEcsJ/CZKXtVBT7atW60zZ8iNBCxQsqT9RLQFhnlsJH/YjKcUIFUnRPZ4smPiy6CsJ2
        3hT/lj2cWnr06kcLFTTiXSAWavpR6BTGVb5Hz6c+wBZUfRIUkXIlL++tvX5RLWTDvXgyAa
        Wdp/hrpl2fKyvOxm1VX7/euJygcBcNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-zcUVdxkzNjKmuv2Y-DMtQg-1; Fri, 22 Oct 2021 11:36:26 -0400
X-MC-Unique: zcUVdxkzNjKmuv2Y-DMtQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62C278064D2;
        Fri, 22 Oct 2021 15:36:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E86DA60C04;
        Fri, 22 Oct 2021 15:36:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 06/13] KVM: SEV-ES: keep INS functions together
Date:   Fri, 22 Oct 2021 11:36:09 -0400
Message-Id: <20211022153616.1722429-7-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make the diff a little nicer when we actually get to fixing
the bug.  No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63f9cb33cc19..23e772412134 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12385,15 +12385,6 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
-static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
-{
-	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
-	       vcpu->arch.pio.count * vcpu->arch.pio.size);
-	vcpu->arch.pio.count = 0;
-
-	return 1;
-}
-
 static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 			   unsigned int port, unsigned int count)
 {
@@ -12409,6 +12400,15 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 	return 0;
 }
 
+static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
+{
+	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
+	       vcpu->arch.pio.count * vcpu->arch.pio.size);
+	vcpu->arch.pio.count = 0;
+
+	return 1;
+}
+
 static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 			  unsigned int port, unsigned int count)
 {
-- 
2.27.0


