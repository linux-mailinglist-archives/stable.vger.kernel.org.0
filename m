Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F591C5FA5
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 20:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbgEESIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 14:08:11 -0400
Received: from terminus.zytor.com ([198.137.202.136]:57697 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729315AbgEESIL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 14:08:11 -0400
Received: from [172.27.9.0] (c-73-231-201-241.hsd1.ca.comcast.net [73.231.201.241])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 045I7QkG2666886
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 5 May 2020 11:07:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 045I7QkG2666886
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020042201; t=1588702047;
        bh=4cVMSAo5+1hI6OdDCminTspOqusfTES7OMmVmqp4XjQ=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=Nhf5+JWvcVJBl3eGfQramD8sznodcvqRcLHWQ0zVAir5IoZp+WIZPnToDoDHsX//n
         SsX499ThiXg4yy82lq+kfDM5g/TOw+rMstw1/3So72et/eB1Y698rxsg85FJ8Xt+KA
         0rmUPKiYleJp4G4EUCJq0EbQbYQtjnioah8uauPjrrhCy1lw53QU9NFgpvA5aOGcqc
         o7r6z6jh9H49TzsFT1P7VRnDP/5aBzkcu7CCAwWcZPGCAc56Fc54R8AlHYtq/QhA+h
         SnPob6TTm7PQsUen9kZJSMVkhc8mMlnpz89ymMzf0xc5zPGrNOkuueiQLhobKEPiMD
         B15Jhs20yU7AA==
Date:   Tue, 05 May 2020 11:07:24 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <20200505174423.199985-1-ndesaulniers@google.com>
References: <20200505174423.199985-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
CC:     Sedat Dilek <sedat.dilek@gmail.com>, stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>, x86@kernel.org,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
From:   hpa@zytor.com
Message-ID: <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On May 5, 2020 10:44:22 AM PDT, Nick Desaulniers <ndesaulniers@google=2Ecom=
> wrote:
>From: Sedat Dilek <sedat=2Edilek@gmail=2Ecom>
>
>It turns out that if your config tickles __builtin_constant_p via
>differences in choices to inline or not, this now produces invalid
>assembly:
>
>$ cat foo=2Ec
>long a(long b, long c) {
>  asm("orb\t%1, %0" : "+q"(c): "r"(b));
>  return c;
>}
>$ gcc foo=2Ec
>foo=2Ec: Assembler messages:
>foo=2Ec:2: Error: `%rax' not allowed with `orb'
>
>The "q" constraint only has meanting on -m32 otherwise is treated as
>"r"=2E
>
>This is easily reproducible via Clang+CONFIG_STAGING=3Dy+CONFIG_VT6656=3D=
m,
>or Clang+allyesconfig=2E
>
>Keep the masking operation to appease sparse (`make C=3D1`), add back the
>cast in order to properly select the proper 8b register alias=2E
>
> [Nick: reworded]
>
>Cc: stable@vger=2Ekernel=2Eorg
>Cc: Jesse Brandeburg <jesse=2Ebrandeburg@intel=2Ecom>
>Link: https://github=2Ecom/ClangBuiltLinux/linux/issues/961
>Link: https://lore=2Ekernel=2Eorg/lkml/20200504193524=2EGA221287@google=
=2Ecom/
>Fixes: 1651e700664b4 ("x86: Fix bitops=2Eh warning with a moved cast")
>Reported-by: Sedat Dilek <sedat=2Edilek@gmail=2Ecom>
>Reported-by: kernelci=2Eorg bot <bot@kernelci=2Eorg>
>Suggested-by: Andy Shevchenko <andriy=2Eshevchenko@intel=2Ecom>
>Suggested-by: Ilie Halip <ilie=2Ehalip@gmail=2Ecom>
>Tested-by: Sedat Dilek <sedat=2Edilek@gmail=2Ecom>
>Signed-off-by: Sedat Dilek <sedat=2Edilek@gmail=2Ecom>
>Signed-off-by: Nick Desaulniers <ndesaulniers@google=2Ecom>
>---
> arch/x86/include/asm/bitops=2Eh | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/include/asm/bitops=2Eh
>b/arch/x86/include/asm/bitops=2Eh
>index b392571c1f1d=2E=2E139122e5b25b 100644
>--- a/arch/x86/include/asm/bitops=2Eh
>+++ b/arch/x86/include/asm/bitops=2Eh
>@@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long *addr)
> 	if (__builtin_constant_p(nr)) {
> 		asm volatile(LOCK_PREFIX "orb %1,%0"
> 			: CONST_MASK_ADDR(nr, addr)
>-			: "iq" (CONST_MASK(nr) & 0xff)
>+			: "iq" ((u8)(CONST_MASK(nr) & 0xff))
> 			: "memory");
> 	} else {
> 		asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
>@@ -74,7 +74,7 @@ arch_clear_bit(long nr, volatile unsigned long *addr)
> 	if (__builtin_constant_p(nr)) {
> 		asm volatile(LOCK_PREFIX "andb %1,%0"
> 			: CONST_MASK_ADDR(nr, addr)
>-			: "iq" (CONST_MASK(nr) ^ 0xff));
>+			: "iq" ((u8)(CONST_MASK(nr) ^ 0xff)));
> 	} else {
> 		asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
> 			: : RLONG_ADDR(addr), "Ir" (nr) : "memory");

Drop & 0xff and change ^ 0xff to ~=2E

The redundancy is confusing=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
