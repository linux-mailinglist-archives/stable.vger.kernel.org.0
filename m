Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE0D5FF661
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 00:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJNW1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 18:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJNW1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 18:27:03 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2C91781E7
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 15:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665786423; x=1697322423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tJZNea2m1/KOerh3yHR76fNVXbTJz0xM3ObteFENufw=;
  b=sn8RermBdqwWCZPphLsKrAisoDzBw+JakKPg33NPE52YSKFEVn6gmo93
   GF8ELkNywrZL5TWMkWaqqqX9+BsIpALEy+Vd1SBlfDjcp+Ua8/xq+3nHE
   jHzt6HFTit9a5Ko6L3UKY67MCmtOtgQcoPKeYIBim41WFKgtibTbOnCmN
   Y=;
X-IronPort-AV: E=Sophos;i="5.95,185,1661817600"; 
   d="scan'208";a="269693704"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 22:27:02 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id 459B31A2AC9;
        Fri, 14 Oct 2022 22:27:01 +0000 (UTC)
Received: from EX19D028UEC004.ant.amazon.com (10.252.137.183) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 14 Oct 2022 22:26:56 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX19D028UEC004.ant.amazon.com (10.252.137.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Fri, 14 Oct 2022 22:26:55 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Fri, 14 Oct 2022 22:26:55
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 1756028E6; Fri, 14 Oct 2022 22:26:54 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <surajjs@amazon.com>, <luizcap@amazon.com>, <aams@amazon.de>
CC:     <mbacco@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>, <stable@vger.kernel.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 8/9] KVM: x86: do not report preemption if the steal time cache is stale
Date:   Fri, 14 Oct 2022 22:26:42 +0000
Message-ID: <20221014222643.25815-10-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221014222643.25815-1-risbhat@amazon.com>
References: <20221014222643.25815-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-14.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit c3c28d24d910a746b02f496d190e0e8c6560224b upstream.

Commit 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time
/ preempted status", 2021-11-11) open coded the previous call to
kvm_map_gfn, but in doing so it dropped the comparison between the cached
guest physical address and the one in the MSR.  This cause an incorrect
cache hit if the guest modifies the steal time address while the memslots
remain the same.  This can happen with kexec, in which case the preempted
bit is written at the address used by the old kernel instead of
the old one.

Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Fixes: 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 111aa95f3de3..9e9298c333c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4089,6 +4089,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	struct kvm_steal_time __user *st;
 	struct kvm_memslots *slots;
 	static const u8 preempted = KVM_VCPU_PREEMPTED;
+	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
 
 	/*
 	 * The vCPU can be marked preempted if and only if the VM-Exit was on
@@ -4116,6 +4117,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	slots = kvm_memslots(vcpu->kvm);
 
 	if (unlikely(slots->generation != ghc->generation ||
+		     gpa != ghc->gpa ||
 		     kvm_is_error_hva(ghc->hva) || !ghc->memslot))
 		return;
 
-- 
2.37.1

