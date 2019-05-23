Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8764227E1F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 15:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbfEWN2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 09:28:07 -0400
Received: from ozlabs.org ([203.11.71.1]:49167 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729934AbfEWN2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 09:28:07 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 458r0W1tQ5z9s1c;
        Thu, 23 May 2019 23:27:54 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, will.deacon@arm.com
Cc:     aou@eecs.berkeley.edu, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, davem@davemloft.net, fenghua.yu@intel.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        ink@jurassic.park.msu.ru, jhogan@kernel.org, linux@armlinux.org.uk,
        mark.rutland@arm.com, mattst88@gmail.com, mingo@kernel.org,
        palmer@sifive.com, paul.burton@mips.com, paulus@samba.org,
        ralf@linux-mips.org, rth@twiddle.net, stable@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, vgupta@synopsys.com
Subject: Re: [PATCH 10/18] locking/atomic: powerpc: use s64 for atomic64
In-Reply-To: <20190522132250.26499-11-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com> <20190522132250.26499-11-mark.rutland@arm.com>
Date:   Thu, 23 May 2019 23:27:54 +1000
Message-ID: <87ef4pqp0l.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mark Rutland <mark.rutland@arm.com> writes:
> As a step towards making the atomic64 API use consistent types treewide,
> let's have the powerpc atomic64 implementation use s64 as the underlying
> type for atomic64_t, rather than long, matching the generated headers.
>
> As atomic64_read() depends on the generic defintion of atomic64_t, this
> still returns long on 64-bit. This will be converted in a subsequent
> patch.
>
> Otherwise, there should be no functional change as a result of this
> patch.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/powerpc/include/asm/atomic.h | 44 +++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)

Conversion looks good to me.

Reviewed-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers

> diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
> index 52eafaf74054..31c231ea56b7 100644
> --- a/arch/powerpc/include/asm/atomic.h
> +++ b/arch/powerpc/include/asm/atomic.h
> @@ -297,24 +297,24 @@ static __inline__ int atomic_dec_if_positive(atomic_t *v)
>  
>  #define ATOMIC64_INIT(i)	{ (i) }
>  
> -static __inline__ long atomic64_read(const atomic64_t *v)
> +static __inline__ s64 atomic64_read(const atomic64_t *v)
>  {
> -	long t;
> +	s64 t;
>  
>  	__asm__ __volatile__("ld%U1%X1 %0,%1" : "=r"(t) : "m"(v->counter));
>  
>  	return t;
>  }
>  
> -static __inline__ void atomic64_set(atomic64_t *v, long i)
> +static __inline__ void atomic64_set(atomic64_t *v, s64 i)
>  {
>  	__asm__ __volatile__("std%U0%X0 %1,%0" : "=m"(v->counter) : "r"(i));
>  }
>  
>  #define ATOMIC64_OP(op, asm_op)						\
> -static __inline__ void atomic64_##op(long a, atomic64_t *v)		\
> +static __inline__ void atomic64_##op(s64 a, atomic64_t *v)		\
>  {									\
> -	long t;								\
> +	s64 t;								\
>  									\
>  	__asm__ __volatile__(						\
>  "1:	ldarx	%0,0,%3		# atomic64_" #op "\n"			\
> @@ -327,10 +327,10 @@ static __inline__ void atomic64_##op(long a, atomic64_t *v)		\
>  }
>  
>  #define ATOMIC64_OP_RETURN_RELAXED(op, asm_op)				\
> -static inline long							\
> -atomic64_##op##_return_relaxed(long a, atomic64_t *v)			\
> +static inline s64							\
> +atomic64_##op##_return_relaxed(s64 a, atomic64_t *v)			\
>  {									\
> -	long t;								\
> +	s64 t;								\
>  									\
>  	__asm__ __volatile__(						\
>  "1:	ldarx	%0,0,%3		# atomic64_" #op "_return_relaxed\n"	\
> @@ -345,10 +345,10 @@ atomic64_##op##_return_relaxed(long a, atomic64_t *v)			\
>  }
>  
>  #define ATOMIC64_FETCH_OP_RELAXED(op, asm_op)				\
> -static inline long							\
> -atomic64_fetch_##op##_relaxed(long a, atomic64_t *v)			\
> +static inline s64							\
> +atomic64_fetch_##op##_relaxed(s64 a, atomic64_t *v)			\
>  {									\
> -	long res, t;							\
> +	s64 res, t;							\
>  									\
>  	__asm__ __volatile__(						\
>  "1:	ldarx	%0,0,%4		# atomic64_fetch_" #op "_relaxed\n"	\
> @@ -396,7 +396,7 @@ ATOMIC64_OPS(xor, xor)
>  
>  static __inline__ void atomic64_inc(atomic64_t *v)
>  {
> -	long t;
> +	s64 t;
>  
>  	__asm__ __volatile__(
>  "1:	ldarx	%0,0,%2		# atomic64_inc\n\
> @@ -409,9 +409,9 @@ static __inline__ void atomic64_inc(atomic64_t *v)
>  }
>  #define atomic64_inc atomic64_inc
>  
> -static __inline__ long atomic64_inc_return_relaxed(atomic64_t *v)
> +static __inline__ s64 atomic64_inc_return_relaxed(atomic64_t *v)
>  {
> -	long t;
> +	s64 t;
>  
>  	__asm__ __volatile__(
>  "1:	ldarx	%0,0,%2		# atomic64_inc_return_relaxed\n"
> @@ -427,7 +427,7 @@ static __inline__ long atomic64_inc_return_relaxed(atomic64_t *v)
>  
>  static __inline__ void atomic64_dec(atomic64_t *v)
>  {
> -	long t;
> +	s64 t;
>  
>  	__asm__ __volatile__(
>  "1:	ldarx	%0,0,%2		# atomic64_dec\n\
> @@ -440,9 +440,9 @@ static __inline__ void atomic64_dec(atomic64_t *v)
>  }
>  #define atomic64_dec atomic64_dec
>  
> -static __inline__ long atomic64_dec_return_relaxed(atomic64_t *v)
> +static __inline__ s64 atomic64_dec_return_relaxed(atomic64_t *v)
>  {
> -	long t;
> +	s64 t;
>  
>  	__asm__ __volatile__(
>  "1:	ldarx	%0,0,%2		# atomic64_dec_return_relaxed\n"
> @@ -463,9 +463,9 @@ static __inline__ long atomic64_dec_return_relaxed(atomic64_t *v)
>   * Atomically test *v and decrement if it is greater than 0.
>   * The function returns the old value of *v minus 1.
>   */
> -static __inline__ long atomic64_dec_if_positive(atomic64_t *v)
> +static __inline__ s64 atomic64_dec_if_positive(atomic64_t *v)
>  {
> -	long t;
> +	s64 t;
>  
>  	__asm__ __volatile__(
>  	PPC_ATOMIC_ENTRY_BARRIER
> @@ -502,9 +502,9 @@ static __inline__ long atomic64_dec_if_positive(atomic64_t *v)
>   * Atomically adds @a to @v, so long as it was not @u.
>   * Returns the old value of @v.
>   */
> -static __inline__ long atomic64_fetch_add_unless(atomic64_t *v, long a, long u)
> +static __inline__ s64 atomic64_fetch_add_unless(atomic64_t *v, s64 a, s64 u)
>  {
> -	long t;
> +	s64 t;
>  
>  	__asm__ __volatile__ (
>  	PPC_ATOMIC_ENTRY_BARRIER
> @@ -534,7 +534,7 @@ static __inline__ long atomic64_fetch_add_unless(atomic64_t *v, long a, long u)
>   */
>  static __inline__ int atomic64_inc_not_zero(atomic64_t *v)
>  {
> -	long t1, t2;
> +	s64 t1, t2;
>  
>  	__asm__ __volatile__ (
>  	PPC_ATOMIC_ENTRY_BARRIER
> -- 
> 2.11.0
