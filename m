Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA245B3EA0
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiIISOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiIISOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:14:30 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7E3386
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662747265; x=1694283265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RRY8HCFP4PJyl6W5VHQ7UpAnbttQ3sM9BhN6zXob3HI=;
  b=Ho+eQAkuRA0u6XAfk0nlncYptQ4aM42Rzjosrqt8FtE/f7QR+tWg76Yk
   1zSDHq6YrzfdPwNoWHYPifPxqE3Mcfq9BcaDhe1DS8hvJ0OIidXiQu5sr
   GNGXq8GZ7/E9wxu6YjhKapwvW1hjfYIuxk2Ino5E2LwX+8G8RaWOd1DW1
   w=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 18:14:19 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com (Postfix) with ESMTPS id 169BC81B9B;
        Fri,  9 Sep 2022 18:14:16 +0000 (UTC)
Received: from EX19D008UEC002.ant.amazon.com (10.252.135.242) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 18:14:16 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX19D008UEC002.ant.amazon.com (10.252.135.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 9 Sep 2022 18:14:16 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 18:14:16 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 1084258D4; Fri,  9 Sep 2022 18:14:15 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <surajjs@amazon.com>,
        <mbacco@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
        kernel test robot <lkp@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 3/9] KVM: Fix steal time asm constraints
Date:   Fri, 9 Sep 2022 18:13:45 +0000
Message-ID: <20220909181351.23983-4-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220909181351.23983-1-risbhat@amazon.com>
References: <20220909181351.23983-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

