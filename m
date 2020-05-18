Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087CC1D81B9
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgERRuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730640AbgERRuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:50:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80CA520674;
        Mon, 18 May 2020 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824210;
        bh=hLhqsgP2gFprrbBxfiRlmxjjwHYIN6WgwIWxOuIPfX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjcmFmc1D8aN0wewImAUKg5x48hg67yVo4yND1KLOVwEQIipkcwUelDZu31k12RXh
         FfK/c77+a+0Ib15zeUcGAdvWg1RWHotCzgSC0zTJeWF6/kNHw7uVSRgHlgdi+fmrDn
         gbKtFOB8lmoQqdcXm5Ol/05/Kc5V2x0J5AkPnDTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 079/114] x86/asm: Add instruction suffixes to bitops
Date:   Mon, 18 May 2020 19:36:51 +0200
Message-Id: <20200518173516.883086422@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

commit 22636f8c9511245cb3c8412039f1dd95afb3aa59 upstream.

Omitting suffixes from instructions in AT&T mode is bad practice when
operand size cannot be determined by the assembler from register
operands, and is likely going to be warned about by upstream gas in the
future (mine does already). Add the missing suffixes here. Note that for
64-bit this means some operations change from being 32-bit to 64-bit.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/5A93F98702000078001ABACC@prv-mh.provo.novell.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/bitops.h |   29 ++++++++++++++++-------------
 arch/x86/include/asm/percpu.h |    2 +-
 2 files changed, 17 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -78,7 +78,7 @@ set_bit(long nr, volatile unsigned long
 			: "iq" ((u8)CONST_MASK(nr))
 			: "memory");
 	} else {
-		asm volatile(LOCK_PREFIX "bts %1,%0"
+		asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
 			: BITOP_ADDR(addr) : "Ir" (nr) : "memory");
 	}
 }
@@ -94,7 +94,7 @@ set_bit(long nr, volatile unsigned long
  */
 static __always_inline void __set_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
+	asm volatile(__ASM_SIZE(bts) " %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
 
 /**
@@ -115,7 +115,7 @@ clear_bit(long nr, volatile unsigned lon
 			: CONST_MASK_ADDR(nr, addr)
 			: "iq" ((u8)~CONST_MASK(nr)));
 	} else {
-		asm volatile(LOCK_PREFIX "btr %1,%0"
+		asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
 			: BITOP_ADDR(addr)
 			: "Ir" (nr));
 	}
@@ -137,7 +137,7 @@ static __always_inline void clear_bit_un
 
 static __always_inline void __clear_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
+	asm volatile(__ASM_SIZE(btr) " %1,%0" : ADDR : "Ir" (nr));
 }
 
 static __always_inline bool clear_bit_unlock_is_negative_byte(long nr, volatile unsigned long *addr)
@@ -182,7 +182,7 @@ static __always_inline void __clear_bit_
  */
 static __always_inline void __change_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
+	asm volatile(__ASM_SIZE(btc) " %1,%0" : ADDR : "Ir" (nr));
 }
 
 /**
@@ -201,7 +201,7 @@ static __always_inline void change_bit(l
 			: CONST_MASK_ADDR(nr, addr)
 			: "iq" ((u8)CONST_MASK(nr)));
 	} else {
-		asm volatile(LOCK_PREFIX "btc %1,%0"
+		asm volatile(LOCK_PREFIX __ASM_SIZE(btc) " %1,%0"
 			: BITOP_ADDR(addr)
 			: "Ir" (nr));
 	}
@@ -217,7 +217,8 @@ static __always_inline void change_bit(l
  */
 static __always_inline bool test_and_set_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", c);
+	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts),
+	                 *addr, "Ir", nr, "%0", c);
 }
 
 /**
@@ -246,7 +247,7 @@ static __always_inline bool __test_and_s
 {
 	bool oldbit;
 
-	asm("bts %2,%1"
+	asm(__ASM_SIZE(bts) " %2,%1"
 	    CC_SET(c)
 	    : CC_OUT(c) (oldbit), ADDR
 	    : "Ir" (nr));
@@ -263,7 +264,8 @@ static __always_inline bool __test_and_s
  */
 static __always_inline bool test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, "Ir", nr, "%0", c);
+	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(btr),
+	                 *addr, "Ir", nr, "%0", c);
 }
 
 /**
@@ -286,7 +288,7 @@ static __always_inline bool __test_and_c
 {
 	bool oldbit;
 
-	asm volatile("btr %2,%1"
+	asm volatile(__ASM_SIZE(btr) " %2,%1"
 		     CC_SET(c)
 		     : CC_OUT(c) (oldbit), ADDR
 		     : "Ir" (nr));
@@ -298,7 +300,7 @@ static __always_inline bool __test_and_c
 {
 	bool oldbit;
 
-	asm volatile("btc %2,%1"
+	asm volatile(__ASM_SIZE(btc) " %2,%1"
 		     CC_SET(c)
 		     : CC_OUT(c) (oldbit), ADDR
 		     : "Ir" (nr) : "memory");
@@ -316,7 +318,8 @@ static __always_inline bool __test_and_c
  */
 static __always_inline bool test_and_change_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, "Ir", nr, "%0", c);
+	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(btc),
+	                 *addr, "Ir", nr, "%0", c);
 }
 
 static __always_inline bool constant_test_bit(long nr, const volatile unsigned long *addr)
@@ -329,7 +332,7 @@ static __always_inline bool variable_tes
 {
 	bool oldbit;
 
-	asm volatile("bt %2,%1"
+	asm volatile(__ASM_SIZE(bt) " %2,%1"
 		     CC_SET(c)
 		     : CC_OUT(c) (oldbit)
 		     : "m" (*(unsigned long *)addr), "Ir" (nr));
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -526,7 +526,7 @@ static inline bool x86_this_cpu_variable
 {
 	bool oldbit;
 
-	asm volatile("bt "__percpu_arg(2)",%1"
+	asm volatile("btl "__percpu_arg(2)",%1"
 			CC_SET(c)
 			: CC_OUT(c) (oldbit)
 			: "m" (*(unsigned long __percpu *)addr), "Ir" (nr));


