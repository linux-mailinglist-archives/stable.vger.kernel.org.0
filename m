Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262B04B49F2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiBNKEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:04:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345093AbiBNKEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:04:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DBB45512;
        Mon, 14 Feb 2022 01:48:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D135612D0;
        Mon, 14 Feb 2022 09:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D135EC340E9;
        Mon, 14 Feb 2022 09:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832136;
        bh=H9AOZ4VvMnz+eej4Jp2A9tk40+GzB/tTtRcrZcb3Tu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QemBq8kNZq3A72x7Rt8hRCt5gYQV96/OFBvI314Zt0q+5dLPXmFp4q70MUY2o5Dy0
         tlEgIJsgjbF+2NsakNxP06yGSCSzk7OLRqDOWyg/WDW68MJzMnA/aOJqdXTxrHEpGx
         jFTVqMavcs/kK4O5+NCOEX2l9d2Y33E2EwfQhTNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/172] KVM: SVM: Dont kill SEV guest if SMAP erratum triggers in usermode
Date:   Mon, 14 Feb 2022 10:25:21 +0100
Message-Id: <20220214092508.576251831@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit cdf85e0c5dc766fc7fc779466280e454a6d04f87 ]

Inject a #GP instead of synthesizing triple fault to try to avoid killing
the guest if emulation of an SEV guest fails due to encountering the SMAP
erratum.  The injected #GP may still be fatal to the guest, e.g. if the
userspace process is providing critical functionality, but KVM should
make every attempt to keep the guest alive.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Message-Id: <20220120010719.711476-10-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 980abc437cdaa..f05aa7290267d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4473,7 +4473,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	is_user = svm_get_cpl(vcpu) == 3;
 	if (smap && (!smep || is_user)) {
 		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
+		/*
+		 * If the fault occurred in userspace, arbitrarily inject #GP
+		 * to avoid killing the guest and to hopefully avoid confusing
+		 * the guest kernel too much, e.g. injecting #PF would not be
+		 * coherent with respect to the guest's page tables.  Request
+		 * triple fault if the fault occurred in the kernel as there's
+		 * no fault that KVM can inject without confusing the guest.
+		 * In practice, the triple fault is moot as no sane SEV kernel
+		 * will execute from user memory while also running with SMAP=1.
+		 */
+		if (is_user)
+			kvm_inject_gp(vcpu, 0);
+		else
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
 
 	return false;
-- 
2.34.1



