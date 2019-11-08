Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34E4F542F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbfKHSy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:54:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733176AbfKHSy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474AA20865;
        Fri,  8 Nov 2019 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239295;
        bh=XCmyTQ+12MfTtmsUotGI91wLqCMwUYde/6dmLNHaGFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrH8nYf6MD9IarerlEVXM8MCJHfLxfnegni5pGkoW7TtD9KbWaeRSlIIcpehaNjdB
         ayk7JsbafxDzkpyxlPquhugnkScS7nPBCs6KGv5mhVACE71wTzQzlQWNzelFg56IQW
         CnKgrV7BTTCvWkEfAfxRtDkPxbzLL3fhuaJsK1RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Grall <julien.grall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 39/75] arm/arm64: smccc-1.1: Handle function result as parameters
Date:   Fri,  8 Nov 2019 19:49:56 +0100
Message-Id: <20191108174747.367090509@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit 755a8bf5579d22eb5636685c516d8dede799e27b ]

If someone has the silly idea to write something along those lines:

	extern u64 foo(void);

	void bar(struct arm_smccc_res *res)
	{
		arm_smccc_1_1_smc(0xbad, foo(), res);
	}

they are in for a surprise, as this gets compiled as:

	0000000000000588 <bar>:
	 588:   a9be7bfd        stp     x29, x30, [sp, #-32]!
	 58c:   910003fd        mov     x29, sp
	 590:   f9000bf3        str     x19, [sp, #16]
	 594:   aa0003f3        mov     x19, x0
	 598:   aa1e03e0        mov     x0, x30
	 59c:   94000000        bl      0 <_mcount>
	 5a0:   94000000        bl      0 <foo>
	 5a4:   aa0003e1        mov     x1, x0
	 5a8:   d4000003        smc     #0x0
	 5ac:   b4000073        cbz     x19, 5b8 <bar+0x30>
	 5b0:   a9000660        stp     x0, x1, [x19]
	 5b4:   a9010e62        stp     x2, x3, [x19, #16]
	 5b8:   f9400bf3        ldr     x19, [sp, #16]
	 5bc:   a8c27bfd        ldp     x29, x30, [sp], #32
	 5c0:   d65f03c0        ret
	 5c4:   d503201f        nop

The call to foo "overwrites" the x0 register for the return value,
and we end up calling the wrong secure service.

A solution is to evaluate all the parameters before assigning
anything to specific registers, leading to the expected result:

	0000000000000588 <bar>:
	 588:   a9be7bfd        stp     x29, x30, [sp, #-32]!
	 58c:   910003fd        mov     x29, sp
	 590:   f9000bf3        str     x19, [sp, #16]
	 594:   aa0003f3        mov     x19, x0
	 598:   aa1e03e0        mov     x0, x30
	 59c:   94000000        bl      0 <_mcount>
	 5a0:   94000000        bl      0 <foo>
	 5a4:   aa0003e1        mov     x1, x0
	 5a8:   d28175a0        mov     x0, #0xbad
	 5ac:   d4000003        smc     #0x0
	 5b0:   b4000073        cbz     x19, 5bc <bar+0x34>
	 5b4:   a9000660        stp     x0, x1, [x19]
	 5b8:   a9010e62        stp     x2, x3, [x19, #16]
	 5bc:   f9400bf3        ldr     x19, [sp, #16]
	 5c0:   a8c27bfd        ldp     x29, x30, [sp], #32
	 5c4:   d65f03c0        ret

Reported-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/arm-smccc.h |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -173,41 +173,51 @@ asmlinkage void arm_smccc_hvc(unsigned l
 	register unsigned long r3 asm("r3")
 
 #define __declare_arg_1(a0, a1, res)					\
+	typeof(a1) __a1 = a1;						\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = a1;			\
+	register unsigned long r1 asm("r1") = __a1;			\
 	register unsigned long r2 asm("r2");				\
 	register unsigned long r3 asm("r3")
 
 #define __declare_arg_2(a0, a1, a2, res)				\
+	typeof(a1) __a1 = a1;						\
+	typeof(a2) __a2 = a2;						\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = a1;			\
-	register unsigned long r2 asm("r2") = a2;			\
+	register unsigned long r1 asm("r1") = __a1;			\
+	register unsigned long r2 asm("r2") = __a2;			\
 	register unsigned long r3 asm("r3")
 
 #define __declare_arg_3(a0, a1, a2, a3, res)				\
+	typeof(a1) __a1 = a1;						\
+	typeof(a2) __a2 = a2;						\
+	typeof(a3) __a3 = a3;						\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long r0 asm("r0") = (u32)a0;			\
-	register unsigned long r1 asm("r1") = a1;			\
-	register unsigned long r2 asm("r2") = a2;			\
-	register unsigned long r3 asm("r3") = a3
+	register unsigned long r1 asm("r1") = __a1;			\
+	register unsigned long r2 asm("r2") = __a2;			\
+	register unsigned long r3 asm("r3") = __a3
 
 #define __declare_arg_4(a0, a1, a2, a3, a4, res)			\
+	typeof(a4) __a4 = a4;						\
 	__declare_arg_3(a0, a1, a2, a3, res);				\
-	register typeof(a4) r4 asm("r4") = a4
+	register unsigned long r4 asm("r4") = __a4
 
 #define __declare_arg_5(a0, a1, a2, a3, a4, a5, res)			\
+	typeof(a5) __a5 = a5;						\
 	__declare_arg_4(a0, a1, a2, a3, a4, res);			\
-	register typeof(a5) r5 asm("r5") = a5
+	register unsigned long r5 asm("r5") = __a5
 
 #define __declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res)		\
+	typeof(a6) __a6 = a6;						\
 	__declare_arg_5(a0, a1, a2, a3, a4, a5, res);			\
-	register typeof(a6) r6 asm("r6") = a6
+	register unsigned long r6 asm("r6") = __a6
 
 #define __declare_arg_7(a0, a1, a2, a3, a4, a5, a6, a7, res)		\
+	typeof(a7) __a7 = a7;						\
 	__declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res);		\
-	register typeof(a7) r7 asm("r7") = a7
+	register unsigned long r7 asm("r7") = __a7
 
 #define ___declare_args(count, ...) __declare_arg_ ## count(__VA_ARGS__)
 #define __declare_args(count, ...)  ___declare_args(count, __VA_ARGS__)


