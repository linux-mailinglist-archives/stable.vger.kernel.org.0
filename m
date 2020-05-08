Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182551CB00A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgEHNXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbgEHMi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01C7F24964;
        Fri,  8 May 2020 12:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941506;
        bh=i+T718m1aIGBAyTqzaq4+biCQ9TNEUltVR2+ml15jU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZpsqg5QCpIFvzvCqj/LYkoKaIe7FEonAjy+OX1McXnJTu4K6gVzB0krovKtFW7n/
         4TiI7AO5gue1+BkIvo2gVmNl4wl6MhRkM4voPZ9ON19b3hJ6YweGQ4SHQYEBRldtRx
         I5y7Bjy7Scfv4hT6vr14KVT3JkUs+T5KTmH7SNYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@imgtec.com>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        "Maciej W. Rozycki" <macro@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 022/312] MIPS: math-emu: Fix m{add,sub}.s shifts
Date:   Fri,  8 May 2020 14:30:13 +0200
Message-Id: <20200508123126.046827568@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@imgtec.com>

commit db57f29d50683afd75c7f8b9908af7669837c3a9 upstream.

The code in _sp_maddf (formerly ieee754sp_madd) appears to have been
copied verbatim from ieee754sp_add, and although it's adding the
unpacked "r" & "z" floats it kept using macros that operate on "x" &
"y". This led to the addition being carried out incorrectly on some
mismash of the product, accumulator & multiplicand fields. Typically
this would lead to the assertions "ze == re" & "ze <= SP_EMAX" failing
since ze & re hadn't been operated upon.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Fixes: e24c3bec3e8e ("MIPS: math-emu: Add support for the MIPS R6 MADDF FPU instruction")
Cc: Adam Buchbinder <adam.buchbinder@gmail.com>
Cc: Maciej W. Rozycki <macro@imgtec.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/13159/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/math-emu/ieee754sp.c |    3 ++-
 arch/mips/math-emu/ieee754sp.h |   16 +++++++---------
 arch/mips/math-emu/sp_add.c    |    6 ++++--
 arch/mips/math-emu/sp_maddf.c  |   13 ++++++++-----
 arch/mips/math-emu/sp_sub.c    |    6 ++++--
 5 files changed, 25 insertions(+), 19 deletions(-)

--- a/arch/mips/math-emu/ieee754sp.c
+++ b/arch/mips/math-emu/ieee754sp.c
@@ -130,7 +130,8 @@ union ieee754sp ieee754sp_format(int sn,
 		} else {
 			/* sticky right shift es bits
 			 */
-			SPXSRSXn(es);
+			xm = XSPSRS(xm, es);
+			xe += es;
 			assert((xm & (SP_HIDDEN_BIT << 3)) == 0);
 			assert(xe == SP_EMIN);
 		}
--- a/arch/mips/math-emu/ieee754sp.h
+++ b/arch/mips/math-emu/ieee754sp.h
@@ -46,19 +46,17 @@ static inline int ieee754sp_finite(union
 }
 
 /* 3bit extended single precision sticky right shift */
-#define SPXSRSXn(rs)							\
-	(xe += rs,							\
-	 xm = (rs > (SP_FBITS+3))?1:((xm) >> (rs)) | ((xm) << (32-(rs)) != 0))
+#define XSPSRS(v, rs)						\
+	((rs > (SP_FBITS+3))?1:((v) >> (rs)) | ((v) << (32-(rs)) != 0))
 
-#define SPXSRSX1() \
-	(xe++, (xm = (xm >> 1) | (xm & 1)))
+#define XSPSRS1(m) \
+	((m >> 1) | (m & 1))
 
-#define SPXSRSYn(rs)								\
-	(ye+=rs,								\
-	 ym = (rs > (SP_FBITS+3))?1:((ym) >> (rs)) | ((ym) << (32-(rs)) != 0))
+#define SPXSRSX1() \
+	(xe++, (xm = XSPSRS1(xm)))
 
 #define SPXSRSY1() \
-	(ye++, (ym = (ym >> 1) | (ym & 1)))
+	(ye++, (ym = XSPSRS1(ym)))
 
 /* convert denormal to normalized with extended exponent */
 #define SPDNORMx(m,e) \
--- a/arch/mips/math-emu/sp_add.c
+++ b/arch/mips/math-emu/sp_add.c
@@ -132,13 +132,15 @@ union ieee754sp ieee754sp_add(union ieee
 		 * Have to shift y fraction right to align.
 		 */
 		s = xe - ye;
-		SPXSRSYn(s);
+		ym = XSPSRS(ym, s);
+		ye += s;
 	} else if (ye > xe) {
 		/*
 		 * Have to shift x fraction right to align.
 		 */
 		s = ye - xe;
-		SPXSRSXn(s);
+		xm = XSPSRS(xm, s);
+		xe += s;
 	}
 	assert(xe == ye);
 	assert(xe <= SP_EMAX);
--- a/arch/mips/math-emu/sp_maddf.c
+++ b/arch/mips/math-emu/sp_maddf.c
@@ -208,16 +208,18 @@ union ieee754sp ieee754sp_maddf(union ie
 
 	if (ze > re) {
 		/*
-		 * Have to shift y fraction right to align.
+		 * Have to shift r fraction right to align.
 		 */
 		s = ze - re;
-		SPXSRSYn(s);
+		rm = XSPSRS(rm, s);
+		re += s;
 	} else if (re > ze) {
 		/*
-		 * Have to shift x fraction right to align.
+		 * Have to shift z fraction right to align.
 		 */
 		s = re - ze;
-		SPXSRSYn(s);
+		zm = XSPSRS(zm, s);
+		ze += s;
 	}
 	assert(ze == re);
 	assert(ze <= SP_EMAX);
@@ -230,7 +232,8 @@ union ieee754sp ieee754sp_maddf(union ie
 		zm = zm + rm;
 
 		if (zm >> (SP_FBITS + 1 + 3)) { /* carry out */
-			SPXSRSX1();
+			zm = XSPSRS1(zm);
+			ze++;
 		}
 	} else {
 		if (zm >= rm) {
--- a/arch/mips/math-emu/sp_sub.c
+++ b/arch/mips/math-emu/sp_sub.c
@@ -134,13 +134,15 @@ union ieee754sp ieee754sp_sub(union ieee
 		 * have to shift y fraction right to align
 		 */
 		s = xe - ye;
-		SPXSRSYn(s);
+		ym = XSPSRS(ym, s);
+		ye += s;
 	} else if (ye > xe) {
 		/*
 		 * have to shift x fraction right to align
 		 */
 		s = ye - xe;
-		SPXSRSXn(s);
+		xm = XSPSRS(xm, s);
+		xe += s;
 	}
 	assert(xe == ye);
 	assert(xe <= SP_EMAX);


