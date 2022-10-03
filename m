Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309C45F30C9
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiJCNMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiJCNMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:12:01 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97DE4DF14;
        Mon,  3 Oct 2022 06:11:36 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 79BF442EBB;
        Mon,  3 Oct 2022 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802695;
        bh=XIHl2l4D9Aj/u9UvgJgselcZZsm3SNarJKz0ci/IPgU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=d0ThV0CIyb2jH4LPrckKLo3NOouG4beoqqgGagejy8/QdfMA/tuKnyJ2+oweaGQNH
         A6+/FG78LRmKl67K6HmCBP4CxsVBffDMuJFZ2GozT6FirTgoSCYSLPcsJRGtQiQdsw
         s5OzYD16/EuBmHm7WRAKOs7HTbClN0ISZDpijMbCSfrMANA3VlPQ5+AoC3ZvyteiFB
         WC+dA+sbAxK7EYGwuio2RhRkM/ZTGZ8PLVitS3X0rUJNB5/q/F0sA8jXPlzm8p9Gp6
         zXoq/rRxfjtQY3rK59H0LSr2zmX7WnoYWoosPhUpnLRHJ67M2lkZjaEU+Cz8j3mKNt
         fT+CWzTt+VSRQ==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 11/37] x86/entry: Remove skip_r11rcx
Date:   Mon,  3 Oct 2022 10:10:12 -0300
Message-Id: <20221003131038.12645-12-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
---
 arch/x86/entry/calling.h  | 10 +---------
 arch/x86/entry/entry_64.S |  3 +--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index b3f121478738..7950219aa2fa 100644
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
index 2ba3d53ac5b1..6be2e2952b83 100644
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
-- 
2.34.1

