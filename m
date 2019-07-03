Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0C15ED84
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 22:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfGCUbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 16:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbfGCUbc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 16:31:32 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E92C1218A0;
        Wed,  3 Jul 2019 20:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562185891;
        bh=8rZJjhlUf/qMBdRLPI5prMW5R8RsnoeRcyV06al/QNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=igHZO/XeFH2AYZ1UZL9Hr/0DlCMrJobgPYTmblwWmLYpJhrE0ThCPKavzhp8UODlC
         dltKVf6ekIyFcekgpsHgb2EKKhfzm/UKUp8JEeh9zMBZsnYyG+EmijpcD1zhcqkJ9c
         lsy2bCVVV3XzCoQn+FNDlTDjcguJ5uJAMU1QUF9c=
Date:   Wed, 3 Jul 2019 13:31:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, chetjain@in.ibm.com,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] crypto: user - prevent operating on larval algorithms
Message-ID: <20190703203128.GC10080@gmail.com>
References: <20190701153154.1569c2dc@kitsune.suse.cz>
 <20190702211700.16526-1-ebiggers@kernel.org>
 <20190703143057.miqgc7blhjjxjmee@gondor.apana.org.au>
 <20190703222108.467ec204@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190703222108.467ec204@kitsune.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michal,

On Wed, Jul 03, 2019 at 10:21:08PM +0200, Michal Suchánek wrote:
> On Wed, 3 Jul 2019 22:30:57 +0800
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > On Tue, Jul 02, 2019 at 02:17:00PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Michal Suchanek reported [1] that running the pcrypt_aead01 test from
> > > LTP [2] in a loop and holding Ctrl-C causes a NULL dereference of
> > > alg->cra_users.next in crypto_remove_spawns(), via crypto_del_alg().
> > > The test repeatedly uses CRYPTO_MSG_NEWALG and CRYPTO_MSG_DELALG.
> > > 
> > > The crash occurs when the instance that CRYPTO_MSG_DELALG is trying to
> > > unregister isn't a real registered algorithm, but rather is a "test
> > > larval", which is a special "algorithm" added to the algorithms list
> > > while the real algorithm is still being tested.  Larvals don't have
> > > initialized cra_users, so that causes the crash.  Normally pcrypt_aead01
> > > doesn't trigger this because CRYPTO_MSG_NEWALG waits for the algorithm
> > > to be tested; however, CRYPTO_MSG_NEWALG returns early when interrupted.
> > > 
> 
> Do you have some way to reproduce this reliably?
> 
> I suppose you would have to send a signal to the process for the call
> to get interrupted, right?
> 

It reproduced pretty reliably for me with what you suggested.  Just typing in
terminal:

	while true; do pcrypt_aead01; done

and then holding Ctrl-C.

If I have time I'll try writing an LTP test that specifically reproduces it.
Yes, it would involve sending a signal to a thread or process that's executing
CRYPTO_MSG_NEWALG (unless I find a better way).

- Eric
