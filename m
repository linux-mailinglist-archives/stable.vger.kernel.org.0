Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9360343A05A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbhJYT36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235743AbhJYT3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:29:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95F7B61177;
        Mon, 25 Oct 2021 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189945;
        bh=NKK1Ftoap0zWIXPa89GBg0INsb3GdsBuXkFgg0dB5yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C865NyDjB0NDvammIGnyX3rqq75unrZxYDM1CFaz6dNVJTPcaHt2xxJj9sBYZyZ9H
         lxn4Awr7b83Up1xin+vhV1mo8tBQd9lLpsYj7fZ+ESkytxlOVkwcncr2NhSv+baze2
         q9xhSL90YHga2XTrnBx2js+omXWrbYQHtgtbwsnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 01/58] parisc: math-emu: Fix fall-through warnings
Date:   Mon, 25 Oct 2021 21:14:18 +0200
Message-Id: <20211025190937.804410116@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 6f1fce595b78b775d7fb585c15c2dc3a6994f96e upstream.

Fix lots of fallthrough warnings, e.g.:
arch/parisc/math-emu/fpudispatch.c:323:33: warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/math-emu/fpudispatch.c |   56 +++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 3 deletions(-)

--- a/arch/parisc/math-emu/fpudispatch.c
+++ b/arch/parisc/math-emu/fpudispatch.c
@@ -310,12 +310,15 @@ decode_0c(u_int ir, u_int class, u_int s
 					r1 &= ~3;
 					fpregs[t+3] = fpregs[r1+3];
 					fpregs[t+2] = fpregs[r1+2];
+					fallthrough;
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1];
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 3: /* FABS */
 				switch (fmt) {
 				    case 2: /* illegal */
@@ -325,13 +328,16 @@ decode_0c(u_int ir, u_int class, u_int s
 					r1 &= ~3;
 					fpregs[t+3] = fpregs[r1+3];
 					fpregs[t+2] = fpregs[r1+2];
+					fallthrough;
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					/* copy and clear sign bit */
 					fpregs[t] = fpregs[r1] & 0x7fffffff;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 6: /* FNEG */
 				switch (fmt) {
 				    case 2: /* illegal */
@@ -341,13 +347,16 @@ decode_0c(u_int ir, u_int class, u_int s
 					r1 &= ~3;
 					fpregs[t+3] = fpregs[r1+3];
 					fpregs[t+2] = fpregs[r1+2];
+					fallthrough;
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					/* copy and invert sign bit */
 					fpregs[t] = fpregs[r1] ^ 0x80000000;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 7: /* FNEGABS */
 				switch (fmt) {
 				    case 2: /* illegal */
@@ -357,13 +366,16 @@ decode_0c(u_int ir, u_int class, u_int s
 					r1 &= ~3;
 					fpregs[t+3] = fpregs[r1+3];
 					fpregs[t+2] = fpregs[r1+2];
+					fallthrough;
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					/* copy and set sign bit */
 					fpregs[t] = fpregs[r1] | 0x80000000;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 4: /* FSQRT */
 				switch (fmt) {
 				    case 0:
@@ -376,6 +388,7 @@ decode_0c(u_int ir, u_int class, u_int s
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 5: /* FRND */
 				switch (fmt) {
 				    case 0:
@@ -389,7 +402,7 @@ decode_0c(u_int ir, u_int class, u_int s
 					return(MAJOR_0C_EXCP);
 				}
 		} /* end of switch (subop) */
-
+		BUG();
 	case 1: /* class 1 */
 		df = extru(ir,fpdfpos,2); /* get dest format */
 		if ((df & 2) || (fmt & 2)) {
@@ -419,6 +432,7 @@ decode_0c(u_int ir, u_int class, u_int s
 				    case 3: /* dbl/dbl */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 1: /* FCNVXF */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -434,6 +448,7 @@ decode_0c(u_int ir, u_int class, u_int s
 					return(dbl_to_dbl_fcnvxf(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 2: /* FCNVFX */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -449,6 +464,7 @@ decode_0c(u_int ir, u_int class, u_int s
 					return(dbl_to_dbl_fcnvfx(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 3: /* FCNVFXT */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -464,6 +480,7 @@ decode_0c(u_int ir, u_int class, u_int s
 					return(dbl_to_dbl_fcnvfxt(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 5: /* FCNVUF (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -479,6 +496,7 @@ decode_0c(u_int ir, u_int class, u_int s
 					return(dbl_to_dbl_fcnvuf(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 6: /* FCNVFU (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -494,6 +512,7 @@ decode_0c(u_int ir, u_int class, u_int s
 					return(dbl_to_dbl_fcnvfu(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 7: /* FCNVFUT (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -509,10 +528,11 @@ decode_0c(u_int ir, u_int class, u_int s
 					return(dbl_to_dbl_fcnvfut(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 4: /* undefined */
 				return(MAJOR_0C_EXCP);
 		} /* end of switch subop */
-
+		BUG();
 	case 2: /* class 2 */
 		fpu_type_flags=fpregs[FPU_TYPE_FLAG_POS];
 		r2 = extru(ir, fpr2pos, 5) * sizeof(double)/sizeof(u_int);
@@ -590,6 +610,7 @@ decode_0c(u_int ir, u_int class, u_int s
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 1: /* FTEST */
 				switch (fmt) {
 				    case 0:
@@ -609,8 +630,10 @@ decode_0c(u_int ir, u_int class, u_int s
 				    case 3:
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 		    } /* end of switch subop */
 		} /* end of else for PA1.0 & PA1.1 */
+		BUG();
 	case 3: /* class 3 */
 		r2 = extru(ir,fpr2pos,5) * sizeof(double)/sizeof(u_int);
 		if (r2 == 0)
@@ -633,6 +656,7 @@ decode_0c(u_int ir, u_int class, u_int s
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 1: /* FSUB */
 				switch (fmt) {
 				    case 0:
@@ -645,6 +669,7 @@ decode_0c(u_int ir, u_int class, u_int s
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 2: /* FMPY */
 				switch (fmt) {
 				    case 0:
@@ -657,6 +682,7 @@ decode_0c(u_int ir, u_int class, u_int s
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 3: /* FDIV */
 				switch (fmt) {
 				    case 0:
@@ -669,6 +695,7 @@ decode_0c(u_int ir, u_int class, u_int s
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 			case 4: /* FREM */
 				switch (fmt) {
 				    case 0:
@@ -681,6 +708,7 @@ decode_0c(u_int ir, u_int class, u_int s
 				    case 3: /* quad not implemented */
 					return(MAJOR_0C_EXCP);
 				}
+				BUG();
 		} /* end of class 3 switch */
 	} /* end of switch(class) */
 
@@ -736,10 +764,12 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1];
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 3: /* FABS */
 				switch (fmt) {
 				    case 2:
@@ -747,10 +777,12 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1] & 0x7fffffff;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 6: /* FNEG */
 				switch (fmt) {
 				    case 2:
@@ -758,10 +790,12 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1] ^ 0x80000000;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 7: /* FNEGABS */
 				switch (fmt) {
 				    case 2:
@@ -769,10 +803,12 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				    case 1: /* double */
 					fpregs[t+1] = fpregs[r1+1];
+					fallthrough;
 				    case 0: /* single */
 					fpregs[t] = fpregs[r1] | 0x80000000;
 					return(NOEXCEPTION);
 				}
+				BUG();
 			case 4: /* FSQRT */
 				switch (fmt) {
 				    case 0:
@@ -785,6 +821,7 @@ u_int fpregs[];
 				    case 3:
 					return(MAJOR_0E_EXCP);
 				}
+				BUG();
 			case 5: /* FRMD */
 				switch (fmt) {
 				    case 0:
@@ -798,7 +835,7 @@ u_int fpregs[];
 					return(MAJOR_0E_EXCP);
 				}
 		} /* end of switch (subop */
-	
+		BUG();
 	case 1: /* class 1 */
 		df = extru(ir,fpdfpos,2); /* get dest format */
 		/*
@@ -826,6 +863,7 @@ u_int fpregs[];
 				    case 3: /* dbl/dbl */
 					return(MAJOR_0E_EXCP);
 				}
+				BUG();
 			case 1: /* FCNVXF */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -841,6 +879,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvxf(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 2: /* FCNVFX */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -856,6 +895,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvfx(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 3: /* FCNVFXT */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -871,6 +911,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvfxt(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 5: /* FCNVUF (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -886,6 +927,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvuf(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 6: /* FCNVFU (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -901,6 +943,7 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvfu(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 7: /* FCNVFUT (PA2.0 only) */
 				switch(fmt) {
 				    case 0: /* sgl/sgl */
@@ -916,9 +959,11 @@ u_int fpregs[];
 					return(dbl_to_dbl_fcnvfut(&fpregs[r1],0,
 						&fpregs[t],status));
 				}
+				BUG();
 			case 4: /* undefined */
 				return(MAJOR_0C_EXCP);
 		} /* end of switch subop */
+		BUG();
 	case 2: /* class 2 */
 		/*
 		 * Be careful out there.
@@ -994,6 +1039,7 @@ u_int fpregs[];
 				}
 		    } /* end of switch subop */
 		} /* end of else for PA1.0 & PA1.1 */
+		BUG();
 	case 3: /* class 3 */
 		/*
 		 * Be careful out there.
@@ -1026,6 +1072,7 @@ u_int fpregs[];
 					return(dbl_fadd(&fpregs[r1],&fpregs[r2],
 						&fpregs[t],status));
 				}
+				BUG();
 			case 1: /* FSUB */
 				switch (fmt) {
 				    case 0:
@@ -1035,6 +1082,7 @@ u_int fpregs[];
 					return(dbl_fsub(&fpregs[r1],&fpregs[r2],
 						&fpregs[t],status));
 				}
+				BUG();
 			case 2: /* FMPY or XMPYU */
 				/*
 				 * check for integer multiply (x bit set)
@@ -1071,6 +1119,7 @@ u_int fpregs[];
 					       &fpregs[r2],&fpregs[t],status));
 				    }
 				}
+				BUG();
 			case 3: /* FDIV */
 				switch (fmt) {
 				    case 0:
@@ -1080,6 +1129,7 @@ u_int fpregs[];
 					return(dbl_fdiv(&fpregs[r1],&fpregs[r2],
 						&fpregs[t],status));
 				}
+				BUG();
 			case 4: /* FREM */
 				switch (fmt) {
 				    case 0:


