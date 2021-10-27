Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4315B43CCE2
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 16:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhJ0PB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 11:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237486AbhJ0PB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 11:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635346771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dmMAXlBbydUPcO3WhWZ8PkBNlDfdb7R7qupK88yQ1m8=;
        b=ccimaOP9JQjTK3gvp7cSQWnquAdZ/tutxffC2Qd+QSvBfMEKhKxqLzbhoiLaVx2TcSCpdN
        8T+Ygz1CBCku9gJIU3M0NeiByVbLvO07mv65u9AtJLMxcq9+x/5H11RYKJ7DPwYucRjZI8
        F9hBQF5Tqq9Ih3I60Wgd/189RA51hzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-E56qGJLRP3erriuCDy46wA-1; Wed, 27 Oct 2021 10:59:28 -0400
X-MC-Unique: E56qGJLRP3erriuCDy46wA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43C2910B3942;
        Wed, 27 Oct 2021 14:59:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D065060862;
        Wed, 27 Oct 2021 14:59:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Marc Orr <marcorr@google.com>
Subject: [PATCH] KVM: SEV-ES: fix another issue with string I/O VMGEXITs
Date:   Wed, 27 Oct 2021 10:59:26 -0400
Message-Id: <20211027145926.2873481-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the guest requests string I/O from the hypervisor via VMGEXIT,
SW_EXITINFO2 will contain the REP count.  However, sev_es_string_io
was incorrectly treating it as the size of the GHCB buffer in
bytes.

This fixes the "outsw" test in the experimental SEV tests of
kvm-unit-tests.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reported-by: Marc Orr <marcorr@google.com>
Tested-by: Marc Orr <marcorr@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e672493b5d8d..efd207fd335e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2579,11 +2579,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 {
-	if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
+	int count;
+	int bytes;
+
+	if (svm->vmcb->control.exit_info_2 > INT_MAX)
+		return -EINVAL;
+
+	count = svm->vmcb->control.exit_info_2;
+	if (unlikely(check_mul_overflow(count, size, &bytes)))
+		return -EINVAL;
+
+	if (!setup_vmgexit_scratch(svm, in, bytes))
 		return -EINVAL;
 
-	return kvm_sev_es_string_io(&svm->vcpu, size, port,
-				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
+	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->ghcb_sa, count, in);
 }
 
 void sev_es_init_vmcb(struct vcpu_svm *svm)
-- 
2.27.0

