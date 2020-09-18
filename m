Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F2F26F7B2
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 10:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgIRIHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 04:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgIRIHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 04:07:03 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B102EC061788
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 01:07:02 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id b79so4578065wmb.4
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 01:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tgDf+8aovxjwoFqw2pAtXyIqTcZuyQ4tZIemMpo6x5g=;
        b=waJaW8Mte9D9mu7wVneZdTaseFBahkj505vErBuQBlQdpJCv75cCAvwDEWNFUdX0yw
         vYzf5M/L1eh5a+L0kuixVIG7B/rrBkqi9HSe10xnQGCX0q2eVFVVU0cLlhyGWAdNMc7L
         dXQBDU/znPYpMoRmNtBz8CktfjhKqXMdmgeqAfrLx9i7wlrwgkd31B5QiSOjjLSBwkzV
         zilkLklpmyL1MOZuZ3hw6WhcgZy0qw5zi/nT35DeJM0MCuoa0y+0ztiQHZxanmwOVTJn
         g/EpZ23RO+2tZsx9k9JwZ/FAn9YMTUN5othT0vqOf8E1E+FnGLkaoOj6G3nkYHEg7THo
         vknw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tgDf+8aovxjwoFqw2pAtXyIqTcZuyQ4tZIemMpo6x5g=;
        b=ryCCWyafCjEead0UbjahlQjTODjBwJFK9os4xuVJs0L1o2lbYdt3dmzCpZPoUK50pU
         pQ5n64eYBeRGRqpHmZBW9SPjIWlARTgcz+32PNACkeADaE7fNuc8eI+XaGidJTP7WvO7
         ZkNdlouHwE+dMi9ZoZlxBAtPX1nDYdIN72A8ucqPdxCfcnC8aezs31fcw2Wm8JsqQzqP
         3mc0frDKWMWs2JKEtBhbsH0M+8XshRWWMz6sqBPK77kmPUxhEhyyA3hBS4WPY39YjSN7
         haaqecg242X7wU8U+FWLynE4LKh495wdrwEBO7iO0Vg51795GQSRoz26SmA4FA3COWAT
         Hykg==
X-Gm-Message-State: AOAM533Ht/2pkEdZw/LSfnsWtRpGMYipkvnicM0iVWviOzizxzPddNtn
        COlh6sfQszbpRDAJPFIjqTJViA==
X-Google-Smtp-Source: ABdhPJzLuGCkjX50uDxEUgN+LexVakjf3B5xC2tQu09Z2pdTpH6+Pd24cnvL3XO8Yfc9PLw9FvZOnw==
X-Received: by 2002:a7b:c4d9:: with SMTP id g25mr14060379wmk.15.1600416421193;
        Fri, 18 Sep 2020 01:07:01 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id r15sm3524860wmn.24.2020.09.18.01.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 01:07:00 -0700 (PDT)
Date:   Fri, 18 Sep 2020 10:06:58 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     arnd@arndb.de, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH 4/7] crypto: sun4i-ss: handle BigEndian for cipher
Message-ID: <20200918080658.GA22656@Red>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
 <1600367758-28589-5-git-send-email-clabbe@baylibre.com>
 <20200918073128.GA24168@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918073128.GA24168@gondor.apana.org.au>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 05:31:28PM +1000, Herbert Xu wrote:
> On Thu, Sep 17, 2020 at 06:35:55PM +0000, Corentin Labbe wrote:
> > Ciphers produce invalid results on BE.
> > Key and IV need to be written in LE.
> > Furthermore, the non-optimized function is too complicated to convert,
> > let's simply fallback on BE for the moment.
> > 
> > Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  .../crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> Does the BE failure get caught by the selftest?
> 

Yes, selftest found it.

> If so please just leave it enabled so that it can be fixed properly.

Not sure to leave it enabled is a good idea.
A least, leaving it failing probably will not annoy any user (according to my readings of #linux-sunxi, nobody use BE).

But I think only me will see it and since I already have this on my TODO list, I dont see any interest to leave it failing.
Furthermore, having a clean BE boot will permit to enable BE boots for thoses SoCs on kernelCI.

Regards
