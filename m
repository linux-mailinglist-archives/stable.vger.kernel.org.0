Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF304FD77A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiDLHah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353059AbiDLHZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADC84D638;
        Tue, 12 Apr 2022 00:00:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B4E3615B4;
        Tue, 12 Apr 2022 07:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A3EC385AA;
        Tue, 12 Apr 2022 07:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746806;
        bh=qT4rRxjdgHvgFLUUTFXORG38wBgzvPAGzYgrVrQ2Wyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcveiLWjT1mWudMNksZFPKHY90jUtRRcyHc1bz8L1WaZNDzPkK3XkM8UmGxBwzrVr
         EGzsrpxSgeP1gnd4+Q8h6cHveaDFZJLLywJGR+aMSs+FQ/smOiHt6BEB5BjjqhXiQh
         r5TrfxEXBg1WNqbL3srf/GG9Igov5Wt1p8vl/hcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 137/285] x86: Annotate call_on_stack()
Date:   Tue, 12 Apr 2022 08:29:54 +0200
Message-Id: <20220412062947.621591678@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit be0075951fde739f14ee2b659e2fd6e2499c46c0 ]

vmlinux.o: warning: objtool: page_fault_oops()+0x13c: unreachable instruction

0000 000000000005b460 <page_fault_oops>:
...
0128    5b588:  49 89 23                mov    %rsp,(%r11)
012b    5b58b:  4c 89 dc                mov    %r11,%rsp
012e    5b58e:  4c 89 f2                mov    %r14,%rdx
0131    5b591:  48 89 ee                mov    %rbp,%rsi
0134    5b594:  4c 89 e7                mov    %r12,%rdi
0137    5b597:  e8 00 00 00 00          call   5b59c <page_fault_oops+0x13c>    5b598: R_X86_64_PLT32   handle_stack_overflow-0x4
013c    5b59c:  5c                      pop    %rsp

vmlinux.o: warning: objtool: sysvec_reboot()+0x6d: unreachable instruction

0000 00000000000033f0 <sysvec_reboot>:
...
005d     344d:  4c 89 dc                mov    %r11,%rsp
0060     3450:  e8 00 00 00 00          call   3455 <sysvec_reboot+0x65>        3451: R_X86_64_PLT32    irq_enter_rcu-0x4
0065     3455:  48 89 ef                mov    %rbp,%rdi
0068     3458:  e8 00 00 00 00          call   345d <sysvec_reboot+0x6d>        3459: R_X86_64_PC32     .text+0x47d0c
006d     345d:  e8 00 00 00 00          call   3462 <sysvec_reboot+0x72>        345e: R_X86_64_PLT32    irq_exit_rcu-0x4
0072     3462:  5c                      pop    %rsp

Both cases are due to a call_on_stack() calling a __noreturn function.
Since that's an inline asm, GCC can't do anything about the
instructions after the CALL. Therefore put in an explicit
ASM_REACHABLE annotation to make sure objtool and gcc are consistently
confused about control flow.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154319.468805622@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/irq_stack.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/irq_stack.h b/arch/x86/include/asm/irq_stack.h
index ae9d40f6c706..05af249d6bec 100644
--- a/arch/x86/include/asm/irq_stack.h
+++ b/arch/x86/include/asm/irq_stack.h
@@ -99,7 +99,8 @@
 }
 
 #define ASM_CALL_ARG0							\
-	"call %P[__func]				\n"
+	"call %P[__func]				\n"		\
+	ASM_REACHABLE
 
 #define ASM_CALL_ARG1							\
 	"movq	%[arg1], %%rdi				\n"		\
-- 
2.35.1



