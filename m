Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDE75881CD
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 20:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiHBSRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 14:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiHBSRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 14:17:39 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A247E32EFE;
        Tue,  2 Aug 2022 11:17:38 -0700 (PDT)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 272IDHUg002582;
        Tue, 2 Aug 2022 13:13:17 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 272IDFmt002581;
        Tue, 2 Aug 2022 13:13:15 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Tue, 2 Aug 2022 13:13:15 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] powerpc: Fix eh field when calling lwarx on PPC32
Message-ID: <20220802181315.GI25951@gate.crashing.org>
References: <a1176e19e627dd6a1b8d24c6c457a8ab874b7d12.1659430931.git.christophe.leroy@csgroup.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1176e19e627dd6a1b8d24c6c457a8ab874b7d12.1659430931.git.christophe.leroy@csgroup.eu>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On Tue, Aug 02, 2022 at 11:02:36AM +0200, Christophe Leroy wrote:
> Commit 9401f4e46cf6 ("powerpc: Use lwarx/ldarx directly instead of
> PPC_LWARX/LDARX macros") properly handled the eh field of lwarx
> in asm/bitops.h but failed to clear it for PPC32 in
> asm/simple_spinlock.h
> 
> So, do as in arch_atomic_try_cmpxchg_lock(), set it to 1 if PPC64
> but set it to 0 if PPC32. For that use IS_ENABLED(CONFIG_PPC64) which
> returns 1 when CONFIG_PPC64 is set and 0 otherwise.
> 
> Reported-by: Pali Rohár <pali@kernel.org>

Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>

> +	unsigned int eh = IS_ENABLED(CONFIG_PPC64);
>  
>  	token = LOCK_TOKEN;
>  	__asm__ __volatile__(
> -"1:	lwarx		%0,0,%2,1\n\
> +"1:	lwarx		%0,0,%2,%3\n\
>  	cmpwi		0,%0,0\n\
>  	bne-		2f\n\
>  	stwcx.		%1,0,%2\n\
> @@ -59,7 +60,7 @@ static inline unsigned long __arch_spin_trylock(arch_spinlock_t *lock)
>  	PPC_ACQUIRE_BARRIER
>  "2:"
>  	: "=&r" (tmp)
> -	: "r" (token), "r" (&lock->slock)
> +	: "r" (token), "r" (&lock->slock), "i" (eh)
>  	: "cr0", "memory");

That should work yes.  But please note that "n" is prefered if a number
is required (like here), not some other constant, as allowed by "i".

Thanks!


Segher
