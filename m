Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2CC82A36
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 06:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbfHFEUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 00:20:34 -0400
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:58470 "EHLO
        emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfHFEUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 00:20:34 -0400
Received: from toshiba (85-76-131-212-nat.elisa-mobile.fi [85.76.131.212])
        by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 076594000A;
        Tue,  6 Aug 2019 07:20:30 +0300 (EEST)
Message-ID: <5D490002.8C6EBB8B@users.sourceforge.net>
Date:   Tue, 06 Aug 2019 07:20:18 +0300
From:   Jari Ruusu <jariruusu@users.sourceforge.net>
MIME-Version: 1.0
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4.9 00/42] 4.9.188-stable review
References: <20190805124924.788666484@linuxfoundation.org>
                 <5D488D55.B84FC098@users.sourceforge.net> <20190805201847.GA31714@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Mon, Aug 05, 2019 at 11:11:01PM +0300, Jari Ruusu wrote:
> > Peter Zijlstra's "x86/atomic: Fix smp_mb__{before,after}_atomic()"
> > upstream commit 69d927bba39517d0980462efc051875b7f4db185 seems to
> > be missing/lost from 4.9 and older stable kernels.
> 
> Can you send properly backported and tested patches?

linux-4.9 backport of "x86/atomic: Fix smp_mb__{before,after}_atomic()".
Tested.

Signed-off-by: Jari Ruusu <jari.ruusu@gmail.com>

--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -49,7 +49,7 @@
 {
 	asm volatile(LOCK_PREFIX "addl %1,%0"
 		     : "+m" (v->counter)
-		     : "ir" (i));
+		     : "ir" (i) : "memory");
 }
 
 /**
@@ -63,7 +63,7 @@
 {
 	asm volatile(LOCK_PREFIX "subl %1,%0"
 		     : "+m" (v->counter)
-		     : "ir" (i));
+		     : "ir" (i) : "memory");
 }
 
 /**
@@ -89,7 +89,7 @@
 static __always_inline void atomic_inc(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "incl %0"
-		     : "+m" (v->counter));
+		     : "+m" (v->counter) :: "memory");
 }
 
 /**
@@ -101,7 +101,7 @@
 static __always_inline void atomic_dec(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "decl %0"
-		     : "+m" (v->counter));
+		     : "+m" (v->counter) :: "memory");
 }
 
 /**
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -44,7 +44,7 @@
 {
 	asm volatile(LOCK_PREFIX "addq %1,%0"
 		     : "=m" (v->counter)
-		     : "er" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter) : "memory");
 }
 
 /**
@@ -58,7 +58,7 @@
 {
 	asm volatile(LOCK_PREFIX "subq %1,%0"
 		     : "=m" (v->counter)
-		     : "er" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter) : "memory");
 }
 
 /**
@@ -85,7 +85,7 @@
 {
 	asm volatile(LOCK_PREFIX "incq %0"
 		     : "=m" (v->counter)
-		     : "m" (v->counter));
+		     : "m" (v->counter) : "memory");
 }
 
 /**
@@ -98,7 +98,7 @@
 {
 	asm volatile(LOCK_PREFIX "decq %0"
 		     : "=m" (v->counter)
-		     : "m" (v->counter));
+		     : "m" (v->counter) : "memory");
 }
 
 /**
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -105,8 +105,8 @@
 #endif
 
 /* Atomic operations are already serializing on x86 */
-#define __smp_mb__before_atomic()	barrier()
-#define __smp_mb__after_atomic()	barrier()
+#define __smp_mb__before_atomic()	do { } while (0)
+#define __smp_mb__after_atomic()	do { } while (0)
 
 #include <asm-generic/barrier.h>
 

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
