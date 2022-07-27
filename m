Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E6F582EFD
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbiG0RUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240113AbiG0RSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D795C9C3;
        Wed, 27 Jul 2022 09:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCBE7B8200C;
        Wed, 27 Jul 2022 16:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF11C433C1;
        Wed, 27 Jul 2022 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940225;
        bh=fQbnzm2Dq9Za4ZflIcr2EXIrw0q4yIR4IjS0LUqj6cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvL7+CEQ+TkQlw9ljrObHvmbq/XD9aLIP7ycTmD+OJCv30JZdAJCP+U9Nip17/940
         hJD0+x9jxGW/cScFLMCsoeGTDT67F5yLnc1S147e2rCRgR1UYP7PQSlTod9AGq7Iva
         1W/EiipzEjI28JKfdntvgs7RkEFZ5J7SIAsX/A7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/201] x86/futex: Remove .fixup usage
Date:   Wed, 27 Jul 2022 18:10:54 +0200
Message-Id: <20220727161034.050152608@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4c132d1d844a53fc4e4b5c34e36ef10d6124b783 ]

Use the new EX_TYPE_IMM_REG to store -EFAULT into the designated 'ret'
register, this removes the need for anonymous .fixup code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20211110101325.426016322@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/extable_fixup_types.h |  2 ++
 arch/x86/include/asm/futex.h               | 28 +++++++---------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/include/asm/extable_fixup_types.h
index 9d597fe1017d..7469038de100 100644
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -42,6 +42,8 @@
 #define	EX_TYPE_DEFAULT_MCE_SAFE	14
 #define	EX_TYPE_FAULT_MCE_SAFE		15
 #define	EX_TYPE_POP_ZERO		16
+
 #define	EX_TYPE_IMM_REG			17 /* reg := (long)imm */
+#define	EX_TYPE_EFAULT_REG		(EX_TYPE_IMM_REG | EX_DATA_IMM(-EFAULT))
 
 #endif
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index f9c00110a69a..99d345b686fa 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -17,13 +17,9 @@ do {								\
 	int oldval = 0, ret;					\
 	asm volatile("1:\t" insn "\n"				\
 		     "2:\n"					\
-		     "\t.section .fixup,\"ax\"\n"		\
-		     "3:\tmov\t%3, %1\n"			\
-		     "\tjmp\t2b\n"				\
-		     "\t.previous\n"				\
-		     _ASM_EXTABLE_UA(1b, 3b)			\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %1) \
 		     : "=r" (oldval), "=r" (ret), "+m" (*uaddr)	\
-		     : "i" (-EFAULT), "0" (oparg), "1" (0));	\
+		     : "0" (oparg), "1" (0));	\
 	if (ret)						\
 		goto label;					\
 	*oval = oldval;						\
@@ -39,15 +35,11 @@ do {								\
 		     "3:\t" LOCK_PREFIX "cmpxchgl %3, %2\n"	\
 		     "\tjnz\t2b\n"				\
 		     "4:\n"					\
-		     "\t.section .fixup,\"ax\"\n"		\
-		     "5:\tmov\t%5, %1\n"			\
-		     "\tjmp\t4b\n"				\
-		     "\t.previous\n"				\
-		     _ASM_EXTABLE_UA(1b, 5b)			\
-		     _ASM_EXTABLE_UA(3b, 5b)			\
+		     _ASM_EXTABLE_TYPE_REG(1b, 4b, EX_TYPE_EFAULT_REG, %1) \
+		     _ASM_EXTABLE_TYPE_REG(3b, 4b, EX_TYPE_EFAULT_REG, %1) \
 		     : "=&a" (oldval), "=&r" (ret),		\
 		       "+m" (*uaddr), "=&r" (tem)		\
-		     : "r" (oparg), "i" (-EFAULT), "1" (0));	\
+		     : "r" (oparg), "1" (0));			\
 	if (ret)						\
 		goto label;					\
 	*oval = oldval;						\
@@ -95,15 +87,11 @@ static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	if (!user_access_begin(uaddr, sizeof(u32)))
 		return -EFAULT;
 	asm volatile("\n"
-		"1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
+		"1:\t" LOCK_PREFIX "cmpxchgl %3, %2\n"
 		"2:\n"
-		"\t.section .fixup, \"ax\"\n"
-		"3:\tmov     %3, %0\n"
-		"\tjmp     2b\n"
-		"\t.previous\n"
-		_ASM_EXTABLE_UA(1b, 3b)
+		_ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %0) \
 		: "+r" (ret), "=a" (oldval), "+m" (*uaddr)
-		: "i" (-EFAULT), "r" (newval), "1" (oldval)
+		: "r" (newval), "1" (oldval)
 		: "memory"
 	);
 	user_access_end();
-- 
2.35.1



