Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C7E588246
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 21:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiHBTKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 15:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiHBTKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 15:10:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C81DF83;
        Tue,  2 Aug 2022 12:10:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1688C6145D;
        Tue,  2 Aug 2022 19:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6F1C433D6;
        Tue,  2 Aug 2022 19:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659467405;
        bh=FjoeZzzk1IzB3OU/5rf9Bn7kBcKlBx8DdUOpNoI+29M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SAU3uYYYWc+Cvh90gsfebNVhmo0a903dG1YSM4Wmps4cLy6Ks5G2G5bDlwqqzpB7I
         +Zp03dcI8GcDKGyP6FHM5MnBy9j4OUBP/ZA1gNmNLz/zvK+ueJP8lOe9T8DYT4H80+
         vXyRDULeyI9aVi8PzR3soQ5peyjfVU/IT1eMdv9Vuk5LZDqapz/n6AnKW1hrOpa/Qp
         KVy1R7AT84C4ZZ9fiaacLJGNm5EiscZxq6d0IeJBZeGxacd1bhM9bAZapGO7eytmBk
         2H9lkgingWXOA7r4wtjeIBQo0I/VymM0GgzPLGK44Ke+HvQwPt7F6/buwLyyrZOL78
         Pdux2tg4v8yVg==
Received: by pali.im (Postfix)
        id 30CF7F81; Tue,  2 Aug 2022 21:10:02 +0200 (CEST)
Date:   Tue, 2 Aug 2022 21:10:02 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 1/3] powerpc: Fix eh field when calling lwarx on PPC32
Message-ID: <20220802191002.h5pzq5goo34owqfv@pali>
References: <a1176e19e627dd6a1b8d24c6c457a8ab874b7d12.1659430931.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1176e19e627dd6a1b8d24c6c457a8ab874b7d12.1659430931.git.christophe.leroy@csgroup.eu>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 02 August 2022 11:02:36 Christophe Leroy wrote:
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
> Fixes: 9401f4e46cf6 ("powerpc: Use lwarx/ldarx directly instead of PPC_LWARX/LDARX macros")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

This fix works perfectly. Thanks!

Tested-by: Pali Rohár <pali@kernel.org>

> ---
>  arch/powerpc/include/asm/simple_spinlock.h | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/simple_spinlock.h b/arch/powerpc/include/asm/simple_spinlock.h
> index 7ae6aeef8464..5095c636a680 100644
> --- a/arch/powerpc/include/asm/simple_spinlock.h
> +++ b/arch/powerpc/include/asm/simple_spinlock.h
> @@ -48,10 +48,11 @@ static inline int arch_spin_is_locked(arch_spinlock_t *lock)
>  static inline unsigned long __arch_spin_trylock(arch_spinlock_t *lock)
>  {
>  	unsigned long tmp, token;
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
>  
>  	return tmp;
> @@ -156,9 +157,10 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
>  static inline long __arch_read_trylock(arch_rwlock_t *rw)
>  {
>  	long tmp;
> +	unsigned int eh = IS_ENABLED(CONFIG_PPC64);
>  
>  	__asm__ __volatile__(
> -"1:	lwarx		%0,0,%1,1\n"
> +"1:	lwarx		%0,0,%1,%2\n"
>  	__DO_SIGN_EXTEND
>  "	addic.		%0,%0,1\n\
>  	ble-		2f\n"
> @@ -166,7 +168,7 @@ static inline long __arch_read_trylock(arch_rwlock_t *rw)
>  	bne-		1b\n"
>  	PPC_ACQUIRE_BARRIER
>  "2:"	: "=&r" (tmp)
> -	: "r" (&rw->lock)
> +	: "r" (&rw->lock), "i" (eh)
>  	: "cr0", "xer", "memory");
>  
>  	return tmp;
> @@ -179,17 +181,18 @@ static inline long __arch_read_trylock(arch_rwlock_t *rw)
>  static inline long __arch_write_trylock(arch_rwlock_t *rw)
>  {
>  	long tmp, token;
> +	unsigned int eh = IS_ENABLED(CONFIG_PPC64);
>  
>  	token = WRLOCK_TOKEN;
>  	__asm__ __volatile__(
> -"1:	lwarx		%0,0,%2,1\n\
> +"1:	lwarx		%0,0,%2,%3\n\
>  	cmpwi		0,%0,0\n\
>  	bne-		2f\n"
>  "	stwcx.		%1,0,%2\n\
>  	bne-		1b\n"
>  	PPC_ACQUIRE_BARRIER
>  "2:"	: "=&r" (tmp)
> -	: "r" (token), "r" (&rw->lock)
> +	: "r" (token), "r" (&rw->lock), "i" (eh)
>  	: "cr0", "memory");
>  
>  	return tmp;
> -- 
> 2.36.1
> 
