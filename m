Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C496DEF76
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjDLIvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjDLIvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846C79EC9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7DC36311A
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6FBC4339B;
        Wed, 12 Apr 2023 08:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289436;
        bh=qLaI2HZOKZjOQmZjWHIXapXNy83pMiq813rBb64/TnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzL90R8DNtYZK5p41lIPPjTOFsnJCi+K9tWaGrEZYss+wqwTc2GhczBsdFjHzIUiW
         9hjZ3TJrtHeiLa+30I7YqQz3SS317hubZJOP9JOkuQUP0LtOyI4H4t9sYufR+rpST/
         IBMeJoZCvHAUxK5DK18xYJtMTs26+AYmck2KKv/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.2 099/173] KVM: x86: Clear "has_error_code", not "error_code", for RM exception injection
Date:   Wed, 12 Apr 2023 10:33:45 +0200
Message-Id: <20230412082842.071974579@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 6c41468c7c12d74843bb414fc00307ea8a6318c3 upstream.

When injecting an exception into a vCPU in Real Mode, suppress the error
code by clearing the flag that tracks whether the error code is valid, not
by clearing the error code itself.  The "typo" was introduced by recent
fix for SVM's funky Paged Real Mode.

Opportunistically hoist the logic above the tracepoint so that the trace
is coherent with respect to what is actually injected (this was also the
behavior prior to the buggy commit).

Fixes: b97f07458373 ("KVM: x86: determine if an exception has an error code only when injecting it.")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230322143300.2209476-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9795,13 +9795,20 @@ int kvm_check_nested_events(struct kvm_v
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Suppress the error code if the vCPU is in Real Mode, as Real Mode
+	 * exceptions don't report error codes.  The presence of an error code
+	 * is carried with the exception and only stripped when the exception
+	 * is injected as intercepted #PF VM-Exits for AMD's Paged Real Mode do
+	 * report an error code despite the CPU being in Real Mode.
+	 */
+	vcpu->arch.exception.has_error_code &= is_protmode(vcpu);
+
 	trace_kvm_inj_exception(vcpu->arch.exception.vector,
 				vcpu->arch.exception.has_error_code,
 				vcpu->arch.exception.error_code,
 				vcpu->arch.exception.injected);
 
-	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
-		vcpu->arch.exception.error_code = false;
 	static_call(kvm_x86_inject_exception)(vcpu);
 }
 


