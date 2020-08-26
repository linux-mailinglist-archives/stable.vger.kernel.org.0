Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5651253118
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 16:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgHZOTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 10:19:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33226 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbgHZOTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 10:19:34 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kAwGa-00064P-1R; Thu, 27 Aug 2020 00:19:09 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Aug 2020 00:19:08 +1000
Date:   Thu, 27 Aug 2020 00:19:08 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Denis Kenzior <denkenz@gmail.com>
Cc:     Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Caleb Jorden <caljorden@hotmail.com>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
Message-ID: <20200826141907.GA5111@gondor.apana.org.au>
References: <20200826055150.2753.90553@ml01.vlan13.01.org>
 <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
 <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
 <20200826114952.GA2375@gondor.apana.org.au>
 <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au>
 <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
 <20200826130010.GA3232@gondor.apana.org.au>
 <c27e5303-48d9-04a4-4e73-cfea5470f357@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c27e5303-48d9-04a4-4e73-cfea5470f357@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 08:57:17AM -0500, Denis Kenzior wrote:
> 
> I'm just waking up now, so I might seem dense, but for my education, can you
> tell me why we need to set MSG_MORE when we issue just a single sendmsg
> followed immediately by recv/recvmsg? ell/iwd operates on small buffers, so
> we don't really feed the kernel data in multiple send operations.  You can
> see this in the ell git tree link referenced in Andrew's reply.

You obviously don't need MSG_MORE if you're doing a single sendmsg.

The problematic code is in l_cipher_set_iv.  It does a sendmsg(2)
that expects to be followed by more sendmsg(2) calls before a
recvmsg(2).  That's the one that needs a MSG_MORE.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
