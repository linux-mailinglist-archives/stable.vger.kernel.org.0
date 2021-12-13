Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECDC47269F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhLMJxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:53:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234093AbhLMJuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639389019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KDYQOwQx4rZacCg3r7QLOnuW80bM6mm0dkDvri3LFO8=;
        b=AgoKjKglgnVMfnXoydf+Ml7wQ/i/znaVQ1CmUM7GMILK5EDzaGxFpnqEyFY/yoBfJFwN4x
        ZkHCCyLmGY0it6FIfY2rrWCAWCtt/cSg1BOHmEq70qj/GlE2ELof+2xEMNYg0269OAmOks
        3z+yZ1jyVW2OeFBEbuBlSYqLloDmyz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-x0LyZ0OaMz6JG9zJ-VFRXw-1; Mon, 13 Dec 2021 04:50:15 -0500
X-MC-Unique: x0LyZ0OaMz6JG9zJ-VFRXw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF187874981;
        Mon, 13 Dec 2021 09:50:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 578335D6BA;
        Mon, 13 Dec 2021 09:50:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        gregkh@linuxfoundation.org
Subject: [PATCH 5.10] KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI req
Date:   Mon, 13 Dec 2021 10:50:12 +0100
Message-Id: <20211213095012.15021-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 3244867af8c065e51969f1bffe732d3ebfd9a7d2 upstream.

Do not bail early if there are no bits set in the sparse banks for a
non-sparse, a.k.a. "all CPUs", IPI request.  Per the Hyper-V spec, it is
legal to have a variable length of '0', e.g. VP_SET's BankContents in
this case, if the request can be serviced without the extra info.

  It is possible that for a given invocation of a hypercall that does
  accept variable sized input headers that all the header input fits
  entirely within the fixed size header. In such cases the variable sized
  input header is zero-sized and the corresponding bits in the hypercall
  input should be set to zero.

Bailing early results in KVM failing to send IPIs to all CPUs as expected
by the guest.

Fixes: 214ff83d4473 ("KVM: x86: hyperv: implement PV IPI send hypercalls")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211207220926.718794-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bb39f493447c..328f37e4fd3a 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1641,11 +1641,13 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
 		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
 
+		if (all_cpus)
+			goto check_and_send_ipi;
+
 		if (!sparse_banks_len)
 			goto ret_success;
 
-		if (!all_cpus &&
-		    kvm_read_guest(kvm,
+		if (kvm_read_guest(kvm,
 				   ingpa + offsetof(struct hv_send_ipi_ex,
 						    vp_set.bank_contents),
 				   sparse_banks,
@@ -1653,6 +1655,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 	}
 
+check_and_send_ipi:
 	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
-- 
2.33.1

