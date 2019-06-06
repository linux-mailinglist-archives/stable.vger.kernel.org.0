Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D749036928
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 03:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfFFBZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 21:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbfFFBZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 21:25:43 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 896332083E;
        Thu,  6 Jun 2019 01:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559784341;
        bh=xs7oBOIy1Lmw2Q3mzV7fguCJyO2cJ7LAfg5HREKny/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MZzlgZTLNhcuIviYujpvlonM6lkbhsscoW8rYxm3FoSwv8HQq4cv/GW0aMj3ljZQj
         gQOitoOdHkUPtJgglK9Gkcm17Gi3C0kBb0a48/fVlil1hTTpUu7hXlTvAmsFzMvQsf
         FHaN9lF/bK7N+Mu8QSMelY66+Q7bAcVWPDg7XUWo=
Date:   Wed, 5 Jun 2019 21:25:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, clang-built-linux@googlegroups.com,
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
Subject: Re: [PATCH 5.1] include/linux/bitops.h: sanitize rotate primitives
Message-ID: <20190606012540.GI29739@sasha-vm>
References: <20190604152530.106715-1-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190604152530.106715-1-mka@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 08:25:31AM -0700, Matthias Kaehlcke wrote:
>From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>
>commit ef4d6f6b275c498f8e5626c99dbeefdc5027f843 upstream
>
>The ror32 implementation (word >> shift) | (word << (32 - shift) has
>undefined behaviour if shift is outside the [1, 31] range.  Similarly
>for the 64 bit variants.  Most callers pass a compile-time constant
>(naturally in that range), but there's an UBSAN report that these may
>actually be called with a shift count of 0.
>
>Instead of special-casing that, we can make them DTRT for all values of
>shift while also avoiding UB.  For some reason, this was already partly
>done for rol32 (which was well-defined for [0, 31]).  gcc 8 recognizes
>these patterns as rotates, so for example
>
>  __u32 rol32(__u32 word, unsigned int shift)
>  {
>	return (word << (shift & 31)) | (word >> ((-shift) & 31));
>  }
>
>compiles to
>
>0000000000000020 <rol32>:
>  20:   89 f8                   mov    %edi,%eax
>  22:   89 f1                   mov    %esi,%ecx
>  24:   d3 c0                   rol    %cl,%eax
>  26:   c3                      retq
>
>Older compilers unfortunately do not do as well, but this only affects
>the small minority of users that don't pass constants.
>
>Due to integer promotions, ro[lr]8 were already well-defined for shifts
>in [0, 8], and ro[lr]16 were mostly well-defined for shifts in [0, 16]
>(only mostly - u16 gets promoted to _signed_ int, so if bit 15 is set,
>word << 16 is undefined).  For consistency, update those as well.
>
>Link: http://lkml.kernel.org/r/20190410211906.2190-1-linux@rasmusvillemoes.dk
>Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>Reported-by: Ido Schimmel <idosch@mellanox.com>
>Tested-by: Ido Schimmel <idosch@mellanox.com>
>Reviewed-by: Will Deacon <will.deacon@arm.com>
>Cc: Vadim Pasternak <vadimp@mellanox.com>
>Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
>Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
>Cc: Pavel Machek <pavel@ucw.cz>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>---
>Hi Greg and Sasha,
>
>Please pick this patch for 5.1. It fixes (at least) crashes due
>to undefined instructions in BPF code on arm32 when building with
>clang:

I see that Greg has queued it up yesterday, it should be in the next
release. Thanks!

--
Thanks,
Sasha
