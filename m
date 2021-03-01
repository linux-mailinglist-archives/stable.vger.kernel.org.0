Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9EC32907B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242950AbhCAUIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:53 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:35608 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbhCAT5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 14:57:17 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGoeG-0004pw-8h
        for stable@vger.kernel.org; Mon, 01 Mar 2021 20:56:08 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGoeF-0056PR-6Y
        for stable@vger.kernel.org; Mon, 01 Mar 2021 20:56:07 +0100
Date:   Mon, 1 Mar 2021 20:56:07 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Subject: [stable 4.9-4.19] Fix arm64 build regression in xen-netback
Message-ID: <YD1G1zQT/H+CUwXF@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eh7t2JQvHW0UUDvt"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eh7t2JQvHW0UUDvt
Content-Type: multipart/mixed; boundary="78nhM7UyumR5M09q"
Content-Disposition: inline


--78nhM7UyumR5M09q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The arm64 implementations of some atomic operations had incorrect
assembly constraints.  Depending on the compiler version and
options, this can result in a build failure for some parameter
values:

/tmp/ccDOb5nB.s: Assembler messages:
/tmp/ccDOb5nB.s:2214: Error: immediate out of range at operand 3 -- `bic w1=
,w0,5'

This has specifically been seen when building a 4.9 stable kernel with
gcc 6.3.0, since commit 23025393dbeb "xen/netback: use lateeoi irq
binding" was applied.  I can also reproduce it with 4.14.

I cannot reproduce it with 4.19, but the same fixes are applicable and
the issue presumably could occur when using different compiler
options.

I haven't done anything about the 4.4 branch since it does not have
that xen-netback fix and it has significantly different definitions
for arm64 atomic ops.

I've attached a mailbox of patches for each of the 4.9, 4.14, and 4.19
branches.

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--78nhM7UyumR5M09q
Content-Type: application/mbox
Content-Disposition: attachment; filename="arm64-atomic-4.9.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 8a92647cf4a83b00cc76143e0e162adf3f711ae0 Mon Sep 17 00:00:00 2001=0A=
=46rom: Robin Murphy <robin.murphy@arm.com>=0ADate: Fri, 12 May 2017 13:48:=
41 +0100=0ASubject: [PATCH 1/4] arm64: Remove redundant mov from LL/SC cmpx=
chg=0A=0Acommit 8df728e1ae614f592961e51f65d3e3212ede5a75 upstream.=0A=0AThe=
 cmpxchg implementation introduced by commit c342f78217e8 ("arm64:=0Acmpxch=
g: patch in lse instructions when supported by the CPU") performs=0Aan appa=
rently redundant register move of [old] to [oldval] in the=0Asuccess case -=
 it always uses the same register width as [oldval] was=0Aoriginally loaded=
 with, and is only executed when [old] and [oldval] are=0Aknown to be equal=
 anyway.=0A=0AThe only effect it seemingly does have is to take up a surpri=
sing amount=0Aof space in the kernel text, as removing it reveals:=0A=0A   =
text	   data	    bss	    dec	    hex	filename=0A12426658	1348614	4499749	18=
275021	116dacd	vmlinux.o.new=0A12429238	1348614	4499749	18277601	116e4e1	vm=
linux.o.old=0A=0AReviewed-by: Will Deacon <will.deacon@arm.com>=0ASigned-of=
f-by: Robin Murphy <robin.murphy@arm.com>=0ASigned-off-by: Catalin Marinas =
<catalin.marinas@arm.com>=0ASigned-off-by: Ben Hutchings <ben@decadent.org.=
uk>=0A---=0A arch/arm64/include/asm/atomic_ll_sc.h | 1 -=0A 1 file changed,=
 1 deletion(-)=0A=0Adiff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/ar=
ch/arm64/include/asm/atomic_ll_sc.h=0Aindex f819fdcff1ac..f5a2d09afb38 1006=
44=0A--- a/arch/arm64/include/asm/atomic_ll_sc.h=0A+++ b/arch/arm64/include=
/asm/atomic_ll_sc.h=0A@@ -264,7 +264,6 @@ __LL_SC_PREFIX(__cmpxchg_case_##n=
ame(volatile void *ptr,		\=0A 	"	st" #rel "xr" #sz "\t%w[tmp], %" #w "[new]=
, %[v]\n"	\=0A 	"	cbnz	%w[tmp], 1b\n"					\=0A 	"	" #mb "\n"						\=0A-	"	m=
ov	%" #w "[oldval], %" #w "[old]\n"		\=0A 	"2:"								\=0A 	: [tmp] "=3D&r=
" (tmp), [oldval] "=3D&r" (oldval),			\=0A 	  [v] "+Q" (*(unsigned long *)p=
tr)				\=0A=0AFrom d1761f2f111d4fc19823cf1a3e6ddcf91d7efa9f Mon Sep 17 00:0=
0:00 2001=0AFrom: Will Deacon <will.deacon@arm.com>=0ADate: Thu, 13 Sep 201=
8 13:30:45 +0100=0ASubject: [PATCH 2/4] arm64: Avoid redundant type convers=
ions in xchg() and=0A cmpxchg()=0A=0Acommit 5ef3fe4cecdf82fdd71ce7898840396=
3d01444d4 upstream.=0A=0AOur atomic instructions (either LSE atomics of LDX=
R/STXR sequences)=0Anatively support byte, half-word, word and double-word =
memory accesses=0Aso there is no need to mask the data register prior to be=
ing stored.=0A=0ASigned-off-by: Will Deacon <will.deacon@arm.com>=0ASigned-=
off-by: Ben Hutchings <ben@decadent.org.uk>=0A---=0A arch/arm64/include/asm=
/atomic_ll_sc.h |  53 ++++++------=0A arch/arm64/include/asm/atomic_lse.h  =
 |  46 +++++-----=0A arch/arm64/include/asm/cmpxchg.h      | 116 ++++++++++=
+++-------------=0A 3 files changed, 108 insertions(+), 107 deletions(-)=0A=
=0Adiff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/=
asm/atomic_ll_sc.h=0Aindex f5a2d09afb38..f02d3bf7b9e6 100644=0A--- a/arch/a=
rm64/include/asm/atomic_ll_sc.h=0A+++ b/arch/arm64/include/asm/atomic_ll_sc=
=2Eh=0A@@ -248,48 +248,49 @@ __LL_SC_PREFIX(atomic64_dec_if_positive(atomic=
64_t *v))=0A }=0A __LL_SC_EXPORT(atomic64_dec_if_positive);=0A =0A-#define =
__CMPXCHG_CASE(w, sz, name, mb, acq, rel, cl)			\=0A-__LL_SC_INLINE unsigne=
d long						\=0A-__LL_SC_PREFIX(__cmpxchg_case_##name(volatile void *ptr,		=
\=0A-				     unsigned long old,			\=0A-				     unsigned long new))		\=0A+=
#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl)		\=0A+__LL_SC_IN=
LINE u##sz							\=0A+__LL_SC_PREFIX(__cmpxchg_case_##name##sz(volatile voi=
d *ptr,		\=0A+					 unsigned long old,		\=0A+					 u##sz new))			\=0A {				=
					\=0A-	unsigned long tmp, oldval;					\=0A+	unsigned long tmp;						\=
=0A+	u##sz oldval;							\=0A 									\=0A 	asm volatile(							\=0A 	"	pr=
fm	pstl1strm, %[v]\n"				\=0A-	"1:	ld" #acq "xr" #sz "\t%" #w "[oldval], %[=
v]\n"		\=0A+	"1:	ld" #acq "xr" #sfx "\t%" #w "[oldval], %[v]\n"		\=0A 	"	eo=
r	%" #w "[tmp], %" #w "[oldval], %" #w "[old]\n"	\=0A 	"	cbnz	%" #w "[tmp],=
 2f\n"				\=0A-	"	st" #rel "xr" #sz "\t%w[tmp], %" #w "[new], %[v]\n"	\=0A+=
	"	st" #rel "xr" #sfx "\t%w[tmp], %" #w "[new], %[v]\n"	\=0A 	"	cbnz	%w[tmp=
], 1b\n"					\=0A 	"	" #mb "\n"						\=0A 	"2:"								\=0A 	: [tmp] "=3D&r=
" (tmp), [oldval] "=3D&r" (oldval),			\=0A-	  [v] "+Q" (*(unsigned long *)p=
tr)				\=0A+	  [v] "+Q" (*(u##sz *)ptr)					\=0A 	: [old] "Lr" (old), [new]=
 "r" (new)				\=0A 	: cl);								\=0A 									\=0A 	return oldval;							=
\=0A }									\=0A-__LL_SC_EXPORT(__cmpxchg_case_##name);=0A+__LL_SC_EXPOR=
T(__cmpxchg_case_##name##sz);=0A =0A-__CMPXCHG_CASE(w, b,     1,        ,  =
,  ,         )=0A-__CMPXCHG_CASE(w, h,     2,        ,  ,  ,         )=0A-_=
_CMPXCHG_CASE(w,  ,     4,        ,  ,  ,         )=0A-__CMPXCHG_CASE( ,  ,=
     8,        ,  ,  ,         )=0A-__CMPXCHG_CASE(w, b, acq_1,        , a,=
  , "memory")=0A-__CMPXCHG_CASE(w, h, acq_2,        , a,  , "memory")=0A-__=
CMPXCHG_CASE(w,  , acq_4,        , a,  , "memory")=0A-__CMPXCHG_CASE( ,  , =
acq_8,        , a,  , "memory")=0A-__CMPXCHG_CASE(w, b, rel_1,        ,  , =
l, "memory")=0A-__CMPXCHG_CASE(w, h, rel_2,        ,  , l, "memory")=0A-__C=
MPXCHG_CASE(w,  , rel_4,        ,  , l, "memory")=0A-__CMPXCHG_CASE( ,  , r=
el_8,        ,  , l, "memory")=0A-__CMPXCHG_CASE(w, b,  mb_1, dmb ish,  , l=
, "memory")=0A-__CMPXCHG_CASE(w, h,  mb_2, dmb ish,  , l, "memory")=0A-__CM=
PXCHG_CASE(w,  ,  mb_4, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE( ,  ,  m=
b_8, dmb ish,  , l, "memory")=0A+__CMPXCHG_CASE(w, b,     ,  8,        ,  ,=
  ,         )=0A+__CMPXCHG_CASE(w, h,     , 16,        ,  ,  ,         )=0A=
+__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  ,         )=0A+__CMPXCHG_CASE(=
 ,  ,     , 64,        ,  ,  ,         )=0A+__CMPXCHG_CASE(w, b, acq_,  8, =
       , a,  , "memory")=0A+__CMPXCHG_CASE(w, h, acq_, 16,        , a,  , "=
memory")=0A+__CMPXCHG_CASE(w,  , acq_, 32,        , a,  , "memory")=0A+__CM=
PXCHG_CASE( ,  , acq_, 64,        , a,  , "memory")=0A+__CMPXCHG_CASE(w, b,=
 rel_,  8,        ,  , l, "memory")=0A+__CMPXCHG_CASE(w, h, rel_, 16,      =
  ,  , l, "memory")=0A+__CMPXCHG_CASE(w,  , rel_, 32,        ,  , l, "memor=
y")=0A+__CMPXCHG_CASE( ,  , rel_, 64,        ,  , l, "memory")=0A+__CMPXCHG=
_CASE(w, b,  mb_,  8, dmb ish,  , l, "memory")=0A+__CMPXCHG_CASE(w, h,  mb_=
, 16, dmb ish,  , l, "memory")=0A+__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish,  =
, l, "memory")=0A+__CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory")=
=0A =0A #undef __CMPXCHG_CASE=0A =0Adiff --git a/arch/arm64/include/asm/ato=
mic_lse.h b/arch/arm64/include/asm/atomic_lse.h=0Aindex d32a0160c89f..982fe=
05e5058 100644=0A--- a/arch/arm64/include/asm/atomic_lse.h=0A+++ b/arch/arm=
64/include/asm/atomic_lse.h=0A@@ -446,22 +446,22 @@ static inline long atom=
ic64_dec_if_positive(atomic64_t *v)=0A =0A #define __LL_SC_CMPXCHG(op)	__LL=
_SC_CALL(__cmpxchg_case_##op)=0A =0A-#define __CMPXCHG_CASE(w, sz, name, mb=
, cl...)				\=0A-static inline unsigned long __cmpxchg_case_##name(volatile=
 void *ptr,	\=0A-						  unsigned long old,	\=0A-						  unsigned long new)=
	\=0A+#define __CMPXCHG_CASE(w, sfx, name, sz, mb, cl...)			\=0A+static inl=
ine u##sz __cmpxchg_case_##name##sz(volatile void *ptr,	\=0A+					      uns=
igned long old,	\=0A+					      u##sz new)		\=0A {									\=0A 	register u=
nsigned long x0 asm ("x0") =3D (unsigned long)ptr;	\=0A 	register unsigned =
long x1 asm ("x1") =3D old;			\=0A-	register unsigned long x2 asm ("x2") =
=3D new;			\=0A+	register u##sz x2 asm ("x2") =3D new;				\=0A 									\=
=0A 	asm volatile(ARM64_LSE_ATOMIC_INSN(				\=0A 	/* LL/SC */							\=0A-	_=
_LL_SC_CMPXCHG(name)						\=0A+	__LL_SC_CMPXCHG(name##sz)					\=0A 	__nops(=
2),							\=0A 	/* LSE atomics */						\=0A 	"	mov	" #w "30, %" #w "[old]\n=
"			\=0A-	"	cas" #mb #sz "\t" #w "30, %" #w "[new], %[v]\n"		\=0A+	"	cas" #=
mb #sfx "\t" #w "30, %" #w "[new], %[v]\n"	\=0A 	"	mov	%" #w "[ret], " #w "=
30")			\=0A 	: [ret] "+r" (x0), [v] "+Q" (*(unsigned long *)ptr)		\=0A 	: [=
old] "r" (x1), [new] "r" (x2)				\=0A@@ -470,22 +470,22 @@ static inline un=
signed long __cmpxchg_case_##name(volatile void *ptr,	\=0A 	return x0;					=
		\=0A }=0A =0A-__CMPXCHG_CASE(w, b,     1,   )=0A-__CMPXCHG_CASE(w, h,    =
 2,   )=0A-__CMPXCHG_CASE(w,  ,     4,   )=0A-__CMPXCHG_CASE(x,  ,     8,  =
 )=0A-__CMPXCHG_CASE(w, b, acq_1,  a, "memory")=0A-__CMPXCHG_CASE(w, h, acq=
_2,  a, "memory")=0A-__CMPXCHG_CASE(w,  , acq_4,  a, "memory")=0A-__CMPXCHG=
_CASE(x,  , acq_8,  a, "memory")=0A-__CMPXCHG_CASE(w, b, rel_1,  l, "memory=
")=0A-__CMPXCHG_CASE(w, h, rel_2,  l, "memory")=0A-__CMPXCHG_CASE(w,  , rel=
_4,  l, "memory")=0A-__CMPXCHG_CASE(x,  , rel_8,  l, "memory")=0A-__CMPXCHG=
_CASE(w, b,  mb_1, al, "memory")=0A-__CMPXCHG_CASE(w, h,  mb_2, al, "memory=
")=0A-__CMPXCHG_CASE(w,  ,  mb_4, al, "memory")=0A-__CMPXCHG_CASE(x,  ,  mb=
_8, al, "memory")=0A+__CMPXCHG_CASE(w, b,     ,  8,   )=0A+__CMPXCHG_CASE(w=
, h,     , 16,   )=0A+__CMPXCHG_CASE(w,  ,     , 32,   )=0A+__CMPXCHG_CASE(=
x,  ,     , 64,   )=0A+__CMPXCHG_CASE(w, b, acq_,  8,  a, "memory")=0A+__CM=
PXCHG_CASE(w, h, acq_, 16,  a, "memory")=0A+__CMPXCHG_CASE(w,  , acq_, 32, =
 a, "memory")=0A+__CMPXCHG_CASE(x,  , acq_, 64,  a, "memory")=0A+__CMPXCHG_=
CASE(w, b, rel_,  8,  l, "memory")=0A+__CMPXCHG_CASE(w, h, rel_, 16,  l, "m=
emory")=0A+__CMPXCHG_CASE(w,  , rel_, 32,  l, "memory")=0A+__CMPXCHG_CASE(x=
,  , rel_, 64,  l, "memory")=0A+__CMPXCHG_CASE(w, b,  mb_,  8, al, "memory"=
)=0A+__CMPXCHG_CASE(w, h,  mb_, 16, al, "memory")=0A+__CMPXCHG_CASE(w,  ,  =
mb_, 32, al, "memory")=0A+__CMPXCHG_CASE(x,  ,  mb_, 64, al, "memory")=0A =
=0A #undef __LL_SC_CMPXCHG=0A #undef __CMPXCHG_CASE=0Adiff --git a/arch/arm=
64/include/asm/cmpxchg.h b/arch/arm64/include/asm/cmpxchg.h=0Aindex 9b2e2e2=
e728a..ed6a1aae6fbb 100644=0A--- a/arch/arm64/include/asm/cmpxchg.h=0A+++ b=
/arch/arm64/include/asm/cmpxchg.h=0A@@ -29,46 +29,46 @@=0A  * barrier case =
is generated as release+dmb for the former and=0A  * acquire+release for th=
e latter.=0A  */=0A-#define __XCHG_CASE(w, sz, name, mb, nop_lse, acq, acq_=
lse, rel, cl)	\=0A-static inline unsigned long __xchg_case_##name(unsigned =
long x,		\=0A-					       volatile void *ptr)	\=0A-{									\=0A-	unsigned=
 long ret, tmp;						\=0A-									\=0A-	asm volatile(ARM64_LSE_ATOMIC_INSN=
(				\=0A-	/* LL/SC */							\=0A-	"	prfm	pstl1strm, %2\n"				\=0A-	"1:	ld"=
 #acq "xr" #sz "\t%" #w "0, %2\n"			\=0A-	"	st" #rel "xr" #sz "\t%w1, %" #w=
 "3, %2\n"		\=0A-	"	cbnz	%w1, 1b\n"					\=0A-	"	" #mb,							\=0A-	/* LSE a=
tomics */						\=0A-	"	swp" #acq_lse #rel #sz "\t%" #w "3, %" #w "0, %2\n"	=
\=0A-		__nops(3)						\=0A-	"	" #nop_lse)						\=0A-	: "=3D&r" (ret), "=3D&=
r" (tmp), "+Q" (*(unsigned long *)ptr)	\=0A-	: "r" (x)							\=0A-	: cl);		=
						\=0A-									\=0A-	return ret;							\=0A+#define __XCHG_CASE(w, sfx=
, name, sz, mb, nop_lse, acq, acq_lse, rel, cl)	\=0A+static inline u##sz __=
xchg_case_##name##sz(u##sz x, volatile void *ptr)		\=0A+{										\=0A+	u#=
#sz ret;								\=0A+	unsigned long tmp;							\=0A+										\=0A+	asm vol=
atile(ARM64_LSE_ATOMIC_INSN(					\=0A+	/* LL/SC */								\=0A+	"	prfm	pstl=
1strm, %2\n"					\=0A+	"1:	ld" #acq "xr" #sfx "\t%" #w "0, %2\n"				\=0A+	"=
	st" #rel "xr" #sfx "\t%w1, %" #w "3, %2\n"			\=0A+	"	cbnz	%w1, 1b\n"						=
\=0A+	"	" #mb,								\=0A+	/* LSE atomics */							\=0A+	"	swp" #acq_lse #=
rel #sfx "\t%" #w "3, %" #w "0, %2\n"		\=0A+		__nops(3)							\=0A+	"	" #no=
p_lse)							\=0A+	: "=3D&r" (ret), "=3D&r" (tmp), "+Q" (*(u##sz *)ptr)			\=
=0A+	: "r" (x)								\=0A+	: cl);									\=0A+										\=0A+	return ret;=
								\=0A }=0A =0A-__XCHG_CASE(w, b,     1,        ,    ,  ,  ,  ,      =
   )=0A-__XCHG_CASE(w, h,     2,        ,    ,  ,  ,  ,         )=0A-__XCHG=
_CASE(w,  ,     4,        ,    ,  ,  ,  ,         )=0A-__XCHG_CASE( ,  ,   =
  8,        ,    ,  ,  ,  ,         )=0A-__XCHG_CASE(w, b, acq_1,        , =
   , a, a,  , "memory")=0A-__XCHG_CASE(w, h, acq_2,        ,    , a, a,  , =
"memory")=0A-__XCHG_CASE(w,  , acq_4,        ,    , a, a,  , "memory")=0A-_=
_XCHG_CASE( ,  , acq_8,        ,    , a, a,  , "memory")=0A-__XCHG_CASE(w, =
b, rel_1,        ,    ,  ,  , l, "memory")=0A-__XCHG_CASE(w, h, rel_2,     =
   ,    ,  ,  , l, "memory")=0A-__XCHG_CASE(w,  , rel_4,        ,    ,  ,  =
, l, "memory")=0A-__XCHG_CASE( ,  , rel_8,        ,    ,  ,  , l, "memory")=
=0A-__XCHG_CASE(w, b,  mb_1, dmb ish, nop,  , a, l, "memory")=0A-__XCHG_CAS=
E(w, h,  mb_2, dmb ish, nop,  , a, l, "memory")=0A-__XCHG_CASE(w,  ,  mb_4,=
 dmb ish, nop,  , a, l, "memory")=0A-__XCHG_CASE( ,  ,  mb_8, dmb ish, nop,=
  , a, l, "memory")=0A+__XCHG_CASE(w, b,     ,  8,        ,    ,  ,  ,  ,  =
       )=0A+__XCHG_CASE(w, h,     , 16,        ,    ,  ,  ,  ,         )=0A=
+__XCHG_CASE(w,  ,     , 32,        ,    ,  ,  ,  ,         )=0A+__XCHG_CAS=
E( ,  ,     , 64,        ,    ,  ,  ,  ,         )=0A+__XCHG_CASE(w, b, acq=
_,  8,        ,    , a, a,  , "memory")=0A+__XCHG_CASE(w, h, acq_, 16,     =
   ,    , a, a,  , "memory")=0A+__XCHG_CASE(w,  , acq_, 32,        ,    , a=
, a,  , "memory")=0A+__XCHG_CASE( ,  , acq_, 64,        ,    , a, a,  , "me=
mory")=0A+__XCHG_CASE(w, b, rel_,  8,        ,    ,  ,  , l, "memory")=0A+_=
_XCHG_CASE(w, h, rel_, 16,        ,    ,  ,  , l, "memory")=0A+__XCHG_CASE(=
w,  , rel_, 32,        ,    ,  ,  , l, "memory")=0A+__XCHG_CASE( ,  , rel_,=
 64,        ,    ,  ,  , l, "memory")=0A+__XCHG_CASE(w, b,  mb_,  8, dmb is=
h, nop,  , a, l, "memory")=0A+__XCHG_CASE(w, h,  mb_, 16, dmb ish, nop,  , =
a, l, "memory")=0A+__XCHG_CASE(w,  ,  mb_, 32, dmb ish, nop,  , a, l, "memo=
ry")=0A+__XCHG_CASE( ,  ,  mb_, 64, dmb ish, nop,  , a, l, "memory")=0A =0A=
 #undef __XCHG_CASE=0A =0A@@ -79,13 +79,13 @@ static __always_inline  unsig=
ned long __xchg##sfx(unsigned long x,	\=0A {									\=0A 	switch (size) {	=
						\=0A 	case 1:								\=0A-		return __xchg_case##sfx##_1(x, ptr);			\=
=0A+		return __xchg_case##sfx##_8(x, ptr);			\=0A 	case 2:								\=0A-		re=
turn __xchg_case##sfx##_2(x, ptr);			\=0A+		return __xchg_case##sfx##_16(x,=
 ptr);			\=0A 	case 4:								\=0A-		return __xchg_case##sfx##_4(x, ptr);		=
	\=0A+		return __xchg_case##sfx##_32(x, ptr);			\=0A 	case 8:								\=0A-	=
	return __xchg_case##sfx##_8(x, ptr);			\=0A+		return __xchg_case##sfx##_64=
(x, ptr);			\=0A 	default:							\=0A 		BUILD_BUG();						\=0A 	}								\=
=0A@@ -122,13 +122,13 @@ static __always_inline unsigned long __cmpxchg##sf=
x(volatile void *ptr,	\=0A {									\=0A 	switch (size) {							\=0A 	case=
 1:								\=0A-		return __cmpxchg_case##sfx##_1(ptr, (u8)old, new);	\=0A+	=
	return __cmpxchg_case##sfx##_8(ptr, (u8)old, new);	\=0A 	case 2:								\=
=0A-		return __cmpxchg_case##sfx##_2(ptr, (u16)old, new);	\=0A+		return __c=
mpxchg_case##sfx##_16(ptr, (u16)old, new);	\=0A 	case 4:								\=0A-		retu=
rn __cmpxchg_case##sfx##_4(ptr, old, new);		\=0A+		return __cmpxchg_case##s=
fx##_32(ptr, old, new);		\=0A 	case 8:								\=0A-		return __cmpxchg_case#=
#sfx##_8(ptr, old, new);		\=0A+		return __cmpxchg_case##sfx##_64(ptr, old, =
new);		\=0A 	default:							\=0A 		BUILD_BUG();						\=0A 	}								\=0A@@ =
-222,16 +222,16 @@ __CMPXCHG_GEN(_mb)=0A 	__ret;								\=0A })=0A =0A-#def=
ine __CMPWAIT_CASE(w, sz, name)					\=0A-static inline void __cmpwait_case_=
##name(volatile void *ptr,		\=0A-					 unsigned long val)		\=0A+#define __C=
MPWAIT_CASE(w, sfx, sz)					\=0A+static inline void __cmpwait_case_##sz(vol=
atile void *ptr,		\=0A+				       unsigned long val)		\=0A {									\=0A 	=
unsigned long tmp;						\=0A 									\=0A 	asm volatile(							\=0A 	"	sev=
l\n"							\=0A 	"	wfe\n"							\=0A-	"	ldxr" #sz "\t%" #w "[tmp], %[v]\n"	=
		\=0A+	"	ldxr" #sfx "\t%" #w "[tmp], %[v]\n"			\=0A 	"	eor	%" #w "[tmp], %=
" #w "[tmp], %" #w "[val]\n"	\=0A 	"	cbnz	%" #w "[tmp], 1f\n"				\=0A 	"	wf=
e\n"							\=0A@@ -240,10 +240,10 @@ static inline void __cmpwait_case_##na=
me(volatile void *ptr,		\=0A 	: [val] "r" (val));						\=0A }=0A =0A-__CMPW=
AIT_CASE(w, b, 1);=0A-__CMPWAIT_CASE(w, h, 2);=0A-__CMPWAIT_CASE(w,  , 4);=
=0A-__CMPWAIT_CASE( ,  , 8);=0A+__CMPWAIT_CASE(w, b, 8);=0A+__CMPWAIT_CASE(=
w, h, 16);=0A+__CMPWAIT_CASE(w,  , 32);=0A+__CMPWAIT_CASE( ,  , 64);=0A =0A=
 #undef __CMPWAIT_CASE=0A =0A@@ -254,13 +254,13 @@ static __always_inline v=
oid __cmpwait##sfx(volatile void *ptr,		\=0A {									\=0A 	switch (size) =
{							\=0A 	case 1:								\=0A-		return __cmpwait_case##sfx##_1(ptr, (u8=
)val);		\=0A+		return __cmpwait_case##sfx##_8(ptr, (u8)val);		\=0A 	case 2:=
								\=0A-		return __cmpwait_case##sfx##_2(ptr, (u16)val);		\=0A+		retur=
n __cmpwait_case##sfx##_16(ptr, (u16)val);		\=0A 	case 4:								\=0A-		ret=
urn __cmpwait_case##sfx##_4(ptr, val);		\=0A+		return __cmpwait_case##sfx##=
_32(ptr, val);		\=0A 	case 8:								\=0A-		return __cmpwait_case##sfx##_8(=
ptr, val);		\=0A+		return __cmpwait_case##sfx##_64(ptr, val);		\=0A 	defaul=
t:							\=0A 		BUILD_BUG();						\=0A 	}								\=0A=0AFrom 192b5640661ae4=
3796b4cc84091d587c2adaf0d9 Mon Sep 17 00:00:00 2001=0AFrom: Will Deacon <wi=
ll.deacon@arm.com>=0ADate: Tue, 18 Sep 2018 09:39:55 +0100=0ASubject: [PATC=
H 3/4] arm64: cmpxchg: Use "K" instead of "L" for ll/sc=0A immediate constr=
aint=0A=0Acommit 4230509978f2921182da4e9197964dccdbe463c3 upstream.=0A=0ATh=
e "L" AArch64 machine constraint, which we use for the "old" value in=0Aan =
LL/SC cmpxchg(), generates an immediate that is suitable for a 64-bit=0Alog=
ical instruction. However, for cmpxchg() operations on types smaller=0Athan=
 64 bits, this constraint can result in an invalid instruction which=0Ais c=
orrectly rejected by GAS, such as EOR W1, W1, #0xffffffff.=0A=0AWhilst we c=
ould special-case the constraint based on the cmpxchg size,=0Ait's far easi=
er to change the constraint to "K" and put up with using=0Aa register for l=
arge 64-bit immediates. For out-of-line LL/SC atomics,=0Athis is all moot a=
nyway.=0A=0AReported-by: Robin Murphy <robin.murphy@arm.com>=0ASigned-off-b=
y: Will Deacon <will.deacon@arm.com>=0ASigned-off-by: Ben Hutchings <ben@de=
cadent.org.uk>=0A---=0A arch/arm64/include/asm/atomic_ll_sc.h | 2 +-=0A 1 f=
ile changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/arch/arm64/inc=
lude/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h=0Aindex f02=
d3bf7b9e6..fb841553b0b0 100644=0A--- a/arch/arm64/include/asm/atomic_ll_sc.=
h=0A+++ b/arch/arm64/include/asm/atomic_ll_sc.h=0A@@ -268,7 +268,7 @@ __LL_=
SC_PREFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		\=0A 	"2:"								=
\=0A 	: [tmp] "=3D&r" (tmp), [oldval] "=3D&r" (oldval),			\=0A 	  [v] "+Q" =
(*(u##sz *)ptr)					\=0A-	: [old] "Lr" (old), [new] "r" (new)				\=0A+	: [o=
ld] "Kr" (old), [new] "r" (new)				\=0A 	: cl);								\=0A 									\=0A 	=
return oldval;							\=0A=0AFrom 28a1c9ba78a2d2e6b0296dab67c03b04b3904913 M=
on Sep 17 00:00:00 2001=0AFrom: Andrew Murray <andrew.murray@arm.com>=0ADat=
e: Wed, 28 Aug 2019 18:50:06 +0100=0ASubject: [PATCH 4/4] arm64: Use correc=
t ll/sc atomic constraints=0A=0Acommit 580fa1b874711d633f9b145b7777b0e83ebf=
3787 upstream.=0A=0AThe A64 ISA accepts distinct (but overlapping) ranges o=
f immediates for:=0A=0A * add arithmetic instructions ('I' machine constrai=
nt)=0A * sub arithmetic instructions ('J' machine constraint)=0A * 32-bit l=
ogical instructions ('K' machine constraint)=0A * 64-bit logical instructio=
ns ('L' machine constraint)=0A=0A... but we currently use the 'I' constrain=
t for many atomic operations=0Ausing sub or logical instructions, which is =
not always valid.=0A=0AWhen CONFIG_ARM64_LSE_ATOMICS is not set, this allow=
s invalid immediates=0Ato be passed to instructions, potentially resulting =
in a build failure.=0AWhen CONFIG_ARM64_LSE_ATOMICS is selected the out-of-=
line ll/sc atomics=0Aalways use a register as they have no visibility of th=
e value passed by=0Athe caller.=0A=0AThis patch adds a constraint parameter=
 to the ATOMIC_xx and=0A__CMPXCHG_CASE macros so that we can pass appropria=
te constraints for=0Aeach case, with uses updated accordingly.=0A=0AUnfortu=
nately prior to GCC 8.1.0 the 'K' constraint erroneously accepted=0A'429496=
7295', so we must instead force the use of a register.=0A=0ASigned-off-by: =
Andrew Murray <andrew.murray@arm.com>=0ASigned-off-by: Will Deacon <will@ke=
rnel.org>=0A[bwh: Backported to 4.9: adjust context]=0ASigned-off-by: Ben H=
utchings <ben@decadent.org.uk>=0A---=0A arch/arm64/include/asm/atomic_ll_sc=
=2Eh | 89 ++++++++++++++-------------=0A 1 file changed, 47 insertions(+), =
42 deletions(-)=0A=0Adiff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/a=
rch/arm64/include/asm/atomic_ll_sc.h=0Aindex fb841553b0b0..1cc42441bc67 100=
644=0A--- a/arch/arm64/include/asm/atomic_ll_sc.h=0A+++ b/arch/arm64/includ=
e/asm/atomic_ll_sc.h=0A@@ -37,7 +37,7 @@=0A  * (the optimize attribute sile=
ntly ignores these options).=0A  */=0A =0A-#define ATOMIC_OP(op, asm_op)			=
			\=0A+#define ATOMIC_OP(op, asm_op, constraint)				\=0A __LL_SC_INLINE vo=
id							\=0A __LL_SC_PREFIX(atomic_##op(int i, atomic_t *v))				\=0A {				=
					\=0A@@ -51,11 +51,11 @@ __LL_SC_PREFIX(atomic_##op(int i, atomic_t *v)=
)				\=0A "	stxr	%w1, %w0, %2\n"						\=0A "	cbnz	%w1, 1b"						\=0A 	: "=
=3D&r" (result), "=3D&r" (tmp), "+Q" (v->counter)		\=0A-	: "Ir" (i));						=
	\=0A+	: #constraint "r" (i));						\=0A }									\=0A __LL_SC_EXPORT(atom=
ic_##op);=0A =0A-#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_o=
p)		\=0A+#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_op, const=
raint)\=0A __LL_SC_INLINE int							\=0A __LL_SC_PREFIX(atomic_##op##_retur=
n##name(int i, atomic_t *v))		\=0A {									\=0A@@ -70,14 +70,14 @@ __LL_S=
C_PREFIX(atomic_##op##_return##name(int i, atomic_t *v))		\=0A "	cbnz	%w1, =
1b\n"						\=0A "	" #mb								\=0A 	: "=3D&r" (result), "=3D&r" (tmp), "+Q=
" (v->counter)		\=0A-	: "Ir" (i)							\=0A+	: #constraint "r" (i)						\=
=0A 	: cl);								\=0A 									\=0A 	return result;							\=0A }									=
\=0A __LL_SC_EXPORT(atomic_##op##_return##name);=0A =0A-#define ATOMIC_FETC=
H_OP(name, mb, acq, rel, cl, op, asm_op)		\=0A+#define ATOMIC_FETCH_OP(name=
, mb, acq, rel, cl, op, asm_op, constraint)	\=0A __LL_SC_INLINE int							\=
=0A __LL_SC_PREFIX(atomic_fetch_##op##name(int i, atomic_t *v))		\=0A {				=
					\=0A@@ -92,7 +92,7 @@ __LL_SC_PREFIX(atomic_fetch_##op##name(int i, at=
omic_t *v))		\=0A "	cbnz	%w2, 1b\n"						\=0A "	" #mb								\=0A 	: "=3D&r=
" (result), "=3D&r" (val), "=3D&r" (tmp), "+Q" (v->counter)	\=0A-	: "Ir" (i=
)							\=0A+	: #constraint "r" (i)						\=0A 	: cl);								\=0A 									=
\=0A 	return result;							\=0A@@ -110,8 +110,8 @@ __LL_SC_EXPORT(atomic_fe=
tch_##op##name);=0A 	ATOMIC_FETCH_OP (_acquire,        , a,  , "memory", __=
VA_ARGS__)\=0A 	ATOMIC_FETCH_OP (_release,        ,  , l, "memory", __VA_AR=
GS__)=0A =0A-ATOMIC_OPS(add, add)=0A-ATOMIC_OPS(sub, sub)=0A+ATOMIC_OPS(add=
, add, I)=0A+ATOMIC_OPS(sub, sub, J)=0A =0A #undef ATOMIC_OPS=0A #define AT=
OMIC_OPS(...)							\=0A@@ -121,17 +121,17 @@ ATOMIC_OPS(sub, sub)=0A 	ATOM=
IC_FETCH_OP (_acquire,        , a,  , "memory", __VA_ARGS__)\=0A 	ATOMIC_FE=
TCH_OP (_release,        ,  , l, "memory", __VA_ARGS__)=0A =0A-ATOMIC_OPS(a=
nd, and)=0A-ATOMIC_OPS(andnot, bic)=0A-ATOMIC_OPS(or, orr)=0A-ATOMIC_OPS(xo=
r, eor)=0A+ATOMIC_OPS(and, and, )=0A+ATOMIC_OPS(andnot, bic, )=0A+ATOMIC_OP=
S(or, orr, )=0A+ATOMIC_OPS(xor, eor, )=0A =0A #undef ATOMIC_OPS=0A #undef A=
TOMIC_FETCH_OP=0A #undef ATOMIC_OP_RETURN=0A #undef ATOMIC_OP=0A =0A-#defin=
e ATOMIC64_OP(op, asm_op)						\=0A+#define ATOMIC64_OP(op, asm_op, constra=
int)				\=0A __LL_SC_INLINE void							\=0A __LL_SC_PREFIX(atomic64_##op(lo=
ng i, atomic64_t *v))			\=0A {									\=0A@@ -145,11 +145,11 @@ __LL_SC_PR=
EFIX(atomic64_##op(long i, atomic64_t *v))			\=0A "	stxr	%w1, %0, %2\n"				=
		\=0A "	cbnz	%w1, 1b"						\=0A 	: "=3D&r" (result), "=3D&r" (tmp), "+Q" (=
v->counter)		\=0A-	: "Ir" (i));							\=0A+	: #constraint "r" (i));						\=
=0A }									\=0A __LL_SC_EXPORT(atomic64_##op);=0A =0A-#define ATOMIC64_O=
P_RETURN(name, mb, acq, rel, cl, op, asm_op)		\=0A+#define ATOMIC64_OP_RETU=
RN(name, mb, acq, rel, cl, op, asm_op, constraint)\=0A __LL_SC_INLINE long	=
						\=0A __LL_SC_PREFIX(atomic64_##op##_return##name(long i, atomic64_t *=
v))	\=0A {									\=0A@@ -164,14 +164,14 @@ __LL_SC_PREFIX(atomic64_##op##=
_return##name(long i, atomic64_t *v))	\=0A "	cbnz	%w1, 1b\n"						\=0A "	" =
#mb								\=0A 	: "=3D&r" (result), "=3D&r" (tmp), "+Q" (v->counter)		\=0A=
-	: "Ir" (i)							\=0A+	: #constraint "r" (i)						\=0A 	: cl);								\=
=0A 									\=0A 	return result;							\=0A }									\=0A __LL_SC_EXPORT(=
atomic64_##op##_return##name);=0A =0A-#define ATOMIC64_FETCH_OP(name, mb, a=
cq, rel, cl, op, asm_op)		\=0A+#define ATOMIC64_FETCH_OP(name, mb, acq, rel=
, cl, op, asm_op, constraint)\=0A __LL_SC_INLINE long							\=0A __LL_SC_PR=
EFIX(atomic64_fetch_##op##name(long i, atomic64_t *v))	\=0A {									\=0A@=
@ -186,7 +186,7 @@ __LL_SC_PREFIX(atomic64_fetch_##op##name(long i, atomic6=
4_t *v))	\=0A "	cbnz	%w2, 1b\n"						\=0A "	" #mb								\=0A 	: "=3D&r" (r=
esult), "=3D&r" (val), "=3D&r" (tmp), "+Q" (v->counter)	\=0A-	: "Ir" (i)			=
				\=0A+	: #constraint "r" (i)						\=0A 	: cl);								\=0A 									\=0A=
 	return result;							\=0A@@ -204,8 +204,8 @@ __LL_SC_EXPORT(atomic64_fetc=
h_##op##name);=0A 	ATOMIC64_FETCH_OP (_acquire,, a,  , "memory", __VA_ARGS_=
_)	\=0A 	ATOMIC64_FETCH_OP (_release,,  , l, "memory", __VA_ARGS__)=0A =0A-=
ATOMIC64_OPS(add, add)=0A-ATOMIC64_OPS(sub, sub)=0A+ATOMIC64_OPS(add, add, =
I)=0A+ATOMIC64_OPS(sub, sub, J)=0A =0A #undef ATOMIC64_OPS=0A #define ATOMI=
C64_OPS(...)						\=0A@@ -215,10 +215,10 @@ ATOMIC64_OPS(sub, sub)=0A 	ATOM=
IC64_FETCH_OP (_acquire,, a,  , "memory", __VA_ARGS__)	\=0A 	ATOMIC64_FETCH=
_OP (_release,,  , l, "memory", __VA_ARGS__)=0A =0A-ATOMIC64_OPS(and, and)=
=0A-ATOMIC64_OPS(andnot, bic)=0A-ATOMIC64_OPS(or, orr)=0A-ATOMIC64_OPS(xor,=
 eor)=0A+ATOMIC64_OPS(and, and, L)=0A+ATOMIC64_OPS(andnot, bic, )=0A+ATOMIC=
64_OPS(or, orr, L)=0A+ATOMIC64_OPS(xor, eor, L)=0A =0A #undef ATOMIC64_OPS=
=0A #undef ATOMIC64_FETCH_OP=0A@@ -248,7 +248,7 @@ __LL_SC_PREFIX(atomic64_=
dec_if_positive(atomic64_t *v))=0A }=0A __LL_SC_EXPORT(atomic64_dec_if_posi=
tive);=0A =0A-#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl)		\=
=0A+#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl, constraint)	=
\=0A __LL_SC_INLINE u##sz							\=0A __LL_SC_PREFIX(__cmpxchg_case_##name##=
sz(volatile void *ptr,		\=0A 					 unsigned long old,		\=0A@@ -268,29 +268,=
34 @@ __LL_SC_PREFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		\=0A 	"=
2:"								\=0A 	: [tmp] "=3D&r" (tmp), [oldval] "=3D&r" (oldval),			\=0A 	=
  [v] "+Q" (*(u##sz *)ptr)					\=0A-	: [old] "Kr" (old), [new] "r" (new)			=
	\=0A+	: [old] #constraint "r" (old), [new] "r" (new)			\=0A 	: cl);							=
	\=0A 									\=0A 	return oldval;							\=0A }									\=0A __LL_SC_EXPOR=
T(__cmpxchg_case_##name##sz);=0A =0A-__CMPXCHG_CASE(w, b,     ,  8,        =
,  ,  ,         )=0A-__CMPXCHG_CASE(w, h,     , 16,        ,  ,  ,         =
)=0A-__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  ,         )=0A-__CMPXCHG_C=
ASE( ,  ,     , 64,        ,  ,  ,         )=0A-__CMPXCHG_CASE(w, b, acq_, =
 8,        , a,  , "memory")=0A-__CMPXCHG_CASE(w, h, acq_, 16,        , a, =
 , "memory")=0A-__CMPXCHG_CASE(w,  , acq_, 32,        , a,  , "memory")=0A-=
__CMPXCHG_CASE( ,  , acq_, 64,        , a,  , "memory")=0A-__CMPXCHG_CASE(w=
, b, rel_,  8,        ,  , l, "memory")=0A-__CMPXCHG_CASE(w, h, rel_, 16,  =
      ,  , l, "memory")=0A-__CMPXCHG_CASE(w,  , rel_, 32,        ,  , l, "m=
emory")=0A-__CMPXCHG_CASE( ,  , rel_, 64,        ,  , l, "memory")=0A-__CMP=
XCHG_CASE(w, b,  mb_,  8, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE(w, h, =
 mb_, 16, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE(w,  ,  mb_, 32, dmb is=
h,  , l, "memory")=0A-__CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory=
")=0A+/*=0A+ * Earlier versions of GCC (no later than 8.1.0) appear to inco=
rrectly=0A+ * handle the 'K' constraint for the value 4294967295 - thus we =
use no=0A+ * constraint for 32 bit operations.=0A+ */=0A+__CMPXCHG_CASE(w, =
b,     ,  8,        ,  ,  ,         , )=0A+__CMPXCHG_CASE(w, h,     , 16,  =
      ,  ,  ,         , )=0A+__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  , =
        , )=0A+__CMPXCHG_CASE( ,  ,     , 64,        ,  ,  ,         , L)=
=0A+__CMPXCHG_CASE(w, b, acq_,  8,        , a,  , "memory", )=0A+__CMPXCHG_=
CASE(w, h, acq_, 16,        , a,  , "memory", )=0A+__CMPXCHG_CASE(w,  , acq=
_, 32,        , a,  , "memory", )=0A+__CMPXCHG_CASE( ,  , acq_, 64,        =
, a,  , "memory", L)=0A+__CMPXCHG_CASE(w, b, rel_,  8,        ,  , l, "memo=
ry", )=0A+__CMPXCHG_CASE(w, h, rel_, 16,        ,  , l, "memory", )=0A+__CM=
PXCHG_CASE(w,  , rel_, 32,        ,  , l, "memory", )=0A+__CMPXCHG_CASE( , =
 , rel_, 64,        ,  , l, "memory", L)=0A+__CMPXCHG_CASE(w, b,  mb_,  8, =
dmb ish,  , l, "memory", )=0A+__CMPXCHG_CASE(w, h,  mb_, 16, dmb ish,  , l,=
 "memory", )=0A+__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish,  , l, "memory", )=
=0A+__CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory", L)=0A =0A #unde=
f __CMPXCHG_CASE=0A =0A
--78nhM7UyumR5M09q
Content-Type: application/mbox
Content-Disposition: attachment; filename="arm64-atomic-4.14.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 66913a2af8fdb41ed6beecd68a5a7e0185e52b63 Mon Sep 17 00:00:00 2001=0A=
=46rom: Will Deacon <will.deacon@arm.com>=0ADate: Thu, 13 Sep 2018 13:30:45=
 +0100=0ASubject: [PATCH 1/3] arm64: Avoid redundant type conversions in xc=
hg() and=0A cmpxchg()=0A=0Acommit 5ef3fe4cecdf82fdd71ce78988403963d01444d4 =
upstream.=0A=0AOur atomic instructions (either LSE atomics of LDXR/STXR seq=
uences)=0Anatively support byte, half-word, word and double-word memory acc=
esses=0Aso there is no need to mask the data register prior to being stored=
=2E=0A=0ASigned-off-by: Will Deacon <will.deacon@arm.com>=0ASigned-off-by: =
Ben Hutchings <ben@decadent.org.uk>=0A---=0A arch/arm64/include/asm/atomic_=
ll_sc.h |  53 ++++++------=0A arch/arm64/include/asm/atomic_lse.h   |  46 +=
++++-----=0A arch/arm64/include/asm/cmpxchg.h      | 116 +++++++++++++-----=
--------=0A 3 files changed, 108 insertions(+), 107 deletions(-)=0A=0Adiff =
--git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atom=
ic_ll_sc.h=0Aindex f5a2d09afb38..f02d3bf7b9e6 100644=0A--- a/arch/arm64/inc=
lude/asm/atomic_ll_sc.h=0A+++ b/arch/arm64/include/asm/atomic_ll_sc.h=0A@@ =
-248,48 +248,49 @@ __LL_SC_PREFIX(atomic64_dec_if_positive(atomic64_t *v))=
=0A }=0A __LL_SC_EXPORT(atomic64_dec_if_positive);=0A =0A-#define __CMPXCHG=
_CASE(w, sz, name, mb, acq, rel, cl)			\=0A-__LL_SC_INLINE unsigned long			=
			\=0A-__LL_SC_PREFIX(__cmpxchg_case_##name(volatile void *ptr,		\=0A-				=
     unsigned long old,			\=0A-				     unsigned long new))		\=0A+#define _=
_CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl)		\=0A+__LL_SC_INLINE u##s=
z							\=0A+__LL_SC_PREFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		=
\=0A+					 unsigned long old,		\=0A+					 u##sz new))			\=0A {									\=0A=
-	unsigned long tmp, oldval;					\=0A+	unsigned long tmp;						\=0A+	u##sz =
oldval;							\=0A 									\=0A 	asm volatile(							\=0A 	"	prfm	pstl1str=
m, %[v]\n"				\=0A-	"1:	ld" #acq "xr" #sz "\t%" #w "[oldval], %[v]\n"		\=0A=
+	"1:	ld" #acq "xr" #sfx "\t%" #w "[oldval], %[v]\n"		\=0A 	"	eor	%" #w "[t=
mp], %" #w "[oldval], %" #w "[old]\n"	\=0A 	"	cbnz	%" #w "[tmp], 2f\n"				\=
=0A-	"	st" #rel "xr" #sz "\t%w[tmp], %" #w "[new], %[v]\n"	\=0A+	"	st" #rel=
 "xr" #sfx "\t%w[tmp], %" #w "[new], %[v]\n"	\=0A 	"	cbnz	%w[tmp], 1b\n"			=
		\=0A 	"	" #mb "\n"						\=0A 	"2:"								\=0A 	: [tmp] "=3D&r" (tmp), [o=
ldval] "=3D&r" (oldval),			\=0A-	  [v] "+Q" (*(unsigned long *)ptr)				\=0A=
+	  [v] "+Q" (*(u##sz *)ptr)					\=0A 	: [old] "Lr" (old), [new] "r" (new)	=
			\=0A 	: cl);								\=0A 									\=0A 	return oldval;							\=0A }					=
				\=0A-__LL_SC_EXPORT(__cmpxchg_case_##name);=0A+__LL_SC_EXPORT(__cmpxchg=
_case_##name##sz);=0A =0A-__CMPXCHG_CASE(w, b,     1,        ,  ,  ,       =
  )=0A-__CMPXCHG_CASE(w, h,     2,        ,  ,  ,         )=0A-__CMPXCHG_CA=
SE(w,  ,     4,        ,  ,  ,         )=0A-__CMPXCHG_CASE( ,  ,     8,    =
    ,  ,  ,         )=0A-__CMPXCHG_CASE(w, b, acq_1,        , a,  , "memory=
")=0A-__CMPXCHG_CASE(w, h, acq_2,        , a,  , "memory")=0A-__CMPXCHG_CAS=
E(w,  , acq_4,        , a,  , "memory")=0A-__CMPXCHG_CASE( ,  , acq_8,     =
   , a,  , "memory")=0A-__CMPXCHG_CASE(w, b, rel_1,        ,  , l, "memory"=
)=0A-__CMPXCHG_CASE(w, h, rel_2,        ,  , l, "memory")=0A-__CMPXCHG_CASE=
(w,  , rel_4,        ,  , l, "memory")=0A-__CMPXCHG_CASE( ,  , rel_8,      =
  ,  , l, "memory")=0A-__CMPXCHG_CASE(w, b,  mb_1, dmb ish,  , l, "memory")=
=0A-__CMPXCHG_CASE(w, h,  mb_2, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE(=
w,  ,  mb_4, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE( ,  ,  mb_8, dmb is=
h,  , l, "memory")=0A+__CMPXCHG_CASE(w, b,     ,  8,        ,  ,  ,        =
 )=0A+__CMPXCHG_CASE(w, h,     , 16,        ,  ,  ,         )=0A+__CMPXCHG_=
CASE(w,  ,     , 32,        ,  ,  ,         )=0A+__CMPXCHG_CASE( ,  ,     ,=
 64,        ,  ,  ,         )=0A+__CMPXCHG_CASE(w, b, acq_,  8,        , a,=
  , "memory")=0A+__CMPXCHG_CASE(w, h, acq_, 16,        , a,  , "memory")=0A=
+__CMPXCHG_CASE(w,  , acq_, 32,        , a,  , "memory")=0A+__CMPXCHG_CASE(=
 ,  , acq_, 64,        , a,  , "memory")=0A+__CMPXCHG_CASE(w, b, rel_,  8, =
       ,  , l, "memory")=0A+__CMPXCHG_CASE(w, h, rel_, 16,        ,  , l, "=
memory")=0A+__CMPXCHG_CASE(w,  , rel_, 32,        ,  , l, "memory")=0A+__CM=
PXCHG_CASE( ,  , rel_, 64,        ,  , l, "memory")=0A+__CMPXCHG_CASE(w, b,=
  mb_,  8, dmb ish,  , l, "memory")=0A+__CMPXCHG_CASE(w, h,  mb_, 16, dmb i=
sh,  , l, "memory")=0A+__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish,  , l, "memor=
y")=0A+__CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory")=0A =0A #unde=
f __CMPXCHG_CASE=0A =0Adiff --git a/arch/arm64/include/asm/atomic_lse.h b/a=
rch/arm64/include/asm/atomic_lse.h=0Aindex f9b0b09153e0..4d6f917b654e 10064=
4=0A--- a/arch/arm64/include/asm/atomic_lse.h=0A+++ b/arch/arm64/include/as=
m/atomic_lse.h=0A@@ -446,22 +446,22 @@ static inline long atomic64_dec_if_p=
ositive(atomic64_t *v)=0A =0A #define __LL_SC_CMPXCHG(op)	__LL_SC_CALL(__cm=
pxchg_case_##op)=0A =0A-#define __CMPXCHG_CASE(w, sz, name, mb, cl...)				\=
=0A-static inline unsigned long __cmpxchg_case_##name(volatile void *ptr,	\=
=0A-						  unsigned long old,	\=0A-						  unsigned long new)	\=0A+#define=
 __CMPXCHG_CASE(w, sfx, name, sz, mb, cl...)			\=0A+static inline u##sz __c=
mpxchg_case_##name##sz(volatile void *ptr,	\=0A+					      unsigned long ol=
d,	\=0A+					      u##sz new)		\=0A {									\=0A 	register unsigned long =
x0 asm ("x0") =3D (unsigned long)ptr;	\=0A 	register unsigned long x1 asm (=
"x1") =3D old;			\=0A-	register unsigned long x2 asm ("x2") =3D new;			\=0A=
+	register u##sz x2 asm ("x2") =3D new;				\=0A 									\=0A 	asm volatile=
(ARM64_LSE_ATOMIC_INSN(				\=0A 	/* LL/SC */							\=0A-	__LL_SC_CMPXCHG(na=
me)						\=0A+	__LL_SC_CMPXCHG(name##sz)					\=0A 	__nops(2),							\=0A 	/=
* LSE atomics */						\=0A 	"	mov	" #w "30, %" #w "[old]\n"			\=0A-	"	cas" =
#mb #sz "\t" #w "30, %" #w "[new], %[v]\n"		\=0A+	"	cas" #mb #sfx "\t" #w "=
30, %" #w "[new], %[v]\n"	\=0A 	"	mov	%" #w "[ret], " #w "30")			\=0A 	: [r=
et] "+r" (x0), [v] "+Q" (*(unsigned long *)ptr)		\=0A 	: [old] "r" (x1), [n=
ew] "r" (x2)				\=0A@@ -470,22 +470,22 @@ static inline unsigned long __cmp=
xchg_case_##name(volatile void *ptr,	\=0A 	return x0;							\=0A }=0A =0A-_=
_CMPXCHG_CASE(w, b,     1,   )=0A-__CMPXCHG_CASE(w, h,     2,   )=0A-__CMPX=
CHG_CASE(w,  ,     4,   )=0A-__CMPXCHG_CASE(x,  ,     8,   )=0A-__CMPXCHG_C=
ASE(w, b, acq_1,  a, "memory")=0A-__CMPXCHG_CASE(w, h, acq_2,  a, "memory")=
=0A-__CMPXCHG_CASE(w,  , acq_4,  a, "memory")=0A-__CMPXCHG_CASE(x,  , acq_8=
,  a, "memory")=0A-__CMPXCHG_CASE(w, b, rel_1,  l, "memory")=0A-__CMPXCHG_C=
ASE(w, h, rel_2,  l, "memory")=0A-__CMPXCHG_CASE(w,  , rel_4,  l, "memory")=
=0A-__CMPXCHG_CASE(x,  , rel_8,  l, "memory")=0A-__CMPXCHG_CASE(w, b,  mb_1=
, al, "memory")=0A-__CMPXCHG_CASE(w, h,  mb_2, al, "memory")=0A-__CMPXCHG_C=
ASE(w,  ,  mb_4, al, "memory")=0A-__CMPXCHG_CASE(x,  ,  mb_8, al, "memory")=
=0A+__CMPXCHG_CASE(w, b,     ,  8,   )=0A+__CMPXCHG_CASE(w, h,     , 16,   =
)=0A+__CMPXCHG_CASE(w,  ,     , 32,   )=0A+__CMPXCHG_CASE(x,  ,     , 64,  =
 )=0A+__CMPXCHG_CASE(w, b, acq_,  8,  a, "memory")=0A+__CMPXCHG_CASE(w, h, =
acq_, 16,  a, "memory")=0A+__CMPXCHG_CASE(w,  , acq_, 32,  a, "memory")=0A+=
__CMPXCHG_CASE(x,  , acq_, 64,  a, "memory")=0A+__CMPXCHG_CASE(w, b, rel_, =
 8,  l, "memory")=0A+__CMPXCHG_CASE(w, h, rel_, 16,  l, "memory")=0A+__CMPX=
CHG_CASE(w,  , rel_, 32,  l, "memory")=0A+__CMPXCHG_CASE(x,  , rel_, 64,  l=
, "memory")=0A+__CMPXCHG_CASE(w, b,  mb_,  8, al, "memory")=0A+__CMPXCHG_CA=
SE(w, h,  mb_, 16, al, "memory")=0A+__CMPXCHG_CASE(w,  ,  mb_, 32, al, "mem=
ory")=0A+__CMPXCHG_CASE(x,  ,  mb_, 64, al, "memory")=0A =0A #undef __LL_SC=
_CMPXCHG=0A #undef __CMPXCHG_CASE=0Adiff --git a/arch/arm64/include/asm/cmp=
xchg.h b/arch/arm64/include/asm/cmpxchg.h=0Aindex 9b2e2e2e728a..ed6a1aae6fb=
b 100644=0A--- a/arch/arm64/include/asm/cmpxchg.h=0A+++ b/arch/arm64/includ=
e/asm/cmpxchg.h=0A@@ -29,46 +29,46 @@=0A  * barrier case is generated as re=
lease+dmb for the former and=0A  * acquire+release for the latter.=0A  */=
=0A-#define __XCHG_CASE(w, sz, name, mb, nop_lse, acq, acq_lse, rel, cl)	\=
=0A-static inline unsigned long __xchg_case_##name(unsigned long x,		\=0A-	=
				       volatile void *ptr)	\=0A-{									\=0A-	unsigned long ret, tmp;=
						\=0A-									\=0A-	asm volatile(ARM64_LSE_ATOMIC_INSN(				\=0A-	/* L=
L/SC */							\=0A-	"	prfm	pstl1strm, %2\n"				\=0A-	"1:	ld" #acq "xr" #sz =
"\t%" #w "0, %2\n"			\=0A-	"	st" #rel "xr" #sz "\t%w1, %" #w "3, %2\n"		\=
=0A-	"	cbnz	%w1, 1b\n"					\=0A-	"	" #mb,							\=0A-	/* LSE atomics */				=
		\=0A-	"	swp" #acq_lse #rel #sz "\t%" #w "3, %" #w "0, %2\n"	\=0A-		__nops=
(3)						\=0A-	"	" #nop_lse)						\=0A-	: "=3D&r" (ret), "=3D&r" (tmp), "+Q=
" (*(unsigned long *)ptr)	\=0A-	: "r" (x)							\=0A-	: cl);								\=0A-		=
							\=0A-	return ret;							\=0A+#define __XCHG_CASE(w, sfx, name, sz, m=
b, nop_lse, acq, acq_lse, rel, cl)	\=0A+static inline u##sz __xchg_case_##n=
ame##sz(u##sz x, volatile void *ptr)		\=0A+{										\=0A+	u##sz ret;					=
			\=0A+	unsigned long tmp;							\=0A+										\=0A+	asm volatile(ARM64_L=
SE_ATOMIC_INSN(					\=0A+	/* LL/SC */								\=0A+	"	prfm	pstl1strm, %2\n"	=
				\=0A+	"1:	ld" #acq "xr" #sfx "\t%" #w "0, %2\n"				\=0A+	"	st" #rel "xr=
" #sfx "\t%w1, %" #w "3, %2\n"			\=0A+	"	cbnz	%w1, 1b\n"						\=0A+	"	" #mb=
,								\=0A+	/* LSE atomics */							\=0A+	"	swp" #acq_lse #rel #sfx "\t%=
" #w "3, %" #w "0, %2\n"		\=0A+		__nops(3)							\=0A+	"	" #nop_lse)							=
\=0A+	: "=3D&r" (ret), "=3D&r" (tmp), "+Q" (*(u##sz *)ptr)			\=0A+	: "r" (x=
)								\=0A+	: cl);									\=0A+										\=0A+	return ret;								\=0A =
}=0A =0A-__XCHG_CASE(w, b,     1,        ,    ,  ,  ,  ,         )=0A-__XCH=
G_CASE(w, h,     2,        ,    ,  ,  ,  ,         )=0A-__XCHG_CASE(w,  ,  =
   4,        ,    ,  ,  ,  ,         )=0A-__XCHG_CASE( ,  ,     8,        ,=
    ,  ,  ,  ,         )=0A-__XCHG_CASE(w, b, acq_1,        ,    , a, a,  ,=
 "memory")=0A-__XCHG_CASE(w, h, acq_2,        ,    , a, a,  , "memory")=0A-=
__XCHG_CASE(w,  , acq_4,        ,    , a, a,  , "memory")=0A-__XCHG_CASE( ,=
  , acq_8,        ,    , a, a,  , "memory")=0A-__XCHG_CASE(w, b, rel_1,    =
    ,    ,  ,  , l, "memory")=0A-__XCHG_CASE(w, h, rel_2,        ,    ,  , =
 , l, "memory")=0A-__XCHG_CASE(w,  , rel_4,        ,    ,  ,  , l, "memory"=
)=0A-__XCHG_CASE( ,  , rel_8,        ,    ,  ,  , l, "memory")=0A-__XCHG_CA=
SE(w, b,  mb_1, dmb ish, nop,  , a, l, "memory")=0A-__XCHG_CASE(w, h,  mb_2=
, dmb ish, nop,  , a, l, "memory")=0A-__XCHG_CASE(w,  ,  mb_4, dmb ish, nop=
,  , a, l, "memory")=0A-__XCHG_CASE( ,  ,  mb_8, dmb ish, nop,  , a, l, "me=
mory")=0A+__XCHG_CASE(w, b,     ,  8,        ,    ,  ,  ,  ,         )=0A+_=
_XCHG_CASE(w, h,     , 16,        ,    ,  ,  ,  ,         )=0A+__XCHG_CASE(=
w,  ,     , 32,        ,    ,  ,  ,  ,         )=0A+__XCHG_CASE( ,  ,     ,=
 64,        ,    ,  ,  ,  ,         )=0A+__XCHG_CASE(w, b, acq_,  8,       =
 ,    , a, a,  , "memory")=0A+__XCHG_CASE(w, h, acq_, 16,        ,    , a, =
a,  , "memory")=0A+__XCHG_CASE(w,  , acq_, 32,        ,    , a, a,  , "memo=
ry")=0A+__XCHG_CASE( ,  , acq_, 64,        ,    , a, a,  , "memory")=0A+__X=
CHG_CASE(w, b, rel_,  8,        ,    ,  ,  , l, "memory")=0A+__XCHG_CASE(w,=
 h, rel_, 16,        ,    ,  ,  , l, "memory")=0A+__XCHG_CASE(w,  , rel_, 3=
2,        ,    ,  ,  , l, "memory")=0A+__XCHG_CASE( ,  , rel_, 64,        ,=
    ,  ,  , l, "memory")=0A+__XCHG_CASE(w, b,  mb_,  8, dmb ish, nop,  , a,=
 l, "memory")=0A+__XCHG_CASE(w, h,  mb_, 16, dmb ish, nop,  , a, l, "memory=
")=0A+__XCHG_CASE(w,  ,  mb_, 32, dmb ish, nop,  , a, l, "memory")=0A+__XCH=
G_CASE( ,  ,  mb_, 64, dmb ish, nop,  , a, l, "memory")=0A =0A #undef __XCH=
G_CASE=0A =0A@@ -79,13 +79,13 @@ static __always_inline  unsigned long __xc=
hg##sfx(unsigned long x,	\=0A {									\=0A 	switch (size) {							\=0A 	c=
ase 1:								\=0A-		return __xchg_case##sfx##_1(x, ptr);			\=0A+		return _=
_xchg_case##sfx##_8(x, ptr);			\=0A 	case 2:								\=0A-		return __xchg_ca=
se##sfx##_2(x, ptr);			\=0A+		return __xchg_case##sfx##_16(x, ptr);			\=0A =
	case 4:								\=0A-		return __xchg_case##sfx##_4(x, ptr);			\=0A+		return=
 __xchg_case##sfx##_32(x, ptr);			\=0A 	case 8:								\=0A-		return __xchg=
_case##sfx##_8(x, ptr);			\=0A+		return __xchg_case##sfx##_64(x, ptr);			\=
=0A 	default:							\=0A 		BUILD_BUG();						\=0A 	}								\=0A@@ -122,13 =
+122,13 @@ static __always_inline unsigned long __cmpxchg##sfx(volatile voi=
d *ptr,	\=0A {									\=0A 	switch (size) {							\=0A 	case 1:								\=
=0A-		return __cmpxchg_case##sfx##_1(ptr, (u8)old, new);	\=0A+		return __cm=
pxchg_case##sfx##_8(ptr, (u8)old, new);	\=0A 	case 2:								\=0A-		return =
__cmpxchg_case##sfx##_2(ptr, (u16)old, new);	\=0A+		return __cmpxchg_case##=
sfx##_16(ptr, (u16)old, new);	\=0A 	case 4:								\=0A-		return __cmpxchg_=
case##sfx##_4(ptr, old, new);		\=0A+		return __cmpxchg_case##sfx##_32(ptr, =
old, new);		\=0A 	case 8:								\=0A-		return __cmpxchg_case##sfx##_8(ptr,=
 old, new);		\=0A+		return __cmpxchg_case##sfx##_64(ptr, old, new);		\=0A 	=
default:							\=0A 		BUILD_BUG();						\=0A 	}								\=0A@@ -222,16 +222,=
16 @@ __CMPXCHG_GEN(_mb)=0A 	__ret;								\=0A })=0A =0A-#define __CMPWAIT=
_CASE(w, sz, name)					\=0A-static inline void __cmpwait_case_##name(volati=
le void *ptr,		\=0A-					 unsigned long val)		\=0A+#define __CMPWAIT_CASE(w=
, sfx, sz)					\=0A+static inline void __cmpwait_case_##sz(volatile void *p=
tr,		\=0A+				       unsigned long val)		\=0A {									\=0A 	unsigned long=
 tmp;						\=0A 									\=0A 	asm volatile(							\=0A 	"	sevl\n"							\=
=0A 	"	wfe\n"							\=0A-	"	ldxr" #sz "\t%" #w "[tmp], %[v]\n"			\=0A+	"	ld=
xr" #sfx "\t%" #w "[tmp], %[v]\n"			\=0A 	"	eor	%" #w "[tmp], %" #w "[tmp],=
 %" #w "[val]\n"	\=0A 	"	cbnz	%" #w "[tmp], 1f\n"				\=0A 	"	wfe\n"							\=
=0A@@ -240,10 +240,10 @@ static inline void __cmpwait_case_##name(volatile =
void *ptr,		\=0A 	: [val] "r" (val));						\=0A }=0A =0A-__CMPWAIT_CASE(w, =
b, 1);=0A-__CMPWAIT_CASE(w, h, 2);=0A-__CMPWAIT_CASE(w,  , 4);=0A-__CMPWAIT=
_CASE( ,  , 8);=0A+__CMPWAIT_CASE(w, b, 8);=0A+__CMPWAIT_CASE(w, h, 16);=0A=
+__CMPWAIT_CASE(w,  , 32);=0A+__CMPWAIT_CASE( ,  , 64);=0A =0A #undef __CMP=
WAIT_CASE=0A =0A@@ -254,13 +254,13 @@ static __always_inline void __cmpwait=
##sfx(volatile void *ptr,		\=0A {									\=0A 	switch (size) {							\=0A =
	case 1:								\=0A-		return __cmpwait_case##sfx##_1(ptr, (u8)val);		\=0A+=
		return __cmpwait_case##sfx##_8(ptr, (u8)val);		\=0A 	case 2:								\=0A-=
		return __cmpwait_case##sfx##_2(ptr, (u16)val);		\=0A+		return __cmpwait_c=
ase##sfx##_16(ptr, (u16)val);		\=0A 	case 4:								\=0A-		return __cmpwait=
_case##sfx##_4(ptr, val);		\=0A+		return __cmpwait_case##sfx##_32(ptr, val)=
;		\=0A 	case 8:								\=0A-		return __cmpwait_case##sfx##_8(ptr, val);		\=
=0A+		return __cmpwait_case##sfx##_64(ptr, val);		\=0A 	default:							\=0A=
 		BUILD_BUG();						\=0A 	}								\=0A=0AFrom fe09ab5810b1d9475154ff5d583=
fce77db6004c2 Mon Sep 17 00:00:00 2001=0AFrom: Will Deacon <will.deacon@arm=
=2Ecom>=0ADate: Tue, 18 Sep 2018 09:39:55 +0100=0ASubject: [PATCH 2/3] arm6=
4: cmpxchg: Use "K" instead of "L" for ll/sc=0A immediate constraint=0A=0Ac=
ommit 4230509978f2921182da4e9197964dccdbe463c3 upstream.=0A=0AThe "L" AArch=
64 machine constraint, which we use for the "old" value in=0Aan LL/SC cmpxc=
hg(), generates an immediate that is suitable for a 64-bit=0Alogical instru=
ction. However, for cmpxchg() operations on types smaller=0Athan 64 bits, t=
his constraint can result in an invalid instruction which=0Ais correctly re=
jected by GAS, such as EOR W1, W1, #0xffffffff.=0A=0AWhilst we could specia=
l-case the constraint based on the cmpxchg size,=0Ait's far easier to chang=
e the constraint to "K" and put up with using=0Aa register for large 64-bit=
 immediates. For out-of-line LL/SC atomics,=0Athis is all moot anyway.=0A=
=0AReported-by: Robin Murphy <robin.murphy@arm.com>=0ASigned-off-by: Will D=
eacon <will.deacon@arm.com>=0ASigned-off-by: Ben Hutchings <ben@decadent.or=
g.uk>=0A---=0A arch/arm64/include/asm/atomic_ll_sc.h | 2 +-=0A 1 file chang=
ed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/arch/arm64/include/asm/=
atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h=0Aindex f02d3bf7b9e6=
=2E.fb841553b0b0 100644=0A--- a/arch/arm64/include/asm/atomic_ll_sc.h=0A+++=
 b/arch/arm64/include/asm/atomic_ll_sc.h=0A@@ -268,7 +268,7 @@ __LL_SC_PREF=
IX(__cmpxchg_case_##name##sz(volatile void *ptr,		\=0A 	"2:"								\=0A 	:=
 [tmp] "=3D&r" (tmp), [oldval] "=3D&r" (oldval),			\=0A 	  [v] "+Q" (*(u##s=
z *)ptr)					\=0A-	: [old] "Lr" (old), [new] "r" (new)				\=0A+	: [old] "Kr=
" (old), [new] "r" (new)				\=0A 	: cl);								\=0A 									\=0A 	return =
oldval;							\=0A=0AFrom fbcb75b42b48e8acd708954a94eb6d0e9a19edb4 Mon Sep =
17 00:00:00 2001=0AFrom: Andrew Murray <andrew.murray@arm.com>=0ADate: Wed,=
 28 Aug 2019 18:50:06 +0100=0ASubject: [PATCH 3/3] arm64: Use correct ll/sc=
 atomic constraints=0A=0Acommit 580fa1b874711d633f9b145b7777b0e83ebf3787 up=
stream.=0A=0AThe A64 ISA accepts distinct (but overlapping) ranges of immed=
iates for:=0A=0A * add arithmetic instructions ('I' machine constraint)=0A =
* sub arithmetic instructions ('J' machine constraint)=0A * 32-bit logical =
instructions ('K' machine constraint)=0A * 64-bit logical instructions ('L'=
 machine constraint)=0A=0A... but we currently use the 'I' constraint for m=
any atomic operations=0Ausing sub or logical instructions, which is not alw=
ays valid.=0A=0AWhen CONFIG_ARM64_LSE_ATOMICS is not set, this allows inval=
id immediates=0Ato be passed to instructions, potentially resulting in a bu=
ild failure.=0AWhen CONFIG_ARM64_LSE_ATOMICS is selected the out-of-line ll=
/sc atomics=0Aalways use a register as they have no visibility of the value=
 passed by=0Athe caller.=0A=0AThis patch adds a constraint parameter to the=
 ATOMIC_xx and=0A__CMPXCHG_CASE macros so that we can pass appropriate cons=
traints for=0Aeach case, with uses updated accordingly.=0A=0AUnfortunately =
prior to GCC 8.1.0 the 'K' constraint erroneously accepted=0A'4294967295', =
so we must instead force the use of a register.=0A=0ASigned-off-by: Andrew =
Murray <andrew.murray@arm.com>=0ASigned-off-by: Will Deacon <will@kernel.or=
g>=0A[bwh: Backported to 4.14: adjust context]=0ASigned-off-by: Ben Hutchin=
gs <ben@decadent.org.uk>=0A---=0A arch/arm64/include/asm/atomic_ll_sc.h | 8=
9 ++++++++++++++-------------=0A 1 file changed, 47 insertions(+), 42 delet=
ions(-)=0A=0Adiff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm6=
4/include/asm/atomic_ll_sc.h=0Aindex fb841553b0b0..1cc42441bc67 100644=0A--=
- a/arch/arm64/include/asm/atomic_ll_sc.h=0A+++ b/arch/arm64/include/asm/at=
omic_ll_sc.h=0A@@ -37,7 +37,7 @@=0A  * (the optimize attribute silently ign=
ores these options).=0A  */=0A =0A-#define ATOMIC_OP(op, asm_op)						\=0A+=
#define ATOMIC_OP(op, asm_op, constraint)				\=0A __LL_SC_INLINE void						=
	\=0A __LL_SC_PREFIX(atomic_##op(int i, atomic_t *v))				\=0A {									\=
=0A@@ -51,11 +51,11 @@ __LL_SC_PREFIX(atomic_##op(int i, atomic_t *v))				\=
=0A "	stxr	%w1, %w0, %2\n"						\=0A "	cbnz	%w1, 1b"						\=0A 	: "=3D&r" (=
result), "=3D&r" (tmp), "+Q" (v->counter)		\=0A-	: "Ir" (i));							\=0A+	:=
 #constraint "r" (i));						\=0A }									\=0A __LL_SC_EXPORT(atomic_##op)=
;=0A =0A-#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_op)		\=0A=
+#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_op, constraint)\=
=0A __LL_SC_INLINE int							\=0A __LL_SC_PREFIX(atomic_##op##_return##name=
(int i, atomic_t *v))		\=0A {									\=0A@@ -70,14 +70,14 @@ __LL_SC_PREFI=
X(atomic_##op##_return##name(int i, atomic_t *v))		\=0A "	cbnz	%w1, 1b\n"		=
				\=0A "	" #mb								\=0A 	: "=3D&r" (result), "=3D&r" (tmp), "+Q" (v->c=
ounter)		\=0A-	: "Ir" (i)							\=0A+	: #constraint "r" (i)						\=0A 	: cl=
);								\=0A 									\=0A 	return result;							\=0A }									\=0A __LL=
_SC_EXPORT(atomic_##op##_return##name);=0A =0A-#define ATOMIC_FETCH_OP(name=
, mb, acq, rel, cl, op, asm_op)		\=0A+#define ATOMIC_FETCH_OP(name, mb, acq=
, rel, cl, op, asm_op, constraint)	\=0A __LL_SC_INLINE int							\=0A __LL_=
SC_PREFIX(atomic_fetch_##op##name(int i, atomic_t *v))		\=0A {									\=0A=
@@ -92,7 +92,7 @@ __LL_SC_PREFIX(atomic_fetch_##op##name(int i, atomic_t *v=
))		\=0A "	cbnz	%w2, 1b\n"						\=0A "	" #mb								\=0A 	: "=3D&r" (result=
), "=3D&r" (val), "=3D&r" (tmp), "+Q" (v->counter)	\=0A-	: "Ir" (i)							\=
=0A+	: #constraint "r" (i)						\=0A 	: cl);								\=0A 									\=0A 	ret=
urn result;							\=0A@@ -110,8 +110,8 @@ __LL_SC_EXPORT(atomic_fetch_##op#=
#name);=0A 	ATOMIC_FETCH_OP (_acquire,        , a,  , "memory", __VA_ARGS__=
)\=0A 	ATOMIC_FETCH_OP (_release,        ,  , l, "memory", __VA_ARGS__)=0A =
=0A-ATOMIC_OPS(add, add)=0A-ATOMIC_OPS(sub, sub)=0A+ATOMIC_OPS(add, add, I)=
=0A+ATOMIC_OPS(sub, sub, J)=0A =0A #undef ATOMIC_OPS=0A #define ATOMIC_OPS(=
=2E..)							\=0A@@ -121,17 +121,17 @@ ATOMIC_OPS(sub, sub)=0A 	ATOMIC_FETC=
H_OP (_acquire,        , a,  , "memory", __VA_ARGS__)\=0A 	ATOMIC_FETCH_OP =
(_release,        ,  , l, "memory", __VA_ARGS__)=0A =0A-ATOMIC_OPS(and, and=
)=0A-ATOMIC_OPS(andnot, bic)=0A-ATOMIC_OPS(or, orr)=0A-ATOMIC_OPS(xor, eor)=
=0A+ATOMIC_OPS(and, and, )=0A+ATOMIC_OPS(andnot, bic, )=0A+ATOMIC_OPS(or, o=
rr, )=0A+ATOMIC_OPS(xor, eor, )=0A =0A #undef ATOMIC_OPS=0A #undef ATOMIC_F=
ETCH_OP=0A #undef ATOMIC_OP_RETURN=0A #undef ATOMIC_OP=0A =0A-#define ATOMI=
C64_OP(op, asm_op)						\=0A+#define ATOMIC64_OP(op, asm_op, constraint)			=
	\=0A __LL_SC_INLINE void							\=0A __LL_SC_PREFIX(atomic64_##op(long i, a=
tomic64_t *v))			\=0A {									\=0A@@ -145,11 +145,11 @@ __LL_SC_PREFIX(at=
omic64_##op(long i, atomic64_t *v))			\=0A "	stxr	%w1, %0, %2\n"						\=0A =
"	cbnz	%w1, 1b"						\=0A 	: "=3D&r" (result), "=3D&r" (tmp), "+Q" (v->coun=
ter)		\=0A-	: "Ir" (i));							\=0A+	: #constraint "r" (i));						\=0A }			=
						\=0A __LL_SC_EXPORT(atomic64_##op);=0A =0A-#define ATOMIC64_OP_RETURN=
(name, mb, acq, rel, cl, op, asm_op)		\=0A+#define ATOMIC64_OP_RETURN(name,=
 mb, acq, rel, cl, op, asm_op, constraint)\=0A __LL_SC_INLINE long							\=
=0A __LL_SC_PREFIX(atomic64_##op##_return##name(long i, atomic64_t *v))	\=
=0A {									\=0A@@ -164,14 +164,14 @@ __LL_SC_PREFIX(atomic64_##op##_retu=
rn##name(long i, atomic64_t *v))	\=0A "	cbnz	%w1, 1b\n"						\=0A "	" #mb		=
						\=0A 	: "=3D&r" (result), "=3D&r" (tmp), "+Q" (v->counter)		\=0A-	: "=
Ir" (i)							\=0A+	: #constraint "r" (i)						\=0A 	: cl);								\=0A 			=
						\=0A 	return result;							\=0A }									\=0A __LL_SC_EXPORT(atomic6=
4_##op##_return##name);=0A =0A-#define ATOMIC64_FETCH_OP(name, mb, acq, rel=
, cl, op, asm_op)		\=0A+#define ATOMIC64_FETCH_OP(name, mb, acq, rel, cl, o=
p, asm_op, constraint)\=0A __LL_SC_INLINE long							\=0A __LL_SC_PREFIX(at=
omic64_fetch_##op##name(long i, atomic64_t *v))	\=0A {									\=0A@@ -186,=
7 +186,7 @@ __LL_SC_PREFIX(atomic64_fetch_##op##name(long i, atomic64_t *v)=
)	\=0A "	cbnz	%w2, 1b\n"						\=0A "	" #mb								\=0A 	: "=3D&r" (result),=
 "=3D&r" (val), "=3D&r" (tmp), "+Q" (v->counter)	\=0A-	: "Ir" (i)							\=
=0A+	: #constraint "r" (i)						\=0A 	: cl);								\=0A 									\=0A 	ret=
urn result;							\=0A@@ -204,8 +204,8 @@ __LL_SC_EXPORT(atomic64_fetch_##o=
p##name);=0A 	ATOMIC64_FETCH_OP (_acquire,, a,  , "memory", __VA_ARGS__)	\=
=0A 	ATOMIC64_FETCH_OP (_release,,  , l, "memory", __VA_ARGS__)=0A =0A-ATOM=
IC64_OPS(add, add)=0A-ATOMIC64_OPS(sub, sub)=0A+ATOMIC64_OPS(add, add, I)=
=0A+ATOMIC64_OPS(sub, sub, J)=0A =0A #undef ATOMIC64_OPS=0A #define ATOMIC6=
4_OPS(...)						\=0A@@ -215,10 +215,10 @@ ATOMIC64_OPS(sub, sub)=0A 	ATOMIC=
64_FETCH_OP (_acquire,, a,  , "memory", __VA_ARGS__)	\=0A 	ATOMIC64_FETCH_O=
P (_release,,  , l, "memory", __VA_ARGS__)=0A =0A-ATOMIC64_OPS(and, and)=0A=
-ATOMIC64_OPS(andnot, bic)=0A-ATOMIC64_OPS(or, orr)=0A-ATOMIC64_OPS(xor, eo=
r)=0A+ATOMIC64_OPS(and, and, L)=0A+ATOMIC64_OPS(andnot, bic, )=0A+ATOMIC64_=
OPS(or, orr, L)=0A+ATOMIC64_OPS(xor, eor, L)=0A =0A #undef ATOMIC64_OPS=0A =
#undef ATOMIC64_FETCH_OP=0A@@ -248,7 +248,7 @@ __LL_SC_PREFIX(atomic64_dec_=
if_positive(atomic64_t *v))=0A }=0A __LL_SC_EXPORT(atomic64_dec_if_positive=
);=0A =0A-#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl)		\=0A+=
#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl, constraint)	\=0A=
 __LL_SC_INLINE u##sz							\=0A __LL_SC_PREFIX(__cmpxchg_case_##name##sz(v=
olatile void *ptr,		\=0A 					 unsigned long old,		\=0A@@ -268,29 +268,34 @=
@ __LL_SC_PREFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		\=0A 	"2:"	=
							\=0A 	: [tmp] "=3D&r" (tmp), [oldval] "=3D&r" (oldval),			\=0A 	  [v=
] "+Q" (*(u##sz *)ptr)					\=0A-	: [old] "Kr" (old), [new] "r" (new)				\=
=0A+	: [old] #constraint "r" (old), [new] "r" (new)			\=0A 	: cl);								\=
=0A 									\=0A 	return oldval;							\=0A }									\=0A __LL_SC_EXPORT(=
__cmpxchg_case_##name##sz);=0A =0A-__CMPXCHG_CASE(w, b,     ,  8,        , =
 ,  ,         )=0A-__CMPXCHG_CASE(w, h,     , 16,        ,  ,  ,         )=
=0A-__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  ,         )=0A-__CMPXCHG_CA=
SE( ,  ,     , 64,        ,  ,  ,         )=0A-__CMPXCHG_CASE(w, b, acq_,  =
8,        , a,  , "memory")=0A-__CMPXCHG_CASE(w, h, acq_, 16,        , a,  =
, "memory")=0A-__CMPXCHG_CASE(w,  , acq_, 32,        , a,  , "memory")=0A-_=
_CMPXCHG_CASE( ,  , acq_, 64,        , a,  , "memory")=0A-__CMPXCHG_CASE(w,=
 b, rel_,  8,        ,  , l, "memory")=0A-__CMPXCHG_CASE(w, h, rel_, 16,   =
     ,  , l, "memory")=0A-__CMPXCHG_CASE(w,  , rel_, 32,        ,  , l, "me=
mory")=0A-__CMPXCHG_CASE( ,  , rel_, 64,        ,  , l, "memory")=0A-__CMPX=
CHG_CASE(w, b,  mb_,  8, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE(w, h,  =
mb_, 16, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish=
,  , l, "memory")=0A-__CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory"=
)=0A+/*=0A+ * Earlier versions of GCC (no later than 8.1.0) appear to incor=
rectly=0A+ * handle the 'K' constraint for the value 4294967295 - thus we u=
se no=0A+ * constraint for 32 bit operations.=0A+ */=0A+__CMPXCHG_CASE(w, b=
,     ,  8,        ,  ,  ,         , )=0A+__CMPXCHG_CASE(w, h,     , 16,   =
     ,  ,  ,         , )=0A+__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  ,  =
       , )=0A+__CMPXCHG_CASE( ,  ,     , 64,        ,  ,  ,         , L)=0A=
+__CMPXCHG_CASE(w, b, acq_,  8,        , a,  , "memory", )=0A+__CMPXCHG_CAS=
E(w, h, acq_, 16,        , a,  , "memory", )=0A+__CMPXCHG_CASE(w,  , acq_, =
32,        , a,  , "memory", )=0A+__CMPXCHG_CASE( ,  , acq_, 64,        , a=
,  , "memory", L)=0A+__CMPXCHG_CASE(w, b, rel_,  8,        ,  , l, "memory"=
, )=0A+__CMPXCHG_CASE(w, h, rel_, 16,        ,  , l, "memory", )=0A+__CMPXC=
HG_CASE(w,  , rel_, 32,        ,  , l, "memory", )=0A+__CMPXCHG_CASE( ,  , =
rel_, 64,        ,  , l, "memory", L)=0A+__CMPXCHG_CASE(w, b,  mb_,  8, dmb=
 ish,  , l, "memory", )=0A+__CMPXCHG_CASE(w, h,  mb_, 16, dmb ish,  , l, "m=
emory", )=0A+__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish,  , l, "memory", )=0A+_=
_CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory", L)=0A =0A #undef __C=
MPXCHG_CASE=0A =0A
--78nhM7UyumR5M09q
Content-Type: application/mbox
Content-Disposition: attachment; filename="arm64-atomic-4.19.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom e083ce6e570878de4510a16879de473508c8486a Mon Sep 17 00:00:00 2001=0A=
=46rom: Will Deacon <will.deacon@arm.com>=0ADate: Thu, 13 Sep 2018 13:30:45=
 +0100=0ASubject: [PATCH 1/3] arm64: Avoid redundant type conversions in xc=
hg() and=0A cmpxchg()=0A=0Acommit 5ef3fe4cecdf82fdd71ce78988403963d01444d4 =
upstream.=0A=0AOur atomic instructions (either LSE atomics of LDXR/STXR seq=
uences)=0Anatively support byte, half-word, word and double-word memory acc=
esses=0Aso there is no need to mask the data register prior to being stored=
=2E=0A=0ASigned-off-by: Will Deacon <will.deacon@arm.com>=0A[bwh: Backporte=
d to 4.19: adjust context]=0ASigned-off-by: Ben Hutchings <ben@decadent.org=
=2Euk>=0A---=0A arch/arm64/include/asm/atomic_ll_sc.h |  53 ++++++------=0A=
 arch/arm64/include/asm/atomic_lse.h   |  46 +++++-----=0A arch/arm64/inclu=
de/asm/cmpxchg.h      | 116 +++++++++++++-------------=0A 3 files changed, =
108 insertions(+), 107 deletions(-)=0A=0Adiff --git a/arch/arm64/include/as=
m/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h=0Aindex f5a2d09afb=
38..f02d3bf7b9e6 100644=0A--- a/arch/arm64/include/asm/atomic_ll_sc.h=0A+++=
 b/arch/arm64/include/asm/atomic_ll_sc.h=0A@@ -248,48 +248,49 @@ __LL_SC_PR=
EFIX(atomic64_dec_if_positive(atomic64_t *v))=0A }=0A __LL_SC_EXPORT(atomic=
64_dec_if_positive);=0A =0A-#define __CMPXCHG_CASE(w, sz, name, mb, acq, re=
l, cl)			\=0A-__LL_SC_INLINE unsigned long						\=0A-__LL_SC_PREFIX(__cmpxc=
hg_case_##name(volatile void *ptr,		\=0A-				     unsigned long old,			\=0A=
-				     unsigned long new))		\=0A+#define __CMPXCHG_CASE(w, sfx, name, sz=
, mb, acq, rel, cl)		\=0A+__LL_SC_INLINE u##sz							\=0A+__LL_SC_PREFIX(__=
cmpxchg_case_##name##sz(volatile void *ptr,		\=0A+					 unsigned long old,	=
	\=0A+					 u##sz new))			\=0A {									\=0A-	unsigned long tmp, oldval;		=
			\=0A+	unsigned long tmp;						\=0A+	u##sz oldval;							\=0A 									\=
=0A 	asm volatile(							\=0A 	"	prfm	pstl1strm, %[v]\n"				\=0A-	"1:	ld" #=
acq "xr" #sz "\t%" #w "[oldval], %[v]\n"		\=0A+	"1:	ld" #acq "xr" #sfx "\t%=
" #w "[oldval], %[v]\n"		\=0A 	"	eor	%" #w "[tmp], %" #w "[oldval], %" #w "=
[old]\n"	\=0A 	"	cbnz	%" #w "[tmp], 2f\n"				\=0A-	"	st" #rel "xr" #sz "\t%=
w[tmp], %" #w "[new], %[v]\n"	\=0A+	"	st" #rel "xr" #sfx "\t%w[tmp], %" #w =
"[new], %[v]\n"	\=0A 	"	cbnz	%w[tmp], 1b\n"					\=0A 	"	" #mb "\n"						\=
=0A 	"2:"								\=0A 	: [tmp] "=3D&r" (tmp), [oldval] "=3D&r" (oldval),			=
\=0A-	  [v] "+Q" (*(unsigned long *)ptr)				\=0A+	  [v] "+Q" (*(u##sz *)ptr=
)					\=0A 	: [old] "Lr" (old), [new] "r" (new)				\=0A 	: cl);								\=0A=
 									\=0A 	return oldval;							\=0A }									\=0A-__LL_SC_EXPORT(__c=
mpxchg_case_##name);=0A+__LL_SC_EXPORT(__cmpxchg_case_##name##sz);=0A =0A-_=
_CMPXCHG_CASE(w, b,     1,        ,  ,  ,         )=0A-__CMPXCHG_CASE(w, h,=
     2,        ,  ,  ,         )=0A-__CMPXCHG_CASE(w,  ,     4,        ,  ,=
  ,         )=0A-__CMPXCHG_CASE( ,  ,     8,        ,  ,  ,         )=0A-__=
CMPXCHG_CASE(w, b, acq_1,        , a,  , "memory")=0A-__CMPXCHG_CASE(w, h, =
acq_2,        , a,  , "memory")=0A-__CMPXCHG_CASE(w,  , acq_4,        , a, =
 , "memory")=0A-__CMPXCHG_CASE( ,  , acq_8,        , a,  , "memory")=0A-__C=
MPXCHG_CASE(w, b, rel_1,        ,  , l, "memory")=0A-__CMPXCHG_CASE(w, h, r=
el_2,        ,  , l, "memory")=0A-__CMPXCHG_CASE(w,  , rel_4,        ,  , l=
, "memory")=0A-__CMPXCHG_CASE( ,  , rel_8,        ,  , l, "memory")=0A-__CM=
PXCHG_CASE(w, b,  mb_1, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE(w, h,  m=
b_2, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE(w,  ,  mb_4, dmb ish,  , l,=
 "memory")=0A-__CMPXCHG_CASE( ,  ,  mb_8, dmb ish,  , l, "memory")=0A+__CMP=
XCHG_CASE(w, b,     ,  8,        ,  ,  ,         )=0A+__CMPXCHG_CASE(w, h, =
    , 16,        ,  ,  ,         )=0A+__CMPXCHG_CASE(w,  ,     , 32,       =
 ,  ,  ,         )=0A+__CMPXCHG_CASE( ,  ,     , 64,        ,  ,  ,        =
 )=0A+__CMPXCHG_CASE(w, b, acq_,  8,        , a,  , "memory")=0A+__CMPXCHG_=
CASE(w, h, acq_, 16,        , a,  , "memory")=0A+__CMPXCHG_CASE(w,  , acq_,=
 32,        , a,  , "memory")=0A+__CMPXCHG_CASE( ,  , acq_, 64,        , a,=
  , "memory")=0A+__CMPXCHG_CASE(w, b, rel_,  8,        ,  , l, "memory")=0A=
+__CMPXCHG_CASE(w, h, rel_, 16,        ,  , l, "memory")=0A+__CMPXCHG_CASE(=
w,  , rel_, 32,        ,  , l, "memory")=0A+__CMPXCHG_CASE( ,  , rel_, 64, =
       ,  , l, "memory")=0A+__CMPXCHG_CASE(w, b,  mb_,  8, dmb ish,  , l, "=
memory")=0A+__CMPXCHG_CASE(w, h,  mb_, 16, dmb ish,  , l, "memory")=0A+__CM=
PXCHG_CASE(w,  ,  mb_, 32, dmb ish,  , l, "memory")=0A+__CMPXCHG_CASE( ,  ,=
  mb_, 64, dmb ish,  , l, "memory")=0A =0A #undef __CMPXCHG_CASE=0A =0Adiff=
 --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomi=
c_lse.h=0Aindex eab3de4f2ad2..80cadc789f1a 100644=0A--- a/arch/arm64/includ=
e/asm/atomic_lse.h=0A+++ b/arch/arm64/include/asm/atomic_lse.h=0A@@ -480,24=
 +480,24 @@ static inline long atomic64_dec_if_positive(atomic64_t *v)=0A =
=0A #define __LL_SC_CMPXCHG(op)	__LL_SC_CALL(__cmpxchg_case_##op)=0A =0A-#d=
efine __CMPXCHG_CASE(w, sz, name, mb, cl...)				\=0A-static inline unsigned=
 long __cmpxchg_case_##name(volatile void *ptr,	\=0A-						  unsigned long =
old,	\=0A-						  unsigned long new)	\=0A+#define __CMPXCHG_CASE(w, sfx, na=
me, sz, mb, cl...)			\=0A+static inline u##sz __cmpxchg_case_##name##sz(vol=
atile void *ptr,	\=0A+					      unsigned long old,	\=0A+					      u##sz n=
ew)		\=0A {									\=0A 	register unsigned long x0 asm ("x0") =3D (unsigne=
d long)ptr;	\=0A 	register unsigned long x1 asm ("x1") =3D old;			\=0A-	reg=
ister unsigned long x2 asm ("x2") =3D new;			\=0A+	register u##sz x2 asm ("=
x2") =3D new;				\=0A 									\=0A 	asm volatile(							\=0A 	__LSE_PREAMB=
LE							\=0A 	ARM64_LSE_ATOMIC_INSN(						\=0A 	/* LL/SC */							\=0A-	__=
LL_SC_CMPXCHG(name)						\=0A+	__LL_SC_CMPXCHG(name##sz)					\=0A 	__nops(2=
),							\=0A 	/* LSE atomics */						\=0A 	"	mov	" #w "30, %" #w "[old]\n"=
			\=0A-	"	cas" #mb #sz "\t" #w "30, %" #w "[new], %[v]\n"		\=0A+	"	cas" #m=
b #sfx "\t" #w "30, %" #w "[new], %[v]\n"	\=0A 	"	mov	%" #w "[ret], " #w "3=
0")			\=0A 	: [ret] "+r" (x0), [v] "+Q" (*(unsigned long *)ptr)		\=0A 	: [o=
ld] "r" (x1), [new] "r" (x2)				\=0A@@ -506,22 +506,22 @@ static inline uns=
igned long __cmpxchg_case_##name(volatile void *ptr,	\=0A 	return x0;						=
	\=0A }=0A =0A-__CMPXCHG_CASE(w, b,     1,   )=0A-__CMPXCHG_CASE(w, h,     =
2,   )=0A-__CMPXCHG_CASE(w,  ,     4,   )=0A-__CMPXCHG_CASE(x,  ,     8,   =
)=0A-__CMPXCHG_CASE(w, b, acq_1,  a, "memory")=0A-__CMPXCHG_CASE(w, h, acq_=
2,  a, "memory")=0A-__CMPXCHG_CASE(w,  , acq_4,  a, "memory")=0A-__CMPXCHG_=
CASE(x,  , acq_8,  a, "memory")=0A-__CMPXCHG_CASE(w, b, rel_1,  l, "memory"=
)=0A-__CMPXCHG_CASE(w, h, rel_2,  l, "memory")=0A-__CMPXCHG_CASE(w,  , rel_=
4,  l, "memory")=0A-__CMPXCHG_CASE(x,  , rel_8,  l, "memory")=0A-__CMPXCHG_=
CASE(w, b,  mb_1, al, "memory")=0A-__CMPXCHG_CASE(w, h,  mb_2, al, "memory"=
)=0A-__CMPXCHG_CASE(w,  ,  mb_4, al, "memory")=0A-__CMPXCHG_CASE(x,  ,  mb_=
8, al, "memory")=0A+__CMPXCHG_CASE(w, b,     ,  8,   )=0A+__CMPXCHG_CASE(w,=
 h,     , 16,   )=0A+__CMPXCHG_CASE(w,  ,     , 32,   )=0A+__CMPXCHG_CASE(x=
,  ,     , 64,   )=0A+__CMPXCHG_CASE(w, b, acq_,  8,  a, "memory")=0A+__CMP=
XCHG_CASE(w, h, acq_, 16,  a, "memory")=0A+__CMPXCHG_CASE(w,  , acq_, 32,  =
a, "memory")=0A+__CMPXCHG_CASE(x,  , acq_, 64,  a, "memory")=0A+__CMPXCHG_C=
ASE(w, b, rel_,  8,  l, "memory")=0A+__CMPXCHG_CASE(w, h, rel_, 16,  l, "me=
mory")=0A+__CMPXCHG_CASE(w,  , rel_, 32,  l, "memory")=0A+__CMPXCHG_CASE(x,=
  , rel_, 64,  l, "memory")=0A+__CMPXCHG_CASE(w, b,  mb_,  8, al, "memory")=
=0A+__CMPXCHG_CASE(w, h,  mb_, 16, al, "memory")=0A+__CMPXCHG_CASE(w,  ,  m=
b_, 32, al, "memory")=0A+__CMPXCHG_CASE(x,  ,  mb_, 64, al, "memory")=0A =
=0A #undef __LL_SC_CMPXCHG=0A #undef __CMPXCHG_CASE=0Adiff --git a/arch/arm=
64/include/asm/cmpxchg.h b/arch/arm64/include/asm/cmpxchg.h=0Aindex d8b01c7=
c9cd3..94ccb3bfbd61 100644=0A--- a/arch/arm64/include/asm/cmpxchg.h=0A+++ b=
/arch/arm64/include/asm/cmpxchg.h=0A@@ -30,46 +30,46 @@=0A  * barrier case =
is generated as release+dmb for the former and=0A  * acquire+release for th=
e latter.=0A  */=0A-#define __XCHG_CASE(w, sz, name, mb, nop_lse, acq, acq_=
lse, rel, cl)	\=0A-static inline unsigned long __xchg_case_##name(unsigned =
long x,		\=0A-					       volatile void *ptr)	\=0A-{									\=0A-	unsigned=
 long ret, tmp;						\=0A-									\=0A-	asm volatile(ARM64_LSE_ATOMIC_INSN=
(				\=0A-	/* LL/SC */							\=0A-	"	prfm	pstl1strm, %2\n"				\=0A-	"1:	ld"=
 #acq "xr" #sz "\t%" #w "0, %2\n"			\=0A-	"	st" #rel "xr" #sz "\t%w1, %" #w=
 "3, %2\n"		\=0A-	"	cbnz	%w1, 1b\n"					\=0A-	"	" #mb,							\=0A-	/* LSE a=
tomics */						\=0A-	"	swp" #acq_lse #rel #sz "\t%" #w "3, %" #w "0, %2\n"	=
\=0A-		__nops(3)						\=0A-	"	" #nop_lse)						\=0A-	: "=3D&r" (ret), "=3D&=
r" (tmp), "+Q" (*(unsigned long *)ptr)	\=0A-	: "r" (x)							\=0A-	: cl);		=
						\=0A-									\=0A-	return ret;							\=0A+#define __XCHG_CASE(w, sfx=
, name, sz, mb, nop_lse, acq, acq_lse, rel, cl)	\=0A+static inline u##sz __=
xchg_case_##name##sz(u##sz x, volatile void *ptr)		\=0A+{										\=0A+	u#=
#sz ret;								\=0A+	unsigned long tmp;							\=0A+										\=0A+	asm vol=
atile(ARM64_LSE_ATOMIC_INSN(					\=0A+	/* LL/SC */								\=0A+	"	prfm	pstl=
1strm, %2\n"					\=0A+	"1:	ld" #acq "xr" #sfx "\t%" #w "0, %2\n"				\=0A+	"=
	st" #rel "xr" #sfx "\t%w1, %" #w "3, %2\n"			\=0A+	"	cbnz	%w1, 1b\n"						=
\=0A+	"	" #mb,								\=0A+	/* LSE atomics */							\=0A+	"	swp" #acq_lse #=
rel #sfx "\t%" #w "3, %" #w "0, %2\n"		\=0A+		__nops(3)							\=0A+	"	" #no=
p_lse)							\=0A+	: "=3D&r" (ret), "=3D&r" (tmp), "+Q" (*(u##sz *)ptr)			\=
=0A+	: "r" (x)								\=0A+	: cl);									\=0A+										\=0A+	return ret;=
								\=0A }=0A =0A-__XCHG_CASE(w, b,     1,        ,    ,  ,  ,  ,      =
   )=0A-__XCHG_CASE(w, h,     2,        ,    ,  ,  ,  ,         )=0A-__XCHG=
_CASE(w,  ,     4,        ,    ,  ,  ,  ,         )=0A-__XCHG_CASE( ,  ,   =
  8,        ,    ,  ,  ,  ,         )=0A-__XCHG_CASE(w, b, acq_1,        , =
   , a, a,  , "memory")=0A-__XCHG_CASE(w, h, acq_2,        ,    , a, a,  , =
"memory")=0A-__XCHG_CASE(w,  , acq_4,        ,    , a, a,  , "memory")=0A-_=
_XCHG_CASE( ,  , acq_8,        ,    , a, a,  , "memory")=0A-__XCHG_CASE(w, =
b, rel_1,        ,    ,  ,  , l, "memory")=0A-__XCHG_CASE(w, h, rel_2,     =
   ,    ,  ,  , l, "memory")=0A-__XCHG_CASE(w,  , rel_4,        ,    ,  ,  =
, l, "memory")=0A-__XCHG_CASE( ,  , rel_8,        ,    ,  ,  , l, "memory")=
=0A-__XCHG_CASE(w, b,  mb_1, dmb ish, nop,  , a, l, "memory")=0A-__XCHG_CAS=
E(w, h,  mb_2, dmb ish, nop,  , a, l, "memory")=0A-__XCHG_CASE(w,  ,  mb_4,=
 dmb ish, nop,  , a, l, "memory")=0A-__XCHG_CASE( ,  ,  mb_8, dmb ish, nop,=
  , a, l, "memory")=0A+__XCHG_CASE(w, b,     ,  8,        ,    ,  ,  ,  ,  =
       )=0A+__XCHG_CASE(w, h,     , 16,        ,    ,  ,  ,  ,         )=0A=
+__XCHG_CASE(w,  ,     , 32,        ,    ,  ,  ,  ,         )=0A+__XCHG_CAS=
E( ,  ,     , 64,        ,    ,  ,  ,  ,         )=0A+__XCHG_CASE(w, b, acq=
_,  8,        ,    , a, a,  , "memory")=0A+__XCHG_CASE(w, h, acq_, 16,     =
   ,    , a, a,  , "memory")=0A+__XCHG_CASE(w,  , acq_, 32,        ,    , a=
, a,  , "memory")=0A+__XCHG_CASE( ,  , acq_, 64,        ,    , a, a,  , "me=
mory")=0A+__XCHG_CASE(w, b, rel_,  8,        ,    ,  ,  , l, "memory")=0A+_=
_XCHG_CASE(w, h, rel_, 16,        ,    ,  ,  , l, "memory")=0A+__XCHG_CASE(=
w,  , rel_, 32,        ,    ,  ,  , l, "memory")=0A+__XCHG_CASE( ,  , rel_,=
 64,        ,    ,  ,  , l, "memory")=0A+__XCHG_CASE(w, b,  mb_,  8, dmb is=
h, nop,  , a, l, "memory")=0A+__XCHG_CASE(w, h,  mb_, 16, dmb ish, nop,  , =
a, l, "memory")=0A+__XCHG_CASE(w,  ,  mb_, 32, dmb ish, nop,  , a, l, "memo=
ry")=0A+__XCHG_CASE( ,  ,  mb_, 64, dmb ish, nop,  , a, l, "memory")=0A =0A=
 #undef __XCHG_CASE=0A =0A@@ -80,13 +80,13 @@ static __always_inline  unsig=
ned long __xchg##sfx(unsigned long x,	\=0A {									\=0A 	switch (size) {	=
						\=0A 	case 1:								\=0A-		return __xchg_case##sfx##_1(x, ptr);			\=
=0A+		return __xchg_case##sfx##_8(x, ptr);			\=0A 	case 2:								\=0A-		re=
turn __xchg_case##sfx##_2(x, ptr);			\=0A+		return __xchg_case##sfx##_16(x,=
 ptr);			\=0A 	case 4:								\=0A-		return __xchg_case##sfx##_4(x, ptr);		=
	\=0A+		return __xchg_case##sfx##_32(x, ptr);			\=0A 	case 8:								\=0A-	=
	return __xchg_case##sfx##_8(x, ptr);			\=0A+		return __xchg_case##sfx##_64=
(x, ptr);			\=0A 	default:							\=0A 		BUILD_BUG();						\=0A 	}								\=
=0A@@ -123,13 +123,13 @@ static __always_inline unsigned long __cmpxchg##sf=
x(volatile void *ptr,	\=0A {									\=0A 	switch (size) {							\=0A 	case=
 1:								\=0A-		return __cmpxchg_case##sfx##_1(ptr, (u8)old, new);	\=0A+	=
	return __cmpxchg_case##sfx##_8(ptr, (u8)old, new);	\=0A 	case 2:								\=
=0A-		return __cmpxchg_case##sfx##_2(ptr, (u16)old, new);	\=0A+		return __c=
mpxchg_case##sfx##_16(ptr, (u16)old, new);	\=0A 	case 4:								\=0A-		retu=
rn __cmpxchg_case##sfx##_4(ptr, old, new);		\=0A+		return __cmpxchg_case##s=
fx##_32(ptr, old, new);		\=0A 	case 8:								\=0A-		return __cmpxchg_case#=
#sfx##_8(ptr, old, new);		\=0A+		return __cmpxchg_case##sfx##_64(ptr, old, =
new);		\=0A 	default:							\=0A 		BUILD_BUG();						\=0A 	}								\=0A@@ =
-197,16 +197,16 @@ __CMPXCHG_GEN(_mb)=0A 	__ret; \=0A })=0A =0A-#define __C=
MPWAIT_CASE(w, sz, name)					\=0A-static inline void __cmpwait_case_##name(=
volatile void *ptr,		\=0A-					 unsigned long val)		\=0A+#define __CMPWAIT_=
CASE(w, sfx, sz)					\=0A+static inline void __cmpwait_case_##sz(volatile v=
oid *ptr,		\=0A+				       unsigned long val)		\=0A {									\=0A 	unsigne=
d long tmp;						\=0A 									\=0A 	asm volatile(							\=0A 	"	sevl\n"			=
				\=0A 	"	wfe\n"							\=0A-	"	ldxr" #sz "\t%" #w "[tmp], %[v]\n"			\=0A+=
	"	ldxr" #sfx "\t%" #w "[tmp], %[v]\n"			\=0A 	"	eor	%" #w "[tmp], %" #w "[=
tmp], %" #w "[val]\n"	\=0A 	"	cbnz	%" #w "[tmp], 1f\n"				\=0A 	"	wfe\n"			=
				\=0A@@ -215,10 +215,10 @@ static inline void __cmpwait_case_##name(vola=
tile void *ptr,		\=0A 	: [val] "r" (val));						\=0A }=0A =0A-__CMPWAIT_CAS=
E(w, b, 1);=0A-__CMPWAIT_CASE(w, h, 2);=0A-__CMPWAIT_CASE(w,  , 4);=0A-__CM=
PWAIT_CASE( ,  , 8);=0A+__CMPWAIT_CASE(w, b, 8);=0A+__CMPWAIT_CASE(w, h, 16=
);=0A+__CMPWAIT_CASE(w,  , 32);=0A+__CMPWAIT_CASE( ,  , 64);=0A =0A #undef =
__CMPWAIT_CASE=0A =0A@@ -229,13 +229,13 @@ static __always_inline void __cm=
pwait##sfx(volatile void *ptr,		\=0A {									\=0A 	switch (size) {							=
\=0A 	case 1:								\=0A-		return __cmpwait_case##sfx##_1(ptr, (u8)val);		=
\=0A+		return __cmpwait_case##sfx##_8(ptr, (u8)val);		\=0A 	case 2:								=
\=0A-		return __cmpwait_case##sfx##_2(ptr, (u16)val);		\=0A+		return __cmpw=
ait_case##sfx##_16(ptr, (u16)val);		\=0A 	case 4:								\=0A-		return __cm=
pwait_case##sfx##_4(ptr, val);		\=0A+		return __cmpwait_case##sfx##_32(ptr,=
 val);		\=0A 	case 8:								\=0A-		return __cmpwait_case##sfx##_8(ptr, val=
);		\=0A+		return __cmpwait_case##sfx##_64(ptr, val);		\=0A 	default:						=
	\=0A 		BUILD_BUG();						\=0A 	}								\=0A=0AFrom b8cb7f9dadaf4aed5420a6=
62b9d44717433ece8f Mon Sep 17 00:00:00 2001=0AFrom: Will Deacon <will.deaco=
n@arm.com>=0ADate: Tue, 18 Sep 2018 09:39:55 +0100=0ASubject: [PATCH 2/3] a=
rm64: cmpxchg: Use "K" instead of "L" for ll/sc=0A immediate constraint=0A=
=0Acommit 4230509978f2921182da4e9197964dccdbe463c3 upstream.=0A=0AThe "L" A=
Arch64 machine constraint, which we use for the "old" value in=0Aan LL/SC c=
mpxchg(), generates an immediate that is suitable for a 64-bit=0Alogical in=
struction. However, for cmpxchg() operations on types smaller=0Athan 64 bit=
s, this constraint can result in an invalid instruction which=0Ais correctl=
y rejected by GAS, such as EOR W1, W1, #0xffffffff.=0A=0AWhilst we could sp=
ecial-case the constraint based on the cmpxchg size,=0Ait's far easier to c=
hange the constraint to "K" and put up with using=0Aa register for large 64=
-bit immediates. For out-of-line LL/SC atomics,=0Athis is all moot anyway.=
=0A=0AReported-by: Robin Murphy <robin.murphy@arm.com>=0ASigned-off-by: Wil=
l Deacon <will.deacon@arm.com>=0ASigned-off-by: Ben Hutchings <ben@decadent=
=2Eorg.uk>=0A---=0A arch/arm64/include/asm/atomic_ll_sc.h | 2 +-=0A 1 file =
changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/arch/arm64/include=
/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h=0Aindex f02d3bf=
7b9e6..fb841553b0b0 100644=0A--- a/arch/arm64/include/asm/atomic_ll_sc.h=0A=
+++ b/arch/arm64/include/asm/atomic_ll_sc.h=0A@@ -268,7 +268,7 @@ __LL_SC_P=
REFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		\=0A 	"2:"								\=0A=
 	: [tmp] "=3D&r" (tmp), [oldval] "=3D&r" (oldval),			\=0A 	  [v] "+Q" (*(u=
##sz *)ptr)					\=0A-	: [old] "Lr" (old), [new] "r" (new)				\=0A+	: [old] =
"Kr" (old), [new] "r" (new)				\=0A 	: cl);								\=0A 									\=0A 	retu=
rn oldval;							\=0A=0AFrom ba588fb40d7b3f7c7215eb97c9d8e35f2c4876aa Mon S=
ep 17 00:00:00 2001=0AFrom: Andrew Murray <andrew.murray@arm.com>=0ADate: W=
ed, 28 Aug 2019 18:50:06 +0100=0ASubject: [PATCH 3/3] arm64: Use correct ll=
/sc atomic constraints=0A=0Acommit 580fa1b874711d633f9b145b7777b0e83ebf3787=
 upstream.=0A=0AThe A64 ISA accepts distinct (but overlapping) ranges of im=
mediates for:=0A=0A * add arithmetic instructions ('I' machine constraint)=
=0A * sub arithmetic instructions ('J' machine constraint)=0A * 32-bit logi=
cal instructions ('K' machine constraint)=0A * 64-bit logical instructions =
('L' machine constraint)=0A=0A... but we currently use the 'I' constraint f=
or many atomic operations=0Ausing sub or logical instructions, which is not=
 always valid.=0A=0AWhen CONFIG_ARM64_LSE_ATOMICS is not set, this allows i=
nvalid immediates=0Ato be passed to instructions, potentially resulting in =
a build failure.=0AWhen CONFIG_ARM64_LSE_ATOMICS is selected the out-of-lin=
e ll/sc atomics=0Aalways use a register as they have no visibility of the v=
alue passed by=0Athe caller.=0A=0AThis patch adds a constraint parameter to=
 the ATOMIC_xx and=0A__CMPXCHG_CASE macros so that we can pass appropriate =
constraints for=0Aeach case, with uses updated accordingly.=0A=0AUnfortunat=
ely prior to GCC 8.1.0 the 'K' constraint erroneously accepted=0A'429496729=
5', so we must instead force the use of a register.=0A=0ASigned-off-by: And=
rew Murray <andrew.murray@arm.com>=0ASigned-off-by: Will Deacon <will@kerne=
l.org>=0A[bwh: Backported to 4.19: adjust context]=0ASigned-off-by: Ben Hut=
chings <ben@decadent.org.uk>=0A---=0A arch/arm64/include/asm/atomic_ll_sc.h=
 | 89 ++++++++++++++-------------=0A 1 file changed, 47 insertions(+), 42 d=
eletions(-)=0A=0Adiff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/=
arm64/include/asm/atomic_ll_sc.h=0Aindex fb841553b0b0..1cc42441bc67 100644=
=0A--- a/arch/arm64/include/asm/atomic_ll_sc.h=0A+++ b/arch/arm64/include/a=
sm/atomic_ll_sc.h=0A@@ -37,7 +37,7 @@=0A  * (the optimize attribute silentl=
y ignores these options).=0A  */=0A =0A-#define ATOMIC_OP(op, asm_op)						=
\=0A+#define ATOMIC_OP(op, asm_op, constraint)				\=0A __LL_SC_INLINE void	=
						\=0A __LL_SC_PREFIX(atomic_##op(int i, atomic_t *v))				\=0A {							=
		\=0A@@ -51,11 +51,11 @@ __LL_SC_PREFIX(atomic_##op(int i, atomic_t *v))		=
		\=0A "	stxr	%w1, %w0, %2\n"						\=0A "	cbnz	%w1, 1b"						\=0A 	: "=3D&r=
" (result), "=3D&r" (tmp), "+Q" (v->counter)		\=0A-	: "Ir" (i));							\=0A=
+	: #constraint "r" (i));						\=0A }									\=0A __LL_SC_EXPORT(atomic_##=
op);=0A =0A-#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_op)		\=
=0A+#define ATOMIC_OP_RETURN(name, mb, acq, rel, cl, op, asm_op, constraint=
)\=0A __LL_SC_INLINE int							\=0A __LL_SC_PREFIX(atomic_##op##_return##na=
me(int i, atomic_t *v))		\=0A {									\=0A@@ -70,14 +70,14 @@ __LL_SC_PRE=
FIX(atomic_##op##_return##name(int i, atomic_t *v))		\=0A "	cbnz	%w1, 1b\n"=
						\=0A "	" #mb								\=0A 	: "=3D&r" (result), "=3D&r" (tmp), "+Q" (v-=
>counter)		\=0A-	: "Ir" (i)							\=0A+	: #constraint "r" (i)						\=0A 	: =
cl);								\=0A 									\=0A 	return result;							\=0A }									\=0A __=
LL_SC_EXPORT(atomic_##op##_return##name);=0A =0A-#define ATOMIC_FETCH_OP(na=
me, mb, acq, rel, cl, op, asm_op)		\=0A+#define ATOMIC_FETCH_OP(name, mb, a=
cq, rel, cl, op, asm_op, constraint)	\=0A __LL_SC_INLINE int							\=0A __L=
L_SC_PREFIX(atomic_fetch_##op##name(int i, atomic_t *v))		\=0A {									\=
=0A@@ -92,7 +92,7 @@ __LL_SC_PREFIX(atomic_fetch_##op##name(int i, atomic_t=
 *v))		\=0A "	cbnz	%w2, 1b\n"						\=0A "	" #mb								\=0A 	: "=3D&r" (res=
ult), "=3D&r" (val), "=3D&r" (tmp), "+Q" (v->counter)	\=0A-	: "Ir" (i)					=
		\=0A+	: #constraint "r" (i)						\=0A 	: cl);								\=0A 									\=0A 	=
return result;							\=0A@@ -110,8 +110,8 @@ __LL_SC_EXPORT(atomic_fetch_##=
op##name);=0A 	ATOMIC_FETCH_OP (_acquire,        , a,  , "memory", __VA_ARG=
S__)\=0A 	ATOMIC_FETCH_OP (_release,        ,  , l, "memory", __VA_ARGS__)=
=0A =0A-ATOMIC_OPS(add, add)=0A-ATOMIC_OPS(sub, sub)=0A+ATOMIC_OPS(add, add=
, I)=0A+ATOMIC_OPS(sub, sub, J)=0A =0A #undef ATOMIC_OPS=0A #define ATOMIC_=
OPS(...)							\=0A@@ -121,17 +121,17 @@ ATOMIC_OPS(sub, sub)=0A 	ATOMIC_FE=
TCH_OP (_acquire,        , a,  , "memory", __VA_ARGS__)\=0A 	ATOMIC_FETCH_O=
P (_release,        ,  , l, "memory", __VA_ARGS__)=0A =0A-ATOMIC_OPS(and, a=
nd)=0A-ATOMIC_OPS(andnot, bic)=0A-ATOMIC_OPS(or, orr)=0A-ATOMIC_OPS(xor, eo=
r)=0A+ATOMIC_OPS(and, and, )=0A+ATOMIC_OPS(andnot, bic, )=0A+ATOMIC_OPS(or,=
 orr, )=0A+ATOMIC_OPS(xor, eor, )=0A =0A #undef ATOMIC_OPS=0A #undef ATOMIC=
_FETCH_OP=0A #undef ATOMIC_OP_RETURN=0A #undef ATOMIC_OP=0A =0A-#define ATO=
MIC64_OP(op, asm_op)						\=0A+#define ATOMIC64_OP(op, asm_op, constraint)	=
			\=0A __LL_SC_INLINE void							\=0A __LL_SC_PREFIX(atomic64_##op(long i,=
 atomic64_t *v))			\=0A {									\=0A@@ -145,11 +145,11 @@ __LL_SC_PREFIX(=
atomic64_##op(long i, atomic64_t *v))			\=0A "	stxr	%w1, %0, %2\n"						\=
=0A "	cbnz	%w1, 1b"						\=0A 	: "=3D&r" (result), "=3D&r" (tmp), "+Q" (v->=
counter)		\=0A-	: "Ir" (i));							\=0A+	: #constraint "r" (i));						\=0A =
}									\=0A __LL_SC_EXPORT(atomic64_##op);=0A =0A-#define ATOMIC64_OP_RE=
TURN(name, mb, acq, rel, cl, op, asm_op)		\=0A+#define ATOMIC64_OP_RETURN(n=
ame, mb, acq, rel, cl, op, asm_op, constraint)\=0A __LL_SC_INLINE long					=
		\=0A __LL_SC_PREFIX(atomic64_##op##_return##name(long i, atomic64_t *v))	=
\=0A {									\=0A@@ -164,14 +164,14 @@ __LL_SC_PREFIX(atomic64_##op##_ret=
urn##name(long i, atomic64_t *v))	\=0A "	cbnz	%w1, 1b\n"						\=0A "	" #mb	=
							\=0A 	: "=3D&r" (result), "=3D&r" (tmp), "+Q" (v->counter)		\=0A-	: =
"Ir" (i)							\=0A+	: #constraint "r" (i)						\=0A 	: cl);								\=0A 		=
							\=0A 	return result;							\=0A }									\=0A __LL_SC_EXPORT(atomic=
64_##op##_return##name);=0A =0A-#define ATOMIC64_FETCH_OP(name, mb, acq, re=
l, cl, op, asm_op)		\=0A+#define ATOMIC64_FETCH_OP(name, mb, acq, rel, cl, =
op, asm_op, constraint)\=0A __LL_SC_INLINE long							\=0A __LL_SC_PREFIX(a=
tomic64_fetch_##op##name(long i, atomic64_t *v))	\=0A {									\=0A@@ -186=
,7 +186,7 @@ __LL_SC_PREFIX(atomic64_fetch_##op##name(long i, atomic64_t *v=
))	\=0A "	cbnz	%w2, 1b\n"						\=0A "	" #mb								\=0A 	: "=3D&r" (result)=
, "=3D&r" (val), "=3D&r" (tmp), "+Q" (v->counter)	\=0A-	: "Ir" (i)							\=
=0A+	: #constraint "r" (i)						\=0A 	: cl);								\=0A 									\=0A 	ret=
urn result;							\=0A@@ -204,8 +204,8 @@ __LL_SC_EXPORT(atomic64_fetch_##o=
p##name);=0A 	ATOMIC64_FETCH_OP (_acquire,, a,  , "memory", __VA_ARGS__)	\=
=0A 	ATOMIC64_FETCH_OP (_release,,  , l, "memory", __VA_ARGS__)=0A =0A-ATOM=
IC64_OPS(add, add)=0A-ATOMIC64_OPS(sub, sub)=0A+ATOMIC64_OPS(add, add, I)=
=0A+ATOMIC64_OPS(sub, sub, J)=0A =0A #undef ATOMIC64_OPS=0A #define ATOMIC6=
4_OPS(...)						\=0A@@ -215,10 +215,10 @@ ATOMIC64_OPS(sub, sub)=0A 	ATOMIC=
64_FETCH_OP (_acquire,, a,  , "memory", __VA_ARGS__)	\=0A 	ATOMIC64_FETCH_O=
P (_release,,  , l, "memory", __VA_ARGS__)=0A =0A-ATOMIC64_OPS(and, and)=0A=
-ATOMIC64_OPS(andnot, bic)=0A-ATOMIC64_OPS(or, orr)=0A-ATOMIC64_OPS(xor, eo=
r)=0A+ATOMIC64_OPS(and, and, L)=0A+ATOMIC64_OPS(andnot, bic, )=0A+ATOMIC64_=
OPS(or, orr, L)=0A+ATOMIC64_OPS(xor, eor, L)=0A =0A #undef ATOMIC64_OPS=0A =
#undef ATOMIC64_FETCH_OP=0A@@ -248,7 +248,7 @@ __LL_SC_PREFIX(atomic64_dec_=
if_positive(atomic64_t *v))=0A }=0A __LL_SC_EXPORT(atomic64_dec_if_positive=
);=0A =0A-#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl)		\=0A+=
#define __CMPXCHG_CASE(w, sfx, name, sz, mb, acq, rel, cl, constraint)	\=0A=
 __LL_SC_INLINE u##sz							\=0A __LL_SC_PREFIX(__cmpxchg_case_##name##sz(v=
olatile void *ptr,		\=0A 					 unsigned long old,		\=0A@@ -268,29 +268,34 @=
@ __LL_SC_PREFIX(__cmpxchg_case_##name##sz(volatile void *ptr,		\=0A 	"2:"	=
							\=0A 	: [tmp] "=3D&r" (tmp), [oldval] "=3D&r" (oldval),			\=0A 	  [v=
] "+Q" (*(u##sz *)ptr)					\=0A-	: [old] "Kr" (old), [new] "r" (new)				\=
=0A+	: [old] #constraint "r" (old), [new] "r" (new)			\=0A 	: cl);								\=
=0A 									\=0A 	return oldval;							\=0A }									\=0A __LL_SC_EXPORT(=
__cmpxchg_case_##name##sz);=0A =0A-__CMPXCHG_CASE(w, b,     ,  8,        , =
 ,  ,         )=0A-__CMPXCHG_CASE(w, h,     , 16,        ,  ,  ,         )=
=0A-__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  ,         )=0A-__CMPXCHG_CA=
SE( ,  ,     , 64,        ,  ,  ,         )=0A-__CMPXCHG_CASE(w, b, acq_,  =
8,        , a,  , "memory")=0A-__CMPXCHG_CASE(w, h, acq_, 16,        , a,  =
, "memory")=0A-__CMPXCHG_CASE(w,  , acq_, 32,        , a,  , "memory")=0A-_=
_CMPXCHG_CASE( ,  , acq_, 64,        , a,  , "memory")=0A-__CMPXCHG_CASE(w,=
 b, rel_,  8,        ,  , l, "memory")=0A-__CMPXCHG_CASE(w, h, rel_, 16,   =
     ,  , l, "memory")=0A-__CMPXCHG_CASE(w,  , rel_, 32,        ,  , l, "me=
mory")=0A-__CMPXCHG_CASE( ,  , rel_, 64,        ,  , l, "memory")=0A-__CMPX=
CHG_CASE(w, b,  mb_,  8, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE(w, h,  =
mb_, 16, dmb ish,  , l, "memory")=0A-__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish=
,  , l, "memory")=0A-__CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory"=
)=0A+/*=0A+ * Earlier versions of GCC (no later than 8.1.0) appear to incor=
rectly=0A+ * handle the 'K' constraint for the value 4294967295 - thus we u=
se no=0A+ * constraint for 32 bit operations.=0A+ */=0A+__CMPXCHG_CASE(w, b=
,     ,  8,        ,  ,  ,         , )=0A+__CMPXCHG_CASE(w, h,     , 16,   =
     ,  ,  ,         , )=0A+__CMPXCHG_CASE(w,  ,     , 32,        ,  ,  ,  =
       , )=0A+__CMPXCHG_CASE( ,  ,     , 64,        ,  ,  ,         , L)=0A=
+__CMPXCHG_CASE(w, b, acq_,  8,        , a,  , "memory", )=0A+__CMPXCHG_CAS=
E(w, h, acq_, 16,        , a,  , "memory", )=0A+__CMPXCHG_CASE(w,  , acq_, =
32,        , a,  , "memory", )=0A+__CMPXCHG_CASE( ,  , acq_, 64,        , a=
,  , "memory", L)=0A+__CMPXCHG_CASE(w, b, rel_,  8,        ,  , l, "memory"=
, )=0A+__CMPXCHG_CASE(w, h, rel_, 16,        ,  , l, "memory", )=0A+__CMPXC=
HG_CASE(w,  , rel_, 32,        ,  , l, "memory", )=0A+__CMPXCHG_CASE( ,  , =
rel_, 64,        ,  , l, "memory", L)=0A+__CMPXCHG_CASE(w, b,  mb_,  8, dmb=
 ish,  , l, "memory", )=0A+__CMPXCHG_CASE(w, h,  mb_, 16, dmb ish,  , l, "m=
emory", )=0A+__CMPXCHG_CASE(w,  ,  mb_, 32, dmb ish,  , l, "memory", )=0A+_=
_CMPXCHG_CASE( ,  ,  mb_, 64, dmb ish,  , l, "memory", L)=0A =0A #undef __C=
MPXCHG_CASE=0A =0A
--78nhM7UyumR5M09q--

--eh7t2JQvHW0UUDvt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA9RtIACgkQ57/I7JWG
EQnWLRAAxIIMwpX5nQr0riw2vZQG01jw6L2+WHK/OdFPivXsUvEReDjDdNSfsfDB
vgfT95KZS5vRs5XZtH/jL6rND9p2CD3HGaQLB44FF8iQqIy/i1A1MtXWltPU5CG0
b00HjeKRokNeXl7VbNzmVhisEaDbzYvQ7NSj2iDud67iMkGFVydf2RVzD9KjhjUI
53jVkOoGQ2/LqgES98y5Jo4UI+IPzkm3xj+GEioIKrigxjh6yHksE+c3XIff+uCe
ldlj7PgyPlK/79D5FuWcLqKhSVM9zFg7xKUuUbzZWpYIcLGNXAX2xsAKZ3rRJf3E
gQyv/LrmR+g94q9VN70iH10KsbkGeuLXTM3S/lgjwUJIe0S1wltGIXpo44CSeq0F
p+AIJ8VQub6LOqXukQbr2CvneKK4OYIEAc8gWzThiuSuf33KzJD9m1vwWtGQN+he
9DdS6yDEwrrW33kXjCz47RcnznmxZCIKPbBy960AgRfom6QxmHwQKTM3Pl4Cf1xH
LE4KsuHQCHVEbTQ+i3AYMsfeksvc314u4xp146IOc8BBZNfxPwRYdnTSYDri2KPy
09/tndEFf5/Fc0xO+S5Bdm/B0kmRO47W9eNB79aqFjsfFIeml1NCxry8FfU2CKOB
bNkVfPnQTcQX6dNen/sczoDu5dNmoKWNaRmnzLczkkSJH8hMvXk=
=3WTv
-----END PGP SIGNATURE-----

--eh7t2JQvHW0UUDvt--
