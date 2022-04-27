Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F982511D1F
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244145AbiD0RlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 13:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244166AbiD0RlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 13:41:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3354B41FB2
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 10:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651081083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NrnrIbR3L39VOrIgvRZkUaU80AMLT3lel5AFpVPIXhk=;
        b=IjDMRAAB1uIH0SzFGAUayoCmeqV7K2NfylLC2AFeJ/tWT84E3kTAwSRR5GKqhEU2xZgR5Z
        XcWYzCcrVwYRPv0RwkhEyXFzgmypCfgsMfGGyXOyDCX2hH2C+tI5z+6lnoocj+JAHiJFrB
        Kxkx5x9gqg3s52t+qIQGbzgbzAy9FZo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-YckeZTk2M4S3Fq1wKK3kTA-1; Wed, 27 Apr 2022 13:38:00 -0400
X-MC-Unique: YckeZTk2M4S3Fq1wKK3kTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F925802812;
        Wed, 27 Apr 2022 17:37:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 773C4407DEC3;
        Wed, 27 Apr 2022 17:37:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86: never write to memory from kvm_vcpu_check_block
Date:   Wed, 27 Apr 2022 13:37:58 -0400
Message-Id: <20220427173758.517087-4-pbonzini@redhat.com>
In-Reply-To: <20220427173758.517087-1-pbonzini@redhat.com>
References: <20220427173758.517087-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kvm_vcpu_check_block is called while not in TASK_RUNNING, and therefore
cannot sleep.  Writing to guest memory is therefore forbidden, but it
can happen if kvm_check_nested_events causes a vmexit.

Fortunately, all events that are caught by kvm_check_nested_events are
also handled by kvm_vcpu_has_events through vendor callbacks such as
kvm_x86_interrupt_allowed or kvm_x86_ops.nested_ops->has_events, so
remove the call.

Cc: stable@vger.kernel.org
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d563812ca229..90b4f50b9a84 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10341,9 +10341,6 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
-		kvm_check_nested_events(vcpu);
-
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
 }
-- 
2.31.1

