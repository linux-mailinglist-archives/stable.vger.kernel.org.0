Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E5B593681
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245401AbiHOTFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245001AbiHOTDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:03:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7022C37193;
        Mon, 15 Aug 2022 11:33:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3682B8105D;
        Mon, 15 Aug 2022 18:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BACAC433D6;
        Mon, 15 Aug 2022 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588435;
        bh=4cVpYbMaOLnwvVrSAlEAPQ/lSB/ciAKciQ+78iytvp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7AXN2wti+viPJEvfYiBQn4vxf23Sm8H0RP6meWH3H7Rh7Bd1GhknWvEaCmNbGjpk
         mbvMYitG8triHkuvs5QFV9A1h/J5PTADlsyuxv2arEBoVcG3zs8QTm1S2e5Q1MA66D
         aPpCEfSV5a7r1boYyNW/pFB8z3jOAyiY1LjdXCNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/779] KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is supported
Date:   Mon, 15 Aug 2022 20:00:47 +0200
Message-Id: <20220815180354.511102787@linuxfoundation.org>
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

[ Upstream commit 3741aec4c38fa4123ab08ae552f05366d4fd05d8 ]

If NRIPS is supported in hardware but disabled in KVM, set next_rip to
the next RIP when advancing RIP as part of emulating INT3 injection.
There is no flag to tell the CPU that KVM isn't using next_rip, and so
leaving next_rip is left as is will result in the CPU pushing garbage
onto the stack when vectoring the injected event.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: 66b7138f9136 ("KVM: SVM: Emulate nRIP feature when reinjecting INT3")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Message-Id: <cd328309a3b88604daa2359ad56f36cb565ce2d4.1651440202.git.maciej.szmigiero@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 05d76832362d..2947e3c965e3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -394,6 +394,10 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 */
 		(void)skip_emulated_instruction(vcpu);
 		rip = kvm_rip_read(vcpu);
+
+		if (boot_cpu_has(X86_FEATURE_NRIPS))
+			svm->vmcb->control.next_rip = rip;
+
 		svm->int3_rip = rip + svm->vmcb->save.cs.base;
 		svm->int3_injected = rip - old_rip;
 	}
@@ -3683,7 +3687,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	/*
 	 * If NextRIP isn't enabled, KVM must manually advance RIP prior to
 	 * injecting the soft exception/interrupt.  That advancement needs to
-	 * be unwound if vectoring didn't complete.  Note, the _new_ event may
+	 * be unwound if vectoring didn't complete.  Note, the new event may
 	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
 	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
 	 * be the reported vectored event, but RIP still needs to be unwound.
-- 
2.35.1



