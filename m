Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716E14F3989
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241297AbiDELfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352823AbiDEKFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:05:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8886205EB;
        Tue,  5 Apr 2022 02:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72B56B81B13;
        Tue,  5 Apr 2022 09:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE215C385A2;
        Tue,  5 Apr 2022 09:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152434;
        bh=OjenJG737FwnU9dz57Y47PpcOUtRbaj0pVKRFDqpTfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBnNLeRv8D4yOrcCrUaRPh79K26Gkf6X2OLkD1g5SIvai488RgGAlmLU3VCtDrvGy
         dlvF0kr2Od+WhugOAbZ/9Yxze1duZT8gXxhEgYRxCLacxbvz6PX3ysGKMIcMwwy8qI
         qlolX6DNVKhV7Cfnnfyv2IoiTudYKVZGH8RiU9Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 774/913] KVM: x86: hyper-v: Drop redundant ex parameter from kvm_hv_send_ipi()
Date:   Tue,  5 Apr 2022 09:30:36 +0200
Message-Id: <20220405070403.032251066@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 50e523dd79f6a856d793ce5711719abe27cffbf2 upstream.

'struct kvm_hv_hcall' has all the required information already,
there's no need to pass 'ex' additionally.

No functional change intended.

Cc: stable@vger.kernel.org # 5.14.x
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220222154642.684285-2-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1874,7 +1874,7 @@ static void kvm_send_ipi_to_many(struct
 	}
 }
 
-static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
+static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
@@ -1888,7 +1888,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vc
 	u32 vector;
 	bool all_cpus;
 
-	if (!ex) {
+	if (hc->code == HVCALL_SEND_IPI) {
 		if (!hc->fast) {
 			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
 						    sizeof(send_ipi))))
@@ -2278,14 +2278,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vc
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_send_ipi(vcpu, &hc, false);
+		ret = kvm_hv_send_ipi(vcpu, &hc);
 		break;
 	case HVCALL_SEND_IPI_EX:
 		if (unlikely(hc.fast || hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_send_ipi(vcpu, &hc, true);
+		ret = kvm_hv_send_ipi(vcpu, &hc);
 		break;
 	case HVCALL_POST_DEBUG_DATA:
 	case HVCALL_RETRIEVE_DEBUG_DATA:


