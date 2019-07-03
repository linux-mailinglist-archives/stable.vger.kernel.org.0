Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B975E6BD
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 16:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfGCObH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 10:31:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52348 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCObH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 10:31:07 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1higHk-0000ng-VR; Wed, 03 Jul 2019 22:31:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1higHh-0000aL-6m; Wed, 03 Jul 2019 22:30:57 +0800
Date:   Wed, 3 Jul 2019 22:30:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, chetjain@in.ibm.com,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] crypto: user - prevent operating on larval algorithms
Message-ID: <20190703143057.miqgc7blhjjxjmee@gondor.apana.org.au>
References: <20190701153154.1569c2dc@kitsune.suse.cz>
 <20190702211700.16526-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702211700.16526-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 02:17:00PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Michal Suchanek reported [1] that running the pcrypt_aead01 test from
> LTP [2] in a loop and holding Ctrl-C causes a NULL dereference of
> alg->cra_users.next in crypto_remove_spawns(), via crypto_del_alg().
> The test repeatedly uses CRYPTO_MSG_NEWALG and CRYPTO_MSG_DELALG.
> 
> The crash occurs when the instance that CRYPTO_MSG_DELALG is trying to
> unregister isn't a real registered algorithm, but rather is a "test
> larval", which is a special "algorithm" added to the algorithms list
> while the real algorithm is still being tested.  Larvals don't have
> initialized cra_users, so that causes the crash.  Normally pcrypt_aead01
> doesn't trigger this because CRYPTO_MSG_NEWALG waits for the algorithm
> to be tested; however, CRYPTO_MSG_NEWALG returns early when interrupted.
> 
> Everything else in the "crypto user configuration" API has this same bug
> too, i.e. it inappropriately allows operating on larval algorithms
> (though it doesn't look like the other cases can cause a crash).
> 
> Fix this by making crypto_alg_match() exclude larval algorithms.
> 
> [1] https://lkml.kernel.org/r/20190625071624.27039-1-msuchanek@suse.de
> [2] https://github.com/linux-test-project/ltp/blob/20190517/testcases/kernel/crypto/pcrypt_aead01.c
> 
> Reported-by: Michal Suchanek <msuchanek@suse.de>
> Fixes: a38f7907b926 ("crypto: Add userspace configuration API")
> Cc: <stable@vger.kernel.org> # v3.2+
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/crypto_user_base.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
