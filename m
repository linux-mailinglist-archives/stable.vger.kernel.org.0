Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921395EE20
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 23:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfGCVKQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 3 Jul 2019 17:10:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:35034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbfGCVKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 17:10:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 24FABAD35;
        Wed,  3 Jul 2019 21:10:15 +0000 (UTC)
Date:   Wed, 3 Jul 2019 23:10:14 +0200
From:   Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, chetjain@in.ibm.com,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] crypto: user - prevent operating on larval algorithms
Message-ID: <20190703231014.610ab8b5@kitsune.suse.cz>
In-Reply-To: <20190703203128.GC10080@gmail.com>
References: <20190701153154.1569c2dc@kitsune.suse.cz>
        <20190702211700.16526-1-ebiggers@kernel.org>
        <20190703143057.miqgc7blhjjxjmee@gondor.apana.org.au>
        <20190703222108.467ec204@kitsune.suse.cz>
        <20190703203128.GC10080@gmail.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Jul 2019 13:31:29 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Hi Michal,
> 
> On Wed, Jul 03, 2019 at 10:21:08PM +0200, Michal Suchánek wrote:
> > On Wed, 3 Jul 2019 22:30:57 +0800
> > Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >   
> > > On Tue, Jul 02, 2019 at 02:17:00PM -0700, Eric Biggers wrote:  
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > Michal Suchanek reported [1] that running the pcrypt_aead01 test from
> > > > LTP [2] in a loop and holding Ctrl-C causes a NULL dereference of
> > > > alg->cra_users.next in crypto_remove_spawns(), via crypto_del_alg().
> > > > The test repeatedly uses CRYPTO_MSG_NEWALG and CRYPTO_MSG_DELALG.
> > > > 
> > > > The crash occurs when the instance that CRYPTO_MSG_DELALG is trying to
> > > > unregister isn't a real registered algorithm, but rather is a "test
> > > > larval", which is a special "algorithm" added to the algorithms list
> > > > while the real algorithm is still being tested.  Larvals don't have
> > > > initialized cra_users, so that causes the crash.  Normally pcrypt_aead01
> > > > doesn't trigger this because CRYPTO_MSG_NEWALG waits for the algorithm
> > > > to be tested; however, CRYPTO_MSG_NEWALG returns early when interrupted.
> > > >   
> > 
> > Do you have some way to reproduce this reliably?
> > 
> > I suppose you would have to send a signal to the process for the call
> > to get interrupted, right?
> >   
> 
> It reproduced pretty reliably for me with what you suggested.  Just typing in
> terminal:
> 
> 	while true; do pcrypt_aead01; done
> 
> and then holding Ctrl-C.
> 
> If I have time I'll try writing an LTP test that specifically reproduces it.
> Yes, it would involve sending a signal to a thread or process that's executing
> CRYPTO_MSG_NEWALG (unless I find a better way).

Maybe it is possible to just send the remove message without waiting
for the ack on add.

Thanks

Michal
