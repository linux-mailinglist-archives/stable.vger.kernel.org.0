Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9923AD623
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 01:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbhFRXvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 19:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbhFRXvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 19:51:48 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9FBC06175F
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 16:49:37 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e33so9146065pgm.3
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 16:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1LjPznQ/uIsBDTfnzklraJ3U4KjBtmygs7CsvfkuOpE=;
        b=DOvQjNeS+IMvZE3V2rm/bsTOIE2+ElVWYpXBZFcbc3+qR4DzP1GrEt9yKpj0PRQqM5
         QK21+zJTSoN1Btb1LpXsZEUBLD482NwV90tCJzDecrk9yRXIR7/iS40hHtUX6HWl3Caq
         KqA7e5DTfGdu/IRPBaotih4QTz2Uw9/rrROpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1LjPznQ/uIsBDTfnzklraJ3U4KjBtmygs7CsvfkuOpE=;
        b=UGkFNk0yMBYVXAOilmZzclU2VsYKSqyYit6doEZG+vpEteScbe9rz5DxJCOXSQJDuX
         QS5/WCWXSLP6J3w7UsWhOTwqUEtIy6GQ00sDJGkaKYaWnZta3Y6I7A8Qj62/lhZkB9aA
         eI01EycbbNDgL+aPEBjl9ptxcLhhcQWIRAlitcpTNi9MYuvp4Ye/RQxmTFHxjLum54g0
         +bqGDuEDiqygyV6qgWilglUDv29lGohIfEDDzFW/xoZWp0TPL1wxM14rLN8MNp4ZHoLk
         TZPeGdHTzwdjT7mI2KiRZo4n09bdHQaYAr1MuzDck5JHaoyb4p3P58Y3s7Gi4lK6lxuF
         hwtg==
X-Gm-Message-State: AOAM5336TJZi9H8Ql6oMkNWZ9LV0Cym0N1tksNCg2k5bQRpjSyJGlcsY
        LFYgnTfDNsFLbe9/i69B8slxKQ==
X-Google-Smtp-Source: ABdhPJwZim075DfvinUYZnIyBpgJHTRdBHlySZ9Lv5z4lp07rXwavP5/Oq5awRv5qpMc/S7ulDSg/Q==
X-Received: by 2002:a63:d47:: with SMTP id 7mr12346532pgn.339.1624060177005;
        Fri, 18 Jun 2021 16:49:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b1sm472127pjk.51.2021.06.18.16.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 16:49:36 -0700 (PDT)
Date:   Fri, 18 Jun 2021 16:49:34 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: nx: Fix memcpy() over-reading in nonce
Message-ID: <202106181648.0C5FA93@keescook>
References: <20210616203459.1248036-1-keescook@chromium.org>
 <87zgvpqb00.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgvpqb00.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 17, 2021 at 04:08:15PM +1000, Michael Ellerman wrote:
> Kees Cook <keescook@chromium.org> writes:
> > Fix typo in memcpy() where size should be CTR_RFC3686_NONCE_SIZE.
> >
> > Fixes: 030f4e968741 ("crypto: nx - Fix reentrancy bugs")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Thanks.
> 
> > ---
> >  drivers/crypto/nx/nx-aes-ctr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
> > index 13f518802343..6120e350ff71 100644
> > --- a/drivers/crypto/nx/nx-aes-ctr.c
> > +++ b/drivers/crypto/nx/nx-aes-ctr.c
> > @@ -118,7 +118,7 @@ static int ctr3686_aes_nx_crypt(struct skcipher_request *req)
> >  	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
> >  	u8 iv[16];
> >  
> > -	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_IV_SIZE);
> > +	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_NONCE_SIZE);
> >  	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->iv, CTR_RFC3686_IV_SIZE);
> >  	iv[12] = iv[13] = iv[14] = 0;
> >  	iv[15] = 1;
> 
> Where IV_SIZE is 8 and NONCE_SIZE is 4.
> 
> And iv is 16 bytes, so it's not a buffer overflow.
> 
> But priv.ctr.nonce is 4 bytes, and at the end of the struct, so it reads
> 4 bytes past the end of the nx_crypto_ctx, which is not good.
> 
> But then immediately overwrites whatever it read with req->iv.
> 
> So seems pretty harmless in practice?

Right -- there's no damage done, but future memcpy() FORTIFY work alerts
on this, so I'm going through cleaning all of these up. :)

-- 
Kees Cook
