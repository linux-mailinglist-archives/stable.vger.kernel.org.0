Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44136CC538
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbjC1PMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbjC1PMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A322C1025B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89B70B81D78
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF44C433EF;
        Tue, 28 Mar 2023 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016260;
        bh=IVvsUdyz116ejvlveiGeYlwNf13FbIOeU5v8ez6r6JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md/xfAFl0j/KzzA14ZD5KpP4avZJOQRqJvKJLkcMp4sE7cA+0IOtfAnNLz/ZQYUo4
         m4X0oAhcImwnYp+v343OjV88LTDS/YqCkJfiPnnj5qr9euTYtD7xtvTDK1fkaO3rL+
         5DJx13YRCvs9ECgHxbeC+0Y+Hkt41ZDHSDl9Sdlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.15 123/146] KVM: x86: hyper-v: Avoid calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL
Date:   Tue, 28 Mar 2023 16:43:32 +0200
Message-Id: <20230328142607.771592784@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 6470accc7ba948b0b3aca22b273fe84ec638a116 upstream.

In preparation to making kvm_make_vcpus_request_mask() use for_each_set_bit()
switch kvm_hv_flush_tlb() to calling kvm_make_all_cpus_request() for 'all cpus'
case.

Note: kvm_make_all_cpus_request() (unlike kvm_make_vcpus_request_mask())
currently dynamically allocates cpumask on each call and this is suboptimal.
Both kvm_make_all_cpus_request() and kvm_make_vcpus_request_mask() are
going to be switched to using pre-allocated per-cpu masks.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210903075141.403071-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1846,16 +1846,19 @@ static u64 kvm_hv_flush_tlb(struct kvm_v
 
 	cpumask_clear(&hv_vcpu->tlb_flush);
 
-	vcpu_mask = all_cpus ? NULL :
-		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
-					vp_bitmap, vcpu_bitmap);
-
 	/*
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
-	kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
-				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
+	if (all_cpus) {
+		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
+	} else {
+		vcpu_mask = sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
+						    vp_bitmap, vcpu_bitmap);
+
+		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
+					    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
+	}
 
 ret_success:
 	/* We always do full TLB flush, set 'Reps completed' = 'Rep Count' */


