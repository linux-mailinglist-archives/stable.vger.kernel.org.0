Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B375050F5
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238925AbiDRMaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239831AbiDRM3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:29:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBE42252F;
        Mon, 18 Apr 2022 05:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08633B80ED7;
        Mon, 18 Apr 2022 12:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4EAC385A7;
        Mon, 18 Apr 2022 12:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284558;
        bh=QMX86yDOHgHCQF7PKdcANYx9Gm9XmftVcAWvc7nmjg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0MV1Lvv2fOaOBKtP0uOwm1z/amJShd5UX6D7HwkRz9OIXqYeFpkqm8bxNch1LB8E
         JDH+G+tCzg6CPvnwo9Q9X2ZellIQoQKE73sZ8DU8xD6Hig5GlWqrlc4InNK5KXWZXP
         UI+231C2sp0exwevnNC85xE+LUoYtzmee9XdqV5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 154/219] static_call: Properly initialise DEFINE_STATIC_CALL_RET0()
Date:   Mon, 18 Apr 2022 14:12:03 +0200
Message-Id: <20220418121211.196704519@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 5517d500829c683a358a8de04ecb2e28af629ae5 ]

When a static call is updated with __static_call_return0() as target,
arch_static_call_transform() set it to use an optimised set of
instructions which are meant to lay in the same cacheline.

But when initialising a static call with DEFINE_STATIC_CALL_RET0(),
we get a branch to the real __static_call_return0() function instead
of getting the optimised setup:

	c00d8120 <__SCT__perf_snapshot_branch_stack>:
	c00d8120:	4b ff ff f4 	b       c00d8114 <__static_call_return0>
	c00d8124:	3d 80 c0 0e 	lis     r12,-16370
	c00d8128:	81 8c 81 3c 	lwz     r12,-32452(r12)
	c00d812c:	7d 89 03 a6 	mtctr   r12
	c00d8130:	4e 80 04 20 	bctr
	c00d8134:	38 60 00 00 	li      r3,0
	c00d8138:	4e 80 00 20 	blr
	c00d813c:	00 00 00 00 	.long 0x0

Add ARCH_DEFINE_STATIC_CALL_RET0_TRAMP() defined by each architecture
to setup the optimised configuration, and rework
DEFINE_STATIC_CALL_RET0() to call it:

	c00d8120 <__SCT__perf_snapshot_branch_stack>:
	c00d8120:	48 00 00 14 	b       c00d8134 <__SCT__perf_snapshot_branch_stack+0x14>
	c00d8124:	3d 80 c0 0e 	lis     r12,-16370
	c00d8128:	81 8c 81 3c 	lwz     r12,-32452(r12)
	c00d812c:	7d 89 03 a6 	mtctr   r12
	c00d8130:	4e 80 04 20 	bctr
	c00d8134:	38 60 00 00 	li      r3,0
	c00d8138:	4e 80 00 20 	blr
	c00d813c:	00 00 00 00 	.long 0x0

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/1e0a61a88f52a460f62a58ffc2a5f847d1f7d9d8.1647253456.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/static_call.h |  1 +
 arch/x86/include/asm/static_call.h     |  2 ++
 include/linux/static_call.h            | 20 +++++++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/static_call.h b/arch/powerpc/include/asm/static_call.h
index 0a0bc79bd1fa..de1018cc522b 100644
--- a/arch/powerpc/include/asm/static_call.h
+++ b/arch/powerpc/include/asm/static_call.h
@@ -24,5 +24,6 @@
 
 #define ARCH_DEFINE_STATIC_CALL_TRAMP(name, func)	__PPC_SCT(name, "b " #func)
 #define ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)	__PPC_SCT(name, "blr")
+#define ARCH_DEFINE_STATIC_CALL_RET0_TRAMP(name)	__PPC_SCT(name, "b .+20")
 
 #endif /* _ASM_POWERPC_STATIC_CALL_H */
diff --git a/arch/x86/include/asm/static_call.h b/arch/x86/include/asm/static_call.h
index ed4f8bb6c2d9..2455d721503e 100644
--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -38,6 +38,8 @@
 #define ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)			\
 	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, "ret; int3; nop; nop; nop")
 
+#define ARCH_DEFINE_STATIC_CALL_RET0_TRAMP(name)			\
+	ARCH_DEFINE_STATIC_CALL_TRAMP(name, __static_call_return0)
 
 #define ARCH_ADD_TRAMP_KEY(name)					\
 	asm(".pushsection .static_call_tramp_key, \"a\"		\n"	\
diff --git a/include/linux/static_call.h b/include/linux/static_call.h
index fcc5b48989b3..3c50b0fdda16 100644
--- a/include/linux/static_call.h
+++ b/include/linux/static_call.h
@@ -196,6 +196,14 @@ extern long __static_call_return0(void);
 	};								\
 	ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
 
+#define DEFINE_STATIC_CALL_RET0(name, _func)				\
+	DECLARE_STATIC_CALL(name, _func);				\
+	struct static_call_key STATIC_CALL_KEY(name) = {		\
+		.func = __static_call_return0,				\
+		.type = 1,						\
+	};								\
+	ARCH_DEFINE_STATIC_CALL_RET0_TRAMP(name)
+
 #define static_call_cond(name)	(void)__static_call(name)
 
 #define EXPORT_STATIC_CALL(name)					\
@@ -231,6 +239,12 @@ static inline int static_call_init(void) { return 0; }
 	};								\
 	ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
 
+#define DEFINE_STATIC_CALL_RET0(name, _func)				\
+	DECLARE_STATIC_CALL(name, _func);				\
+	struct static_call_key STATIC_CALL_KEY(name) = {		\
+		.func = __static_call_return0,				\
+	};								\
+	ARCH_DEFINE_STATIC_CALL_RET0_TRAMP(name)
 
 #define static_call_cond(name)	(void)__static_call(name)
 
@@ -284,6 +298,9 @@ static inline long __static_call_return0(void)
 		.func = NULL,						\
 	}
 
+#define DEFINE_STATIC_CALL_RET0(name, _func)				\
+	__DEFINE_STATIC_CALL(name, _func, __static_call_return0)
+
 static inline void __static_call_nop(void) { }
 
 /*
@@ -327,7 +344,4 @@ static inline int static_call_text_reserved(void *start, void *end)
 #define DEFINE_STATIC_CALL(name, _func)					\
 	__DEFINE_STATIC_CALL(name, _func, _func)
 
-#define DEFINE_STATIC_CALL_RET0(name, _func)				\
-	__DEFINE_STATIC_CALL(name, _func, __static_call_return0)
-
 #endif /* _LINUX_STATIC_CALL_H */
-- 
2.35.1



