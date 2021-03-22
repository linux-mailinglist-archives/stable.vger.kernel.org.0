Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76043438F9
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 07:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCVGAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 02:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhCVGAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 02:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B741F61925;
        Mon, 22 Mar 2021 06:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616392823;
        bh=Da2kIHXdeLQLxHVtJ1X0RBS7P/w99Xfmpvej3S/icEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ef48nPH3zvBkOLkb8veTf+jCHcnWBykU8Ac3RV5+FbxXDznhcvKjRUEjAopcfAi9G
         haCtYyjCzvhAtn3YvyQOx6Bu1g3AbngUwd6NpspUKciyvPfBuzajkHYrLWzUOz881O
         i4KPu6DF1CwvV0yffu/mwPdFA5eFZuZkRpNKZwcQXPMpuGVDgRsrIbPRyk2hEf5eAM
         aULf7xN3htptwMY4qm53AAxyNPINN1Wim2bk/nihZEqYWaeyXIPXQJDStDRNVmJQZ6
         rtaifP/D4mLPNJsftTuYePga44YSQHv6Ru7TPDhBac3Ci8ClHOqSRhuiWu5iZ3YJIv
         ZNaN6f4pJqG6g==
Date:   Sun, 21 Mar 2021 23:00:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: rng - fix crypto_rng_reset() refcounting when
 !CRYPTO_STATS
Message-ID: <YFgyaeeY6k6Pltw7@sol.localdomain>
References: <20210322050748.265604-1-ebiggers@kernel.org>
 <20210322054522.GC1667@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322054522.GC1667@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 08:45:22AM +0300, Dan Carpenter wrote:
> On Sun, Mar 21, 2021 at 10:07:48PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > crypto_stats_get() is a no-op when the kernel is compiled without
> > CONFIG_CRYPTO_STATS, so pairing it with crypto_alg_put() unconditionally
> > (as crypto_rng_reset() does) is wrong.
> > 
> 
> Presumably the intention was that _get() and _put() should always pair.
> It's really ugly and horrible that they don't. We could have
> predicted bug like this would happen and will continue to happen until
> the crypto_stats_get() is renamed.
> 

Well, the crypto stats stuff has always been pretty broken, so I don't think
people have looked at it too closely.  Currently crypto_stats_get() pairs with
one of the functions that tallies the statistics, such as
crypto_stats_rng_seed() or crypto_stats_aead_encrypt().  What change are you
suggesting, exactly?  Maybe moving the conditional crypto_alg_put() into a new
function crypto_stats_put() and moving it into the callers?  Or do you think the
functions should just be renamed to something like crypto_stats_begin() and
crypto_stats_end_{rng_seed,aead_encrypt}()?

Another issue is that a lot of operations (such as the rng one in question here)
don't actually need the get/put at all because they are never asynchronous.  I
didn't aim to address that in my patch though...

- Eric
