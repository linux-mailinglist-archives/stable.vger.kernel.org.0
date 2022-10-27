Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F9E6103C6
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbiJ0VDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236666AbiJ0VDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:03:03 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5345A44CF3;
        Thu, 27 Oct 2022 13:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904124; x=1698440124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=derLv7dQEAXbOAKEsypaYAoNRpFKvEhJUqwrKS5o+Xk=;
  b=J8Pdvyyx9nrWRpeQH951xBhbbLEGV9up44QHLXfIpDj1Wz5/H6YYKAAk
   BAI0BdzjURoPEjmZsJd4VYB5G+z9wy5cJHM7pZJnnZRkgBaKyGX2h0adf
   iCj1BSN5FiYfdUmSp2LhVxokoMgLYEW57xQ2SKGadfKpXnqQrI1NvNXwF
   8=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="274379660"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:55:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id 8F3FC41740;
        Thu, 27 Oct 2022 20:55:23 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:55:22 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.160.223) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:55:22 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 19/34] x86/speculation: Add LFENCE to RSB fill sequence
Date:   Thu, 27 Oct 2022 13:55:11 -0700
Message-ID: <20221027205512.17684-3-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027205512.17684-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
 <20221027205512.17684-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D11UWB002.ant.amazon.com (10.43.161.20) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit ba6e31af2be96c4d0536f2152ed6f7b6c11bca47 upstream.

RSB fill sequence does not have any protection for miss-prediction of
conditional branch at the end of the sequence. CPU can speculatively
execute code immediately after the sequence, while RSB filling hasn't
completed yet.

  #define __FILL_RETURN_BUFFER(reg, nr, sp)       \
          mov     $(nr/2), reg;                   \
  771:                                            \
          ANNOTATE_INTRA_FUNCTION_CALL;           \
          call    772f;                           \
  773:    /* speculation trap */                  \
          UNWIND_HINT_EMPTY;                      \
          pause;                                  \
          lfence;                                 \
          jmp     773b;                           \
  772:                                            \
          ANNOTATE_INTRA_FUNCTION_CALL;           \
          call    774f;                           \
  775:    /* speculation trap */                  \
          UNWIND_HINT_EMPTY;                      \
          pause;                                  \
          lfence;                                 \
          jmp     775b;                           \
  774:                                            \
          add     $(BITS_PER_LONG/8) * 2, sp;     \
          dec     reg;                            \
          jnz     771b;        <----- CPU can miss-predict here.

Before RSB is filled, RETs that come in program order after this macro
can be executed speculatively, making them vulnerable to RSB-based
attacks.

Mitigate it by adding an LFENCE after the conditional branch to prevent
speculation while RSB is being filled.

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/nospec-branch.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 652c1159a6f6..0d474525caec 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -54,7 +54,9 @@
 774:						\
 	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
-	jnz	771b;
+	jnz	771b;				\
+	/* barrier for jnz misprediction */	\
+	lfence;
 
 #ifdef __ASSEMBLY__
 
-- 
2.17.1

