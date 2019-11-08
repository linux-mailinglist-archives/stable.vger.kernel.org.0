Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD8AF4BC9
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKHMgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfKHMgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:38 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 003B9222CE;
        Fri,  8 Nov 2019 12:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216597;
        bh=lfqNguIX+MS46uPt+mN0qDZclrGzkeCxHG39i5vuD9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krWsqwHyo6DwWAFs7OvJ5/sUootB7W7uX9cXhbmaiqyt6g8HYLbGPxI1dyhDQ/RQJ
         QYPAj/XJ4Ek0UEkeW32I+WIbq4/FI2jkhrCoTqlswEz1bCRDT6WjlwDi2y3B9YbU6a
         feR4hWu3MDUAJlPldL8RaiFfYniHqD4hu6S2LF18=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 15/50] arm/arm64: smccc-1.1: Make return values unsigned long
Date:   Fri,  8 Nov 2019 13:35:19 +0100
Message-Id: <20191108123554.29004-16-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
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
---
 include/linux/arm-smccc.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index a4eec441f82d..9b340ff4fd7b 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -167,31 +167,31 @@ asmlinkage void arm_smccc_hvc(unsigned long a0, unsigned long a1,
 
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
-- 
2.20.1

