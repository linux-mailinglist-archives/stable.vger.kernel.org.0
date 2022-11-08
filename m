Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00A26213A4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbiKHNwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbiKHNwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:52:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8F966C90
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:52:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C382615A3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2F1C43470;
        Tue,  8 Nov 2022 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915531;
        bh=uoD8+wFL4TQLNEuMCSDT8m3EKp+7ogvt23T58I+me2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUoUHbFK12Y5AhBzDhcNNZgXDtfMyttzsS/3PiOxPjHUt/JejzFaf3xQr2Fiwy4ZM
         vstOdWiD0JlA7Cn80/RXWLLly+I8qfBJA2T7EdpFFeU3V++5bb19LQiv83jstojysJ
         eNPyEW64RqT1DO1ja0bZgw0+QodCO/bOt2+BuAG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/118] KVM: x86: Trace re-injected exceptions
Date:   Tue,  8 Nov 2022 14:38:03 +0100
Message-Id: <20221108133340.942671112@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit a61d7c5432ac5a953bbcec17af031661c2bd201d ]

Trace exceptions that are re-injected, not just those that KVM is
injecting for the first time.  Debugging re-injection bugs is painful
enough as is, not having visibility into what KVM is doing only makes
things worse.

Delay propagating pending=>injected in the non-reinjection path so that
the tracing can properly identify reinjected exceptions.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Message-Id: <25470690a38b4d2b32b6204875dd35676c65c9f2.1651440202.git.maciej.szmigiero@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 5623f751bd9c ("KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/trace.h | 12 ++++++++----
 arch/x86/kvm/x86.c   | 16 +++++++++-------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index a2835d784f4b..3d4988ea8b57 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -304,25 +304,29 @@ TRACE_EVENT(kvm_inj_virq,
  * Tracepoint for kvm interrupt injection:
  */
 TRACE_EVENT(kvm_inj_exception,
-	TP_PROTO(unsigned exception, bool has_error, unsigned error_code),
-	TP_ARGS(exception, has_error, error_code),
+	TP_PROTO(unsigned exception, bool has_error, unsigned error_code,
+		 bool reinjected),
+	TP_ARGS(exception, has_error, error_code, reinjected),
 
 	TP_STRUCT__entry(
 		__field(	u8,	exception	)
 		__field(	u8,	has_error	)
 		__field(	u32,	error_code	)
+		__field(	bool,	reinjected	)
 	),
 
 	TP_fast_assign(
 		__entry->exception	= exception;
 		__entry->has_error	= has_error;
 		__entry->error_code	= error_code;
+		__entry->reinjected	= reinjected;
 	),
 
-	TP_printk("%s (0x%x)",
+	TP_printk("%s (0x%x)%s",
 		  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
 		  /* FIXME: don't print error_code if not present */
-		  __entry->has_error ? __entry->error_code : 0)
+		  __entry->has_error ? __entry->error_code : 0,
+		  __entry->reinjected ? " [reinjected]" : "")
 );
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f3473418dcd5..17bb3d0e2d13 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8347,6 +8347,11 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	trace_kvm_inj_exception(vcpu->arch.exception.nr,
+				vcpu->arch.exception.has_error_code,
+				vcpu->arch.exception.error_code,
+				vcpu->arch.exception.injected);
+
 	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
 		vcpu->arch.exception.error_code = false;
 	kvm_x86_ops.queue_exception(vcpu);
@@ -8404,13 +8409,6 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.exception.pending) {
-		trace_kvm_inj_exception(vcpu->arch.exception.nr,
-					vcpu->arch.exception.has_error_code,
-					vcpu->arch.exception.error_code);
-
-		vcpu->arch.exception.pending = false;
-		vcpu->arch.exception.injected = true;
-
 		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
 			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
 					     X86_EFLAGS_RF);
@@ -8424,6 +8422,10 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		}
 
 		kvm_inject_exception(vcpu);
+
+		vcpu->arch.exception.pending = false;
+		vcpu->arch.exception.injected = true;
+
 		can_inject = false;
 	}
 
-- 
2.35.1



