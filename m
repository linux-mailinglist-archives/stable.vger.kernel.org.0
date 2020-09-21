Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72758271DC4
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 10:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgIUITo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 04:19:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38400 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgIUITo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 04:19:44 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kKH2x-0000vv-Ms; Mon, 21 Sep 2020 18:19:40 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 21 Sep 2020 18:19:39 +1000
Date:   Mon, 21 Sep 2020 18:19:39 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200921081939.GA4193@gondor.apana.org.au>
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917165802.GC855@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 09:58:02AM -0700, Eric Biggers wrote:
>
> smp_load_acquire() is obviously correct, whereas READ_ONCE() is an optimization
> that is difficult to tell whether it's correct or not.  For trivial data
> structures it's "easy" to tell.  But whenever there is a->b where b is an
> internal implementation detail of another kernel subsystem, the use of which
> could involve accesses to global or static data (for example, spin_lock()
> accessing lockdep stuff), a control dependency can slip in.

If we're going to follow this line of reasoning, surely you should
be converting the RCU derference first and foremost, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
