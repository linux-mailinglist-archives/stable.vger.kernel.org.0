Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C40572380
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbiGLSrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiGLSrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667E1DE189;
        Tue, 12 Jul 2022 11:43:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4C966186E;
        Tue, 12 Jul 2022 18:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D964AC3411E;
        Tue, 12 Jul 2022 18:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651389;
        bh=l9Rc68ra/4bHVh2wqbrdbsWHOSZSdMEmpI128/zN7Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6UJiv6ghGoTZ0GpOg7qFk/c7XUgupaZ8agMlfGnUvb4IWvfRf6HRowrlm8nNe2fY
         VQ21MC3cs/D/MhyJUJknkMtqu2rmNJu7SBB0Q+WV0U+jwimRZmhLVpwrCKSZcgR0Dr
         Ojs6el8gRR6aIzzqowrtx8pcsNa6YVRceUx9NmGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 061/130] x86/lib/atomic64_386_32: Rename things
Date:   Tue, 12 Jul 2022 20:38:27 +0200
Message-Id: <20220712183249.275313711@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 22da5a07c75e1104caf6a42f189c97b83d070073 upstream.

Principally, in order to get rid of #define RET in this code to make
place for a new RET, but also to clarify the code, rename a bunch of
things:

  s/UNLOCK/IRQ_RESTORE/
  s/LOCK/IRQ_SAVE/
  s/BEGIN/BEGIN_IRQ_SAVE/
  s/\<RET\>/RET_IRQ_RESTORE/
  s/RET_ENDP/\tRET_IRQ_RESTORE\rENDP/

which then leaves RET unused so it can be removed.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211204134907.841623970@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/atomic64_386_32.S |   84 ++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 38 deletions(-)

--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -9,81 +9,83 @@
 #include <asm/alternative.h>
 
 /* if you want SMP support, implement these with real spinlocks */
-.macro LOCK reg
+.macro IRQ_SAVE reg
 	pushfl
 	cli
 .endm
 
-.macro UNLOCK reg
+.macro IRQ_RESTORE reg
 	popfl
 .endm
 
-#define BEGIN(op) \
+#define BEGIN_IRQ_SAVE(op) \
 .macro endp; \
 SYM_FUNC_END(atomic64_##op##_386); \
 .purgem endp; \
 .endm; \
 SYM_FUNC_START(atomic64_##op##_386); \
-	LOCK v;
+	IRQ_SAVE v;
 
 #define ENDP endp
 
-#define RET \
-	UNLOCK v; \
+#define RET_IRQ_RESTORE \
+	IRQ_RESTORE v; \
 	ret
 
-#define RET_ENDP \
-	RET; \
-	ENDP
-
 #define v %ecx
-BEGIN(read)
+BEGIN_IRQ_SAVE(read)
 	movl  (v), %eax
 	movl 4(v), %edx
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(set)
+BEGIN_IRQ_SAVE(set)
 	movl %ebx,  (v)
 	movl %ecx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v  %esi
-BEGIN(xchg)
+BEGIN_IRQ_SAVE(xchg)
 	movl  (v), %eax
 	movl 4(v), %edx
 	movl %ebx,  (v)
 	movl %ecx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %ecx
-BEGIN(add)
+BEGIN_IRQ_SAVE(add)
 	addl %eax,  (v)
 	adcl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %ecx
-BEGIN(add_return)
+BEGIN_IRQ_SAVE(add_return)
 	addl  (v), %eax
 	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %ecx
-BEGIN(sub)
+BEGIN_IRQ_SAVE(sub)
 	subl %eax,  (v)
 	sbbl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %ecx
-BEGIN(sub_return)
+BEGIN_IRQ_SAVE(sub_return)
 	negl %edx
 	negl %eax
 	sbbl $0, %edx
@@ -91,47 +93,52 @@ BEGIN(sub_return)
 	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(inc)
+BEGIN_IRQ_SAVE(inc)
 	addl $1,  (v)
 	adcl $0, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(inc_return)
+BEGIN_IRQ_SAVE(inc_return)
 	movl  (v), %eax
 	movl 4(v), %edx
 	addl $1, %eax
 	adcl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(dec)
+BEGIN_IRQ_SAVE(dec)
 	subl $1,  (v)
 	sbbl $0, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(dec_return)
+BEGIN_IRQ_SAVE(dec_return)
 	movl  (v), %eax
 	movl 4(v), %edx
 	subl $1, %eax
 	sbbl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(add_unless)
+BEGIN_IRQ_SAVE(add_unless)
 	addl %eax, %ecx
 	adcl %edx, %edi
 	addl  (v), %eax
@@ -143,7 +150,7 @@ BEGIN(add_unless)
 	movl %edx, 4(v)
 	movl $1, %eax
 2:
-	RET
+	RET_IRQ_RESTORE
 3:
 	cmpl %edx, %edi
 	jne 1b
@@ -153,7 +160,7 @@ ENDP
 #undef v
 
 #define v %esi
-BEGIN(inc_not_zero)
+BEGIN_IRQ_SAVE(inc_not_zero)
 	movl  (v), %eax
 	movl 4(v), %edx
 	testl %eax, %eax
@@ -165,7 +172,7 @@ BEGIN(inc_not_zero)
 	movl %edx, 4(v)
 	movl $1, %eax
 2:
-	RET
+	RET_IRQ_RESTORE
 3:
 	testl %edx, %edx
 	jne 1b
@@ -174,7 +181,7 @@ ENDP
 #undef v
 
 #define v %esi
-BEGIN(dec_if_positive)
+BEGIN_IRQ_SAVE(dec_if_positive)
 	movl  (v), %eax
 	movl 4(v), %edx
 	subl $1, %eax
@@ -183,5 +190,6 @@ BEGIN(dec_if_positive)
 	movl %eax,  (v)
 	movl %edx, 4(v)
 1:
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v


