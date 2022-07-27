Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC8D582F6A
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiG0RZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237123AbiG0RYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:24:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2049D7B1E6;
        Wed, 27 Jul 2022 09:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB47E60DDB;
        Wed, 27 Jul 2022 16:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E884FC433D6;
        Wed, 27 Jul 2022 16:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940361;
        bh=gvB9qFkp5oTwRe9KAeYPBcwDLw972dcraVKHBnGj8A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwdtsLiQoct0rlXj4k2A/OUHMDlnMeLYzm4ghbKvgwBe2DmmrMbTPsUEE1DpsF9EB
         ny7EB7wAGTbegE31y9rwqzQGqSinXtAkLy1UroWg6f0JaVLeni7Q9L8amKE7BaMbUU
         r76isaXs/4UXtc37uKE0ioGrWL7ONbVaVVKXdCBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernardo Meurer Costa <beme@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 197/201] x86/extable: Prefer local labels in .set directives
Date:   Wed, 27 Jul 2022 18:11:41 +0200
Message-Id: <20220727161035.940264257@linuxfoundation.org>
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

From: Nick Desaulniers <ndesaulniers@google.com>

commit 334865b2915c33080624e0d06f1c3e917036472c upstream.

Bernardo reported an error that Nathan bisected down to
(x86_64) defconfig+LTO_CLANG_FULL+X86_PMEM_LEGACY.

    LTO     vmlinux.o
  ld.lld: error: <instantiation>:1:13: redefinition of 'found'
  .set found, 0
              ^

  <inline asm>:29:1: while in macro instantiation
  extable_type_reg reg=%eax, type=(17 | ((0) << 16))
  ^

This appears to be another LTO specific issue similar to what was folded
into commit 4b5305decc84 ("x86/extable: Extend extable functionality"),
where the `.set found, 0` in DEFINE_EXTABLE_TYPE_REG in
arch/x86/include/asm/asm.h conflicts with the symbol for the static
function `found` in arch/x86/kernel/pmem.c.

Assembler .set directive declare symbols with global visibility, so the
assembler may not rename such symbols in the event of a conflict. LTO
could rename static functions if there was a conflict in C sources, but
it cannot see into symbols defined in inline asm.

The symbols are also retained in the symbol table, regardless of LTO.

Give the symbols .L prefixes making them locally visible, so that they
may be renamed for LTO to avoid conflicts, and to drop them from the
symbol table regardless of LTO.

Fixes: 4b5305decc84 ("x86/extable: Extend extable functionality")
Reported-by: Bernardo Meurer Costa <beme@google.com>
Debugged-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20220329202148.2379697-1-ndesaulniers@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/asm.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -149,24 +149,24 @@
 
 # define DEFINE_EXTABLE_TYPE_REG \
 	".macro extable_type_reg type:req reg:req\n"						\
-	".set found, 0\n"									\
-	".set regnr, 0\n"									\
+	".set .Lfound, 0\n"									\
+	".set .Lregnr, 0\n"									\
 	".irp rs,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15\n"		\
 	".ifc \\reg, %%\\rs\n"									\
-	".set found, found+1\n"									\
-	".long \\type + (regnr << 8)\n"								\
+	".set .Lfound, .Lfound+1\n"								\
+	".long \\type + (.Lregnr << 8)\n"							\
 	".endif\n"										\
-	".set regnr, regnr+1\n"									\
+	".set .Lregnr, .Lregnr+1\n"								\
 	".endr\n"										\
-	".set regnr, 0\n"									\
+	".set .Lregnr, 0\n"									\
 	".irp rs,eax,ecx,edx,ebx,esp,ebp,esi,edi,r8d,r9d,r10d,r11d,r12d,r13d,r14d,r15d\n"	\
 	".ifc \\reg, %%\\rs\n"									\
-	".set found, found+1\n"									\
-	".long \\type + (regnr << 8)\n"								\
+	".set .Lfound, .Lfound+1\n"								\
+	".long \\type + (.Lregnr << 8)\n"							\
 	".endif\n"										\
-	".set regnr, regnr+1\n"									\
+	".set .Lregnr, .Lregnr+1\n"								\
 	".endr\n"										\
-	".if (found != 1)\n"									\
+	".if (.Lfound != 1)\n"									\
 	".error \"extable_type_reg: bad register argument\"\n"					\
 	".endif\n"										\
 	".endm\n"


