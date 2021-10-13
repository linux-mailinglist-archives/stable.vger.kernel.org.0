Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE2742C6F2
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbhJMQ6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:58:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237782AbhJMQ60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 12:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634144182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttIAkGSptCBgBNcRMAAwBhA9MZKVi2/uSD/1xXfL/jU=;
        b=c7SpRU1eH/Vsf+BtDAvyiD1upqgj6pvtKydZ7AqThBCt7LY/EjegEp6jtYlrt8BM+81GNt
        qmepLhgyokfyiLJXR3vOHV7096+1jPaPEsDAF1sKyfOYtsHUY45QaxuOmewuYnFrS+hmGz
        /lAz4YZ8kLF//0Zc/VrSTYBLooibZVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-ZzMVoAZ0Pmi_kI18OAKRHg-1; Wed, 13 Oct 2021 12:56:21 -0400
X-MC-Unique: ZzMVoAZ0Pmi_kI18OAKRHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F384C801AA7;
        Wed, 13 Oct 2021 16:56:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7662AADC5;
        Wed, 13 Oct 2021 16:56:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Subject: [PATCH 4/8] KVM: SEV-ES: clean up kvm_sev_es_ins/outs
Date:   Wed, 13 Oct 2021 12:56:12 -0400
Message-Id: <20211013165616.19846-5-pbonzini@redhat.com>
In-Reply-To: <20211013165616.19846-1-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove the data argument and pull setting vcpu->arch.sev_pio_data into
the caller; remove unnecessary clearing of vcpu->arch.pio.count when
emulation is done by the kernel.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 218877e297e5..8880dc36a2b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12382,34 +12382,32 @@ static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 }
 
 static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
-			   unsigned int port, void *data,  unsigned int count)
+			   unsigned int port, unsigned int count)
 {
-	int ret;
+	int ret = emulator_pio_out(vcpu, size, port,
+				   vcpu->arch.sev_pio_data, count);
 
-	ret = emulator_pio_out_emulated(vcpu->arch.emulate_ctxt, size, port,
-					data, count);
-	if (ret)
+	if (ret) {
+		/* Emulation done by the kernel.  */
 		return ret;
+	}
 
 	vcpu->arch.pio.count = 0;
-
 	return 0;
 }
 
 static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
-			  unsigned int port, void *data, unsigned int count)
+			  unsigned int port, unsigned int count)
 {
-	int ret;
+	int ret = emulator_pio_in(vcpu, size, port,
+				  vcpu->arch.sev_pio_data, count);
 
-	ret = emulator_pio_in_emulated(vcpu->arch.emulate_ctxt, size, port,
-				       data, count);
 	if (ret) {
-		vcpu->arch.pio.count = 0;
-	} else {
-		vcpu->arch.sev_pio_data = data;
-		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
+		/* Emulation done by the kernel.  */
+		return ret;
 	}
 
+	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
 	return 0;
 }
 
@@ -12417,8 +12415,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in)
 {
-	return in ? kvm_sev_es_ins(vcpu, size, port, data, count)
-		  : kvm_sev_es_outs(vcpu, size, port, data, count);
+	vcpu->arch.sev_pio_data = data;
+	return in ? kvm_sev_es_ins(vcpu, size, port, count)
+		  : kvm_sev_es_outs(vcpu, size, port, count);
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
-- 
2.27.0


