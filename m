Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D21F1C3F21
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 17:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgEDP4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 11:56:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33584 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728967AbgEDP4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 11:56:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588607762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=OYHq7rOire7Ktnkt0RBpmRo6SGj1PKuzNi8M05DTLkI=;
        b=Ha6TXSR1dk5kDe0nJ5LEmY8b36E9yU4aMBtrvNrdwojjsMm+W5NzOL3BNsywf8ZHANjcR7
        h5IwIFBrdE5a4S6C/1zOxqJGkZcnlD5umQmqxIFuMcYsSnTOfHp7WOJAncBgocu0juS8gj
        HcovR8DeL6p0SvHstSLpd13Yn7l7khI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-FAE15sngPOCntJdqAkUTZg-1; Mon, 04 May 2020 11:56:00 -0400
X-MC-Unique: FAE15sngPOCntJdqAkUTZg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B279D800687;
        Mon,  4 May 2020 15:55:59 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D75F57990;
        Mon,  4 May 2020 15:55:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] KVM: SVM: fill in kvm_run->debug.arch.dr[67]
Date:   Mon,  4 May 2020 11:55:56 -0400
Message-Id: <20200504155558.401468-2-pbonzini@redhat.com>
In-Reply-To: <20200504155558.401468-1-pbonzini@redhat.com>
References: <20200504155558.401468-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The corresponding code was added for VMX in commit 42dbaa5a057
("KVM: x86: Virtualize debug registers, 2008-12-15) but never for AMD.
Fix this.

Cc: stable@vger.kernel.org
Fixes: 42dbaa5a057 ("KVM: x86: Virtualize debug registers")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8447ceb02c74..dbcf4198a9fe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1732,6 +1732,8 @@ static int db_interception(struct vcpu_svm *svm)
 	if (svm->vcpu.guest_debug &
 	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) {
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
+		kvm_run->debug.arch.dr6 = svm->vmcb->save.dr6;
+		kvm_run->debug.arch.dr7 = svm->vmcb->save.dr7;
 		kvm_run->debug.arch.pc =
 			svm->vmcb->save.cs.base + svm->vmcb->save.rip;
 		kvm_run->debug.arch.exception = DB_VECTOR;
-- 
2.18.2


