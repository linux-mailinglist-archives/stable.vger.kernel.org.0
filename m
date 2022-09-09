Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F5B5B3F20
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiIIS4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiIIS4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:56:46 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5DCE915F
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662749806; x=1694285806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=63lmFh9QqDJA+G8Y3XzJWV5Ni6HrsEiFtQOBjMTJvRI=;
  b=DoWJgJuQEuS5JwjIhKc9bjPbVubF2p8sPkduyBJBFGDjHfWf+a9FACsH
   ZjbwhDACQm92kaD887cGAxOMAooO3x9u3xH6pAFYTjpQlGvQbpVnmaRIi
   OGfF9hDpq2RiiPVfoqL5PkjRL2HYuL391mYaoKi2ARGF9Sjkdv7rK+ARr
   k=;
X-IronPort-AV: E=Sophos;i="5.93,303,1654560000"; 
   d="scan'208";a="128610822"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 18:56:44 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id 1CA7A813DE;
        Fri,  9 Sep 2022 18:56:43 +0000 (UTC)
Received: from EX19D002UWC003.ant.amazon.com (10.13.138.183) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 18:56:22 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX19D002UWC003.ant.amazon.com (10.13.138.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 9 Sep 2022 18:56:21 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 18:56:20 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 8C6BD3010; Fri,  9 Sep 2022 18:56:19 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <surajjs@amazon.com>,
        <mbacco@amazon.com>, <bp@alien8.de>, <mingo@redhat.com>,
        <tglx@linutronix.de>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        <jmattson@google.com>, <joro@8bytes.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 9/9] KVM: x86: move guest_pv_has out of user_access section
Date:   Fri, 9 Sep 2022 18:55:57 +0000
Message-ID: <20220909185557.21255-10-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220909185557.21255-1-risbhat@amazon.com>
References: <20220909185557.21255-1-risbhat@amazon.com>
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

commit 3e067fd8503d6205aa0c1c8f48f6b209c592d19c upstream.

When UBSAN is enabled, the code emitted for the call to guest_pv_has
includes a call to __ubsan_handle_load_invalid_value.  objtool
complains that this call happens with UACCESS enabled; to avoid
the warning, pull the calls to user_access_begin into both arms
of the "if" statement, after the check for guest_pv_has.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 arch/x86/kvm/x86.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e9298c333c8..e3599a51c72d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3042,9 +3042,6 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	}
 
 	st = (struct kvm_steal_time __user *)ghc->hva;
-	if (!user_access_begin(st, sizeof(*st)))
-		return;
-
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
@@ -3053,6 +3050,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		u8 st_preempted = 0;
 		int err = -EFAULT;
 
+		if (!user_access_begin(st, sizeof(*st)))
+			return;
+
 		asm volatile("1: xchgb %0, %2\n"
 			     "xor %1, %1\n"
 			     "2:\n"
@@ -3075,6 +3075,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		if (!user_access_begin(st, sizeof(*st)))
 			goto dirty;
 	} else {
+		if (!user_access_begin(st, sizeof(*st)))
+			return;
+
 		unsafe_put_user(0, &st->preempted, out);
 		vcpu->arch.st.preempted = 0;
 	}
-- 
2.37.1

