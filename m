Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8B45B3F1A
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiIIS42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiIIS41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:56:27 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC66E42D4
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662749786; x=1694285786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RRY8HCFP4PJyl6W5VHQ7UpAnbttQ3sM9BhN6zXob3HI=;
  b=IifzDv9rx2XyKHY2+uQFg9TlIxv1xJFVePEV4Igwz7uYr0gIrJdc+jl5
   l3BRnE6oiXYot2XxtoxE23tqG27V5qe8OX18HWniiW2jNPol0IOWjNxw1
   6prD1tgYkCKw0UWoJxO73j0TPPViVfmDxDM09KPQGolmy/VHbU+++jHmu
   w=;
X-IronPort-AV: E=Sophos;i="5.93,303,1654560000"; 
   d="scan'208";a="257988368"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 18:56:24 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-f771ae83.us-east-1.amazon.com (Postfix) with ESMTPS id 58097120019;
        Fri,  9 Sep 2022 18:56:21 +0000 (UTC)
Received: from EX19D030UWA002.ant.amazon.com (10.13.139.117) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 18:56:21 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D030UWA002.ant.amazon.com (10.13.139.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Fri, 9 Sep 2022 18:56:20 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 18:56:20 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 8A61C26; Fri,  9 Sep 2022 18:56:19 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <surajjs@amazon.com>,
        <mbacco@amazon.com>, <bp@alien8.de>, <mingo@redhat.com>,
        <tglx@linutronix.de>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        <jmattson@google.com>, <joro@8bytes.org>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        kernel test robot <lkp@intel.com>,
        "Rishabh Bhatnagar" <risbhat@amazon.com>
Subject: [PATCH 3/9] KVM: Fix steal time asm constraints
Date:   Fri, 9 Sep 2022 18:55:51 +0000
Message-ID: <20220909185557.21255-4-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220909185557.21255-1-risbhat@amazon.com>
References: <20220909185557.21255-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-14.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit 964b7aa0b040bdc6ec1c543ee620cda3f8b4c68a upstream.

In 64-bit mode, x86 instruction encoding allows us to use the low 8 bits
of any GPR as an 8-bit operand. In 32-bit mode, however, we can only use
the [abcd] registers. For which, GCC has the "q" constraint instead of
the less restrictive "r".

Also fix st->preempted, which is an input/output operand rather than an
input.

Fixes: 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <89bf72db1b859990355f9c40713a34e0d2d86c98.camel@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd1e6710bc33..3de3dcb27f7b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3055,9 +3055,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 			     "xor %1, %1\n"
 			     "2:\n"
 			     _ASM_EXTABLE_UA(1b, 2b)
-			     : "+r" (st_preempted),
-			       "+&r" (err)
-			     : "m" (st->preempted));
+			     : "+q" (st_preempted),
+			       "+&r" (err),
+			       "+m" (st->preempted));
 		if (err)
 			goto out;
 
-- 
2.37.1

