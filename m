Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2BF4F2138
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 06:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiDEDLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 23:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiDEDK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 23:10:59 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC8312E179
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 20:01:09 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p8so10821767pfh.8
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 20:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mJ8nCMouM7w/nhMJKJRBKFA46sMtOfXLLoHT1qHAs30=;
        b=CArrt2pnD1iMc0WIa8Cx+ABDfJl6Bg2KrLWJM4dhfTWW3K3CNvBO5hySLybXh7+13+
         SB68gnB5M+b4BZ7qSgXzTsrKIPX9XMcNJPN54FSfjnSjCB4lydmKKvVKe90GzPjAXo6v
         1UNyt4p9nW2Xc+gHwQTvHB4EFYnac3XzePvho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mJ8nCMouM7w/nhMJKJRBKFA46sMtOfXLLoHT1qHAs30=;
        b=REsZAnm0U8vihkqZ/sMfV4VhMLAw/TO0AMg/JsGpttQI88WHf4VEWNX9r25Xr3394U
         qq++5xKlXF47a/7ptqFAqqJT0q5USQe2ZcHl/5LAQYWmwM7DXhQVdT2ENhEjIKeJeZc2
         18JWC526DFtjruQJwQ+G/gMM6ae0ZnczOiMn/g3pMeuExTX1bHxJ8GZ4HLphZgSzCsov
         MDZNvN3Wns0149Lam8ph7sJtH78GHQTcoK8esCtZD9wQjfgvN/TYGnKLGDE6tPUsU/xK
         AfKH4zMGPWZ/ZewFIYntAasgfN35vJSMJRoxRNgiRw9PPiIP8I08S5zuH3tXLbY6NAe8
         /WjQ==
X-Gm-Message-State: AOAM532/Wt9k/TTx4UmGzOJOLiIAjtIavTKcGOM7PZAzc4R+W2qM6t2J
        iV14YCZPaXxM0nFAalNMKRoXiQ==
X-Google-Smtp-Source: ABdhPJyeYh3fTlkZ/CkH3i3RSFVKkJnPOM83Of6P60SC6OvHcj15HvQMgq2SAHXMsFx1WKfSSFr4rg==
X-Received: by 2002:a05:6a00:1304:b0:4e1:2338:f11e with SMTP id j4-20020a056a00130400b004e12338f11emr1263409pfu.24.1649127668849;
        Mon, 04 Apr 2022 20:01:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090ad99000b001bcbc4247a0sm464660pjv.57.2022.04.04.20.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 20:01:08 -0700 (PDT)
Date:   Mon, 4 Apr 2022 20:01:07 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH v2] gcc-plugins: latent_entropy: use /dev/urandom
Message-ID: <202204041953.D7E0BA15@keescook>
References: <CAHmME9otYi4pCzZwSGnK40dp1QMRVPxp+DBysVuLXUKkXinAxg@mail.gmail.com>
 <20220403204036.1269562-1-Jason@zx2c4.com>
 <202204041144.96FC64A8@keescook>
 <Ykt1cj0wPKEsHL2q@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ykt1cj0wPKEsHL2q@zx2c4.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 12:47:14AM +0200, Jason A. Donenfeld wrote:
> On Mon, Apr 4, 2022 at 8:49 PM Kees Cook <keescook@chromium.org> wrote:
> > This mixes two changes: the pRNG change and the "use urandom if
> > non-deterministic" change. I think these should be split, so the pRNG
> > change can be explicitly justified.
> 
> Alright, I'll split those. Or, more probably, just drop the xorshift
> thing. There's not actually a strong reason for preferring xorshift. I
> did it because it produces more uniformity and is faster to compute and
> all that. But none of that stuff actually matters here. It was just a
> sort of "well I'm at it..." thing.

Well, it's nice to have and you already wrote it, so seems a waste to
just drop it. :)

> > >  static struct plugin_info latent_entropy_plugin_info = {
> > > -     .version        = "201606141920vanilla",
> > > +     .version        = "202203311920vanilla",
> >
> > This doesn't really need to be versioned. We can change this to just
> > "vanilla", IMO.
> 
> Okay. I suppose you want it to be in a different patch too, right? In
> which case I'll leave it out and maybe get to it later. (I suppose one
> probably needs to double check whether it's used for anything
> interesting like dwarf debug info or whatever, where maybe it's
> helpful?)

Hm, I don't think it shows up anywhere, but you can just drop the hunk
that touch it. I can remove them all with a separate patch later.

> > > +     if (deterministic_seed) {
> > > +             unsigned HOST_WIDE_INT w = deterministic_seed;
> > > +             w ^= w << 13;
> > > +             w ^= w >> 7;
> > > +             w ^= w << 17;
> > > +             deterministic_seed = w;
> > > +             return deterministic_seed;
> >
> > While seemingly impossible, perhaps don't reset "deterministic_seed",
> > and just continue to use "seed", so that it can never become "0" again.
> 
> Not sure I follow. It's an LFSR. The "L" is important. It'll never become
> zero. It's not "seemingly". We can prove it trivially in Magma:

Got it; yeah. I was reading too quickly. My brain misparsed and got
stuck on "left shift", but it's using rotation. Sorry for the noise.

-- 
Kees Cook
