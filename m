Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372114F1FFF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 01:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiDDXNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 19:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241783AbiDDXKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 19:10:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4705524BD3;
        Mon,  4 Apr 2022 15:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D268B616B1;
        Mon,  4 Apr 2022 22:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE20C2BBE4;
        Mon,  4 Apr 2022 22:47:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="StADTOFj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1649112437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f03Sgznwk70QYZSWwxV+lkMyUN0TDnERCd80Ff7+eOo=;
        b=StADTOFj1BKH5L0K/Z5hEWL6S9XdFR1mQey631hUwzfWEzSdtgOcm1gqrPMYGihCL+uPc7
        4/L2tmXryqIqx0SXAwvR0AEXTT19Wl5EO++YJyAxB0eadcN8gF3MyAoWDDo3zVj3CUFnr9
        jZDSK8q2lGxMT4Kp6BGMZlfRLLxFFrw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b4fa201b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 4 Apr 2022 22:47:17 +0000 (UTC)
Date:   Tue, 5 Apr 2022 00:47:14 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH v2] gcc-plugins: latent_entropy: use /dev/urandom
Message-ID: <Ykt1cj0wPKEsHL2q@zx2c4.com>
References: <CAHmME9otYi4pCzZwSGnK40dp1QMRVPxp+DBysVuLXUKkXinAxg@mail.gmail.com>
 <20220403204036.1269562-1-Jason@zx2c4.com>
 <202204041144.96FC64A8@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202204041144.96FC64A8@keescook>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kees,

On Mon, Apr 4, 2022 at 8:49 PM Kees Cook <keescook@chromium.org> wrote:
> This mixes two changes: the pRNG change and the "use urandom if
> non-deterministic" change. I think these should be split, so the pRNG
> change can be explicitly justified.

Alright, I'll split those. Or, more probably, just drop the xorshift
thing. There's not actually a strong reason for preferring xorshift. I
did it because it produces more uniformity and is faster to compute and
all that. But none of that stuff actually matters here. It was just a
sort of "well I'm at it..." thing.

> >  static struct plugin_info latent_entropy_plugin_info = {
> > -     .version        = "201606141920vanilla",
> > +     .version        = "202203311920vanilla",
>
> This doesn't really need to be versioned. We can change this to just
> "vanilla", IMO.

Okay. I suppose you want it to be in a different patch too, right? In
which case I'll leave it out and maybe get to it later. (I suppose one
probably needs to double check whether it's used for anything
interesting like dwarf debug info or whatever, where maybe it's
helpful?)

> > +     if (deterministic_seed) {
> > +             unsigned HOST_WIDE_INT w = deterministic_seed;
> > +             w ^= w << 13;
> > +             w ^= w >> 7;
> > +             w ^= w << 17;
> > +             deterministic_seed = w;
> > +             return deterministic_seed;
>
> While seemingly impossible, perhaps don't reset "deterministic_seed",
> and just continue to use "seed", so that it can never become "0" again.

Not sure I follow. It's an LFSR. The "L" is important. It'll never become
zero. It's not "seemingly". We can prove it trivially in Magma:

    > w := 64;
    > K := GF(2);
    > I := IdentityMatrix(K, w);
    > SHL := HorizontalJoin(RemoveColumn(I, 1), ZeroMatrix(K, w, 1));
    > SHR := HorizontalJoin(ZeroMatrix(K, w, 1), RemoveColumn(I, w));
    > M :=  (I + SHL^17) * (I + SHR^7) * (I + SHL^13);
    > Order(M) eq 2^64 - 1;
    true
    > P<x> := MinimalPolynomial(M);
    > IsPrimitive(P);
    true
    > IsInvertible(M);
    true 
    > Rank(M);
    64

And more obviously, splitting this into "seed" and "deterministic_seed",
as you suggested, wouldn't actually do much in the case when seed=0,
since 0<<N==0 and 0^0==0.

Jason
