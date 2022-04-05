Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55D14F306E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiDEJBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238859AbiDEIbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB2A46172;
        Tue,  5 Apr 2022 01:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF6C260FF5;
        Tue,  5 Apr 2022 08:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B23C385A0;
        Tue,  5 Apr 2022 08:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146980;
        bh=PZl1d28eh0Ml/HfchsyAPM7MC3+Qu8D9oVwD+5p1AIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXo51zu+3rXAr+AVmgr6HINASR4kG4hJPXWdw+bNTwGKB4PcRpoQL98rFjuA0m2lk
         NlqhWPkhFE4MA2b6Q/1aL9O7oDQMCbf6Rr0c/0YubewqHlJgb4r94iQRbC/BGMofRl
         XBpiecTMhq0h1z9XsKwCF8zXhfQ+vd958JAGDjD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 0957/1126] KVM: x86: hyper-v: Drop redundant ex parameter from kvm_hv_flush_tlb()
Date:   Tue,  5 Apr 2022 09:28:24 +0200
Message-Id: <20220405070435.594294002@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

commit 82c1ead0d678af31e5d883656c12096a0004178b upstream.

'struct kvm_hv_hcall' has all the required information already,
there's no need to pass 'ex' additionally.

No functional change intended.

Cc: stable@vger.kernel.org # 5.14.x
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220222154642.684285-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1750,7 +1750,7 @@ struct kvm_hv_hcall {
 	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
 };
 
-static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
+static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
 	int i;
 	gpa_t gpa;
@@ -1765,7 +1765,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_v
 	int sparse_banks_len;
 	bool all_cpus;
 
-	if (!ex) {
+	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
+	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE) {
 		if (hc->fast) {
 			flush.address_space = hc->ingpa;
 			flush.flags = hc->outgpa;
@@ -2247,32 +2248,20 @@ int kvm_hv_hypercall(struct kvm_vcpu *vc
 				kvm_hv_hypercall_complete_userspace;
 		return 0;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
-		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
-		break;
-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
-		if (unlikely(hc.rep)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
-		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
 		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc);
 		break;
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
 		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc);
 		break;
 	case HVCALL_SEND_IPI:
 		if (unlikely(hc.rep)) {


