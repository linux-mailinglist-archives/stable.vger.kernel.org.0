Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126A15F53B5
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJELix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiJELiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:38:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE033C176;
        Wed,  5 Oct 2022 04:35:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67F6A61650;
        Wed,  5 Oct 2022 11:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79408C433C1;
        Wed,  5 Oct 2022 11:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969686;
        bh=jptJQbqQkDR9voAeaKmIiDtDOa/Eemt4DuBNEaUezZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCZAi3/LEHjM/mwt5bb7hzDNoJFvQB/iylil8xS+D+ioU+yeVzhuL2Fka1ZyUsD8h
         3FEOtADKpKmxEzS+WXKR8f3O6QEtnKc8+HQlDp5DwBdERW8F8QXaJbhRWql1DSZhhb
         2ebl7q6xol9u0FA5ZNkttGVGjgc4l6kWdrbAYQCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 11/51] x86/entry: Remove skip_r11rcx
Date:   Wed,  5 Oct 2022 13:31:59 +0200
Message-Id: <20221005113210.784576725@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/entry/calling.h  |   10 +---------
 arch/x86/entry/entry_64.S |    3 +--
 2 files changed, 2 insertions(+), 11 deletions(-)

--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -146,27 +146,19 @@ For 32-bit we have the following convent
 
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
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -248,8 +248,7 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
-	/* rcx and r11 are already restored (see code above) */
-	POP_REGS pop_rdi=0 skip_r11rcx=1
+	POP_REGS pop_rdi=0
 
 	/*
 	 * Now all regs are restored except RSP and RDI.


