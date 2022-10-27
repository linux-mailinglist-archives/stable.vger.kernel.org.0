Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023C96103B4
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiJ0VDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236348AbiJ0VCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:02:39 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA411F62E;
        Thu, 27 Oct 2022 13:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904099; x=1698440099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=6so0MzVbzuu7W7/xGX9tuwdaEVJrpztFAYeYMSCA6vo=;
  b=nn0R8gMKdQHJORBnGSwdeJhC3dQnauWkMpHdwf50sOqdz2NJ/MoRfToS
   t1np11s9fneHd/fdNM+3VH8sa30dG50Zhca5SgvoSGh+chLPSStFyUpK4
   ZW+Zc3O1jYepRUazBV91/ogkiqOKleSq/jejmDAORxhI1fM2XjAxzBuaQ
   w=;
X-IronPort-AV: E=Sophos;i="5.95,218,1661817600"; 
   d="scan'208";a="260700168"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:54:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id B84274174C;
        Thu, 27 Oct 2022 20:54:52 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:54:51 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.162.178) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:54:50 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 07/34] x86/entry: Remove skip_r11rcx
Date:   Thu, 27 Oct 2022 13:54:41 -0700
Message-ID: <20221027205442.17210-3-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027205442.17210-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
 <20221027205442.17210-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D35UWC003.ant.amazon.com (10.43.162.130) To
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

From: Peter Zijlstra <peterz@infradead.org>

commit 1b331eeea7b8676fc5dbdf80d0a07e41be226177 upstream.

Yes, r11 and rcx have been restored previously, but since they're being
popped anyway (into rsi) might as well pop them into their own regs --
setting them to the value they already are.

Less magical code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220506121631.365070674@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/calling.h  | 10 +---------
 arch/x86/entry/entry_64.S |  3 +--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 1dbc62a96b85..273b562af8fa 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -146,27 +146,19 @@ For 32-bit we have the following conventions - kernel is built with
 
 .endm
 
-.macro POP_REGS pop_rdi=1 skip_r11rcx=0
+.macro POP_REGS pop_rdi=1
 	popq %r15
 	popq %r14
 	popq %r13
 	popq %r12
 	popq %rbp
 	popq %rbx
-	.if \skip_r11rcx
-	popq %rsi
-	.else
 	popq %r11
-	.endif
 	popq %r10
 	popq %r9
 	popq %r8
 	popq %rax
-	.if \skip_r11rcx
-	popq %rsi
-	.else
 	popq %rcx
-	.endif
 	popq %rdx
 	popq %rsi
 	.if \pop_rdi
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index ac389ffb1822..d3472e773b5a 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -301,8 +301,7 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
-	/* rcx and r11 are already restored (see code above) */
-	POP_REGS pop_rdi=0 skip_r11rcx=1
+	POP_REGS pop_rdi=0
 
 	/*
 	 * Now all regs are restored except RSP and RDI.
-- 
2.17.1

