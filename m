Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520EF6103CC
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbiJ0VDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiJ0VDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:03:06 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2489252805;
        Thu, 27 Oct 2022 13:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904136; x=1698440136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=0rtwe3IQgcdvPhlnwATiEOKcROEHUG5SOh8hmHcTseE=;
  b=HHXjZ4X/FcpGWLEdsLdOTLGZB31T+omZK1OPWSbsb5KdNAJVNBnHgOU4
   NqgfMkQtfvwBriURqbYlk0PH1AMcYUyAkp2RmPA5QCgGOtbsKH2AOeTh4
   wpWd4K0HmxuYFyDV1D3vuJrJvUTnLbr+im53BD1crKVZ+uHcK3TIeureL
   M=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="145243761"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:55:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com (Postfix) with ESMTPS id 8AE2B612F5;
        Thu, 27 Oct 2022 20:55:36 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:55:33 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.161.14) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:55:32 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 23/34] x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
Date:   Thu, 27 Oct 2022 13:55:22 -0700
Message-ID: <20221027205523.17741-3-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027205523.17741-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
 <20221027205523.17741-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D37UWA004.ant.amazon.com (10.43.160.23) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit bbb69e8bee1bd882784947095ffb2bfe0f7c9470 upstream.

There's no need to recalculate the host value for every entry/exit.
Just use the cached value in spec_ctrl_current().

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 31aa473717bb..a0d180e52231 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -198,7 +198,7 @@ void __init check_bugs(void)
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
-	u64 msrval, guestval, hostval = x86_spec_ctrl_base;
+	u64 msrval, guestval, hostval = spec_ctrl_current();
 	struct thread_info *ti = current_thread_info();
 
 	/* Is MSR_SPEC_CTRL implemented ? */
@@ -211,15 +211,6 @@ x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 		guestval = hostval & ~x86_spec_ctrl_mask;
 		guestval |= guest_spec_ctrl & x86_spec_ctrl_mask;
 
-		/* SSBD controlled in MSR_SPEC_CTRL */
-		if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-		    static_cpu_has(X86_FEATURE_AMD_SSBD))
-			hostval |= ssbd_tif_to_spec_ctrl(ti->flags);
-
-		/* Conditional STIBP enabled? */
-		if (static_branch_unlikely(&switch_to_cond_stibp))
-			hostval |= stibp_tif_to_spec_ctrl(ti->flags);
-
 		if (hostval != guestval) {
 			msrval = setguest ? guestval : hostval;
 			wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
@@ -1272,7 +1263,6 @@ static void __init spectre_v2_select_mitigation(void)
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
-		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
 		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 	}
-- 
2.17.1

