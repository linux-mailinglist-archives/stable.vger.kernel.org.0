Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A0B1B1D91
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 06:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgDUEZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 00:25:50 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60443 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgDUEZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 00:25:50 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 92529dce;
        Tue, 21 Apr 2020 04:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=zvvCeZA2387aZ4dB2b02Y3gaNhg=; b=iGfkHh
        TK6cMmmzXfYLKEjyScILROnwUjgF89rl6fdjES/ogbS3L+PnK8ab0yst1LqhK703
        542twOi1u53Ps0B7FqIHPC6hum4W3CyBwfVpGxMSAcyVGq/5Jqvg2gM2dGWVEx3v
        9mlajNhxsA+DJIW8JvLJG2eaCGvObr8fUE/YsuEzPGbCXjcg0qhpJAkdjhSh/5uD
        stOXstkkQWcoThCiSOJLWv2t65urtX9VHFFR36nkAjWEpSCE7+Ylt2EF2eBeHhk1
        fd/7QfZ0gzm5t/NP2SFTg3hMLvZdvnZsPU8lV3E1cXuJHyTpeb41jyOZXx62oICN
        ypkg/8u3TbtpwDIg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4f58fcca (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 21 Apr 2020 04:15:03 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id u11so13670903iow.4;
        Mon, 20 Apr 2020 21:25:44 -0700 (PDT)
X-Gm-Message-State: AGi0PuYkSc4OhDd5ZPJU1sP9htCPrWtJGo9dIbnbNZUrqdV9RIevTquf
        6Xfzc0rjw0QNB+IxtmWO8VY0JzWLYSKvRvUaF6E=
X-Google-Smtp-Source: APiQypIyRj2PoMMuv4crd15eUsa84Ysc6zLCi+qX7meem+au7YS2pQ0yUhvSUith/HDjNeRf03EIoEMHv9xqqlNoiSU=
X-Received: by 2002:a05:6602:21d3:: with SMTP id c19mr18687073ioc.29.1587443144218;
 Mon, 20 Apr 2020 21:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <2cdb57f2cdbd49e9bb1034d01d054bb7@AcuMS.aculab.com>
 <CAHmME9pq2Kdrp5C1+90PQyXsaG8xfdRwG-xGNs5U0ykVORrMbw@mail.gmail.com>
In-Reply-To: <CAHmME9pq2Kdrp5C1+90PQyXsaG8xfdRwG-xGNs5U0ykVORrMbw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Apr 2020 22:25:33 -0600
X-Gmail-Original-Message-ID: <CAHmME9pRFGRi8oxazFrd05S+m=_s7=WF5x_jfUAE_Qt+c5-anA@mail.gmail.com>
Message-ID: <CAHmME9pRFGRi8oxazFrd05S+m=_s7=WF5x_jfUAE_Qt+c5-anA@mail.gmail.com>
Subject: Re: FPU register granularity [Was: Re: [PATCH crypto-stable] crypto:
 arch/lib - limit simd usage to PAGE_SIZE chunks]
To:     David Laight <David.Laight@aculab.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 10:14 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi David,
>
> On Mon, Apr 20, 2020 at 2:32 AM David Laight <David.Laight@aculab.com> wrote:
> > Maybe kernel_fp_begin() should be passed the address of somewhere
> > the address of an fpu save area buffer can be written to.
> > Then the pre-emption code can allocate the buffer and save the
> > state into it.
>
> Interesting idea. It looks like `struct xregs_state` is only 576
> bytes. That's not exactly small, but it's not insanely huge either,
> and maybe we could justifiably stick that on the stack, or even
> reserve part of the stack allocation for that that the function would
> know about, without needing to specify any address.

Hah-hah, nevermind here. extended_state_area is of course huge,
bringing the whole structure to a whopping 3k with avx512. :)
