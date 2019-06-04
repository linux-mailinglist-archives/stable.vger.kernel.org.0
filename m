Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C83340A7
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfFDHsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfFDHsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:48:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE2124CCA;
        Tue,  4 Jun 2019 07:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559634533;
        bh=ELhrGmnBm2pvw/SSOXrW+mxhI0V4oTqaT2ulkk5D3rk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FU0zXR4iZh13o6Ob44Oj4nF6IK3Y3Yidef6QLWvGtKfUOF5/Zevc2vt7gSXhdu/Yz
         fAqSnArDymSP422h3/k7WxjZkaHp6adYyJQfMv5kaF+wbRN6DF+DVNWRRJglDzmhmi
         GK70GFrJV6zFmnymKu0skhYwvJKnhUCjXTzL3pkc=
Date:   Tue, 4 Jun 2019 09:48:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ido Schimmel <idosch@mellanox.com>,
        Will Deacon <will.deacon@arm.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] include/linux/bitops.h: sanitize rotate primitives
Message-ID: <20190604074849.GC6840@kroah.com>
References: <20190603183946.42233-1-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603183946.42233-1-mka@chromium.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 11:39:46AM -0700, Matthias Kaehlcke wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> commit ef4d6f6b275c498f8e5626c99dbeefdc5027f843 upstream.
> 
> The ror32 implementation (word >> shift) | (word << (32 - shift) has
> undefined behaviour if shift is outside the [1, 31] range.  Similarly
> for the 64 bit variants.  Most callers pass a compile-time constant
> (naturally in that range), but there's an UBSAN report that these may
> actually be called with a shift count of 0.
> 
> Instead of special-casing that, we can make them DTRT for all values of
> shift while also avoiding UB.  For some reason, this was already partly
> done for rol32 (which was well-defined for [0, 31]).  gcc 8 recognizes
> these patterns as rotates, so for example
> 
>   __u32 rol32(__u32 word, unsigned int shift)
>   {
> 	return (word << (shift & 31)) | (word >> ((-shift) & 31));
>   }
> 
> compiles to
> 
> 0000000000000020 <rol32>:
>   20:   89 f8                   mov    %edi,%eax
>   22:   89 f1                   mov    %esi,%ecx
>   24:   d3 c0                   rol    %cl,%eax
>   26:   c3                      retq
> 
> Older compilers unfortunately do not do as well, but this only affects
> the small minority of users that don't pass constants.
> 
> Due to integer promotions, ro[lr]8 were already well-defined for shifts
> in [0, 8], and ro[lr]16 were mostly well-defined for shifts in [0, 16]
> (only mostly - u16 gets promoted to _signed_ int, so if bit 15 is set,
> word << 16 is undefined).  For consistency, update those as well.
> 
> Link: http://lkml.kernel.org/r/20190410211906.2190-1-linux@rasmusvillemoes.dk
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reported-by: Ido Schimmel <idosch@mellanox.com>
> Tested-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Will Deacon <will.deacon@arm.com>
> Cc: Vadim Pasternak <vadimp@mellanox.com>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Hi Greg and Sasha,
> 
> Please pick this patch for 4.19. It fixes (at least) crashes due
> to undefined instructions in BPF code on arm32 when building with
> clang:

What about for the 5.1 kernel?  You don't want anyone updating from 4.19
to the latest stable and having a regression, right?

thanks,

greg k-h
