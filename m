Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0234B547180
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 05:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349195AbiFKDJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 23:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349678AbiFKDJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 23:09:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27FC13FB1;
        Fri, 10 Jun 2022 20:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ECA061FDA;
        Sat, 11 Jun 2022 03:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A2EC34114;
        Sat, 11 Jun 2022 03:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654916966;
        bh=/u+Q6uSfDAqnjJx+EX/s7QWBd478U30h2HlttADZ4Vo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VLkHbIYZf/LbVn5KZ30u9dI1examoZJ5snwRWOL6519gf/4gcj3TUZU7WFWjepN85
         Xvu6P8j9CgK8ttwJsA7kBmzYrbvnZ/QISmq/WjsFITkWYGRIqP3/TYN2kt4aWBrBZQ
         BehwvkW85jC9IfuaN/ed6OBgVB5Ck51jQdFTJB1CTondBom2VyZrr2ooCLilAyVav4
         2yCDTPHe66zKoR69jTQ7d7Ie4GNRQN0bhFYD5xz5Dsi6w6y+166muYR2JY4jbk951E
         CXK0/mnzOdnXj8mZWSVGR9fIN7PEKGZNPOzX7tB1ZCuYbJ3NO85aHZ47Cv2zwsKfL6
         nA+aut/0tCP7A==
Date:   Fri, 10 Jun 2022 20:09:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jason Self <jason@bluehome.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <YqQHZB6/u4nrFzIm@sol.localdomain>
References: <20220609162943.6e3bba4f@valencia>
 <YqLTecx7MGFPOvhw@kroah.com>
 <20220610182523.2f5620a2@valencia>
 <20220610184255.20ecde41@valencia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610184255.20ecde41@valencia>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 06:42:55PM -0700, Jason Self wrote:
> On Fri, 10 Jun 2022 18:25:23 -0700
> Jason Self <jason@bluehome.net> wrote:
> 
> > On Fri, 10 Jun 2022 07:15:37 +0200
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > On Thu, Jun 09, 2022 at 04:29:43PM -0700, Jason Self wrote:  
> > > > In building 5.15.46 & 5.10.121 with CRYPTO_LIB_CURVE25519=m I
> > > > get the following. My workaround is to leave it as
> > > > CRYPTO_LIB_CURVE25519=n for now.
> > > > 
> > > > CONFIG_OR1K_1200=y
> > > > CONFIG_OPENRISC_BUILTIN_DTB="or1ksim"
> > > > 
> > > >   sed 's/\.ko$/\.o/' modules.order | scripts/mod/modpost    -o
> > > >   modules-only.symvers -i vmlinux.symvers   -T - ERROR: modpost:
> > > >   "__crypto_memneq" [lib/crypto/libcurve25519.ko] undefined!
> > > > make[1]: *** [scripts/Makefile.modpost:134:
> > > > modules-only.symvers] Error 1 make[1]: *** Deleting file
> > > > 'modules-only.symvers' make: *** [Makefile:1783: modules] Error
> > > > 2    
> > > 
> > > 
> > > Is this a new problem, or has it always been there for these
> > > kernel trees?  
> > 
> > It's new; it began in 5.15.45 & 5.10.120, which is when make
> > oldconfig first prompted about CONFIG_CRYPTO_LIB_CURVE25519.
> 
> The result of my git bisect between 5.15.44 and 5.15.45 tell me the
> following. It's the same "lib/crypto: add prompts back to crypto
> libraries" commit when I bisect between 5.10.119 and 5.10.120.
> 
> 
> e16cc79b0f916069de223bdb567fa0bc2ccd18a5 is the first bad commit
> commit e16cc79b0f916069de223bdb567fa0bc2ccd18a5
> Author: Justin M. Forbes <jforbes@fedoraproject.org>
> Date:   Thu Jun 2 22:23:23 2022 +0200
> 
>     lib/crypto: add prompts back to crypto libraries
>     
>     commit e56e18985596617ae426ed5997fb2e737cffb58b upstream.
>     
>     Commit 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in")
>     took away a number of prompt texts from other crypto libraries.
>     This makes values flip from built-in to module when oldconfig
>     runs, and causes problems when these crypto libs need to be built
>     in for thingslike BIG_KEYS.
>     
>     Fixes: 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in")
>     Cc: Herbert Xu <herbert@gondor.apana.org.au>
>     Cc: linux-crypto@vger.kernel.org
>     Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
>     [Jason: - moved menu into submenu of lib/ instead of root menu
>             - fixed chacha sub-dependencies for CONFIG_CRYPTO]
>     Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
>  crypto/Kconfig     |  2 --
>  lib/Kconfig        |  2 ++
>  lib/crypto/Kconfig | 17 ++++++++++++-----
>  3 files changed, 14 insertions(+), 7 deletions(-)
> bisect run success
> 

It looks like "crypto: memneq - move into lib/" is going to fix this
(https://lore.kernel.org/linux-crypto/20220528102429.189731-1-Jason@zx2c4.com).
At the moment it's queued in cryptodev/master.  Herbert, are you planning to
send it upstream soon?

- Eric
