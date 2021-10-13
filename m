Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C0542C6F8
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbhJMQ6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:58:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237473AbhJMQ6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 12:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634144186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyDHERJ+Bp1/cN7FG3NOZsPViXmjFPmdmo0r3sgpXm8=;
        b=e/6duPPWFLrMjXaPYoYiVzgox/KJBbz/jJGN7wEc3SLWvMuSCxACbjnR4H0W7W+7vVqJdM
        4Dv+cOLwStx72Ftxmc16IGgJAxvD8fyxRuHQif49slRhACAiUCHqysvmuPcJz51n5Cc9ng
        XKihkMN0A3CLIvmBbqvCl90sDMkbcYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-2sf0StUlObKJPSKe0u69Ag-1; Wed, 13 Oct 2021 12:56:23 -0400
X-MC-Unique: 2sf0StUlObKJPSKe0u69Ag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0C82804B6C;
        Wed, 13 Oct 2021 16:56:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5519B5DA60;
        Wed, 13 Oct 2021 16:56:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Subject: [PATCH 7/8] KVM: SEV-ES: keep INS functions together
Date:   Wed, 13 Oct 2021 12:56:15 -0400
Message-Id: <20211013165616.19846-8-pbonzini@redhat.com>
In-Reply-To: <20211013165616.19846-1-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make the diff a little nicer when we actually get to fixing
the bug.  No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ef4d6a0de4d8..a485e185ad00 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12377,15 +12377,6 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
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
@@ -12401,6 +12392,15 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
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


