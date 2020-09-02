Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA1625AB5C
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 14:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgIBMqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 08:46:04 -0400
Received: from terminus.zytor.com ([198.137.202.136]:52485 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgIBMqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 08:46:03 -0400
Received: from [IPv6:2601:646:8600:3281:f4fe:3463:b171:987] ([IPv6:2601:646:8600:3281:f4fe:3463:b171:987])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 082CjNHl286057
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 2 Sep 2020 05:45:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 082CjNHl286057
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020082401; t=1599050725;
        bh=1L5g91MJAcj7QUziBqImNRQTt5Ah9En7w62HAgc0uE0=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=CvK7d6SUEjfdK1IfphrxnoCfXwnQJBP6SwlCHK4ABib3Vdd6JqcjpCtwEhohsM8Gh
         KLNsod0CmxXp0+bSaDd63TyGgKDO44M5ac59G1pifdjH+uKI+pKMMbme+3iawhV3TP
         XJnRMaCTy26mQEwAASdgUActJK1vVwZ2rEv+rUg08tMKFfligMb0dR5GAM74rSb80a
         u4x+GheoxBj4ADhh7RrR4s4Plch3/0ezLjfZ1p3NpqTpF23VAQAqI+vI8Z+WMq07GZ
         fB4oXl2Czz6BKNMbnYtj2JlH8hgSu8AsqXDk6LGcs4JvkdsTwvcxxYcoOrwZ0kDB/E
         yiL5lC6LXbo1w==
Date:   Wed, 02 Sep 2020 05:45:15 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <20200901161857.566142-1-namit@vmware.com>
References: <20200901161857.566142-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] x86/special_insn: reverse __force_order logic
To:     Nadav Amit <nadav.amit@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Nadav Amit <namit@vmware.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
From:   hpa@zytor.com
Message-ID: <493788DD-A9BE-4D48-94D1-2E3B8AE6BA4E@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On September 1, 2020 9:18:57 AM PDT, Nadav Amit <nadav=2Eamit@gmail=2Ecom> =
wrote:
>From: Nadav Amit <namit@vmware=2Ecom>
>
>The __force_order logic seems to be inverted=2E __force_order is
>supposedly used to manipulate the compiler to use its memory
>dependencies analysis to enforce orders between CR writes and reads=2E
>Therefore, the memory should behave as a "CR": when the CR is read, the
>memory should be "read" by the inline assembly, and __force_order
>should
>be an output=2E When the CR is written, the memory should be "written"=2E
>
>This change should allow to remove the "volatile" qualifier from CR
>reads at a later patch=2E
>
>While at it, remove the extra new-line from the inline assembly, as it
>only confuses GCC when it estimates the cost of the inline assembly=2E
>
>Cc: Thomas Gleixner <tglx@linutronix=2Ede>
>Cc: Ingo Molnar <mingo@redhat=2Ecom>
>Cc: Borislav Petkov <bp@alien8=2Ede>
>Cc: x86@kernel=2Eorg
>Cc: "H=2E Peter Anvin" <hpa@zytor=2Ecom>
>Cc: Peter Zijlstra <peterz@infradead=2Eorg>
>Cc: Andy Lutomirski <luto@kernel=2Eorg>
>Cc: Kees Cook <keescook@chromium=2Eorg>
>Cc: stable@vger=2Ekernel=2Eorg
>Signed-off-by: Nadav Amit <namit@vmware=2Ecom>
>
>---
>
>Unless I misunderstand the logic, __force_order should also be used by
>rdpkru() and wrpkru() which do not have dependency on __force_order=2E I
>also did not understand why native_write_cr0() has R/W dependency on
>__force_order, and why native_write_cr4() no longer has any dependency
>on __force_order=2E
>---
> arch/x86/include/asm/special_insns=2Eh | 14 +++++++-------
> 1 file changed, 7 insertions(+), 7 deletions(-)
>
>diff --git a/arch/x86/include/asm/special_insns=2Eh
>b/arch/x86/include/asm/special_insns=2Eh
>index 5999b0b3dd4a=2E=2Edff5e5b01a3c 100644
>--- a/arch/x86/include/asm/special_insns=2Eh
>+++ b/arch/x86/include/asm/special_insns=2Eh
>@@ -24,32 +24,32 @@ void native_write_cr0(unsigned long val);
> static inline unsigned long native_read_cr0(void)
> {
> 	unsigned long val;
>-	asm volatile("mov %%cr0,%0\n\t" : "=3Dr" (val), "=3Dm" (__force_order))=
;
>+	asm volatile("mov %%cr0,%0" : "=3Dr" (val) : "m" (__force_order));
> 	return val;
> }
>=20
> static __always_inline unsigned long native_read_cr2(void)
> {
> 	unsigned long val;
>-	asm volatile("mov %%cr2,%0\n\t" : "=3Dr" (val), "=3Dm" (__force_order))=
;
>+	asm volatile("mov %%cr2,%0" : "=3Dr" (val) : "m" (__force_order));
> 	return val;
> }
>=20
> static __always_inline void native_write_cr2(unsigned long val)
> {
>-	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
>+	asm volatile("mov %1,%%cr2" : "=3Dm" (__force_order) : "r" (val));
> }
>=20
> static inline unsigned long __native_read_cr3(void)
> {
> 	unsigned long val;
>-	asm volatile("mov %%cr3,%0\n\t" : "=3Dr" (val), "=3Dm" (__force_order))=
;
>+	asm volatile("mov %%cr3,%0" : "=3Dr" (val) : "m" (__force_order));
> 	return val;
> }
>=20
> static inline void native_write_cr3(unsigned long val)
> {
>-	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
>+	asm volatile("mov %1,%%cr3" : "=3Dm" (__force_order) : "r" (val));
> }
>=20
> static inline unsigned long native_read_cr4(void)
>@@ -64,10 +64,10 @@ static inline unsigned long native_read_cr4(void)
> 	asm volatile("1: mov %%cr4, %0\n"
> 		     "2:\n"
> 		     _ASM_EXTABLE(1b, 2b)
>-		     : "=3Dr" (val), "=3Dm" (__force_order) : "0" (0));
>+		     : "=3Dr" (val) : "m" (__force_order), "0" (0));
> #else
> 	/* CR4 always exists on x86_64=2E */
>-	asm volatile("mov %%cr4,%0\n\t" : "=3Dr" (val), "=3Dm" (__force_order))=
;
>+	asm volatile("mov %%cr4,%0" : "=3Dr" (val) : "m" (__force_order));
> #endif
> 	return val;
> }

This seems reasonable to me, and I fully agree with you that the logic see=
ms to be just plain wrong (and unnoticed since all volatile operations are =
strictly ordered anyway), but you better not remove the volatile from cr2 r=
ead=2E=2E=2E unlike the other CRs that one is written by hardware and so ge=
nuinely is volatile=2E

However, I do believe "=3Dm" is at least theoretically wrong=2E You are on=
ly writing *part* of the total state represented by this token (you can thi=
nk of it as equivalent to a bitop), so it should be "+m"=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
