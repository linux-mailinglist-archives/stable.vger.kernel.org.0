Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA6751DAA6
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiEFOmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442257AbiEFOmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:42:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F946A424;
        Fri,  6 May 2022 07:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DEFB6204C;
        Fri,  6 May 2022 14:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C0EC385A8;
        Fri,  6 May 2022 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651847898;
        bh=Cz7IK5LW9LlHHli9HhQJKzboa9/phiQaRtWkWrvB0xM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sVwHR+pqBuD3DEf3GmOVF/x9hGMR3+GpczIrueBt55YDyFKnM62UyK9HoB+wrA89U
         /6Qke46vifwdNwytWhY8/iBru3Agy3Cfi+oHUBOyknBCPu2Yfu6ZeZuFO8xNA4gfbB
         03U+Z8bX7g6Z1OPC/ODcJa/CW2Yf88WKtzmWq3C4=
Date:   Fri, 6 May 2022 16:38:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH 10/12] crypto: qat - use memzero_explicit() for algs
Message-ID: <YnUy13JBMvhkxSgx@kroah.com>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-11-giovanni.cabiddu@intel.com>
 <YnTo3zfXSXoEX2+R@kroah.com>
 <YnTwP/0WNvecE9SJ@silpixa00400314>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnTwP/0WNvecE9SJ@silpixa00400314>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 10:54:07AM +0100, Giovanni Cabiddu wrote:
> On Fri, May 06, 2022 at 11:22:39AM +0200, Greg KH wrote:
> > On Fri, May 06, 2022 at 09:23:25AM +0100, Giovanni Cabiddu wrote:
> > > Use memzero_explicit(), instead of a memset(.., 0, ..) in the
> > > implementation of the algorithms, for buffers containing sensitive
> > > information to ensure they are wiped out before free.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > > Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> > > Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> > > ---
> > >  drivers/crypto/qat/qat_common/qat_algs.c      | 20 +++++++++----------
> > >  drivers/crypto/qat/qat_common/qat_asym_algs.c | 20 +++++++++----------
> > >  2 files changed, 20 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> > > index 873533dc43a7..c42df18e02b2 100644
> > > --- a/drivers/crypto/qat/qat_common/qat_algs.c
> > > +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> > > @@ -637,12 +637,12 @@ static int qat_alg_aead_newkey(struct crypto_aead *tfm, const u8 *key,
> > >  	return 0;
> > >  
> > >  out_free_all:
> > > -	memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
> > > +	memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
> > 
> > This is for structure fields, why does memset() not work properly here?
> > The compiler should always call this, it doesn't know what
> > dma_free_coherent() does.  You are referencing this pointer after the
> > memset() call so all should be working as intended here.
> > 
> > Because of this, I don't see why this change is needed.  Do you have
> > reports of compilers not calling memset() for all of this properly?
> Apologies, I had a wrong assumption.
> Based on a comment in the memzero_explicit() documentation I assumed it
> should be always used to zero sensitive data.
> 
>      * memzero_explicit - Fill a region of memory (e.g. sensitive
>      *			  keying data) with 0s.

Yes, that's what it is for, when the compiler thinks it is "smarter than
you" for stack variables.

It's great for functions like this:
	int foo(...)
	{
		struct key secret_key;

		do something and set secret_key...

		/* All done, clean up and return */
		memset(&secret_key, 0, sizeof(secret_key));
		return 0;
	}

For that, some compilers now go "hey, they just want to set this to 0
and then never touch it again, that is pointless, let's not call
memset() at all!".

But when you call:
	memset(foo->key, 0, sizeof(key));
	do_something_with_foo(foo);

the compiler can NOT go and ignore the call to memset() as it does not
know what do_something_with_foo() does.  Or at least it better not.

Try out this with a small example and look at the asm output for proof.

You aren't the first to be confused about this, I see this happening at
least once a month with a patch to change code like you did.  Don't know
why it keeps coming up, is this a checkpatch() recommentation?

thanks,

greg k-h
