Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B975437A07
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 17:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhJVPiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 11:38:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233412AbhJVPip (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 11:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634916987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHs/roEsMIo6oJ4XRHlQKJ4vy6z/ppTluv1DuTYqU2M=;
        b=isrnXx5su1uBH531GYcWXxkcDPxtr7nwD7RIWVtOSvS4330OTFzSrDfr2MxeGtae2MGtfX
        f/t3qKxhnAFVghKDp6G1+hP1XK8mReAYW9wqOOKWKG94f+R7lCyTu+mkNeqIujnaXexhSK
        pAw9MaVenzp5x4PP1OcReaUXC0uY3f8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-26XN51qpN-mKrV-CEOtPTA-1; Fri, 22 Oct 2021 11:36:23 -0400
X-MC-Unique: 26XN51qpN-mKrV-CEOtPTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 953951006AA3;
        Fri, 22 Oct 2021 15:36:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 226B560C04;
        Fri, 22 Oct 2021 15:36:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 01/13] KVM: SEV-ES: rename guest_ins_data to sev_pio_data
Date:   Fri, 22 Oct 2021 11:36:04 -0400
Message-Id: <20211022153616.1722429-2-pbonzini@redhat.com>
In-Reply-To: <20211022153616.1722429-1-pbonzini@redhat.com>
References: <20211022153616.1722429-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We will be using this field for OUTS emulation as well, in case the
data that is pushed via OUTS spans more than one page.  In that case,
there will be a need to save the data pointer across exits to userspace.

So, change the name to something that refers to any kind of PIO.
Also spell out what it is used for, namely SEV-ES.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.c              | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..6bed6c416c6c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -702,7 +702,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_pio_request pio;
 	void *pio_data;
-	void *guest_ins_data;
+	void *sev_pio_data;
 
 	u8 event_exit_inst_len;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 381384a54790..379175b725a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12370,7 +12370,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
 static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 {
-	memcpy(vcpu->arch.guest_ins_data, vcpu->arch.pio_data,
+	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
 	       vcpu->arch.pio.count * vcpu->arch.pio.size);
 	vcpu->arch.pio.count = 0;
 
@@ -12402,7 +12402,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 	if (ret) {
 		vcpu->arch.pio.count = 0;
 	} else {
-		vcpu->arch.guest_ins_data = data;
+		vcpu->arch.sev_pio_data = data;
 		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
 	}
 
-- 
2.27.0


