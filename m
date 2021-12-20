Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F93647B070
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbhLTPiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:38:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34446 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbhLTPiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:38:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B636DB80EE8;
        Mon, 20 Dec 2021 15:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6DFC36AE8;
        Mon, 20 Dec 2021 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640014689;
        bh=7MCbBETf2IuQEXkJ4KtZgPpqRlIsuuMsKY8eWRIUSEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P9P0zvgG0zeHiod4JdN8sqO9KftmDxylOTcATn/erjbdu/9d001feTkehBzRZssB3
         x8bH16+SvIH83X1hPLHXWBcByl5ilsoWMwYGly2tWDp7wv4bkkEQ/Ih4jjetEiM+cP
         uQMT0p38jGz/82NVR276QvV3GkF7RqGeSEK4TNodkRzAsNN6G8mjA8ZVgF8HlsQGFn
         G+hOAihSEx6rNm1gxD3vuGUr/ZI+Sw+N3acJHLcnShnN0QxjAfbIVi1scXT/7xh5Kv
         LFdjrWrOgmEKqZpkGctp/IZes+INn98OKL3caV9eG+7aQVN7pQS+N/9lPPJvlBwXkU
         2bfERA2HllL8A==
Date:   Mon, 20 Dec 2021 09:38:06 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND] random: use correct memory barriers for
 crng_node_pool
Message-ID: <YcCjXjouk6NqzPSK@quark>
References: <20211219025139.31085-1-ebiggers@kernel.org>
 <CAHmME9p_TwQntnDu8y0RkxweVMe=4OmNyxcDcEvc-6tAkYDRGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9p_TwQntnDu8y0RkxweVMe=4OmNyxcDcEvc-6tAkYDRGw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 04:17:59PM +0100, Jason A. Donenfeld wrote:
> On Sun, Dec 19, 2021 at 3:52 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > +
> > +static inline struct crng_state *select_crng(void)
> > +{
> > +
> > +static inline struct crng_state *select_crng(void)
> > +{
> 
> Usually static inline is avoided in .c files. Any special reason why
> we'd need this especially much here? Those functions are pretty small
> and I assume will be inlined anyway on most architectures.
> 
> I just did a test on x86_64 with GCC 11, and the same file was
> produced with 'static' as with 'static inline'. Was there an
> arch/config/compiler combo you were concerned about here?

No special reason, this is just a bad habit.  I'm fine with omitting 'inline'
here.

- Eric
