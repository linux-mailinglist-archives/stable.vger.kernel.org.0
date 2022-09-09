Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B8C5B3EA3
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiIISOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiIISOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:14:20 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9709E1A8F
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662747259; x=1694283259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IXiq0FmpiEZ1nmX3k1NPdMxDplgAsw9tBN8yTpTpQco=;
  b=H1V4MRcnRoySrbXG/QcsvU5LXRnT0MS/n4kMCMj4e/grR1YqzH0E7+uJ
   GVdlcyxgFtmos/HrwY6foxdgQP4HJGnYME+11TKx5FXpzohl67ggT6HMp
   gxSYJcUvtttYsPXD7xrbZZ9sDvVne4ba2MOm0wZj8UW0+qIFgLBpCBLtu
   w=;
X-IronPort-AV: E=Sophos;i="5.93,303,1654560000"; 
   d="scan'208";a="224703505"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 18:14:18 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com (Postfix) with ESMTPS id DCF0B140FE7;
        Fri,  9 Sep 2022 18:14:16 +0000 (UTC)
Received: from EX19D030UWA001.ant.amazon.com (10.13.139.94) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 18:14:16 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D030UWA001.ant.amazon.com (10.13.139.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Fri, 9 Sep 2022 18:14:16 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 18:14:16 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 0FB4058D2; Fri,  9 Sep 2022 18:14:15 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <surajjs@amazon.com>,
        <mbacco@amazon.com>, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 4/9] KVM: x86: Remove obsolete disabling of page faults in kvm_arch_vcpu_put()
Date:   Fri, 9 Sep 2022 18:13:46 +0000
Message-ID: <20220909181351.23983-5-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220909181351.23983-1-risbhat@amazon.com>
References: <20220909181351.23983-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 19979fba9bfaeab427a8e106d915f0627c952828 upstream.

Remove the disabling of page faults across kvm_steal_time_set_preempted()
as KVM now accesses the steal time struct (shared with the guest) via a
cached mapping (see commit b043138246a4, "x86/KVM: Make sure
KVM_VCPU_FLUSH_TLB flag is not missed".)  The cache lookup is flagged as
atomic, thus it would be a bug if KVM tried to resolve a new pfn, i.e.
we want the splat that would be reached via might_fault().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210123000334.3123628-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 arch/x86/kvm/x86.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3de3dcb27f7b..87c2283f12c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4120,15 +4120,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (vcpu->preempted)
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
 
-	/*
-	 * Disable page faults because we're in atomic context here.
-	 * kvm_write_guest_offset_cached() would call might_fault()
-	 * that relies on pagefault_disable() to tell if there's a
-	 * bug. NOTE: the write to guest memory may not go through if
-	 * during postcopy live migration or if there's heavy guest
-	 * paging.
-	 */
-	pagefault_disable();
 	/*
 	 * kvm_memslots() will be called by
 	 * kvm_write_guest_offset_cached() so take the srcu lock.
@@ -4136,7 +4127,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_steal_time_set_preempted(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	pagefault_enable();
 	kvm_x86_ops.vcpu_put(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
 	/*
-- 
2.37.1

