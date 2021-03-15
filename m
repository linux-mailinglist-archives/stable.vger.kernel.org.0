Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D71F33B5B0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhCONzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231570AbhCONyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 356C064EEC;
        Mon, 15 Mar 2021 13:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816477;
        bh=JUGm5PTYkYBoFigEiFUa/ooe/ka7v8WcEX7LkNukJdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRqIG8kOQsRN+jK6ICr6uZMXvPzVAvjpU6GfOPRD0QDBvUOybi5iAp4XBpHXGNqlE
         FY0UjoMhEva9J4wR3kSvwrJWAAi9DJ6qWOOjHznKG+gnMoqJh+9LDPd8B1n2HOS8kE
         B50tjhHULFal9mpjY+hSb1ywvo5gEcvu/o1FqCH0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 67/75] alpha: switch __copy_user() and __do_clean_user() to normal calling conventions
Date:   Mon, 15 Mar 2021 14:52:21 +0100
Message-Id: <20210315135210.450031168@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Al Viro <viro@zeniv.linux.org.uk>

commit 8525023121de4848b5f0a7d867ffeadbc477774d upstream.

They used to need odd calling conventions due to old exception handling
mechanism, the last remnants of which had disappeared back in 2002.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/asm/uaccess.h |   67 ++++---------------------
 arch/alpha/lib/clear_user.S      |   66 +++++++++---------------
 arch/alpha/lib/copy_user.S       |   82 ++++++++++++------------------
 arch/alpha/lib/ev6-clear_user.S  |   84 +++++++++++++------------------
 arch/alpha/lib/ev6-copy_user.S   |  104 ++++++++++++++++-----------------------
 5 files changed, 151 insertions(+), 252 deletions(-)

--- a/arch/alpha/include/asm/uaccess.h
+++ b/arch/alpha/include/asm/uaccess.h
@@ -341,45 +341,17 @@ __asm__ __volatile__("1: stb %r2,%1\n"
  * Complex access routines
  */
 
-/* This little bit of silliness is to get the GP loaded for a function
-   that ordinarily wouldn't.  Otherwise we could have it done by the macro
-   directly, which can be optimized the linker.  */
-#ifdef MODULE
-#define __module_address(sym)		"r"(sym),
-#define __module_call(ra, arg, sym)	"jsr $" #ra ",(%" #arg ")," #sym
-#else
-#define __module_address(sym)
-#define __module_call(ra, arg, sym)	"bsr $" #ra "," #sym " !samegp"
-#endif
+extern long __copy_user(void *to, const void *from, long len);
 
-extern void __copy_user(void);
-
-extern inline long
-__copy_tofrom_user_nocheck(void *to, const void *from, long len)
-{
-	register void * __cu_to __asm__("$6") = to;
-	register const void * __cu_from __asm__("$7") = from;
-	register long __cu_len __asm__("$0") = len;
-
-	__asm__ __volatile__(
-		__module_call(28, 3, __copy_user)
-		: "=r" (__cu_len), "=r" (__cu_from), "=r" (__cu_to)
-		: __module_address(__copy_user)
-		  "0" (__cu_len), "1" (__cu_from), "2" (__cu_to)
-		: "$1", "$2", "$3", "$4", "$5", "$28", "memory");
-
-	return __cu_len;
-}
-
-#define __copy_to_user(to, from, n)					\
-({									\
-	__chk_user_ptr(to);						\
-	__copy_tofrom_user_nocheck((__force void *)(to), (from), (n));	\
+#define __copy_to_user(to, from, n)			\
+({							\
+	__chk_user_ptr(to);				\
+	__copy_user((__force void *)(to), (from), (n));	\
 })
-#define __copy_from_user(to, from, n)					\
-({									\
-	__chk_user_ptr(from);						\
-	__copy_tofrom_user_nocheck((to), (__force void *)(from), (n));	\
+#define __copy_from_user(to, from, n)			\
+({							\
+	__chk_user_ptr(from);				\
+	__copy_user((to), (__force void *)(from), (n));	\
 })
 
 #define __copy_to_user_inatomic __copy_to_user
@@ -389,7 +361,7 @@ extern inline long
 copy_to_user(void __user *to, const void *from, long n)
 {
 	if (likely(__access_ok((unsigned long)to, n, get_fs())))
-		n = __copy_tofrom_user_nocheck((__force void *)to, from, n);
+		n = __copy_user((__force void *)to, from, n);
 	return n;
 }
 
@@ -404,21 +376,7 @@ copy_from_user(void *to, const void __us
 	return res;
 }
 
-extern void __do_clear_user(void);
-
-extern inline long
-__clear_user(void __user *to, long len)
-{
-	register void __user * __cl_to __asm__("$6") = to;
-	register long __cl_len __asm__("$0") = len;
-	__asm__ __volatile__(
-		__module_call(28, 2, __do_clear_user)
-		: "=r"(__cl_len), "=r"(__cl_to)
-		: __module_address(__do_clear_user)
-		  "0"(__cl_len), "1"(__cl_to)
-		: "$1", "$2", "$3", "$4", "$5", "$28", "memory");
-	return __cl_len;
-}
+extern long __clear_user(void __user *to, long len);
 
 extern inline long
 clear_user(void __user *to, long len)
@@ -428,9 +386,6 @@ clear_user(void __user *to, long len)
 	return len;
 }
 
-#undef __module_address
-#undef __module_call
-
 #define user_addr_max() \
         (segment_eq(get_fs(), USER_DS) ? TASK_SIZE : ~0UL)
 
--- a/arch/alpha/lib/clear_user.S
+++ b/arch/alpha/lib/clear_user.S
@@ -8,21 +8,6 @@
  * right "bytes left to zero" value (and that it is updated only _after_
  * a successful copy).  There is also some rather minor exception setup
  * stuff.
- *
- * NOTE! This is not directly C-callable, because the calling semantics
- * are different:
- *
- * Inputs:
- *	length in $0
- *	destination address in $6
- *	exception pointer in $7
- *	return address in $28 (exceptions expect it there)
- *
- * Outputs:
- *	bytes left to copy in $0
- *
- * Clobbers:
- *	$1,$2,$3,$4,$5,$6
  */
 #include <asm/export.h>
 
@@ -38,62 +23,63 @@
 	.set noreorder
 	.align 4
 
-	.globl __do_clear_user
-	.ent __do_clear_user
-	.frame	$30, 0, $28
+	.globl __clear_user
+	.ent __clear_user
+	.frame	$30, 0, $26
 	.prologue 0
 
 $loop:
 	and	$1, 3, $4	# e0    :
 	beq	$4, 1f		# .. e1 :
 
-0:	EX( stq_u $31, 0($6) )	# e0    : zero one word
+0:	EX( stq_u $31, 0($16) )	# e0    : zero one word
 	subq	$0, 8, $0	# .. e1 :
 	subq	$4, 1, $4	# e0    :
-	addq	$6, 8, $6	# .. e1 :
+	addq	$16, 8, $16	# .. e1 :
 	bne	$4, 0b		# e1    :
 	unop			#       :
 
 1:	bic	$1, 3, $1	# e0    :
 	beq	$1, $tail	# .. e1 :
 
-2:	EX( stq_u $31, 0($6) )	# e0    : zero four words
+2:	EX( stq_u $31, 0($16) )	# e0    : zero four words
 	subq	$0, 8, $0	# .. e1 :
-	EX( stq_u $31, 8($6) )	# e0    :
+	EX( stq_u $31, 8($16) )	# e0    :
 	subq	$0, 8, $0	# .. e1 :
-	EX( stq_u $31, 16($6) )	# e0    :
+	EX( stq_u $31, 16($16) )	# e0    :
 	subq	$0, 8, $0	# .. e1 :
-	EX( stq_u $31, 24($6) )	# e0    :
+	EX( stq_u $31, 24($16) )	# e0    :
 	subq	$0, 8, $0	# .. e1 :
 	subq	$1, 4, $1	# e0    :
-	addq	$6, 32, $6	# .. e1 :
+	addq	$16, 32, $16	# .. e1 :
 	bne	$1, 2b		# e1    :
 
 $tail:
 	bne	$2, 1f		# e1    : is there a tail to do?
-	ret	$31, ($28), 1	# .. e1 :
+	ret	$31, ($26), 1	# .. e1 :
 
-1:	EX( ldq_u $5, 0($6) )	# e0    :
+1:	EX( ldq_u $5, 0($16) )	# e0    :
 	clr	$0		# .. e1 :
 	nop			# e1    :
 	mskqh	$5, $0, $5	# e0    :
-	EX( stq_u $5, 0($6) )	# e0    :
-	ret	$31, ($28), 1	# .. e1 :
+	EX( stq_u $5, 0($16) )	# e0    :
+	ret	$31, ($26), 1	# .. e1 :
 
-__do_clear_user:
-	and	$6, 7, $4	# e0    : find dest misalignment
+__clear_user:
+	and	$17, $17, $0
+	and	$16, 7, $4	# e0    : find dest misalignment
 	beq	$0, $zerolength # .. e1 :
 	addq	$0, $4, $1	# e0    : bias counter
 	and	$1, 7, $2	# e1    : number of bytes in tail
 	srl	$1, 3, $1	# e0    :
 	beq	$4, $loop	# .. e1 :
 
-	EX( ldq_u $5, 0($6) )	# e0    : load dst word to mask back in
+	EX( ldq_u $5, 0($16) )	# e0    : load dst word to mask back in
 	beq	$1, $oneword	# .. e1 : sub-word store?
 
-	mskql	$5, $6, $5	# e0    : take care of misaligned head
-	addq	$6, 8, $6	# .. e1 :
-	EX( stq_u $5, -8($6) )	# e0    :
+	mskql	$5, $16, $5	# e0    : take care of misaligned head
+	addq	$16, 8, $16	# .. e1 :
+	EX( stq_u $5, -8($16) )	# e0    :
 	addq	$0, $4, $0	# .. e1 : bytes left -= 8 - misalignment
 	subq	$1, 1, $1	# e0    :
 	subq	$0, 8, $0	# .. e1 :
@@ -101,15 +87,15 @@ __do_clear_user:
 	unop			#       :
 
 $oneword:
-	mskql	$5, $6, $4	# e0    :
+	mskql	$5, $16, $4	# e0    :
 	mskqh	$5, $2, $5	# e0    :
 	or	$5, $4, $5	# e1    :
-	EX( stq_u $5, 0($6) )	# e0    :
+	EX( stq_u $5, 0($16) )	# e0    :
 	clr	$0		# .. e1 :
 
 $zerolength:
 $exception:
-	ret	$31, ($28), 1	# .. e1 :
+	ret	$31, ($26), 1	# .. e1 :
 
-	.end __do_clear_user
-	EXPORT_SYMBOL(__do_clear_user)
+	.end __clear_user
+	EXPORT_SYMBOL(__clear_user)
--- a/arch/alpha/lib/copy_user.S
+++ b/arch/alpha/lib/copy_user.S
@@ -9,21 +9,6 @@
  * contains the right "bytes left to copy" value (and that it is updated
  * only _after_ a successful copy). There is also some rather minor
  * exception setup stuff..
- *
- * NOTE! This is not directly C-callable, because the calling semantics are
- * different:
- *
- * Inputs:
- *	length in $0
- *	destination address in $6
- *	source address in $7
- *	return address in $28
- *
- * Outputs:
- *	bytes left to copy in $0
- *
- * Clobbers:
- *	$1,$2,$3,$4,$5,$6,$7
  */
 
 #include <asm/export.h>
@@ -49,58 +34,59 @@
 	.ent __copy_user
 __copy_user:
 	.prologue 0
-	and $6,7,$3
+	and $18,$18,$0
+	and $16,7,$3
 	beq $0,$35
 	beq $3,$36
 	subq $3,8,$3
 	.align 4
 $37:
-	EXI( ldq_u $1,0($7) )
-	EXO( ldq_u $2,0($6) )
-	extbl $1,$7,$1
-	mskbl $2,$6,$2
-	insbl $1,$6,$1
+	EXI( ldq_u $1,0($17) )
+	EXO( ldq_u $2,0($16) )
+	extbl $1,$17,$1
+	mskbl $2,$16,$2
+	insbl $1,$16,$1
 	addq $3,1,$3
 	bis $1,$2,$1
-	EXO( stq_u $1,0($6) )
+	EXO( stq_u $1,0($16) )
 	subq $0,1,$0
-	addq $6,1,$6
-	addq $7,1,$7
+	addq $16,1,$16
+	addq $17,1,$17
 	beq $0,$41
 	bne $3,$37
 $36:
-	and $7,7,$1
+	and $17,7,$1
 	bic $0,7,$4
 	beq $1,$43
 	beq $4,$48
-	EXI( ldq_u $3,0($7) )
+	EXI( ldq_u $3,0($17) )
 	.align 4
 $50:
-	EXI( ldq_u $2,8($7) )
+	EXI( ldq_u $2,8($17) )
 	subq $4,8,$4
-	extql $3,$7,$3
-	extqh $2,$7,$1
+	extql $3,$17,$3
+	extqh $2,$17,$1
 	bis $3,$1,$1
-	EXO( stq $1,0($6) )
-	addq $7,8,$7
+	EXO( stq $1,0($16) )
+	addq $17,8,$17
 	subq $0,8,$0
-	addq $6,8,$6
+	addq $16,8,$16
 	bis $2,$2,$3
 	bne $4,$50
 $48:
 	beq $0,$41
 	.align 4
 $57:
-	EXI( ldq_u $1,0($7) )
-	EXO( ldq_u $2,0($6) )
-	extbl $1,$7,$1
-	mskbl $2,$6,$2
-	insbl $1,$6,$1
+	EXI( ldq_u $1,0($17) )
+	EXO( ldq_u $2,0($16) )
+	extbl $1,$17,$1
+	mskbl $2,$16,$2
+	insbl $1,$16,$1
 	bis $1,$2,$1
-	EXO( stq_u $1,0($6) )
+	EXO( stq_u $1,0($16) )
 	subq $0,1,$0
-	addq $6,1,$6
-	addq $7,1,$7
+	addq $16,1,$16
+	addq $17,1,$17
 	bne $0,$57
 	br $31,$41
 	.align 4
@@ -108,27 +94,27 @@ $43:
 	beq $4,$65
 	.align 4
 $66:
-	EXI( ldq $1,0($7) )
+	EXI( ldq $1,0($17) )
 	subq $4,8,$4
-	EXO( stq $1,0($6) )
-	addq $7,8,$7
+	EXO( stq $1,0($16) )
+	addq $17,8,$17
 	subq $0,8,$0
-	addq $6,8,$6
+	addq $16,8,$16
 	bne $4,$66
 $65:
 	beq $0,$41
-	EXI( ldq $2,0($7) )
-	EXO( ldq $1,0($6) )
+	EXI( ldq $2,0($17) )
+	EXO( ldq $1,0($16) )
 	mskql $2,$0,$2
 	mskqh $1,$0,$1
 	bis $2,$1,$2
-	EXO( stq $2,0($6) )
+	EXO( stq $2,0($16) )
 	bis $31,$31,$0
 $41:
 $35:
 $exitin:
 $exitout:
-	ret $31,($28),1
+	ret $31,($26),1
 
 	.end __copy_user
 EXPORT_SYMBOL(__copy_user)
--- a/arch/alpha/lib/ev6-clear_user.S
+++ b/arch/alpha/lib/ev6-clear_user.S
@@ -9,21 +9,6 @@
  * a successful copy).  There is also some rather minor exception setup
  * stuff.
  *
- * NOTE! This is not directly C-callable, because the calling semantics
- * are different:
- *
- * Inputs:
- *	length in $0
- *	destination address in $6
- *	exception pointer in $7
- *	return address in $28 (exceptions expect it there)
- *
- * Outputs:
- *	bytes left to copy in $0
- *
- * Clobbers:
- *	$1,$2,$3,$4,$5,$6
- *
  * Much of the information about 21264 scheduling/coding comes from:
  *	Compiler Writer's Guide for the Alpha 21264
  *	abbreviated as 'CWG' in other comments here
@@ -56,14 +41,15 @@
 	.set noreorder
 	.align 4
 
-	.globl __do_clear_user
-	.ent __do_clear_user
-	.frame	$30, 0, $28
+	.globl __clear_user
+	.ent __clear_user
+	.frame	$30, 0, $26
 	.prologue 0
 
 				# Pipeline info : Slotting & Comments
-__do_clear_user:
-	and	$6, 7, $4	# .. E  .. ..	: find dest head misalignment
+__clear_user:
+	and	$17, $17, $0
+	and	$16, 7, $4	# .. E  .. ..	: find dest head misalignment
 	beq	$0, $zerolength # U  .. .. ..	:  U L U L
 
 	addq	$0, $4, $1	# .. .. .. E	: bias counter
@@ -75,14 +61,14 @@ __do_clear_user:
 
 /*
  * Head is not aligned.  Write (8 - $4) bytes to head of destination
- * This means $6 is known to be misaligned
+ * This means $16 is known to be misaligned
  */
-	EX( ldq_u $5, 0($6) )	# .. .. .. L	: load dst word to mask back in
+	EX( ldq_u $5, 0($16) )	# .. .. .. L	: load dst word to mask back in
 	beq	$1, $onebyte	# .. .. U  ..	: sub-word store?
-	mskql	$5, $6, $5	# .. U  .. ..	: take care of misaligned head
-	addq	$6, 8, $6	# E  .. .. .. 	: L U U L
+	mskql	$5, $16, $5	# .. U  .. ..	: take care of misaligned head
+	addq	$16, 8, $16	# E  .. .. .. 	: L U U L
 
-	EX( stq_u $5, -8($6) )	# .. .. .. L	:
+	EX( stq_u $5, -8($16) )	# .. .. .. L	:
 	subq	$1, 1, $1	# .. .. E  ..	:
 	addq	$0, $4, $0	# .. E  .. ..	: bytes left -= 8 - misalignment
 	subq	$0, 8, $0	# E  .. .. ..	: U L U L
@@ -93,11 +79,11 @@ __do_clear_user:
  * values upon initial entry to the loop
  * $1 is number of quadwords to clear (zero is a valid value)
  * $2 is number of trailing bytes (0..7) ($2 never used...)
- * $6 is known to be aligned 0mod8
+ * $16 is known to be aligned 0mod8
  */
 $headalign:
 	subq	$1, 16, $4	# .. .. .. E	: If < 16, we can not use the huge loop
-	and	$6, 0x3f, $2	# .. .. E  ..	: Forward work for huge loop
+	and	$16, 0x3f, $2	# .. .. E  ..	: Forward work for huge loop
 	subq	$2, 0x40, $3	# .. E  .. ..	: bias counter (huge loop)
 	blt	$4, $trailquad	# U  .. .. ..	: U L U L
 
@@ -114,21 +100,21 @@ $headalign:
 	beq	$3, $bigalign	# U  .. .. ..	: U L U L : Aligned 0mod64
 
 $alignmod64:
-	EX( stq_u $31, 0($6) )	# .. .. .. L
+	EX( stq_u $31, 0($16) )	# .. .. .. L
 	addq	$3, 8, $3	# .. .. E  ..
 	subq	$0, 8, $0	# .. E  .. ..
 	nop			# E  .. .. ..	: U L U L
 
 	nop			# .. .. .. E
 	subq	$1, 1, $1	# .. .. E  ..
-	addq	$6, 8, $6	# .. E  .. ..
+	addq	$16, 8, $16	# .. E  .. ..
 	blt	$3, $alignmod64	# U  .. .. ..	: U L U L
 
 $bigalign:
 /*
  * $0 is the number of bytes left
  * $1 is the number of quads left
- * $6 is aligned 0mod64
+ * $16 is aligned 0mod64
  * we know that we'll be taking a minimum of one trip through
  * CWG Section 3.7.6: do not expect a sustained store rate of > 1/cycle
  * We are _not_ going to update $0 after every single store.  That
@@ -145,39 +131,39 @@ $bigalign:
 	nop			# E :
 	nop			# E :
 	nop			# E :
-	bis	$6,$6,$3	# E : U L U L : Initial wh64 address is dest
+	bis	$16,$16,$3	# E : U L U L : Initial wh64 address is dest
 	/* This might actually help for the current trip... */
 
 $do_wh64:
 	wh64	($3)		# .. .. .. L1	: memory subsystem hint
 	subq	$1, 16, $4	# .. .. E  ..	: Forward calculation - repeat the loop?
-	EX( stq_u $31, 0($6) )	# .. L  .. ..
+	EX( stq_u $31, 0($16) )	# .. L  .. ..
 	subq	$0, 8, $0	# E  .. .. ..	: U L U L
 
-	addq	$6, 128, $3	# E : Target address of wh64
-	EX( stq_u $31, 8($6) )	# L :
-	EX( stq_u $31, 16($6) )	# L :
+	addq	$16, 128, $3	# E : Target address of wh64
+	EX( stq_u $31, 8($16) )	# L :
+	EX( stq_u $31, 16($16) )	# L :
 	subq	$0, 16, $0	# E : U L L U
 
 	nop			# E :
-	EX( stq_u $31, 24($6) )	# L :
-	EX( stq_u $31, 32($6) )	# L :
+	EX( stq_u $31, 24($16) )	# L :
+	EX( stq_u $31, 32($16) )	# L :
 	subq	$0, 168, $5	# E : U L L U : two trips through the loop left?
 	/* 168 = 192 - 24, since we've already completed some stores */
 
 	subq	$0, 16, $0	# E :
-	EX( stq_u $31, 40($6) )	# L :
-	EX( stq_u $31, 48($6) )	# L :
-	cmovlt	$5, $6, $3	# E : U L L U : Latency 2, extra mapping cycle
+	EX( stq_u $31, 40($16) )	# L :
+	EX( stq_u $31, 48($16) )	# L :
+	cmovlt	$5, $16, $3	# E : U L L U : Latency 2, extra mapping cycle
 
 	subq	$1, 8, $1	# E :
 	subq	$0, 16, $0	# E :
-	EX( stq_u $31, 56($6) )	# L :
+	EX( stq_u $31, 56($16) )	# L :
 	nop			# E : U L U L
 
 	nop			# E :
 	subq	$0, 8, $0	# E :
-	addq	$6, 64, $6	# E :
+	addq	$16, 64, $16	# E :
 	bge	$4, $do_wh64	# U : U L U L
 
 $trailquad:
@@ -190,14 +176,14 @@ $trailquad:
 	beq	$1, $trailbytes	# U  .. .. ..	: U L U L : Only 0..7 bytes to go
 
 $onequad:
-	EX( stq_u $31, 0($6) )	# .. .. .. L
+	EX( stq_u $31, 0($16) )	# .. .. .. L
 	subq	$1, 1, $1	# .. .. E  ..
 	subq	$0, 8, $0	# .. E  .. ..
 	nop			# E  .. .. ..	: U L U L
 
 	nop			# .. .. .. E
 	nop			# .. .. E  ..
-	addq	$6, 8, $6	# .. E  .. ..
+	addq	$16, 8, $16	# .. E  .. ..
 	bgt	$1, $onequad	# U  .. .. ..	: U L U L
 
 	# We have an unknown number of bytes left to go.
@@ -211,9 +197,9 @@ $trailbytes:
 	# so we will use $0 as the loop counter
 	# We know for a fact that $0 > 0 zero due to previous context
 $onebyte:
-	EX( stb $31, 0($6) )	# .. .. .. L
+	EX( stb $31, 0($16) )	# .. .. .. L
 	subq	$0, 1, $0	# .. .. E  ..	:
-	addq	$6, 1, $6	# .. E  .. ..	:
+	addq	$16, 1, $16	# .. E  .. ..	:
 	bgt	$0, $onebyte	# U  .. .. ..	: U L U L
 
 $zerolength:
@@ -221,6 +207,6 @@ $exception:			# Destination for exceptio
 	nop			# .. .. .. E	:
 	nop			# .. .. E  ..	:
 	nop			# .. E  .. ..	:
-	ret	$31, ($28), 1	# L0 .. .. ..	: L U L U
-	.end __do_clear_user
-	EXPORT_SYMBOL(__do_clear_user)
+	ret	$31, ($26), 1	# L0 .. .. ..	: L U L U
+	.end __clear_user
+	EXPORT_SYMBOL(__clear_user)
--- a/arch/alpha/lib/ev6-copy_user.S
+++ b/arch/alpha/lib/ev6-copy_user.S
@@ -12,21 +12,6 @@
  * only _after_ a successful copy). There is also some rather minor
  * exception setup stuff..
  *
- * NOTE! This is not directly C-callable, because the calling semantics are
- * different:
- *
- * Inputs:
- *	length in $0
- *	destination address in $6
- *	source address in $7
- *	return address in $28
- *
- * Outputs:
- *	bytes left to copy in $0
- *
- * Clobbers:
- *	$1,$2,$3,$4,$5,$6,$7
- *
  * Much of the information about 21264 scheduling/coding comes from:
  *	Compiler Writer's Guide for the Alpha 21264
  *	abbreviated as 'CWG' in other comments here
@@ -60,10 +45,11 @@
 				# Pipeline info: Slotting & Comments
 __copy_user:
 	.prologue 0
-	subq $0, 32, $1		# .. E  .. ..	: Is this going to be a small copy?
+	andq $18, $18, $0
+	subq $18, 32, $1	# .. E  .. ..	: Is this going to be a small copy?
 	beq $0, $zerolength	# U  .. .. ..	: U L U L
 
-	and $6,7,$3		# .. .. .. E	: is leading dest misalignment
+	and $16,7,$3		# .. .. .. E	: is leading dest misalignment
 	ble $1, $onebyteloop	# .. .. U  ..	: 1st branch : small amount of data
 	beq $3, $destaligned	# .. U  .. ..	: 2nd (one cycle fetcher stall)
 	subq $3, 8, $3		# E  .. .. ..	: L U U L : trip counter
@@ -73,17 +59,17 @@ __copy_user:
  * We know we have at least one trip through this loop
  */
 $aligndest:
-	EXI( ldbu $1,0($7) )	# .. .. .. L	: Keep loads separate from stores
-	addq $6,1,$6		# .. .. E  ..	: Section 3.8 in the CWG
+	EXI( ldbu $1,0($17) )	# .. .. .. L	: Keep loads separate from stores
+	addq $16,1,$16		# .. .. E  ..	: Section 3.8 in the CWG
 	addq $3,1,$3		# .. E  .. ..	:
 	nop			# E  .. .. ..	: U L U L
 
 /*
- * the -1 is to compensate for the inc($6) done in a previous quadpack
+ * the -1 is to compensate for the inc($16) done in a previous quadpack
  * which allows us zero dependencies within either quadpack in the loop
  */
-	EXO( stb $1,-1($6) )	# .. .. .. L	:
-	addq $7,1,$7		# .. .. E  ..	: Section 3.8 in the CWG
+	EXO( stb $1,-1($16) )	# .. .. .. L	:
+	addq $17,1,$17		# .. .. E  ..	: Section 3.8 in the CWG
 	subq $0,1,$0		# .. E  .. ..	:
 	bne $3, $aligndest	# U  .. .. ..	: U L U L
 
@@ -92,29 +78,29 @@ $aligndest:
  * If we arrived via branch, we have a minimum of 32 bytes
  */
 $destaligned:
-	and $7,7,$1		# .. .. .. E	: Check _current_ source alignment
+	and $17,7,$1		# .. .. .. E	: Check _current_ source alignment
 	bic $0,7,$4		# .. .. E  ..	: number bytes as a quadword loop
-	EXI( ldq_u $3,0($7) )	# .. L  .. ..	: Forward fetch for fallthrough code
+	EXI( ldq_u $3,0($17) )	# .. L  .. ..	: Forward fetch for fallthrough code
 	beq $1,$quadaligned	# U  .. .. ..	: U L U L
 
 /*
- * In the worst case, we've just executed an ldq_u here from 0($7)
+ * In the worst case, we've just executed an ldq_u here from 0($17)
  * and we'll repeat it once if we take the branch
  */
 
 /* Misaligned quadword loop - not unrolled.  Leave it that way. */
 $misquad:
-	EXI( ldq_u $2,8($7) )	# .. .. .. L	:
+	EXI( ldq_u $2,8($17) )	# .. .. .. L	:
 	subq $4,8,$4		# .. .. E  ..	:
-	extql $3,$7,$3		# .. U  .. ..	:
-	extqh $2,$7,$1		# U  .. .. ..	: U U L L
+	extql $3,$17,$3		# .. U  .. ..	:
+	extqh $2,$17,$1		# U  .. .. ..	: U U L L
 
 	bis $3,$1,$1		# .. .. .. E	:
-	EXO( stq $1,0($6) )	# .. .. L  ..	:
-	addq $7,8,$7		# .. E  .. ..	:
+	EXO( stq $1,0($16) )	# .. .. L  ..	:
+	addq $17,8,$17		# .. E  .. ..	:
 	subq $0,8,$0		# E  .. .. ..	: U L L U
 
-	addq $6,8,$6		# .. .. .. E	:
+	addq $16,8,$16		# .. .. .. E	:
 	bis $2,$2,$3		# .. .. E  ..	:
 	nop			# .. E  .. ..	:
 	bne $4,$misquad		# U  .. .. ..	: U L U L
@@ -125,8 +111,8 @@ $misquad:
 	beq $0,$zerolength	# U  .. .. ..	: U L U L
 
 /* We know we have at least one trip through the byte loop */
-	EXI ( ldbu $2,0($7) )	# .. .. .. L	: No loads in the same quad
-	addq $6,1,$6		# .. .. E  ..	: as the store (Section 3.8 in CWG)
+	EXI ( ldbu $2,0($17) )	# .. .. .. L	: No loads in the same quad
+	addq $16,1,$16		# .. .. E  ..	: as the store (Section 3.8 in CWG)
 	nop			# .. E  .. ..	:
 	br $31, $dirtyentry	# L0 .. .. ..	: L U U L
 /* Do the trailing byte loop load, then hop into the store part of the loop */
@@ -136,8 +122,8 @@ $misquad:
  * Based upon the usage context, it's worth the effort to unroll this loop
  * $0 - number of bytes to be moved
  * $4 - number of bytes to move as quadwords
- * $6 is current destination address
- * $7 is current source address
+ * $16 is current destination address
+ * $17 is current source address
  */
 $quadaligned:
 	subq	$4, 32, $2	# .. .. .. E	: do not unroll for small stuff
@@ -155,29 +141,29 @@ $quadaligned:
  * instruction memory hint instruction).
  */
 $unroll4:
-	EXI( ldq $1,0($7) )	# .. .. .. L
-	EXI( ldq $2,8($7) )	# .. .. L  ..
+	EXI( ldq $1,0($17) )	# .. .. .. L
+	EXI( ldq $2,8($17) )	# .. .. L  ..
 	subq	$4,32,$4	# .. E  .. ..
 	nop			# E  .. .. ..	: U U L L
 
-	addq	$7,16,$7	# .. .. .. E
-	EXO( stq $1,0($6) )	# .. .. L  ..
-	EXO( stq $2,8($6) )	# .. L  .. ..
+	addq	$17,16,$17	# .. .. .. E
+	EXO( stq $1,0($16) )	# .. .. L  ..
+	EXO( stq $2,8($16) )	# .. L  .. ..
 	subq	$0,16,$0	# E  .. .. ..	: U L L U
 
-	addq	$6,16,$6	# .. .. .. E
-	EXI( ldq $1,0($7) )	# .. .. L  ..
-	EXI( ldq $2,8($7) )	# .. L  .. ..
+	addq	$16,16,$16	# .. .. .. E
+	EXI( ldq $1,0($17) )	# .. .. L  ..
+	EXI( ldq $2,8($17) )	# .. L  .. ..
 	subq	$4, 32, $3	# E  .. .. ..	: U U L L : is there enough for another trip?
 
-	EXO( stq $1,0($6) )	# .. .. .. L
-	EXO( stq $2,8($6) )	# .. .. L  ..
+	EXO( stq $1,0($16) )	# .. .. .. L
+	EXO( stq $2,8($16) )	# .. .. L  ..
 	subq	$0,16,$0	# .. E  .. ..
-	addq	$7,16,$7	# E  .. .. ..	: U L L U
+	addq	$17,16,$17	# E  .. .. ..	: U L L U
 
 	nop			# .. .. .. E
 	nop			# .. .. E  ..
-	addq	$6,16,$6	# .. E  .. ..
+	addq	$16,16,$16	# .. E  .. ..
 	bgt	$3,$unroll4	# U  .. .. ..	: U L U L
 
 	nop
@@ -186,14 +172,14 @@ $unroll4:
 	beq	$4, $noquads
 
 $onequad:
-	EXI( ldq $1,0($7) )
+	EXI( ldq $1,0($17) )
 	subq	$4,8,$4
-	addq	$7,8,$7
+	addq	$17,8,$17
 	nop
 
-	EXO( stq $1,0($6) )
+	EXO( stq $1,0($16) )
 	subq	$0,8,$0
-	addq	$6,8,$6
+	addq	$16,8,$16
 	bne	$4,$onequad
 
 $noquads:
@@ -207,23 +193,23 @@ $noquads:
  * There's no point in doing a lot of complex alignment calculations to try to
  * to quadword stuff for a small amount of data.
  *	$0 - remaining number of bytes left to copy
- *	$6 - current dest addr
- *	$7 - current source addr
+ *	$16 - current dest addr
+ *	$17 - current source addr
  */
 
 $onebyteloop:
-	EXI ( ldbu $2,0($7) )	# .. .. .. L	: No loads in the same quad
-	addq $6,1,$6		# .. .. E  ..	: as the store (Section 3.8 in CWG)
+	EXI ( ldbu $2,0($17) )	# .. .. .. L	: No loads in the same quad
+	addq $16,1,$16		# .. .. E  ..	: as the store (Section 3.8 in CWG)
 	nop			# .. E  .. ..	:
 	nop			# E  .. .. ..	: U L U L
 
 $dirtyentry:
 /*
- * the -1 is to compensate for the inc($6) done in a previous quadpack
+ * the -1 is to compensate for the inc($16) done in a previous quadpack
  * which allows us zero dependencies within either quadpack in the loop
  */
-	EXO ( stb $2,-1($6) )	# .. .. .. L	:
-	addq $7,1,$7		# .. .. E  ..	: quadpack as the load
+	EXO ( stb $2,-1($16) )	# .. .. .. L	:
+	addq $17,1,$17		# .. .. E  ..	: quadpack as the load
 	subq $0,1,$0		# .. E  .. ..	: change count _after_ copy
 	bgt $0,$onebyteloop	# U  .. .. ..	: U L U L
 
@@ -233,7 +219,7 @@ $exitout:			# Destination for exception
 	nop			# .. .. .. E
 	nop			# .. .. E  ..
 	nop			# .. E  .. ..
-	ret $31,($28),1		# L0 .. .. ..	: L U L U
+	ret $31,($26),1		# L0 .. .. ..	: L U L U
 
 	.end __copy_user
 	EXPORT_SYMBOL(__copy_user)


