Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A6B34C30
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbfFDP0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 11:26:34 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41598 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbfFDP0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 11:26:34 -0400
Received: by mail-pg1-f196.google.com with SMTP id 83so3736999pgg.8
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 08:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=crKvxivG7cxOtgK1pUuDExtj9gC4pf+ucoK2hpGb3bA=;
        b=aOCG+invy3bN0dQkzwdYQPSQ7Gf2fLvoPZ4DUr6TT417shpH7FApKyGiShb0lk6fZU
         HiO2g2jmhgDbyD00+8bspsGtTdaDcfgrXEZ4Cb4w+KCUw4M0OyZSu6OwJyBZL91DncQO
         CQcCV6l8d1i0hRLIw7e3WuJXx/suzhdCD9nPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=crKvxivG7cxOtgK1pUuDExtj9gC4pf+ucoK2hpGb3bA=;
        b=G5KMWocHaA+0+HyoRbcanKM/PKkVTU7Rq7OJcu8YsnWFFExIgFr9Yb8rJWffUbtgOB
         yFytYb5tDU28/ej9yddqIxkzbg/daWy/FwBft4HmziOZG8+RlgrvKtPZjLvJJYeqsl2A
         gVxIxYUpKmeZ5PnwIAhpm0qC9Ri1cXIhTapdiipxvdOFt76DXX4K5ZSXW6g+FHSDy/jB
         EScnFY04AQQGVyWujLZksyMaipLgtVievqKrLv0SGjoS15uGwIduechNczNMbGzmm6xY
         whb1lwlG1yU5tOPkUMDiSSl61xsi+RSkLU4zC7yAfs5XJibv0605soqAc6yzYniQlKSa
         jHOw==
X-Gm-Message-State: APjAAAUBGwztWYpLWLLNDQJP5851vqAKr5U3smSTqeMhaIymZ1nk347D
        j9J+aMCBcqk6L1ebEvCoLExkXA==
X-Google-Smtp-Source: APXvYqy35N9vWt1GRb86X1Q6PVpiwJTM5RjmMshtClcQHQg9WMHQ6TFwt5otkWZa0m7EbfICjG4Ggw==
X-Received: by 2002:a17:90a:f992:: with SMTP id cq18mr36910813pjb.54.1559661993296;
        Tue, 04 Jun 2019 08:26:33 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id b2sm8642989pgk.50.2019.06.04.08.26.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 08:26:32 -0700 (PDT)
Date:   Tue, 4 Jun 2019 08:26:32 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Message-ID: <20190604152632.GO40515@google.com>
References: <20190603183946.42233-1-mka@chromium.org>
 <20190604074849.GC6840@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190604074849.GC6840@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 09:48:49AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jun 03, 2019 at 11:39:46AM -0700, Matthias Kaehlcke wrote:
> > From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > 
> > commit ef4d6f6b275c498f8e5626c99dbeefdc5027f843 upstream.
> > 
> > The ror32 implementation (word >> shift) | (word << (32 - shift) has
> > undefined behaviour if shift is outside the [1, 31] range.  Similarly
> > for the 64 bit variants.  Most callers pass a compile-time constant
> > (naturally in that range), but there's an UBSAN report that these may
> > actually be called with a shift count of 0.
> > 
> > Instead of special-casing that, we can make them DTRT for all values of
> > shift while also avoiding UB.  For some reason, this was already partly
> > done for rol32 (which was well-defined for [0, 31]).  gcc 8 recognizes
> > these patterns as rotates, so for example
> > 
> >   __u32 rol32(__u32 word, unsigned int shift)
> >   {
> > 	return (word << (shift & 31)) | (word >> ((-shift) & 31));
> >   }
> > 
> > compiles to
> > 
> > 0000000000000020 <rol32>:
> >   20:   89 f8                   mov    %edi,%eax
> >   22:   89 f1                   mov    %esi,%ecx
> >   24:   d3 c0                   rol    %cl,%eax
> >   26:   c3                      retq
> > 
> > Older compilers unfortunately do not do as well, but this only affects
> > the small minority of users that don't pass constants.
> > 
> > Due to integer promotions, ro[lr]8 were already well-defined for shifts
> > in [0, 8], and ro[lr]16 were mostly well-defined for shifts in [0, 16]
> > (only mostly - u16 gets promoted to _signed_ int, so if bit 15 is set,
> > word << 16 is undefined).  For consistency, update those as well.
> > 
> > Link: http://lkml.kernel.org/r/20190410211906.2190-1-linux@rasmusvillemoes.dk
> > Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > Reported-by: Ido Schimmel <idosch@mellanox.com>
> > Tested-by: Ido Schimmel <idosch@mellanox.com>
> > Reviewed-by: Will Deacon <will.deacon@arm.com>
> > Cc: Vadim Pasternak <vadimp@mellanox.com>
> > Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> > Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > Hi Greg and Sasha,
> > 
> > Please pick this patch for 4.19. It fixes (at least) crashes due
> > to undefined instructions in BPF code on arm32 when building with
> > clang:
> 
> What about for the 5.1 kernel?  You don't want anyone updating from 4.19
> to the latest stable and having a regression, right?

ack

posted it also for 5.1
