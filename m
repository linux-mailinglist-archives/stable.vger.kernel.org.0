Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801DC5907BD
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 23:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbiHKVGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 17:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbiHKVGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 17:06:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F71A78BED
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 14:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660251969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+LAQ3UWyhcCOdQwv4ps8HwWuKgNTwvufANeP1Ktgs0w=;
        b=Xx9amVxFHP9UwLDm2678bCcPdTo0Oans9S6m406+jzvs9rc0pBVzduwaCDx0kwY0jhLeXT
        eIF7T1QskGe/+5kILeu7kIHLW9IiGDKU95bwdXHSN8qn/H4uQgBRAFOlrZGd480mkZ5R/S
        nHXg1ZbL6jwKGO0NGEz/t0ytSb7SjeE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-MZ3uhukuNoGJY9QJMice3w-1; Thu, 11 Aug 2022 17:06:08 -0400
X-MC-Unique: MZ3uhukuNoGJY9QJMice3w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A51B7800124;
        Thu, 11 Aug 2022 21:06:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79F78492C3B;
        Thu, 11 Aug 2022 21:06:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, vkuznets@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH v2 7/9] KVM: nVMX: Make an event request when pending an MTF nested VM-Exit
Date:   Thu, 11 Aug 2022 17:06:03 -0400
Message-Id: <20220811210605.402337-8-pbonzini@redhat.com>
In-Reply-To: <20220811210605.402337-1-pbonzini@redhat.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Set KVM_REQ_EVENT when MTF becomes pending to ensure that KVM will run
through inject_pending_event() and thus vmx_check_nested_events() prior
to re-entering the guest.

MTF currently works by virtue of KVM's hack that calls
kvm_check_nested_events() from kvm_vcpu_running(), but that hack will
be removed in the near future.  Until that call is removed, the patch
introduces no functional change.

Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..940c0c0f8281 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1660,10 +1660,12 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 	 */
 	if (nested_cpu_has_mtf(vmcs12) &&
 	    (!vcpu->arch.exception.pending ||
-	     vcpu->arch.exception.nr == DB_VECTOR))
+	     vcpu->arch.exception.nr == DB_VECTOR)) {
 		vmx->nested.mtf_pending = true;
-	else
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	} else {
 		vmx->nested.mtf_pending = false;
+	}
 }
 
 static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
-- 
2.31.1


