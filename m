Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CDF42C6FE
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbhJMQ6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:58:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55346 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237825AbhJMQ61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 12:58:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634144183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9uwP/nwAtEFa6z4MrxowW/5B4HvdWDmDYGDyC1ao/UM=;
        b=DMQx0Wo7X8Qm+nLvhmveu47/Ee0hBf3JIgAmais6G8yezBK57ff0+tX7zHZcG97PMsXzX9
        iCsLZWMG4fMFFHDfKzpMvwYqfRnB7JT13TEW9zbjCF2nQlK9+lCBwSxBl//ibXykktfbeL
        pck4MS0ARNCNSd2EzKD9DijgjKo2in8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-WTMj3aW6MRiiPmvTx2VBHQ-1; Wed, 13 Oct 2021 12:56:20 -0400
X-MC-Unique: WTMj3aW6MRiiPmvTx2VBHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA74810A8E00;
        Wed, 13 Oct 2021 16:56:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39D855DA60;
        Wed, 13 Oct 2021 16:56:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Subject: [PATCH 2/8] KVM: SEV-ES: rename guest_ins_data to sev_pio_data
Date:   Wed, 13 Oct 2021 12:56:10 -0400
Message-Id: <20211013165616.19846-3-pbonzini@redhat.com>
In-Reply-To: <20211013165616.19846-1-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since we will be using this for OUTS emulation as well, change the name to
something that refers to any kind of PIO.  Also spell out what it is used
for, namely SEV-ES.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
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
index aabd3a2ec1bc..722f5fcf76e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12369,7 +12369,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
 static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 {
-	memcpy(vcpu->arch.guest_ins_data, vcpu->arch.pio_data,
+	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
 	       vcpu->arch.pio.count * vcpu->arch.pio.size);
 	vcpu->arch.pio.count = 0;
 
@@ -12401,7 +12401,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 	if (ret) {
 		vcpu->arch.pio.count = 0;
 	} else {
-		vcpu->arch.guest_ins_data = data;
+		vcpu->arch.sev_pio_data = data;
 		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
 	}
 
-- 
2.27.0


