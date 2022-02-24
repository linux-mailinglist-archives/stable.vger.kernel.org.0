Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538FC4C3156
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 17:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiBXQbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 11:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiBXQbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 11:31:12 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA24622BF6
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 08:30:29 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id p9so461475wra.12
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 08:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8iFz8OejFA6DX9qXi4bQtBNaigBN1GDlBFEToUXGY3Q=;
        b=m/r5a9WyEVahimcDrZ+I4kJ+LN5cBWUrcwkSOYJNGjLFuEihkwHAmdn4TmcJQatFmI
         iJxxXr3qTsESDM74BAln0qM6OAD6wcNOTgIt+Pi5Uf46pLxlbvkff+J5tfM09G7NRc/K
         pMyLOVPaPukn9OTEQrvxsNvp+jhK1d4R2CKv0MZCys2z0XWqYOZYUI1vJ3DGr8sN4a/w
         TzxvadnG+pes4kBwh0Slizq3PEfC1CBU4zNlGoNDM4DDrDfjbAnyUwLV9ZqgJrHtOkTw
         7sPw6x6j+46l2j40lcmS6ciEvtj1buqo5Vh66VgSW53OOnYIpDMhP3ZG7bhuWj2OWnQT
         XRkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8iFz8OejFA6DX9qXi4bQtBNaigBN1GDlBFEToUXGY3Q=;
        b=Q6JJJFU/7OhgzpXrMH2un2SXmHbXLqKOAfI3yjbhBemQTVFxkHlm6f598zOuRIJ5q1
         Ik8KVtuDYMEtIlftPn7AElj3+G/CIpEItY03siKkpfrqhs7qz1+7Gkbu+DxJm1I+t0OL
         VlFMwcCTItGKJ/ybMIimysqCGzPJdwtkApdDm+jSIlXYPzIhNBhUyng3qesD4y7QzKHK
         YEhGFZAjj2Vv600s0hRYyMINl88zTliAQsCflP/aa4a3BoF6tS7pzcHlSXY6XWq6xe94
         QOcEobo+dife6hVfXiOBFZ1X50vcvOZ012qziO5YNUu+lu1WWw3A8xyOnCxgvFZ3up7h
         bZxw==
X-Gm-Message-State: AOAM533OdG3AQAXZlgC2qyykls6dvajHNvvnX91NxmXnzSS5ComiE53D
        Q5MgVFlUkVcsZkfnlsuxzKa5ix7YlxEFQw==
X-Google-Smtp-Source: ABdhPJxM9Mr69FsUxMrjzwl+vN04ZCx0HQBkHsmr2jnNDhpL/c69hBp6L0yBwPwPAABLQy5SGzYEoA==
X-Received: by 2002:a05:6512:2306:b0:443:3db8:d6c8 with SMTP id o6-20020a056512230600b004433db8d6c8mr2302641lfu.161.1645719757815;
        Thu, 24 Feb 2022 08:22:37 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id i17sm241327lfu.207.2022.02.24.08.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 08:22:37 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Segher Boessenkool <segher@kernel.crashing.org>
Subject: [PATCHv2 2/3] powerpc: fix build errors
Date:   Thu, 24 Feb 2022 17:22:14 +0100
Message-Id: <20220224162215.3406642-2-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220224162215.3406642-1-anders.roxell@linaro.org>
References: <20220224162215.3406642-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
through the them one by one shows that the changes should be safe.  Like
__get_user_atomic_128_aligned() is only called in p9_hmi_special_emu(),
which according to the name is specific to power9.  And __raw_rm_read*()
are only called in things that are powernv or book3s_hv specific.

[1] https://sourceware.org/binutils/docs/as/PowerPC_002dPseudo.html#PowerPC_002dPseudo

Cc: <stable@vger.kernel.org>
Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 arch/powerpc/include/asm/io.h        | 40 ++++++++++++++++++++++------
 arch/powerpc/include/asm/uaccess.h   |  3 +++
 arch/powerpc/platforms/powernv/rng.c |  6 ++++-
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index beba4979bff9..fee979d3a1aa 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -359,25 +359,37 @@ static inline void __raw_writeq_be(unsigned long v, volatile void __iomem *addr)
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
 
@@ -389,7 +401,10 @@ static inline void __raw_rm_writeq_be(u64 val, volatile void __iomem *paddr)
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
@@ -397,7 +412,10 @@ static inline u8 __raw_rm_readb(volatile void __iomem *paddr)
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
@@ -405,7 +423,10 @@ static inline u16 __raw_rm_readw(volatile void __iomem *paddr)
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
@@ -413,7 +434,10 @@ static inline u32 __raw_rm_readl(volatile void __iomem *paddr)
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
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 63316100080c..4a35423f766d 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -125,8 +125,11 @@ do {								\
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
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index b4386714494a..e3d44b36ae98 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -43,7 +43,11 @@ static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
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
-- 
2.34.1

