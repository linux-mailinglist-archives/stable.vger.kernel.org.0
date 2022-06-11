Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB21B547291
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 09:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiFKHNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 03:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiFKHNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 03:13:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E215BE0E;
        Sat, 11 Jun 2022 00:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C522D60A20;
        Sat, 11 Jun 2022 07:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56417C3411E;
        Sat, 11 Jun 2022 07:13:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FAOzbz6b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654931622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y54c2BnUceKRuWbcClQtOKc3rtiRMXKNo+Y37+pnHUs=;
        b=FAOzbz6bULleaKtfLEmPsicyLYq/aJfTDwm6NrLWfRusUa+8JsE89Wkr3t5ga8yu6gN9Wx
        wScepcw62qP1GA387SiZQQP6+kHLdlFUj9fqaUYrSsC74RPAK8CUbXnQOjCO6aEeb4u5qe
        kscjQNKKtbQzlEVE1wxQwqtMfXjVeK8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c55fad24 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 07:13:42 +0000 (UTC)
Date:   Sat, 11 Jun 2022 09:13:40 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>, herbert@gondor.apana.org.au
Cc:     Jason Self <jason@bluehome.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <YqRApN6IbU3OsIWz@zx2c4.com>
References: <20220609162943.6e3bba4f@valencia>
 <YqLTecx7MGFPOvhw@kroah.com>
 <20220610182523.2f5620a2@valencia>
 <20220610184255.20ecde41@valencia>
 <YqQHZB6/u4nrFzIm@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YqQHZB6/u4nrFzIm@sol.localdomain>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Herbert,

On Fri, Jun 10, 2022 at 08:09:24PM -0700, Eric Biggers wrote:
> On Fri, Jun 10, 2022 at 06:42:55PM -0700, Jason Self wrote:
> > On Fri, 10 Jun 2022 18:25:23 -0700
> > Jason Self <jason@bluehome.net> wrote:
> > 
> > > On Fri, 10 Jun 2022 07:15:37 +0200
> > > Greg KH <greg@kroah.com> wrote:
> > > 
> > > > On Thu, Jun 09, 2022 at 04:29:43PM -0700, Jason Self wrote:  
> > > > > In building 5.15.46 & 5.10.121 with CRYPTO_LIB_CURVE25519=m I
> > > > > get the following. My workaround is to leave it as
> > > > > CRYPTO_LIB_CURVE25519=n for now.
> > > > > 
> > > > > CONFIG_OR1K_1200=y
> > > > > CONFIG_OPENRISC_BUILTIN_DTB="or1ksim"
> > > > > 
> > > > >   sed 's/\.ko$/\.o/' modules.order | scripts/mod/modpost    -o
> > > > >   modules-only.symvers -i vmlinux.symvers   -T - ERROR: modpost:
> > > > >   "__crypto_memneq" [lib/crypto/libcurve25519.ko] undefined!
> > > > > make[1]: *** [scripts/Makefile.modpost:134:
> > > > > modules-only.symvers] Error 1 make[1]: *** Deleting file
> > > > > 'modules-only.symvers' make: *** [Makefile:1783: modules] Error
> > > > > 2    
> > > > 
> > > > 
> > > > Is this a new problem, or has it always been there for these
> > > > kernel trees?  
> > > 
> > > It's new; it began in 5.15.45 & 5.10.120, which is when make
> > > oldconfig first prompted about CONFIG_CRYPTO_LIB_CURVE25519.
> > 
> > The result of my git bisect between 5.15.44 and 5.15.45 tell me the
> > following. It's the same "lib/crypto: add prompts back to crypto
> > libraries" commit when I bisect between 5.10.119 and 5.10.120.
> > 
> > 
> > e16cc79b0f916069de223bdb567fa0bc2ccd18a5 is the first bad commit
> > commit e16cc79b0f916069de223bdb567fa0bc2ccd18a5
> > Author: Justin M. Forbes <jforbes@fedoraproject.org>
> > Date:   Thu Jun 2 22:23:23 2022 +0200
> > 
> >     lib/crypto: add prompts back to crypto libraries
> >     
> >     commit e56e18985596617ae426ed5997fb2e737cffb58b upstream.
> >     
> >     Commit 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in")
> >     took away a number of prompt texts from other crypto libraries.
> >     This makes values flip from built-in to module when oldconfig
> >     runs, and causes problems when these crypto libs need to be built
> >     in for thingslike BIG_KEYS.
> >     
> >     Fixes: 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in")
> >     Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >     Cc: linux-crypto@vger.kernel.org
> >     Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> >     [Jason: - moved menu into submenu of lib/ instead of root menu
> >             - fixed chacha sub-dependencies for CONFIG_CRYPTO]
> >     Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> >  crypto/Kconfig     |  2 --
> >  lib/Kconfig        |  2 ++
> >  lib/crypto/Kconfig | 17 ++++++++++++-----
> >  3 files changed, 14 insertions(+), 7 deletions(-)
> > bisect run success
> > 
> 
> It looks like "crypto: memneq - move into lib/" is going to fix this
> (https://lore.kernel.org/linux-crypto/20220528102429.189731-1-Jason@zx2c4.com).
> At the moment it's queued in cryptodev/master.  Herbert, are you planning to
> send it upstream soon?

Both of these commits:

https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=920b0442b9f884f55f4745b53430c80e71e90275
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=2d16803c562ecc644803d42ba98a8e0aef9c014e

were marked as "[PATCH crypto]", rather than cryptodev, have a CC to
stable@, and have a fixes tag. So I think these would be better slated
for the crypto tree rather than the cryptodev tree, so that they make it
to Linus soonish.

Jason
