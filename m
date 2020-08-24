Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D2A24F841
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgHXIvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgHXIvV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:51:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 255B72072D;
        Mon, 24 Aug 2020 08:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259080;
        bh=2Vp2/EnhxOLcTnR113vhbXSIrBboasw4V+gmAafYOc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATrQsv9QX675+fnzvXjEPlEBxRGePY429EUViIPSMmJ5HInABzy3Sz4wGYtIv9Bgm
         OzQhP8XNPETdlbeGDsqjO/F+MtOAQwICkrCFE2jJbTJ9T7OQG5qwb0nm7Cim//dya0
         ZJZCV/vcWlkNVfg7h0t1pP842srWccaWQnMJuIFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 01/39] x86/asm: Remove unnecessary \n\t in front of CC_SET() from asm templates
Date:   Mon, 24 Aug 2020 10:31:00 +0200
Message-Id: <20200824082348.545064159@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082348.445866152@linuxfoundation.org>
References: <20200824082348.445866152@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uros Bizjak <ubizjak@gmail.com>

commit 3c52b5c64326d9dcfee4e10611c53ec1b1b20675 upstream.

There is no need for \n\t in front of CC_SET(), as the macro already includes these two.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20170906151808.5634-1-ubizjak@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/archrandom.h |    8 ++++----
 arch/x86/include/asm/bitops.h     |    8 ++++----
 arch/x86/include/asm/percpu.h     |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -45,7 +45,7 @@ static inline bool rdrand_long(unsigned
 	bool ok;
 	unsigned int retry = RDRAND_RETRY_LOOPS;
 	do {
-		asm volatile(RDRAND_LONG "\n\t"
+		asm volatile(RDRAND_LONG
 			     CC_SET(c)
 			     : CC_OUT(c) (ok), "=a" (*v));
 		if (ok)
@@ -59,7 +59,7 @@ static inline bool rdrand_int(unsigned i
 	bool ok;
 	unsigned int retry = RDRAND_RETRY_LOOPS;
 	do {
-		asm volatile(RDRAND_INT "\n\t"
+		asm volatile(RDRAND_INT
 			     CC_SET(c)
 			     : CC_OUT(c) (ok), "=a" (*v));
 		if (ok)
@@ -71,7 +71,7 @@ static inline bool rdrand_int(unsigned i
 static inline bool rdseed_long(unsigned long *v)
 {
 	bool ok;
-	asm volatile(RDSEED_LONG "\n\t"
+	asm volatile(RDSEED_LONG
 		     CC_SET(c)
 		     : CC_OUT(c) (ok), "=a" (*v));
 	return ok;
@@ -80,7 +80,7 @@ static inline bool rdseed_long(unsigned
 static inline bool rdseed_int(unsigned int *v)
 {
 	bool ok;
-	asm volatile(RDSEED_INT "\n\t"
+	asm volatile(RDSEED_INT
 		     CC_SET(c)
 		     : CC_OUT(c) (ok), "=a" (*v));
 	return ok;
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -232,7 +232,7 @@ static __always_inline bool __test_and_s
 {
 	bool oldbit;
 
-	asm("bts %2,%1\n\t"
+	asm("bts %2,%1"
 	    CC_SET(c)
 	    : CC_OUT(c) (oldbit), ADDR
 	    : "Ir" (nr));
@@ -272,7 +272,7 @@ static __always_inline bool __test_and_c
 {
 	bool oldbit;
 
-	asm volatile("btr %2,%1\n\t"
+	asm volatile("btr %2,%1"
 		     CC_SET(c)
 		     : CC_OUT(c) (oldbit), ADDR
 		     : "Ir" (nr));
@@ -284,7 +284,7 @@ static __always_inline bool __test_and_c
 {
 	bool oldbit;
 
-	asm volatile("btc %2,%1\n\t"
+	asm volatile("btc %2,%1"
 		     CC_SET(c)
 		     : CC_OUT(c) (oldbit), ADDR
 		     : "Ir" (nr) : "memory");
@@ -315,7 +315,7 @@ static __always_inline bool variable_tes
 {
 	bool oldbit;
 
-	asm volatile("bt %2,%1\n\t"
+	asm volatile("bt %2,%1"
 		     CC_SET(c)
 		     : CC_OUT(c) (oldbit)
 		     : "m" (*(unsigned long *)addr), "Ir" (nr));
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -536,7 +536,7 @@ static inline bool x86_this_cpu_variable
 {
 	bool oldbit;
 
-	asm volatile("bt "__percpu_arg(2)",%1\n\t"
+	asm volatile("bt "__percpu_arg(2)",%1"
 			CC_SET(c)
 			: CC_OUT(c) (oldbit)
 			: "m" (*(unsigned long __percpu *)addr), "Ir" (nr));


