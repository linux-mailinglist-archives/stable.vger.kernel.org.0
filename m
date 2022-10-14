Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534BE5FF660
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 00:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJNW1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 18:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJNW07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 18:26:59 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE3FAF1B7
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 15:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665786419; x=1697322419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p0vs6njsc6qitSoGCGrU2uMzw9CIE57W6uCddZEYh4A=;
  b=aTrrlKMJfCejHKqMvkhZlZj+3hPjIYi1+XVeIpg9lNjmFpm+c8gprLXX
   8uG1ApcKAjMMoCjEb8se11Y36Fg/kEmY6dS1W5jsikriKPbaxdRh9IslN
   +P4/sSamEn3EBdhjZ61f515lozCwlxE9E4AJRyqeOpvOmIMMLRMa+JKsP
   Q=;
X-IronPort-AV: E=Sophos;i="5.95,185,1661817600"; 
   d="scan'208";a="255641430"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 22:26:58 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id E502B22256C;
        Fri, 14 Oct 2022 22:26:56 +0000 (UTC)
Received: from EX19D028UEB003.ant.amazon.com (10.252.137.58) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 14 Oct 2022 22:26:55 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX19D028UEB003.ant.amazon.com (10.252.137.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Fri, 14 Oct 2022 22:26:55 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Fri, 14 Oct 2022 22:26:55
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 135D528E0; Fri, 14 Oct 2022 22:26:54 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <surajjs@amazon.com>, <luizcap@amazon.com>, <aams@amazon.de>
CC:     <mbacco@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Dave Young <ruyang@redhat.com>,
        Xiaoying Yan <yiyan@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>, <stable@vger.kernel.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 7/9] KVM: x86: revalidate steal time cache if MSR value changes
Date:   Fri, 14 Oct 2022 22:26:41 +0000
Message-ID: <20221014222643.25815-9-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221014222643.25815-1-risbhat@amazon.com>
References: <20221014222643.25815-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 901d3765fa804ce42812f1d5b1f3de2dfbb26723 upstream.

Commit 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time
/ preempted status", 2021-11-11) open coded the previous call to
kvm_map_gfn, but in doing so it dropped the comparison between the cached
guest physical address and the one in the MSR.  This cause an incorrect
cache hit if the guest modifies the steal time address while the memslots
remain the same.  This can happen with kexec, in which case the steal
time data is written at the address used by the old kernel instead of
the old one.

While at it, rename the variable from gfn to gpa since it is a plain
physical address and not a right-shifted one.

Reported-by: Dave Young <ruyang@redhat.com>
Reported-by: Xiaoying Yan  <yiyan@redhat.com>
Analyzed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Fixes: 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 75494b3c2d1e..111aa95f3de3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3018,6 +3018,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
 	struct kvm_steal_time __user *st;
 	struct kvm_memslots *slots;
+	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
 	u64 steal;
 	u32 version;
 
@@ -3030,13 +3031,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	slots = kvm_memslots(vcpu->kvm);
 
 	if (unlikely(slots->generation != ghc->generation ||
+		     gpa != ghc->gpa ||
 		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
-		gfn_t gfn = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
-
 		/* We rely on the fact that it fits in a single page. */
 		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
 
-		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gfn, sizeof(*st)) ||
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st)) ||
 		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
 			return;
 	}
-- 
2.37.1

