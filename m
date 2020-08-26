Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAD5252F2A
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgHZNAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:00:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33116 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728977AbgHZNAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:00:36 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kAv2A-0004QZ-Po; Wed, 26 Aug 2020 23:00:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Aug 2020 23:00:10 +1000
Date:   Wed, 26 Aug 2020 23:00:10 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Caleb Jorden <caljorden@hotmail.com>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
Message-ID: <20200826130010.GA3232@gondor.apana.org.au>
References: <20200826055150.2753.90553@ml01.vlan13.01.org>
 <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
 <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
 <20200826114952.GA2375@gondor.apana.org.au>
 <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au>
 <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 02:58:02PM +0200, Andrew Zaborowski wrote:
>
> Running iwd's and ell's unit tests I can see that at least the
> following algorithms give EINVAL errors:
> ecb(aes)
> cbc(aes)
> ctr(aes)
> 
> The first one fails in recv() and only for some input lengths.  The
> latter two fail in send().  The relevant ell code starts at
> https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/cipher.c#n271
> 
> The tests didn't get to the point where aead is used.

Yes ell needs to set MSG_MORE after sending the control message.
Any sendmsg(2) without a MSG_MORE will be interpreted as the end
of a request.

I'll work around this in the kernel though for the case where there
is no actual data, with a WARN_ON_ONCE.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
