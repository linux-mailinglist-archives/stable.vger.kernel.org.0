Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B895F5420
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732947AbfKHSy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:54:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbfKHSyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C9521D7F;
        Fri,  8 Nov 2019 18:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239263;
        bh=wuf/8sbxeqrQDFNdCPZk/wONDsGgggqmt0P9phCsHPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqDSjdToNN75Z3F7RHqMFbpj8vzvJn04Rtk5RFbvtL7OkfKaUjX7znVyMIHI2TRz+
         jeqSlXFaHV6bZCIL77GdlC3/9ngkU2qJoEw9UXkNtoLvctIMtLhVVAZRUDFzKoJMMi
         lP7k4f8lFrIr83s9em7RHdCqhgARc6yAebEiZlRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Grall <julien.grall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 38/75] arm/arm64: smccc-1.1: Make return values unsigned long
Date:   Fri,  8 Nov 2019 19:49:55 +0100
Message-Id: <20191108174746.463484664@linuxfoundation.org>
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

[ Upstream commit 1d8f574708a3fb6f18c85486d0c5217df893c0cf ]

An unfortunate consequence of having a strong typing for the input
values to the SMC call is that it also affects the type of the
return values, limiting r0 to 32 bits and r{1,2,3} to whatever
was passed as an input.

Let's turn everything into "unsigned long", which satisfies the
requirements of both architectures, and allows for the full
range of return values.

Reported-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/arm-smccc.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -167,31 +167,31 @@ asmlinkage void arm_smccc_hvc(unsigned l
 
 #define __declare_arg_0(a0, res)					\
 	struct arm_smccc_res   *___res = res;				\
-	register u32           r0 asm("r0") = a0;			\
+	register unsigned long r0 asm("r0") = (u32)a0;			\
 	register unsigned long r1 asm("r1");				\
 	register unsigned long r2 asm("r2");				\
 	register unsigned long r3 asm("r3")
 
 #define __declare_arg_1(a0, a1, res)					\
 	struct arm_smccc_res   *___res = res;				\
-	register u32           r0 asm("r0") = a0;			\
-	register typeof(a1)    r1 asm("r1") = a1;			\
+	register unsigned long r0 asm("r0") = (u32)a0;			\
+	register unsigned long r1 asm("r1") = a1;			\
 	register unsigned long r2 asm("r2");				\
 	register unsigned long r3 asm("r3")
 
 #define __declare_arg_2(a0, a1, a2, res)				\
 	struct arm_smccc_res   *___res = res;				\
-	register u32           r0 asm("r0") = a0;			\
-	register typeof(a1)    r1 asm("r1") = a1;			\
-	register typeof(a2)    r2 asm("r2") = a2;			\
+	register unsigned long r0 asm("r0") = (u32)a0;			\
+	register unsigned long r1 asm("r1") = a1;			\
+	register unsigned long r2 asm("r2") = a2;			\
 	register unsigned long r3 asm("r3")
 
 #define __declare_arg_3(a0, a1, a2, a3, res)				\
 	struct arm_smccc_res   *___res = res;				\
-	register u32           r0 asm("r0") = a0;			\
-	register typeof(a1)    r1 asm("r1") = a1;			\
-	register typeof(a2)    r2 asm("r2") = a2;			\
-	register typeof(a3)    r3 asm("r3") = a3
+	register unsigned long r0 asm("r0") = (u32)a0;			\
+	register unsigned long r1 asm("r1") = a1;			\
+	register unsigned long r2 asm("r2") = a2;			\
+	register unsigned long r3 asm("r3") = a3
 
 #define __declare_arg_4(a0, a1, a2, a3, a4, res)			\
 	__declare_arg_3(a0, a1, a2, a3, res);				\


