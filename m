Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F2E4F18B7
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 17:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378700AbiDDPqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 11:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378671AbiDDPqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 11:46:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D855ADAB
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 08:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649087038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/QV9nUjm9Dhjzm1SVnl9oHHaV7W0AS5z/nmRT3kPDuc=;
        b=K0fmp16IH3JO+uNKKalBkNbwvIZme12W4xZn6kW02O8rjE3YIZCJJZpkJoOMXbHWEOnmWL
        V2nR4FEGRC9BzVHFl9RLjspHgdAF6cPxBU/eq76AbCccB4gq4JggPxMGYeyeXRvwMMHLUl
        0pH0XrTrCoMbfppugPtVe3r4e4dWUYc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-CactOFbjN3KfUqFd7fyFZg-1; Mon, 04 Apr 2022 11:43:55 -0400
X-MC-Unique: CactOFbjN3KfUqFd7fyFZg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCC551C068D4;
        Mon,  4 Apr 2022 15:43:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 425FB145BEF8;
        Mon,  4 Apr 2022 15:43:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 4.19] KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated
Date:   Mon,  4 Apr 2022 11:43:50 -0400
Message-Id: <20220404154352.477059-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit b1e34d325397a33d97d845e312d7cf2a8b646b44 upstream.

Setting non-zero values to SYNIC/STIMER MSRs activates certain features,
this should not happen when KVM_CAP_HYPERV_SYNIC{,2} was not activated.

Note, it would've been better to forbid writing anything to SYNIC/STIMER
MSRs, including zeroes, however, at least QEMU tries clearing
HV_X64_MSR_STIMER0_CONFIG without SynIC. HV_X64_MSR_EOM MSR is somewhat
'special' as writing zero there triggers an action, this also should not
happen when SynIC wasn't activated.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220325132140.25650-4-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/hyperv.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 01d209ab5481..d54c24b88782 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -235,7 +235,7 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
 	int ret;
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || data))
 		return 1;
 
 	trace_kvm_hv_synic_set_msr(vcpu->vcpu_id, msr, data, host);
@@ -281,6 +281,9 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	case HV_X64_MSR_EOM: {
 		int i;
 
+		if (!synic->active)
+			break;
+
 		for (i = 0; i < ARRAY_SIZE(synic->sint); i++)
 			kvm_hv_notify_acked_sint(vcpu, i);
 		break;
@@ -542,6 +545,12 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
 static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 			     bool host)
 {
+	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+
+	if (!synic->active && (!host || config))
+		return 1;
+
 	trace_kvm_hv_stimer_set_config(stimer_to_vcpu(stimer)->vcpu_id,
 				       stimer->index, config, host);
 
@@ -556,6 +565,12 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 			    bool host)
 {
+	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+
+	if (!synic->active && (!host || count))
+		return 1;
+
 	trace_kvm_hv_stimer_set_count(stimer_to_vcpu(stimer)->vcpu_id,
 				      stimer->index, count, host);
 
-- 
2.31.1

