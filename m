Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684355936A2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244835AbiHOTER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244851AbiHOTCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:02:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471702CCB9;
        Mon, 15 Aug 2022 11:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F87361043;
        Mon, 15 Aug 2022 18:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9C3C433D6;
        Mon, 15 Aug 2022 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588432;
        bh=YxRgMpnmW13UinbSczL9GR6bz05U+c6SlFeFp8aplWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfRn1enTXNTaqxfhg5VQt3YzHBe8hv2PzqneB+h3NB79QfBj/kH33nvzB7scnljtO
         YaGBesI19hQoCrUNmD+l2oalTuUsMUN49bNODmsgHJYmYoweWAZFtfbuMEDH75IJmw
         yhJvynJ53iUsrJT4KH9nSPh2IoxDhL8SAQjPzgSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 402/779] KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"
Date:   Mon, 15 Aug 2022 20:00:46 +0200
Message-Id: <20220815180354.461143334@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit cd9e6da8048c5b40315ee2d929b6230ce1252c3c ]

Unwind the RIP advancement done by svm_queue_exception() when injecting
an INT3 ultimately "fails" due to the CPU encountering a VM-Exit while
vectoring the injected event, even if the exception reported by the CPU
isn't the same event that was injected.  If vectoring INT3 encounters an
exception, e.g. #NP, and vectoring the #NP encounters an intercepted
exception, e.g. #PF when KVM is using shadow paging, then the #NP will
be reported as the event that was in-progress.

Note, this is still imperfect, as it will get a false positive if the
INT3 is cleanly injected, no VM-Exit occurs before the IRET from the INT3
handler in the guest, the instruction following the INT3 generates an
exception (directly or indirectly), _and_ vectoring that exception
encounters an exception that is intercepted by KVM.  The false positives
could theoretically be solved by further analyzing the vectoring event,
e.g. by comparing the error code against the expected error code were an
exception to occur when vectoring the original injected exception, but
SVM without NRIPS is a complete disaster, trying to make it 100% correct
is a waste of time.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: 66b7138f9136 ("KVM: SVM: Emulate nRIP feature when reinjecting INT3")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Message-Id: <450133cf0a026cb9825a2ff55d02cb136a1cb111.1651440202.git.maciej.szmigiero@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b001f7d94d1d..05d76832362d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3680,6 +3680,18 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
 	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
 
+	/*
+	 * If NextRIP isn't enabled, KVM must manually advance RIP prior to
+	 * injecting the soft exception/interrupt.  That advancement needs to
+	 * be unwound if vectoring didn't complete.  Note, the _new_ event may
+	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
+	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
+	 * be the reported vectored event, but RIP still needs to be unwound.
+	 */
+	if (int3_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+	   kvm_is_linear_rip(vcpu, svm->int3_rip))
+		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - int3_injected);
+
 	switch (type) {
 	case SVM_EXITINTINFO_TYPE_NMI:
 		vcpu->arch.nmi_injected = true;
@@ -3693,16 +3705,11 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 
 		/*
 		 * In case of software exceptions, do not reinject the vector,
-		 * but re-execute the instruction instead. Rewind RIP first
-		 * if we emulated INT3 before.
+		 * but re-execute the instruction instead.
 		 */
-		if (kvm_exception_is_soft(vector)) {
-			if (vector == BP_VECTOR && int3_injected &&
-			    kvm_is_linear_rip(vcpu, svm->int3_rip))
-				kvm_rip_write(vcpu,
-					      kvm_rip_read(vcpu) - int3_injected);
+		if (kvm_exception_is_soft(vector))
 			break;
-		}
+
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
 			kvm_requeue_exception_e(vcpu, vector, err);
-- 
2.35.1



