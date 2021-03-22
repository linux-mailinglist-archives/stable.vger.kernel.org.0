Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684B6344091
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhCVMNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhCVMNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 08:13:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DECC061756
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 05:13:30 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x16so16436628wrn.4
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 05:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2HcrXIExH/hOwxD80m/t9IkqnA/KCu9VJTjas/G/8LI=;
        b=xA1rFWCsfcNlAqosV+4FnNOHlYiOvFTp4IjEjp3AlNGTEXQluKB2CD4VW06ynDsX+S
         VxLYlMx16Am1JSWNAhNA2MPR4YoBYAPdiiPVTUAHhTV829kf+892HQgybyrPwYJXTu9O
         DdV0tsrr9Tux+F+P5kOCRbdfb73DRuQPWrHAERP9IcEYvb8gADHPIxyhiV83x86BGLr9
         wn6rAfAPk7TQ0QkAsKWr+glk0kfFJpBRfg4t7+nvP+jJWW6gOJSIADIN6GINHcVg0U3j
         EI6+FaxyiAZjn+2lwZXK3LIREN0XC6j+8iiEJpdI7oCoPPGyZ1C51FJJxabUAfJvuG/x
         QIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2HcrXIExH/hOwxD80m/t9IkqnA/KCu9VJTjas/G/8LI=;
        b=OAYVVKGJbnv6ysG0RY8hzl138ksNY0Ird2nh423uyeYVskO3xWfejF/ePv1hFzoKNY
         yW/edIW3H8GynkCkK4ccl7rSLboLZZ7jg6qif/K3gujpKlIgXqLr42OOB/tFEcy6gd0n
         G/r0o18pBM9m/OX/RJWr2PVI+xnV/mXs5G1Dq9bYQbNHeRJJ+8NV7WdaUCIDqxBhD0Fx
         3fKglc4urixGold28Ap5G0sar+tvrttkm9sk9jRQfqptvpHCIDwwtuCi6qdF90Pqo/z3
         X8u/j9pbzPmB9LibZ75CqrCzBgE88HNGLl27zu/KGk/bdfR1F8jD4JnNlXe43Efww3Ga
         4Dsg==
X-Gm-Message-State: AOAM533dyAFBHLtJdk+oBnrfpyoSi/pro5/6jKdMpD3lJOBedK30ZxRY
        y5APpEGTrcho/bbJtLItuznkMA==
X-Google-Smtp-Source: ABdhPJw1pu78Z9PTOGydU1yvQBgmFxs9om6BIzyzIOVfwYuim161rGZPabgMxoMNXrADm9K0qjneeg==
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr18650232wrk.146.1616415208835;
        Mon, 22 Mar 2021 05:13:28 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id p14sm16659640wmc.30.2021.03.22.05.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 05:13:28 -0700 (PDT)
Date:   Mon, 22 Mar 2021 13:13:26 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: rng - fix crypto_rng_reset() refcounting when
 !CRYPTO_STATS
Message-ID: <YFiJ5hnKfXzlAtQi@Red>
References: <20210322050748.265604-1-ebiggers@kernel.org>
 <20210322054522.GC1667@kadam>
 <YFgyaeeY6k6Pltw7@sol.localdomain>
 <20210322073300.GF1667@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210322073300.GF1667@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le Mon, Mar 22, 2021 at 10:33:01AM +0300, Dan Carpenter a écrit :
> On Sun, Mar 21, 2021 at 11:00:09PM -0700, Eric Biggers wrote:
> > On Mon, Mar 22, 2021 at 08:45:22AM +0300, Dan Carpenter wrote:
> > > On Sun, Mar 21, 2021 at 10:07:48PM -0700, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > crypto_stats_get() is a no-op when the kernel is compiled without
> > > > CONFIG_CRYPTO_STATS, so pairing it with crypto_alg_put() unconditionally
> > > > (as crypto_rng_reset() does) is wrong.
> > > > 
> > > 
> > > Presumably the intention was that _get() and _put() should always pair.
> > > It's really ugly and horrible that they don't. We could have
> > > predicted bug like this would happen and will continue to happen until
> > > the crypto_stats_get() is renamed.
> > > 
> > 
> > Well, the crypto stats stuff has always been pretty broken, so I don't think
> > people have looked at it too closely.  Currently crypto_stats_get() pairs with
> > one of the functions that tallies the statistics, such as
> > crypto_stats_rng_seed() or crypto_stats_aead_encrypt().  What change are you
> > suggesting, exactly?  Maybe moving the conditional crypto_alg_put() into a new
> > function crypto_stats_put() and moving it into the callers?  Or do you think the
> > functions should just be renamed to something like crypto_stats_begin() and
> > crypto_stats_end_{rng_seed,aead_encrypt}()?
> 
> To be honest, I misread the crypto_alg_put() thinking that it was
> crypto_*stats*_put().  My favourite fix would be to introduce a
> crypto_stats_put() which is a mirror of crypto_stats_get() and ifdeffed
> out if we don't have CONFIG_CRYPTO_STATS.
> 

I agree it will be better.
I can work on adding crypto_stats_put() if you want.

Regards
