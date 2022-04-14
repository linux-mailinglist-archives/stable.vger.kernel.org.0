Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA0D501553
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348269AbiDNOED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346265AbiDNN4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:56:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEF469711;
        Thu, 14 Apr 2022 06:46:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF00D61D7C;
        Thu, 14 Apr 2022 13:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0ADC385A5;
        Thu, 14 Apr 2022 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943987;
        bh=eIxwzhY4iWEqemklQ0o7WUSParhWIa+YvSWZuF5JoEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIOHNubHtryJlbUk6qgKEs/vhDsodLa0oywE6rWvwKB3HlxDgG/Qa178TBTGZPZm2
         hJESES0FQjOr4QtRy9yjnWXPaKBbfZBv1Yij7ecrTKwuQQSlYy9XxyRwHhy1he0xjv
         UenGyLU6JNUcsKpVh5UXcQEkH7luTQG+hVPh23bY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 313/475] powerpc: Fix build errors with newer binutils
Date:   Thu, 14 Apr 2022 15:11:38 +0200
Message-Id: <20220414110903.847827054@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Anders Roxell <anders.roxell@linaro.org>

commit 8667d0d64dd1f84fd41b5897fd87fa9113ae05e3 upstream.

Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
2.37.90.20220207) the following build error shows up:

  {standard input}: Assembler messages:
  {standard input}:1190: Error: unrecognized opcode: `stbcix'
  {standard input}:1433: Error: unrecognized opcode: `lwzcix'
  {standard input}:1453: Error: unrecognized opcode: `stbcix'
  {standard input}:1460: Error: unrecognized opcode: `stwcix'
  {standard input}:1596: Error: unrecognized opcode: `stbcix'
  ...

Rework to add assembler directives [1] around the instruction. Going
through them one by one shows that the changes should be safe.  Like
__get_user_atomic_128_aligned() is only called in p9_hmi_special_emu(),
which according to the name is specific to power9.  And __raw_rm_read*()
are only called in things that are powernv or book3s_hv specific.

[1] https://sourceware.org/binutils/docs/as/PowerPC_002dPseudo.html#PowerPC_002dPseudo

Cc: stable@vger.kernel.org
Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
[mpe: Make commit subject more descriptive]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220224162215.3406642-2-anders.roxell@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/io.h        |   40 ++++++++++++++++++++++++++++-------
 arch/powerpc/include/asm/uaccess.h   |    3 ++
 arch/powerpc/platforms/powernv/rng.c |    6 ++++-
 3 files changed, 40 insertions(+), 9 deletions(-)

--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -345,25 +345,37 @@ static inline void __raw_writeq_be(unsig
  */
 static inline void __raw_rm_writeb(u8 val, volatile void __iomem *paddr)
 {
-	__asm__ __volatile__("stbcix %0,0,%1"
+	__asm__ __volatile__(".machine push;   \
+			      .machine power6; \
+			      stbcix %0,0,%1;  \
+			      .machine pop;"
 		: : "r" (val), "r" (paddr) : "memory");
 }
 
 static inline void __raw_rm_writew(u16 val, volatile void __iomem *paddr)
 {
-	__asm__ __volatile__("sthcix %0,0,%1"
+	__asm__ __volatile__(".machine push;   \
+			      .machine power6; \
+			      sthcix %0,0,%1;  \
+			      .machine pop;"
 		: : "r" (val), "r" (paddr) : "memory");
 }
 
 static inline void __raw_rm_writel(u32 val, volatile void __iomem *paddr)
 {
-	__asm__ __volatile__("stwcix %0,0,%1"
+	__asm__ __volatile__(".machine push;   \
+			      .machine power6; \
+			      stwcix %0,0,%1;  \
+			      .machine pop;"
 		: : "r" (val), "r" (paddr) : "memory");
 }
 
 static inline void __raw_rm_writeq(u64 val, volatile void __iomem *paddr)
 {
-	__asm__ __volatile__("stdcix %0,0,%1"
+	__asm__ __volatile__(".machine push;   \
+			      .machine power6; \
+			      stdcix %0,0,%1;  \
+			      .machine pop;"
 		: : "r" (val), "r" (paddr) : "memory");
 }
 
@@ -375,7 +387,10 @@ static inline void __raw_rm_writeq_be(u6
 static inline u8 __raw_rm_readb(volatile void __iomem *paddr)
 {
 	u8 ret;
-	__asm__ __volatile__("lbzcix %0,0, %1"
+	__asm__ __volatile__(".machine push;   \
+			      .machine power6; \
+			      lbzcix %0,0, %1; \
+			      .machine pop;"
 			     : "=r" (ret) : "r" (paddr) : "memory");
 	return ret;
 }
@@ -383,7 +398,10 @@ static inline u8 __raw_rm_readb(volatile
 static inline u16 __raw_rm_readw(volatile void __iomem *paddr)
 {
 	u16 ret;
-	__asm__ __volatile__("lhzcix %0,0, %1"
+	__asm__ __volatile__(".machine push;   \
+			      .machine power6; \
+			      lhzcix %0,0, %1; \
+			      .machine pop;"
 			     : "=r" (ret) : "r" (paddr) : "memory");
 	return ret;
 }
@@ -391,7 +409,10 @@ static inline u16 __raw_rm_readw(volatil
 static inline u32 __raw_rm_readl(volatile void __iomem *paddr)
 {
 	u32 ret;
-	__asm__ __volatile__("lwzcix %0,0, %1"
+	__asm__ __volatile__(".machine push;   \
+			      .machine power6; \
+			      lwzcix %0,0, %1; \
+			      .machine pop;"
 			     : "=r" (ret) : "r" (paddr) : "memory");
 	return ret;
 }
@@ -399,7 +420,10 @@ static inline u32 __raw_rm_readl(volatil
 static inline u64 __raw_rm_readq(volatile void __iomem *paddr)
 {
 	u64 ret;
-	__asm__ __volatile__("ldcix %0,0, %1"
+	__asm__ __volatile__(".machine push;   \
+			      .machine power6; \
+			      ldcix %0,0, %1;  \
+			      .machine pop;"
 			     : "=r" (ret) : "r" (paddr) : "memory");
 	return ret;
 }
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -191,8 +191,11 @@ extern long __get_user_bad(void);
  */
 #define __get_user_atomic_128_aligned(kaddr, uaddr, err)		\
 	__asm__ __volatile__(				\
+		".machine push\n"			\
+		".machine altivec\n"			\
 		"1:	lvx  0,0,%1	# get user\n"	\
 		" 	stvx 0,0,%2	# put kernel\n"	\
+		".machine pop\n"			\
 		"2:\n"					\
 		".section .fixup,\"ax\"\n"		\
 		"3:	li %0,%3\n"			\
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -43,7 +43,11 @@ static unsigned long rng_whiten(struct p
 	unsigned long parity;
 
 	/* Calculate the parity of the value */
-	asm ("popcntd %0,%1" : "=r" (parity) : "r" (val));
+	asm (".machine push;   \
+	      .machine power7; \
+	      popcntd %0,%1;   \
+	      .machine pop;"
+	     : "=r" (parity) : "r" (val));
 
 	/* xor our value with the previous mask */
 	val ^= rng->mask;


