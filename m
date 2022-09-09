Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA165B3EA4
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiIISOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiIISOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:14:19 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC07AE3D5B
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662747258; x=1694283258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NFnUZSpLJYxiVyTqrVxZoVPfSYlezS/ry4PUl3TJpI8=;
  b=eQugHP8LvJYGauCpiXZ4D5rQBHeFVzsTI2qRY865w86sNSgdxnoy5IhT
   H0krPGoJSiktpatOC1rFn3OncQsifAieKyzwJLjovFtefaZDiGwca9Nyl
   FCVnEQXdkc3WSCqeKz1UZFD1AMntp1tQdD9RW2UhGTCnnPGjF7oDaPROr
   E=;
X-IronPort-AV: E=Sophos;i="5.93,303,1654560000"; 
   d="scan'208";a="128597207"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 18:14:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com (Postfix) with ESMTPS id 593A445235;
        Fri,  9 Sep 2022 18:14:17 +0000 (UTC)
Received: from EX19D012UWB001.ant.amazon.com (10.13.138.50) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 18:14:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX19D012UWB001.ant.amazon.com (10.13.138.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Fri, 9 Sep 2022 18:14:16 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 18:14:16 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 1361658D8; Fri,  9 Sep 2022 18:14:15 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <surajjs@amazon.com>,
        <mbacco@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5/9] KVM: x86: do not set st->preempted when going back to user space
Date:   Fri, 9 Sep 2022 18:13:47 +0000
Message-ID: <20220909181351.23983-6-risbhat@amazon.com>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit 54aa83c90198e68eee8b0850c749bc70efb548da upstream.

Similar to the Xen path, only change the vCPU's reported state if the vCPU
was actually preempted.  The reason for KVM's behavior is that for example
optimistic spinning might not be a good idea if the guest is doing repeated
exits to userspace; however, it is confusing and unlikely to make a difference,
because well-tuned guests will hardly ever exit KVM_RUN in the first place.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[risbhat@amazon.com: Don't check for xen msr as support is not available
and skip the SEV-ES condition]
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 arch/x86/kvm/x86.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 87c2283f12c4..0df41be32314 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4117,16 +4117,18 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted)
+	if (vcpu->preempted) {
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
 
-	/*
-	 * kvm_memslots() will be called by
-	 * kvm_write_guest_offset_cached() so take the srcu lock.
-	 */
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	kvm_steal_time_set_preempted(vcpu);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		/*
+		 * Take the srcu lock as memslots will be accessed to check the gfn
+		 * cache generation against the memslots generation.
+		 */
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_steal_time_set_preempted(vcpu);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
+
 	kvm_x86_ops.vcpu_put(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
 	/*
-- 
2.37.1

