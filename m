Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F03434E45
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 16:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhJTOyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 10:54:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230106AbhJTOyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 10:54:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634741557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/0QdtGs1Fi//iyAjGxBqoRG5ALBbtyYEvUdrZuMLfmw=;
        b=C9Hil81L9Q7w40TClPy28Bpx9DTOfwJWO6KR6/5Fv3EAAq/5Dke+MLuw0lT0lU8HFdHWcU
        yPwHTcxSe2N0bzvzIftPurku4M+wguS/vrYxpXDE2IdiRD5SJKf01FscWLhDdCt2wMzCyw
        Ievzi1hHdJfe0R+LSQRpPUvNYnupomM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-jlrZb7J6Na6JSbDYuZLiPg-1; Wed, 20 Oct 2021 10:52:33 -0400
X-MC-Unique: jlrZb7J6Na6JSbDYuZLiPg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74ABB8066F3;
        Wed, 20 Oct 2021 14:52:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAB6E5C1D5;
        Wed, 20 Oct 2021 14:52:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH] KVM: x86: check for interrupts before deciding whether to exit the fast path
Date:   Wed, 20 Oct 2021 10:52:29 -0400
Message-Id: <20211020145231.871299-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The kvm_x86_sync_pir_to_irr callback can sometimes set KVM_REQ_EVENT.
If that happens exactly at the time that an exit is handled as
EXIT_FASTPATH_REENTER_GUEST, vcpu_enter_guest will go incorrectly
through the loop that calls kvm_x86_run, instead of processing
the request promptly.

Fixes: 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt delivery for timer fastpath")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa48948b4934..b9b31e5f72b0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9781,14 +9781,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
-                if (unlikely(kvm_vcpu_exit_request(vcpu))) {
+		if (vcpu->arch.apicv_active)
+			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+
+		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
 			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
 			break;
 		}
-
-		if (vcpu->arch.apicv_active)
-			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
-        }
+	}
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And
-- 
2.27.0

