Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E237217BCA
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 01:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgGGXjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 19:39:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58612 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgGGXjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 19:39:14 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jsxAq-00026X-2I; Wed, 08 Jul 2020 09:38:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Jul 2020 09:38:52 +1000
Date:   Wed, 8 Jul 2020 09:38:52 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brian Moyles <bmoyles@netflix.com>,
        Mauricio Faria de Oliveira <mfo@canonical.com>
Subject: Re: [PATCH 4.19 13/36] crypto: af_alg - fix use-after-free in
 af_alg_accept() due to bh_lock_sock()
Message-ID: <20200707233851.GA8460@gondor.apana.org.au>
References: <20200707145749.130272978@linuxfoundation.org>
 <20200707145749.760045378@linuxfoundation.org>
 <20200707212530.GA11158@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707212530.GA11158@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 11:25:31PM +0200, Pavel Machek wrote:
>
> > @@ -308,12 +302,14 @@ int af_alg_accept(struct sock *sk, struc
> >  
> >  	sk2->sk_family = PF_ALG;
> >  
> > -	if (nokey || !ask->refcnt++)
> > +	if (atomic_inc_return_relaxed(&ask->refcnt) == 1)
> >  		sock_hold(sk);
> > -	ask->nokey_refcnt += nokey;
> > +	if (nokey) {
> > +		atomic_inc(&ask->nokey_refcnt);
> > +		atomic_set(&alg_sk(sk2)->nokey_refcnt, 1);
> > +	}
> 
> Should we set the nokey_refcnt to 0 using atomic_set, too?
> Aternatively, should the nokey_refcnt be initialized using
> ATOMIC_INIT()?

What are you asking for? It's already being set with atomic_set.
Or are you asking it to be set to 0 instead of 1? No it needs to
be 1 for the socket destructor.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
